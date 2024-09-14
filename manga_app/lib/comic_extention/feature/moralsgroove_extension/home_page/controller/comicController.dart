import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../../../data/model/model.dart';
import '../../../../data/mortalgroove/provider/comicProvider.dart';


class ComicMotalsController extends GetxController {
  final ComicsMortalProvider _comicsProvider = ComicsMortalProvider();

  // Observables for chapters, comics, loading state, error messages, and other properties
  final chapterInfo = <Chapterinfo>[].obs;
  final chapterList = <Chapter>[].obs;
  final comics = <ComicsModel>[].obs;
  final comic = ComicsModel().obs;
  final newComics = <ComicsModel>[].obs;
  final listImg = <String>[].obs;
  final genComics = <ComicsModel>[].obs;

  RxBool isReversed = false.obs;

  RxBool isLoadingComics = false.obs;
  RxBool isLoadingPopularComics = false.obs;
  RxBool isCategoryComicsLoading = false.obs;
  RxBool isDetailLoading = false.obs;
  RxBool isImgLoading = false.obs;

  RxString errorMessage = ''.obs;
  RxString errorPopularComicMessage = ''.obs;
  RxString errorCategoryComicsMessage = ''.obs;
  RxString errorDetailMessage = ''.obs;
  RxString errorImgMessage = ''.obs;

  RxInt currentChapterNumber = 1.obs;

  RxBool isVisible = true.obs;
  RxBool canPrev = true.obs;
  RxBool canNext = true.obs;
  RxInt tabChange = 1.obs;

  RxString selectedGenre = 'All'.obs;
  RxInt carouselSliderIndex = 0.obs;

  final genres = <String>[].obs;

  @override
  void onInit() async {
    super.onInit();
    await Future.wait([
        fetchComics(),
        fetchPopularComics()
    ]);

    // await lastUpdateComics();
  }

  //Method to pull refresh
  Future<void> pullRefresh() async {
    print("Reset Comic");
    _comicsProvider.comicsService.cachedPages.clear();
    comics.clear();
    isLoadingComics.value = true;
    newComics.clear();
    isLoadingPopularComics.value =true;
    await Future.wait([
      fetchComics(),
      fetchPopularComics()
    ]);
  }

  // Method to change the tab index
  int changeTab(int index) {
    return tabChange.value = index;
  }

  // Method to update visibility
  void updateVisibility(bool visibility) {
    isVisible.value = visibility;
  }

  // Fetch chapter images asynchronously using a loading state
  Future<void> getChapterImg(String slug) async {
    _setLoading(true);
    try {
      await _comicsProvider.getImgChapter(slug);
      listImg.assignAll(_comicsProvider.listImg);
    } catch (e) {
      errorImgMessage.value = 'Failed to load chapter images: $e';
    } finally {
      _setLoading(false);
    }
  }

  // Sort chapters in reverse order
  void sortChapters() {
    isReversed.value= !isReversed.value;
    chapterList.value = chapterList.value.reversed.toList();
  }


  // Fetch all comics by genre
  Future<void> fetchGenComics(String url) async {
    await _fetchData(() async {
      await _fetchDataWithLoading(() async{
        await _comicsProvider.getComicsByGenre(url);
        genComics.assignAll(_comicsProvider.genComic);
      },isCategoryComicsLoading,
          'Failed to load comics by genre',
          errorCategoryComicsMessage
      ) ;
    }, 'Failed to load comics by genre');
  }

  // Fetch popular comics with its own loading state
  Future<void> fetchPopularComics() async {
    await _fetchDataWithLoading(
          () async {
        await _comicsProvider.getAllPopularComics();
        newComics.assignAll(_comicsProvider.popularComics);
      },
      isLoadingPopularComics,  // Use the separate loading state for popular comics
      'Failed to load popular comics',
        errorPopularComicMessage
    );
  }

  // Fetch all comics with its own loading state
  Future<void> fetchComics() async {
    await _fetchDataWithLoading(
          () async {
        await _comicsProvider.getAllComics();
        comics.assignAll(_comicsProvider.comics);
      },
      isLoadingComics,  // Use the separate loading state for comics
      'Failed to load all comics',errorMessage
    );
  }

  // Fetch a specific comic by URL
  Future<ComicsModel> fetchComic(String url) async {
    ComicsModel fetchedComic;
    await _fetchDataWithLoading(() async {
      await _comicsProvider.getComic(url);
      comic.value=_comicsProvider.comic;
      chapterList.assignAll(comic.value.chapters);
    },isDetailLoading, 'Failed to load comic',errorDetailMessage);
    fetchedComic = _comicsProvider.comic;
    return fetchedComic;
  }

  // Utility method to handle repetitive loading/error logic with independent loading states
  Future<void> _fetchDataWithLoading(Future<void> Function() fetchFunction, RxBool loadingState, String errorMsg, RxString err) async {
    loadingState.value = true;
    try {
      await fetchFunction();
      err.value = ''; // Clear error message on success
    } catch (error) {
      err.value = errorMsg;
    } finally {
      loadingState.value = false;
    }
  }

  // Utility method to handle repetitive loading/error logic without custom loading state
  Future<void> _fetchData(Future<void> Function() fetchFunction, String errorMsg) async {
    isLoadingComics.value = true;
    try {
      await fetchFunction();
      errorMessage.value = ''; // Clear error message on success
    } catch (error) {
      errorMessage.value = errorMsg;
    } finally {
      isLoadingComics.value = false;
    }
  }

  // Set loading state
  void _setLoading(bool value) {
    isLoadingComics.value = value;
  }
}
