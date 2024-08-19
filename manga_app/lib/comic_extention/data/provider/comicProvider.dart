


import 'package:manga_app/comic_extention/data/service/getData.dart';
import 'package:manga_app/comic_extention/model/comic.dart';

class ComicsProvider {
  List<ComicsModel> _comics = [];
  List<ComicsModel> _newComics = [];
  List<Chapter> _chapter = [];
  List<String> listImg=[];
  List<Chapterinfo> _chapterInfo = [];

  List<ComicsModel> get comics => _comics;
  List<ComicsModel> get newComics => _newComics;
  List<Chapter> get chapter => _chapter;
  List<Chapterinfo> get chapterInfo => _chapterInfo;

  final ComicsService _comicsService = ComicsService();

  Future<void> getAllComics() async {
    _comics = await _comicsService.getAllComics();
  }

  Future<void> getNewComics() async {
    _newComics = await _comicsService.getNewComics();
  }

  Future<void> getAllChapterOfComic(int id) async {
    _chapter = await _comicsService.getAllChapterOfComic(id);
  }

  Future<void> getImgChapter(String slug, int chapId) async {
    listImg = await _comicsService.getImgChapter(slug, chapId);
  }

  List<ComicsModel> searchComics(String query) {
    return _comics.where((comic) {
      final comicName = comic.title.toLowerCase();
      final searchQuery = query.toLowerCase();
      return comicName.contains(searchQuery);
    }).toList();
  }
}
