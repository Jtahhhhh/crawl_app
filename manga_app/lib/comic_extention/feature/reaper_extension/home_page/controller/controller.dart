import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';

import '../../../../data/model/model.dart';
import '../../../../data/reaperscan_data/provider/comic_provider.dart';

class ComicReaperController extends GetxController {
  final ComicsReaperProvider _comicsProvider = ComicsReaperProvider();

  final RxList<Chapterinfo> chapterInfo = <Chapterinfo>[].obs;
  final RxList<Chapter> chapterList = <Chapter>[].obs;
  final RxList<ComicsModel> comics = <ComicsModel>[].obs;
  final RxList<ComicsModel> comicsPopular = <ComicsModel>[].obs;
  final Rx<ComicsModel> comic = ComicsModel().obs;
  final RxList<ComicsModel> newComics = <ComicsModel>[].obs;
  final RxList<String> listImg = <String>[].obs;
  final RxList<ComicsModel> genComics = <ComicsModel>[].obs;
  final RxList<CategoryComics> category = <CategoryComics>[].obs;

  RxBool isReversed = true.obs;
  RxBool isLoading = false.obs;
  RxBool isImgLoading = false.obs;
  RxBool isChapterLoading = false.obs;
  RxBool isComicsLoading = false.obs;
  RxBool isLoadingComicsAll = false.obs;
  RxBool isCategoryLoading = false.obs;
  RxBool isCategoryComicsLoading = false.obs;

  RxString errorMessage = ''.obs;
  RxString errorImgMessage = ''.obs;
  RxString errorChapterMessage = ''.obs;
  RxString errorComicsMessage = ''.obs;
  RxString errorComicsAllMessage = ''.obs;
  RxString errorCategoryMessage = ''.obs;
  RxString errorCategoryComicsMessage = ''.obs;

  RxInt currentChapterNumber = 1.obs;
  RxBool isVisible = true.obs;
  RxBool canPrev = true.obs;
  RxBool canNext = true.obs;
  RxInt tabChange = 1.obs;
  RxBool isLike = false.obs;
  RxString selectedGenre = 'All'.obs;
  RxInt carouselSliderIndex = 0.obs;

  // Debounce time for search
  Duration debounceDuration = Duration(milliseconds: 300);
  RxBool debounce = false.obs;

  @override
  void onInit() async {
    super.onInit();
    await Future.wait([
      fetchCategory(),
      fetchNewComics(),
      fetchComicsPopular(),
      fetchComics(),
    ]);
  }

  Future<void> pullRefresh() async {
    print("Before clearing cache: ${_comicsProvider.comicsService.cachedPages}");
    // Clear cache
    _comicsProvider.comicsService.cachedPages.clear();
    print("After clearing cache: ${_comicsProvider.comicsService.cachedPages}");
    // Set loading states
    isLoading.value = true;
    isCategoryLoading.value = true;
    isComicsLoading.value = true;
    isLoadingComicsAll.value = true;
    errorMessage.value = '';

    // Clear existing data
    category.clear();
    comics.clear();
    newComics.clear();
    comicsPopular.clear();
    // Fetch fresh data

    try {
      await Future.wait([
        fetchComicsPopular(),
        fetchCategory(),
        fetchNewComics(),
        fetchComics(),
      ]);
    } catch (e) {
      errorMessage.value = 'Error during refresh: $e';
    } finally {
      // Reset loading states
      isLoading.value = false;
      isLoadingComicsAll.value = false;
      isCategoryLoading.value = false;
      isComicsLoading.value = false;
    }
  }


  // Load all initial data concurrently
  Future<void> fetchCategory() async{
    isCategoryLoading .value = true;
    try{
      await _comicsProvider.getCategory();
      category.assignAll(_comicsProvider.category);
      errorCategoryMessage.value = '';
    }catch(error){
      errorCategoryMessage.value = 'Failed to load comics: $error';
    }
    finally {
      isCategoryLoading .value = false;
    }
  }
  Future<void> fetchNewComics() async{
    isComicsLoading .value = true;
    try{
      await _comicsProvider.getNewComics();
      newComics.assignAll(_comicsProvider.newComics);
      errorComicsMessage.value = '';
    }catch(error){
      errorComicsMessage.value = 'Failed to load comics: $error';
    }
    finally {
      isComicsLoading .value = false;
    }
  }
  Future<void> fetchComicsPopular() async{
    isLoading.value = true;
    try{
      await _comicsProvider.getComicsPopular();
      comicsPopular.assignAll(_comicsProvider.comicsPopular);
      errorMessage.value = '';
    }catch(error){
      errorMessage.value = 'Failed to load comics: $error';
    }
    finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchComics() async{
    isLoadingComicsAll.value = true;
    try{
      await _comicsProvider.getComics();
      comics.assignAll(_comicsProvider.comics);
      errorComicsAllMessage.value = '';
    }catch(error){
      errorComicsAllMessage.value = 'Failed to load comics: $error';
    }
    finally {
      isLoadingComicsAll.value = false;
    }
  }


  // Get chapter images
  Future<void> getChapterImg(String slugChapter, String slugComic) async {
    isImgLoading .value = true;
    try {
      await _comicsProvider.getImgChapter(slugChapter, slugComic);
      listImg.assignAll(_comicsProvider.listImg);
    } catch (error) {
      errorImgMessage.value = 'Failed to load chapter images: $error';
    } finally {
      isImgLoading.value = false;
    }
  }

  // Search comics with debounce
  void searchComics(String query) {
    if (!debounce.value) {
      debounce.value = true;
      Future.delayed(debounceDuration, () {
        debounce.value = false;
        final results = _comicsProvider.searchComics(query);
        comics.assignAll(results);
      });
    }
  }


  // Fetch comic details
  Future<void> fetchComic(String slug) async {
    isChapterLoading.value = true;
    try {
      await _comicsProvider.getComicDetail(slug);
      // comic.value =_comicsProvider.comic;
      chapterList.value.assignAll(_comicsProvider.comic.chapters);
      errorChapterMessage.value = ''; // Clear error message
    } catch (error) {
      errorChapterMessage.value = 'Failed to load comic details: $error';
    } finally {
      isChapterLoading.value = false;
    }
  }
  // Fetch all comics by genre
  Future<void> fetchGenComics(String url) async {
    isCategoryComicsLoading.value = true;
    try {
      genComics.clear();
      await _comicsProvider.getGenComics(url);
      genComics.assignAll(_comicsProvider.genComics);
      errorCategoryComicsMessage.value = '';
    } catch (error) {
      errorCategoryComicsMessage.value = 'Failed to load comics: $error';
    } finally {
      isCategoryComicsLoading.value = false;
    }
  }


  // Sort chapters in reverse order
  void sortChapters() {
    isReversed.value=!isReversed.value;
    chapterList.value = chapterList.reversed.toList();
  }

  // Toggle like status
  void changeLike(bool like) {
    isLike.value = like;
  }
}
