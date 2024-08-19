import 'package:get/get.dart';

import '../../../data/provider/comicProvider.dart';
import '../../../model/comic.dart';

class ComicController extends GetxController {
  final ComicsProvider _comicsProvider = ComicsProvider();

  // Observables for chapters, comics, loading state, error messages, and other properties
  final chapterInfo = <Chapterinfo>[].obs;
  final chapterList = <Chapter>[].obs;
  final comics = <ComicsModel>[].obs;
  final newComics = <ComicsModel>[].obs;
  final listImg = <String>[].obs;

  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var currentChapterNumber = 1.obs;
  var isVisible = true.obs;
  var canPrev = true.obs;
  var canNext = true.obs;
  var tabChange = 1.obs;
  bool isLike = false;

  @override
  void onInit() async {
    super.onInit();
    await fetchComics();
    await lastUpdateComics();
  }

  // Method to change the tab index
  int changeTab(int index) {
    return tabChange.value = index;
  }

  // Method to update visibility
  void updateVisibility(bool visibility) {
    isVisible.value = visibility;
  }

  // Fetch a specific chapter based on slug and chapter ID
  Future<void> fetchChapter(String slug, int chapId) async {
    isLoading.value = true;
    errorMessage.value = '';
    currentChapterNumber.value = chapId;
    listImg.clear(); // Clear previous chapter data
    try {
      await _comicsProvider.getImgChapter(slug, chapId);
      listImg.assignAll(_comicsProvider.listImg);
      currentChapterNumber.value = chapId; // Update the current chapter number
    } catch (error) {
      errorMessage.value = 'Failed to load comics: $error';
    } finally {
      isLoading.value = false;
    }
  }


  // Fetch all chapters of a comic by its ID
  Future<void> fetchChapterList(int id) async {
    isLoading.value = true;
    try {
      await _comicsProvider.getAllChapterOfComic(id);
      chapterList.assignAll(_comicsProvider.chapter);
      chapterList.sort((a, b) => int.parse(a.name).compareTo(int.parse(b.name)),);
      errorMessage.value = ''; // Clear error message
    } catch (error) {
      errorMessage.value = 'Failed to load comics: $error';
    } finally {
      isLoading.value = false;
    }
  }

  // Sort chapters in reverse order
  void sortChapters() {
    chapterList.value = chapterList.value.reversed
        .toList();
  }

  // Toggle like status
  void changeLike(bool like) {
    isLike = like;
  }

  // Fetch the latest comics
  Future<void> lastUpdateComics() async {
    isLoading.value = true;
    try {
      await _comicsProvider.getNewComics();
      newComics.assignAll(_comicsProvider.newComics);
      errorMessage.value = ''; // Clear error message
    } catch (error) {
      errorMessage.value = 'Failed to load comics: $error';
    } finally {
      isLoading.value = false;
    }
  }

  // Fetch all comics
  Future<void> fetchComics() async {
    isLoading.value = true;
    try {
      await _comicsProvider.getAllComics();
      comics.assignAll(_comicsProvider.comics);
      errorMessage.value = ''; // Clear error message
    } catch (error) {
      errorMessage.value = 'Failed to load comics: $error';
    } finally {
      isLoading.value = false;
    }
  }
}
