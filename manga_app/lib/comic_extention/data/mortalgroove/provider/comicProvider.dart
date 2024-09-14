import 'dart:isolate';


import '../../model/model.dart';
import '../service/getData.dart';

class ComicsMortalProvider {
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
  List<ComicsModel> get popularComics => _popularComics;
  List<String> get listImg => _listImg;
  List<Chapter> get chapter => _chapter;
  List<Chapterinfo> get chapterInfo => _chapterInfo;

  final CrawlMortals comicsService = CrawlMortals();

  // Fetch all popular comics
  Future<void> getAllPopularComics() async {
    try {
      _popularComics = await comicsService.crawlPopularAllData();
    } catch (e) {
      print('Error fetching popular comics: $e');
    }
  }

  //Fetch all comic

  Future<void> getAllComics() async {
    try {
      _comics = await comicsService.crawlNewData();
    } catch (e) {
      print('Error fetching popular comics: $e');
    }
  }

  // Fetch comic details by URL
  Future<void> getComic(String url) async {
    try {
      var com = await comicsService.getComic(url);
      List<Chapter> chapter = com['chapters']
          ?.map<Chapter>((e) => Chapter(
        e['name'],
        "${url}chapter-${e['name']}/",
        e['date'] ?? "",
      ))
          ?.toList() ?? [];

      List<CategoryComics> category = com['tags']
          ?.map<CategoryComics>((e) => CategoryComics.withLinkDetail(e, ''))
          ?.toList() ?? [];

      comic = ComicsModel.detail(
        com['pic'],
        com['title'],
        '',
        url,
        'onGoing',
        category,
        chapter,
        com['description'],
      );
    } catch (e) {
      print('Error fetching comic: $e');
    }
  }

  // Fetch comics by genre URL
  Future<void> getComicsByGenre(String url) async {
    try {
      _genComic.clear();
      _genComic = await comicsService.crawlDataByGenre(url);
    } catch (e) {
      print('Error fetching comics by genre: $e');
    }
  }

  // Fetch chapter images using an Isolate for background processing
  Future<void> getImgChapter(String slug) async {
    try {
      _listImg = await Isolate.run(() => comicsService.getImgChapter(slug));
      print(_listImg);
    } catch (e) {
      print('Error fetching chapter images: $e');
    }
  }

  // Future<void> getNewComics() async {
  //   _newComics = await _comicsService.getNewComics();
  // }
  //
  // Future<void> getAllChapterOfComic(int id) async {
  //   _chapter = await _comicsService.getAllChapterOfComic(id);
  // }

  // Optional: Search comics by title
  List<ComicsModel> searchComics(String query) {
    return _comics.where((comic) {
      final comicName = comic.title.toLowerCase();
      final searchQuery = query.toLowerCase();
      return comicName.contains(searchQuery);
    }).toList();
  }
}
