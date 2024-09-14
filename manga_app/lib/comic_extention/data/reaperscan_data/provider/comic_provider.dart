import 'dart:isolate';

import '../../model/model.dart';
import '../service/getData.dart';



class ComicsReaperProvider {
  List<CategoryComics> category = [];
  List<ComicsModel> _comicsPopular = [];
  List<ComicsModel> _comics = [];
  List<ComicsModel> _newComics = [];
  List<Chapter> _chapter = [];
  List<String> listImg = [];
  List<Chapterinfo> _chapterInfo = [];
  List<ComicsModel> _genComics = [];
  late ComicsModel _comic;

  List<ComicsModel> get comicsPopular => _comicsPopular;
  List<ComicsModel> get comics => _comics;
  ComicsModel get comic => _comic;
  List<ComicsModel> get newComics => _newComics;
  List<Chapter> get chapter => _chapter;
  List<Chapterinfo> get chapterInfo => _chapterInfo;
  List<ComicsModel> get genComics => _genComics;

  final ReaperGetService comicsService = ReaperGetService();


  // Get all comics
  Future<void> getComicsPopular() async {// Cache check
    _comicsPopular = await comicsService.getDataPopular();
  }

  Future<void> getComics() async {// Cache check
    _comics = await comicsService.getData();
  }

  // Get comic categories
  Future<void> getCategory() async {
   // Cache check
      category = await comicsService.getCateGory();

  }

  // Get new comics
  Future<void> getNewComics() async {
   // Cache check
      _newComics = await comicsService.getNewData();

  }

  // Get new comics
  Future<void> getGenComics(String url) async {

     // Cache check
      _genComics = await comicsService.getDataByGen(url);
  }

  // Get comic details
  Future<void> getComicDetail(String slug) async {
    _comic = await comicsService.fetchDetail(slug);
  }


  // Get chapter images using Isolate to avoid blocking the main thread
  Future<void> getImgChapter(String slug, String comicSlug) async {
    listImg = await Isolate.run(() => comicsService.getImg(slug, comicSlug));
  }

  // Search comics by query
  List<ComicsModel> searchComics(String query) {
    return _comics.where((comic) {
      final comicName = comic.title.toLowerCase();
      final searchQuery = query.toLowerCase();
      return comicName.contains(searchQuery);
    }).toList();
  }
}
