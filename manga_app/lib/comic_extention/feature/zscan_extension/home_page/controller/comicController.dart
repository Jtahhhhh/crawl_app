import 'package:get/get.dart';

import '../../../../data/model/model.dart';
import '../../../../data/zscan_data/provider/comicProvider.dart';


class ComicController extends GetxController {
  final ComicsProvider _comicsProvider = ComicsProvider();

  // Observables for chapters, comics, loading state, error messages, and other properties
  final chapterInfo = <Chapterinfo>[].obs;
  final chapterList = <Chapter>[].obs;
  final comics = <ComicsModel>[].obs;
  final comic = ComicsModel().obs;
  final newComics = <ComicsModel>[].obs;
  final listImg = <String>[].obs;
  final genComics = <ComicsModel>[].obs;

  RxBool isReversed = false.obs;
  RxBool isLastUpdateComicLoading = false.obs;
  RxBool isChapterLoading = false.obs; // Correct observable
  RxBool isImgLoading = false.obs;
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;
  RxString errorLastUpdateComicMessage = ''.obs;
  RxString errorImgMessage = ''.obs;
  RxString errorChapterMessage = ''.obs;

  RxInt currentChapterNumber = 1.obs;
  RxBool isVisible = true.obs;
  RxBool canPrev = true.obs;
  RxBool canNext = true.obs;
  bool isLike = false;

  @override
  void onInit() async {
    super.onInit();
    await Future.wait([
      fetchComics(),
      lastUpdateComics()
    ]);
  }

  Future<void> pullRefresh() async {
    print("Reset Comic");
    _comicsProvider.comicsService.cachedPages.clear();
    isLastUpdateComicLoading.value = true;
    newComics.clear();
    isLoading.value = true;
    comics.clear();

    await Future.wait([
      fetchComics(),
      lastUpdateComics()
    ]);
  }

  // Method to update visibility
  void updateVisibility(bool visibility) {
    isVisible.value = visibility;
  }


  // Fetch all comics by genres
  void fetchGenComics(String Url) {
    isLoading.value = true;
    try {
      genComics.assignAll(
          comics.where((e) =>
          e.categoryComics.where((cat) => cat.name.toLowerCase()==Url).isNotEmpty
          ).toList()
      );
      errorMessage.value = ''; // Clear error message
    } catch (error) {
      errorMessage.value = 'Failed to load comics: $error';
    } finally {
      isLoading.value = false;
    }
  }

  // Fetch a specific chapter based on slug and chapter ID
  Future<void> fetchChapter(String slug, int chapId) async {
    isImgLoading.value = true;
    errorImgMessage.value = '';
    currentChapterNumber.value = chapId;
    try {
      await _comicsProvider.getImgChapter(slug, chapId);
      listImg.value = _comicsProvider.listImg;
    } catch (error) {
      errorImgMessage.value = 'Failed to load chapter images: $error';
    } finally {
      isImgLoading.value = false;
    }
  }

  // Fetch all chapters of a comic by its ID
  Future<void> fetchChapterList(int id, [List<Chapter>? chapters]) async {
    if (chapters != null) {
      chapterList.value = chapters;
      chapterList.sort((a, b) => int.parse(a.name).compareTo(int.parse(b.name)));
      errorChapterMessage.value = ''; // Clear error message
      return;
    }
    isChapterLoading.value = true; // Correct observable
    chapterList.clear(); // Clear previous chapters
    try {
      await _comicsProvider.getAllChapterOfComic(id);
      chapterList.assignAll(_comicsProvider.chapter); // Use assignAll for RxList
      chapterList.sort((a, b) => int.parse(a.name).compareTo(int.parse(b.name)));
      errorChapterMessage.value = ''; // Clear error message
    } catch (error) {
      errorChapterMessage.value = 'Failed to load chapters: $error'; // Updated error message
    } finally {
      isChapterLoading.value = false; // Correct observable
    }
  }

  // Sort chapters in reverse order
  void sortChapters() {
    isReversed.value = !isReversed.value;
    chapterList.value = chapterList.value.reversed.toList();
  }

  // Toggle like status
  void changeLike(bool like) {
    isLike = like;
  }

  // Fetch the latest comics
  Future<void> lastUpdateComics() async {
    isLastUpdateComicLoading.value = true;
    try {
      await _comicsProvider.getNewComics();
      newComics.assignAll(_comicsProvider.newComics);
      errorLastUpdateComicMessage.value = ''; // Clear error message
    } catch (error) {
      errorLastUpdateComicMessage.value = 'Failed to load new comics: $error';
    } finally {
      isLastUpdateComicLoading.value = false;
    }
  }

  // Fetch all comics
  Future<void> fetchComics() async {
    isLoading.value = true;
    try {
      await _comicsProvider.getAllComics();
      comics.assignAll(_comicsProvider.comics); // Correct assignment
      errorMessage.value = ''; // Clear error message
    } catch (error) {
      errorMessage.value = 'Failed to load comics: $error';
    } finally {
      isLoading.value = false;
    }
  }
}
