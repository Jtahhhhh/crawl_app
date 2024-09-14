

import 'dart:isolate';

import '../../model/model.dart';
import '../service/getData.dart';

class ComicsProvider {
  List<ComicsModel> _comics = [];
  List<ComicsModel> _newComics = [];
  List<Chapter> _chapter = [];
  List<String> listImg=[];
  List<Chapterinfo> _chapterInfo = [];
  List<ComicsModel> _genComic = [];

  List<ComicsModel> get comics => _comics;
  List<ComicsModel> get newComics => _newComics;
  List<Chapter> get chapter => _chapter;
  List<Chapterinfo> get chapterInfo => _chapterInfo;
  List<ComicsModel> get genComic=>  _genComic;

  final ComicsGetService comicsService = ComicsGetService();

  Future<void> getAllComics() async {
    _comics = await comicsService.getAllComics();
  }
  // Future<void>getComicByGen(String Url) async{
  //   _genComic.clear();
  //   _genComic = await _comicsService.getGenComics(Url);
  // }

  Future<void> getNewComics() async {
    _newComics = await comicsService.getNewComics();
  }

  Future<void> getAllChapterOfComic(int id) async {
    _chapter = await Isolate.run(() => comicsService.getAllChapterOfComic(id));
  }

  Future<void> getImgChapter(String slug, int chapId) async {
    listImg = await Isolate.run(() => comicsService.getImgChapter(slug, chapId));
  }

  List<ComicsModel> searchComics(String query) {
    return _comics.where((comic) {
      final comicName = comic.title.toLowerCase();
      final searchQuery = query.toLowerCase();
      return comicName.contains(searchQuery);
    }).toList();
  }
}
