import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../../data/model/model.dart';
import '../../../../widget/appbar_widget.dart';
import '../../../../widget/carousel_widget.dart';
import '../../../../widget/category_scroll_widget.dart';
import '../../../../widget/loading.dart';
import '../../../../widget/new_comic_card_widget.dart';
import '../../../../widget/popular_grid_widget.dart';
import '../../../../widget/section_title_widget.dart';
import '../../category_detail/category.dart';
import '../../chap_detail/srceens/chapDetail.dart';
import '../../comic_details_page/srceen/details.dart';
import '../controller/comicController.dart';

class HomePageZscan extends StatelessWidget {
  final ComicController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                TransparentAppBar(title: "Zscan"),
                SizedBox(height: 1.5.h),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async{
                      controller.pullRefresh();
                    },
                    color: Colors.red,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Obx(() {
                            if (controller.isLoading.value) {
                              return Center(child: LoadingWidget());
                            } else if (controller.errorMessage.isNotEmpty) {
                              return Center(
                                child: Text(
                                  controller.errorMessage.value,
                                  style: TextStyle(color: Colors.white),
                                ),
                              );
                            } else {
                              return _buildCarouselSlider(controller.comics);
                            }
                          }),
                          _buildSectionTitle("Category"),
                          Obx(() {
                            if (controller.isLoading.value) {
                              return Center(child: LoadingWidget());
                            } else if (controller.errorMessage.isNotEmpty) {
                              return Center(
                                child: Text(
                                  controller.errorMessage.value,
                                  style: TextStyle(color: Colors.white),
                                ),
                              );
                            } else {
                              return _buildCategoryScroll([
                                CategoryComics.withLinkDetail("Action", "action") ,
                                CategoryComics.withLinkDetail("Romance", "romance") ,
                                CategoryComics.withLinkDetail("Thriller", 'thriller'),
                                CategoryComics.withLinkDetail("Comedy", 'comedy'),
                                CategoryComics.withLinkDetail("Drama", 'drama'),
                                CategoryComics.withLinkDetail("Adventure", 'adventure'),
                                CategoryComics.withLinkDetail("Supernatural", 'supernatural'),
                                CategoryComics.withLinkDetail("Slice of Life", 'slice of life'),
                              ]);
                            }
                          }),
                          _buildSectionTitle("Last Update"),
                          Obx(() {
                            if (controller.isLastUpdateComicLoading.value) {
                              return Center(child: LoadingWidget());
                            } else if (controller.errorMessage.isNotEmpty) {
                              return Center(
                                child: Text(
                                  controller.errorLastUpdateComicMessage.value,
                                  style: TextStyle(color: Colors.white),
                                ),
                              );
                            } else {
                              return _buildNewComicsGrid(controller.newComics);
                            }
                          }),
                          _buildSectionTitle("Other"),
                          Obx(() {
                            if (controller.isLoading.value) {
                              return Center(child: LoadingWidget());
                            } else if (controller.errorMessage.isNotEmpty) {
                              return Center(
                                child: Text(
                                  controller.errorMessage.value,
                                  style: TextStyle(color: Colors.white),
                                ),
                              );
                            } else {
                              return _buildPopularAll(controller.comics);
                            }
                          }),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCarouselSlider(List<ComicsModel> comics) {
    return CarouselSliderWidget(
      comics: comics,
      onPageChanged: (index) {
        // Optional: Handle page change if needed
      },
      onTapItem: (ComicsModel comic) async { // Made async
        controller.fetchChapterList(int.parse(comic.linkDetail.split(' ')[1])); // Await the fetch
        controller.comic.value = comic;
        Get.to(() => ComicDetail());
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return SectionTitle(title: title);
  }

  Widget _buildCategoryScroll(List<CategoryComics> genres) {
    if (genres.isEmpty) { // Removed null check as List<String> cannot be null
      return Center(child: Text("No genres available"));
    }
    return CategoryScroll(
      genres: genres,
      onGenreTap: (url)  {
        controller.fetchGenComics(url);
        Get.to(() => CategoryDetail(title: url));
      },
    );
  }

  Widget _buildNewComicsGrid(List<ComicsModel> comics) {
    return SingleChildScrollView(
      padding: EdgeInsets.zero,
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      child: Row(
        children: comics.map((comic) {
          return Padding(
            padding: EdgeInsets.only(
              left: 1.w,
              right: 18.px,
            ),
            child: NewComicCard(
              comic: comic,
              onTapItem: (ComicsModel comic) {
                controller.fetchChapterList(int.parse(comic.linkDetail.split(' ')[1]));
                controller.comic.value = comic;
                Get.to(() => ComicDetail());
              },
              onTapChapterItem: (ComicsModel comic, List<Chapter> chapters, int index) async {
                controller.fetchChapter(
                  comic.linkDetail.split(" ")[0],
                  int.parse(comic.chapters[index].linkDetail),
                );
                controller.fetchChapterList(
                    int.parse(controller.comic.value.linkDetail.split(' ')[1]),
                    controller.chapterList
                );
                Get.to(() => ChapDetail(
                  isShowFromDetail: false,
                  index: index,
                ));
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPopularAll(List<ComicsModel> comics) {
    return PopularAllGrid(
      comics: comics,
      onTap: (ComicsModel comic) {
        controller.fetchChapterList(int.parse(comic.linkDetail.split(' ')[1]));
        controller.comic.value = comic;
        Get.to(() => ComicDetail());
      },
    );
  }
}
