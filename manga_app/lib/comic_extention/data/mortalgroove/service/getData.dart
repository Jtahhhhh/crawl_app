import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart' as dom;
import 'package:intl/intl.dart';

import '../../model/model.dart';


class CrawlMortals {
  final Map<String, String> cachedPages = {};
  final String baseUrl = "https://mortalsgroove.com/";
  final String popularSelector = '#manga-popular-slider-33 .slider__content';
  final String newSelector = '#manga-popular-slider-17 .slider__content';

  List<ComicsModel> _comics = [];
  late ComicsModel comic;
  List<ComicsModel> _popularComics = [];
  List<ComicsModel> _newComics = [];
  List<Chapter> _chapter = [];
  List<ComicsModel> _genComic = [];
  List<String> _listImg = [];
  List<Chapterinfo> _chapterInfo = [];

  List<ComicsModel> get comics => _comics;
  List<ComicsModel> get genComic => _genComic;
  List<ComicsModel> get newComics => _newComics;
  List<ComicsModel> get popularComic => _popularComics;
  List<String> get listImg => _listImg;
  List<Chapter> get chapter => _chapter;
  List<Chapterinfo> get chapterInfo => _chapterInfo;

  // Centralized HTTP request handler with error and timeout handling, includes caching
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

  // Method to crawl popular comics data
  Future<List<ComicsModel>> crawlPopularAllData() async {
    return _crawlComics(baseUrl, popularSelector);
  }

  // Method to crawl new comics data
  Future<List<ComicsModel>> crawlNewData() async {
    return _crawlComics(baseUrl, newSelector);
  }

  // Method to crawl comics by genre
  Future<List<ComicsModel>> crawlDataByGenre(String genUrl) async {
    return _crawlComics("$baseUrl/manga-genre/$genUrl", '.page-item-detail.manga');
  }

  // Generic method to crawl comics based on URL and query selector
  Future<List<ComicsModel>> _crawlComics(String url, String querySelector) async {
    List<ComicsModel> comics = [];
    String? pageContent = await _fetchPageContent(url);

    if (pageContent != null) {
      dom.Document doc = parse(pageContent);
      List<Future<ComicsModel?>> futures = [];

      // Query the specific elements for comics
      for (var div in doc.querySelectorAll(querySelector)) {
        dom.Element? a = div.querySelector('a');
        if (a != null && a.attributes["href"] != null) {
          futures.add(getComicAndCreateModel(a.attributes["href"]!));
        }
      }

      // Fetch comics in parallel and filter out null results
      final comicModels = await Future.wait(futures);
      comics.addAll(comicModels.whereType<ComicsModel>());
    }

    return comics;
  }

  // Method to fetch comic details and create ComicsModel
  Future<ComicsModel?> getComicAndCreateModel(String url) async {
    try {
      final comic = await getComic(url);
      if (comic.isNotEmpty) {
        return _createComicsModelFromData(comic, url);
      }
    } catch (e) {
      print('Error fetching comic details for URL $url: $e');
    }
    return null;
  }

  // Method to fetch comic details from a given URL
  Future<Map<String, dynamic>> getComic(String url) async {
    Map<String, dynamic> comicDetail = {};
    String? pageContent = await _fetchPageContent(url);

    if (pageContent != null) {
      dom.Document doc = parse(pageContent);

      // Extract comic information
      final pic = doc.querySelector(".summary_image img")?.attributes["data-src"]?.replaceAll(RegExp(r'-(\d+)x(\d+)\.'), '.');
      final title = doc.querySelector('.post-title h1')?.text.trim();
      final description = doc.querySelector('.description-summary')?.text.replaceAll("Show more", "").trim() ?? '';

      // Extract metadata
      String? original, author, artist, released;
      List<String> tags = [];

      for (var info in doc.querySelectorAll('.post-content_item')) {
        final text = info.text.trim();
        if (text.startsWith("Alternative")) {
          original = text.replaceFirst("Alternative", "").trim();
        } else if (text.startsWith("Author")) {
          author = text.replaceFirst("Author(s)", "").trim();
        } else if (text.startsWith("Artist")) {
          artist = text.replaceFirst("Artist(s)", "").trim();
        } else if (text.startsWith("Genre(s)")) {
          tags = text.replaceFirst("Genre(s)", "").split(',').map((tag) => tag.trim()).toList();
        } else if (text.startsWith("Release")) {
          released = text.replaceFirst("Release", "").trim();
        }
      }

      // Crawl chapters
      List<Map<String, String>> allChapters = [];
      for (var element in doc.querySelectorAll('.wp-manga-chapter')) {
        var chapName = element.querySelector('a')?.text.replaceFirst("Chapter", "").trim();
        var chapRelease = element.querySelector('.chapter-release-date')?.text.trim() ?? '';

        if (chapName != null) {
          final numericPart = RegExp(r'(\d+)').firstMatch(chapName)?.group(0);
          if (numericPart != null) {
            allChapters.add({
              "name": numericPart,
              "date": chapRelease.isNotEmpty
                  ? chapRelease
                  : DateFormat('MMMM dd, yyyy').format(DateTime.now()),
            });
          }
        }
      }

      // Sort chapters numerically
      allChapters.sort((a, b) {
        final numA = double.tryParse(a['name'] ?? '0') ?? 0.0;
        final numB = double.tryParse(b['name'] ?? '0') ?? 0.0;
        return numA.compareTo(numB);
      });

      // Store comic details
      if (title != null) {
        comicDetail = {
          "title": title,
          "original_title": original ?? "",
          "description": description,
          "author": author ?? "",
          "slug": title.toLowerCase().replaceAll(" ", "-"),
          "artist": artist ?? "",
          "released": released ?? DateFormat('yyyy').format(DateTime.now()),
          "pic": pic ?? "",
          "tags": tags,
          "chapters": allChapters,
        };
      }
    }

    return comicDetail;
  }

  // Create a ComicsModel from the fetched comic data
  ComicsModel _createComicsModelFromData(Map<String, dynamic> comic, String url) {
    List<CategoryComics> category = (comic['tags'] as List?)
        ?.map<CategoryComics>((e) => CategoryComics.withLinkDetail(e, ''))
        .toList() ?? [];

    List<Chapter> chapter = (comic['chapters'] as List?)
        ?.map<Chapter>((e) => Chapter(
        e['name'],
        "$url/chapter-${e['name']}/",
        e['date'] ?? ""))
        .toList() ?? [];

    return ComicsModel.detail(
      comic['pic'],
      comic['title'],
      '',
      url,
      'onGoing',
      category,
      chapter,
      comic['description'],
    );
  }

  // Method to retrieve chapter images
  Future<List<String>> getImgChapter(String url) async {
    List<String> images = [];
    String? pageContent = await _fetchPageContent(url);

    if (pageContent != null) {
      dom.Document doc = parse(pageContent);
      var readerAreaElement = doc.querySelector('.reading-content');

      if (readerAreaElement != null) {
        for (var imgElement in readerAreaElement.querySelectorAll('img')) {
          String? src = imgElement.attributes['src'] ?? imgElement.attributes['data-src'];
          if (src != null) {
            images.add(src);
          }
        }
      } else {
        print("Reader area not found.");
      }
    }

    return images;
  }
}
