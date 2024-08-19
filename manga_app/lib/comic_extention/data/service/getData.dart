import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:manga_app/comic_extention/model/comic.dart';



class ComicsService {
  Future<List<ComicsModel>> getAllComics() async {
    List<ComicsModel> comics = [];
    try {
      final response = await http.get(Uri.parse('https://zscans.com/swordflake/comics'));
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

  Future<List<ComicsModel>> getNewComics() async {
    List<ComicsModel> comics = [];
    try {
      final response = await http.get(Uri.parse('https://zscans.com/swordflake/new-chapters'));
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
      final response = await http.get(Uri.parse('https://zscans.com/swordflake/comic/$slug'));
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
    List<Chapter> chap = [];
    int total;
    try {
      final response = await http.get(Uri.parse('https://zscans.com/swordflake/comic/$id/chapters'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        total = data['data']['total'];

        List<Future<void>> fetchPages = [];
        for (int x = 1; x <= (total / 20).ceil(); x++) {
          fetchPages.add(_fetchChaptersPage(id, x, chap));
        }

        await Future.wait(fetchPages);
      } else {
        print('Failed to load comics data');
      }
    } catch (error) {
      print('Error fetching comics: $error');
    }
    return chap;
  }

  Future<void> _fetchChaptersPage(int id, int page, List<Chapter> chap) async {
    try {
      final response = await http.get(Uri.parse('https://zscans.com/swordflake/comic/$id/chapters?page=$page'));
      if (response.statusCode == 200) {
        final chapterData = jsonDecode(response.body);
        final chapters = chapterData['data']['data'];
        for (var chapter in chapters) {
          chap.add(
              Chapter(chapter['name'].toString(), chapter['id'].toString(), chapter['created_at'] ?? 'unknown'));
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
      final response = await http.get(Uri.parse('https://zscans.com/swordflake/comic/$slug/chapters/$chapId'));
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

  // Future<List<ComicsMo>> getSearchAsura(String query) async {
  //   List<Comics> comics = [];
  //   final searchQuery = query.toLowerCase();
  //   try {
  //     final response = await http.get(Uri.parse('https://zscans.com/swordflake/comics'));
  //
  //     if (response.statusCode == 200) {
  //       final data = jsonDecode(response.body);
  //       final comicsData = data['data']['comics'] ?? [];
  //
  //       for (var comic in comicsData) {
  //         try {
  //           final comicName = comic['name']?.toString().toLowerCase() ?? '';
  //           if (comicName.contains(searchQuery)) {
  //             final slug = "${comic['slug']} ${comic['id'].toString()}";
  //             comics.add(
  //               ComicsModel.asura(
  //                 comic['cover']?['horizontal'] ?? '',
  //                 comic['name'] ?? '',
  //                 slug,
  //                 (comic['genres']?.isNotEmpty ?? false)
  //                     ? comic['genres'][0]['name'] ?? ''
  //                     : '',
  //               ),
  //             );
  //           }
  //         } catch (e) {
  //           print('Error parsing comic: $e');
  //         }
  //       }
  //     } else {
  //       print('Failed to load comics data');
  //     }
  //   } catch (error) {
  //     print('Error fetching comics: $error');
  //   }
  //
  //   return comics;
  // }

  Future<Uint8List?> fetchImageAsUint8List(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
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
