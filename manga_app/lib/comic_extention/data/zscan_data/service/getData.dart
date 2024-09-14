import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../model/model.dart';





class ComicsGetService {
  final Map<String, String> cachedPages = {};

  Future<String?> _fetchPageContent(String url) async {
    if (cachedPages.containsKey(url)) {
      return cachedPages[url]; // Return cached content if available
    }

    try {
      final response = await compute(http.get, Uri.parse(url)).timeout(Duration(seconds: 15));
      if (response.statusCode == 200) {
        cachedPages[url] = response.body; // Cache the response body
        return response.body;
      } else {
        print('Failed to load page: $url. Status code: ${response.statusCode}');
      }
    } on TimeoutException {
      print('Request to $url timed out after 15 seconds.');
    } catch (e) {
      print('An error occurred while fetching $url: $e');
    }
    return null;
  }

  Future<List<ComicsModel>> getAllComics() async {
    List<ComicsModel> comics = [];
    try {
      final response = await compute(http.get, Uri.parse('https://zscans.com/swordflake/comics'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final comicsData = data['data']['comics'];

        for (var comic in comicsData) {
          try {
            List<CategoryComics> genres = (comic['genres'] as List).map((genre) {
              return CategoryComics.withLinkDetail(
                genre['name'] ?? '',
                genre['slug'] ?? '',
              );
            }).toList();
            String slug = comic['slug'] + " " + comic['id'].toString();

            comics.add(
              ComicsModel.banner(
                comic['cover']?['horizontal'] ?? '',
                comic['name'] ?? '',
                slug,
                comic['rating']?.toString() ?? '',
                (comic['genres'] != null && comic['genres'].isNotEmpty)
                    ? comic['genres'][0]['name'] ?? ''
                    : '',
                genres,
                comic['summary'] ?? '',
                (comic['statuses'] != null && comic['statuses'].isNotEmpty)
                    ? comic['statuses'][0]['name'] ?? ''
                    : '',
              ),
            );
          } catch (e) {
            print('Error parsing comic: $e');
          }
        }
      } else {
        print('Failed to load comics data');
      }
    } catch (error) {
      print('Error fetching comics: $error');
    }
    return comics;
  }



  // Future<List<ComicsModel>> getGenComics(String url) async {
  //   List<ComicsModel> comics = [];
  //   final Completer<InAppWebViewController> controllerCompleter = Completer<InAppWebViewController>();
  //
  //   InAppWebViewController webViewController;
  //
  //   try {
  //     InAppWebView webView = InAppWebView(
  //       initialUrlRequest: URLRequest(url: WebUri('https://zscans.com/comics?genres=$url')),
  //       onWebViewCreated: (controller) {
  //         webViewController = controller;
  //         controllerCompleter.complete(controller);
  //       },
  //       onLoadStop: (controller, url) async {
  //         // Chờ một thời gian để trang tải dữ liệu (tuỳ thuộc vào trang web)
  //         await Future.delayed(Duration(seconds: 5));
  //
  //         // Chạy JavaScript để lấy nội dung HTML của trang
  //         String htmlContent = await controller.evaluateJavascript(source: "window.document.body.outerHTML;");
  //
  //         // Parse nội dung HTML
  //         var document = html.parse(htmlContent);
  //
  //         // Tiếp tục xử lý dữ liệu như trước
  //         for (var comic in document.querySelectorAll('.d-flex.rounded.zs-bg-3.elevation-2')) {
  //           try {
  //             String slug = comic.querySelector('a')?.attributes['href'] ?? '';
  //             String bannerUrl = comic.querySelector('.v-image__image.v-image__image--cover')
  //                 ?.attributes['style']
  //                 ?.replaceAll(RegExp(r'background-image:\s*url\(&quot;'), '')
  //                 .replaceAll(RegExp(r'&quot;\);\s*background-position:\s*center\s*center;'), '') ?? '';
  //             String title = comic.querySelector('.text-body-1')?.text ?? '';
  //             String secondaryText = comic.querySelector('.text--secondary')?.text ?? '';
  //
  //             comics.add(
  //               ComicsModel.banner(
  //                 bannerUrl,
  //                 title,
  //                 slug,
  //                 '',
  //                 '',
  //                 [],
  //                 secondaryText,
  //                 '',
  //               ),
  //             );
  //           } catch (e) {
  //             print('Error parsing comic: $e');
  //           }
  //         }
  //       },
  //     );
  //
  //     // Khởi chạy WebView trong một Widget
  //     // Nếu bạn chỉ cần lấy dữ liệu mà không hiển thị WebView, bạn có thể tạo một StatefulWidget và đặt WebView vào đó với kích thước 0x0.
  //
  //   } catch (error) {
  //     print('Error fetching comics: $error');
  //   }
  //
  //   return comics;
  // }



  Future<List<ComicsModel>> getNewComics() async {
    List<ComicsModel> comics = [];
    try {
      final response = await compute(http.get, Uri.parse('https://zscans.com/swordflake/new-chapters'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final comicsData = data['all'].toList();
        List<Future<void>> fetchComicDetails = [];
        for (var comic in comicsData) {
          fetchComicDetails.add(_fetchComicDetail(comic['slug'], comics,(comic["chapters"][0]["name"]/20).toInt()+1));
        }

        await Future.wait(fetchComicDetails);
      } else {
        print('Failed to load comics data');
      }
    } catch (error) {
      print('Error fetching comics: $error');
    }
    return comics;
  }

  Future<void> _fetchComicDetail(String slug, List<ComicsModel> comics, int indexGet) async {
    try {
      final response = await compute(http.get, Uri.parse('https://zscans.com/swordflake/comic/$slug'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final detailData = data['data'];
        List<Chapter> chap = [];

        await _fetchChaptersPage(detailData['id'], indexGet, chap);

        List<CategoryComics> genres = (detailData['genres'] as List).map((genre) {
          return CategoryComics.withLinkDetail(
            genre['name'] ?? '',
            genre['slug'] ?? '',
          );
        }).toList();

        String slugDetail = "${detailData['slug']} ${detailData['id'].toString()}";
        comics.add(
          ComicsModel.detail(
            detailData['cover']?['full'] ?? '',
            detailData['name'] ?? '',
            detailData['rating']?.toString() ?? '',
            slugDetail,
            genres.isNotEmpty ? genres[0].name : '',
            genres,
            chap,
            detailData['summary'] ?? '',
          ),
        );
      } else {
        print('Failed to load comic details');
      }
    } catch (error) {
      print('Error fetching comic details: $error');
    }
  }

  Future<List<Chapter>> getAllChapterOfComic(int id) async {
    List<Chapter> chapters = [];
    try {
      final response = await compute(http.get, Uri.parse('https://zscans.com/swordflake/comic/$id/chapters'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        int total = data['data']['total'];

        // Collect futures for fetching pages in parallel
        List<Future<void>> fetchPages = List.generate(
          (total / 20).ceil(),
              (pageIndex) => _fetchChaptersPage(id, pageIndex + 1, chapters),
        );

        // Wait for all pages to be fetched
        await Future.wait(fetchPages);
      } else {
        print('Failed to load comics data');
      }
    } catch (error) {
      print('Error fetching comics: $error');
    }
    return chapters;
  }

  Future<void> _fetchChaptersPage(int id, int page, List<Chapter> chapters) async {
    try {
      final response = await compute(http.get, Uri.parse('https://zscans.com/swordflake/comic/$id/chapters?page=$page'));
      if (response.statusCode == 200) {
        final chapterData = jsonDecode(response.body);
        final chapterList = chapterData['data']['data'];
        for (var chapter in chapterList) {
          chapters.add(Chapter(chapter['name'].toString(), chapter['id'].toString(), chapter['created_at'] ?? 'unknown'));
        }
      }
    } catch (error) {
      print("Error fetching page $page of chapters: $error");
    }
  }


  Future<List<String>> getImgChapter(String slug, int chapId) async {
    List<String> imageUrls = [];
    DateTime date = DateTime.now();
    try {
      final response = await compute(http.get, Uri.parse('https://zscans.com/swordflake/comic/$slug/chapters/$chapId'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data']['chapter'];
        List<String> urls = List<String>.from(data['high_quality'].map((e) => e.toString()));
        imageUrls.addAll(urls);
      }
    } catch (error) {
      print('Error fetching comics: $error');
    }
    return imageUrls;
  }



  Future<Uint8List?> fetchImageAsUint8List(String url) async {
    try {
      final response = await compute(http.get, Uri.parse(url));
      if (response.statusCode == 200) {
        return response.bodyBytes;
      } else {
        print('Failed to load image. Status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching image: $e');
      return null;
    }
  }
}
