import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart' as dom;
import 'package:intl/intl.dart';

import '../../model/model.dart';

class ReaperGetService {
  static const String _baseApiUrl = 'https://api.reaperscans.com/';
  static const String _baseMediaUrl = 'https://media.reaperscans.com/file/4SRBHm/';
  static const Duration _timeoutDuration = Duration(seconds: 15);


  final Map<String, String> cachedPages = {};

  Future<String?> _fetchPageContent(String url) async {
    if (cachedPages.containsKey(url)) {
      return cachedPages[url]; // Return cached content if available
    }

    try {
      final response = await http.get(Uri.parse(url)).timeout(Duration(seconds: 15));
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

  Future<List<ComicsModel>> getDataPopular() async {
    return _fetchComicsListFromApi('${_baseApiUrl}comics');
  }

  Future<List<ComicsModel>> getData() async {
    return _fetchComicsListFromApi('${_baseApiUrl}query?page=1&perPage=1000&series_type=Comic&order=desc&orderBy=created_at&adult=true&status=All&tags_ids=%5B%5D');
  }

  Future<List<ComicsModel>> getNewData() async {
    return _fetchComicsListFromApiDaily('${_baseApiUrl}trending?type=daily');
  }

  Future<List<CategoryComics>> getCateGory() async {
    return _fetchCategories('${_baseApiUrl}tags');
  }

  Future<List<ComicsModel>> getDataByGen(String url) async {
    return _fetchComicsListFromApi('https://api.reaperscans.com/query?page=1&perPage=20&series_type=Comic&query_string=&order=desc&orderBy=created_at&adult=true&status=All&tags_ids=[$url]',);
  }

  Future<ComicsModel> fetchDetail(String slug) async {
    String url = '${_baseApiUrl}series/$slug';
    ComicsModel? comic;
    try {
      final response = await _getRequest(url);
      if (response != null) {
        final data = jsonDecode(response);
        comic = await _buildComicModelFromJson(data);
      }
    } catch (e) {
      print('Failed to load comic details for slug: $slug, Error: $e');
    }
    return comic!;
  }

  Future<List<Chapter>> _fetchAllChapters(int comicId) async {
    String url = "${_baseApiUrl}chapter/query?page=1&perPage=1000&series_id=$comicId";
    List<Chapter> allChapters = [];

    try {
      final response = await _getRequest(url);
      if (response != null) {
        final chaptersData = jsonDecode(response)['data'] as List;
        for (var chapter in chaptersData) {
          allChapters.add(
            Chapter(
              chapter['chapter_name'],
              chapter['chapter_slug'],
              DateFormat('MMMM dd, yyyy').format(DateTime.parse(chapter['created_at'].toString())),
            ),
          );
        }
      }
    } catch (e) {
      print('Error fetching chapters for comic ID: $comicId, Error: $e');
    }

    return allChapters;
  }

  Future<List<String>> getImg(String chapSlug, String comicSlug) async {
    String url = "${_baseApiUrl}chapter/$comicSlug/$chapSlug";
    print("chapter img: $url");
    List<String> images = [];

    try {
      final response = await _getRequest(url);
      if (response != null) {
        final chapterData = jsonDecode(response)['chapter']['chapter_data']['images'];
        final chapterImages = chapterData.map((img) {
          if (!img.toString().startsWith('http')) {
            return '$_baseMediaUrl$img';
          }
          return img;
        }).toList();
        images = List<String>.from(chapterImages);
      }
    } catch (e) {
      print('Error fetching images for chapter: $chapSlug of comic: $comicSlug, Error: $e');
    }

    return images;
  }

  // Helper methods

  Future<String?> _getRequest(String url) async {
    try {
      final response = await http.get(Uri.parse(url)).timeout(_timeoutDuration);
      if (response.statusCode == 200) {
        return response.body;
      } else {
        print('Failed to load data from $url, Status code: ${response.statusCode}');
      }
    } on TimeoutException {
      print('Request to $url timed out after 15 seconds.');
    } catch (e) {
      print('Error occurred during HTTP request to $url, Error: $e');
    }
    return null;
  }

  Future<List<ComicsModel>> _fetchComicsListFromApiDaily(String url) async {
    List<ComicsModel> comics = [];

    try {
      final response = await _fetchPageContent(url);
      if (response != null) {
        final parsedData = jsonDecode(response);
        for (var comic in parsedData) {
          comics.add(_buildBannerComicModel(comic));
        }
      }
    } catch (e) {
      print('Error fetching comics list from API: $url, Error: $e');
    }

    return comics;
  }

  Future<List<ComicsModel>> _fetchComicsListFromApi(String url) async {
    List<ComicsModel> comics = [];

    try {
      final response = await _fetchPageContent(url);
      if (response != null) {
        final parsedData = jsonDecode(response)['data'];
        for (var comic in parsedData) {
          comics.add(_buildDetailComicModel(comic));
        }
      }
    } catch (e) {
      print('Error fetching comics list from API: $url, Error: $e');
    }

    return comics;
  }

  ComicsModel _buildDetailComicModel(Map<String, dynamic> comic) {
    String thumbnail = comic['thumbnail'];
    if (!thumbnail.startsWith('http')) {
      thumbnail = '$_baseMediaUrl$thumbnail';
    }
    List<Chapter> chap = (comic['free_chapters'] as List)
        .map((e) => Chapter(
        e['chapter_name'],
        e['chapter_slug'],
        DateFormat('MMMM dd, yyyy').format(DateTime.parse(e['created_at'].toString()))
    ))
        .toList();
    return ComicsModel.detail(
      thumbnail,
      comic['title'],
      '',
      comic['series_slug'],
      'On Going',
      [],
      chap,
      comic['description'].replaceAll(RegExp(r'<[^>]*>'), ''),
    );
  }

  ComicsModel _buildBannerComicModel(Map<String, dynamic> comic) {
    String thumbnail = comic['thumbnail'];
    if (!thumbnail.startsWith('http')) {
      thumbnail = '$_baseMediaUrl$thumbnail';
    }
    return ComicsModel.banner(
      thumbnail,
      comic['title'],
      comic['series_slug'],
      '',
      '',
      [],
      comic['description'].replaceAll(RegExp(r'<[^>]*>'), ''),
      'On Going',
    );
  }

  Future<List<CategoryComics>> _fetchCategories(String url) async {
    List<CategoryComics> categories = [];

    try {
      final response = await _fetchPageContent(url);
      if (response != null) {
        final parsedData = jsonDecode(response);
        if (parsedData is List) {
          final tags = parsedData;
          categories = tags.map((tag) => CategoryComics.withLinkDetail(tag['name'], tag['id'].toString() )).toList();
        } else {
          print('Unexpected data format: $parsedData');
        }
      }
    } catch (e) {
      print('Error fetching categories from API: $url, Error: $e');
    }

    return categories;
  }

  Future<List<ComicsModel>> _fetchComicsFromWebsite(String url, String querySelector) async {
    List<ComicsModel> comics = [];

    try {
      final response = await _fetchPageContent(url);
      if (response != null) {
        dom.Document document = parse(response);
        for (var element in document.querySelectorAll(querySelector)) {
          var a = element.querySelector('a');
          if (a != null && a.attributes['href'] != null) {
            String slug = a.attributes['href']!.replaceAll('/series/', '');
            comics.add(
                ComicsModel.banner(
                    "https://reaperscans.com/"+element.querySelector('img')!.attributes['src'].toString(),
                    element.querySelector('h5')!.text.toString(),
                    slug,
                    '', '',
                    [],
                    '',
                    '')
            );
          }
        }
      }
    } catch (e) {
      print('Error fetching comics from website: $url, Error: $e');
    }

    return comics;
  }

  Future<ComicsModel> _buildComicModelFromJson(Map<String, dynamic> json) async {
    String thumbnail = json['thumbnail'];
    if (!thumbnail.startsWith('http')) {
      thumbnail = '$_baseMediaUrl$thumbnail';
    }
    List<Chapter> chapter= await _fetchAllChapters(json['id']);
    List<CategoryComics> genres = (json['tags'] as List).map((genre) {
      return CategoryComics.withLinkDetail(genre['name'] ?? '', '');
    }).toList();

    return ComicsModel.detail(
      thumbnail,
      json['title'],
      '',
      json['series_slug'],
      'On Going',
      genres,
      chapter,
      json['description'].replaceAll(RegExp(r'<[^>]*>'), ''),
    );
  }
}
