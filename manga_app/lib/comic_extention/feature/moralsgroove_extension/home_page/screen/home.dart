import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../data/model/model.dart';
import '../../../../widget/appbar_widget.dart';
import '../../../../widget/carousel_widget.dart';
import '../../../../widget/category_scroll_widget.dart';
import '../../../../widget/loading.dart';
import '../../../../widget/new_comic_card_widget.dart';
import '../../../../widget/popular_grid_widget.dart';
import '../../../../widget/section_title_widget.dart';
import '../../category_detail/category.dart';
import '../../chap_detail/chapdetail.dart';
import '../../comic_details_page/srceen/details.dart';
import 'package:sizer/sizer.dart';

import '../controller/comicController.dart';

class HomePageMotals extends StatelessWidget {
  final ComicMotalsController controller = Get.find();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                TransparentAppBar(title: "Mortals Groove",),
                SizedBox(height: 1.5.h,),
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
                            if (controller.isLoadingPopularComics.value) {
                              return Center(child: LoadingWidget());
                            } else if (controller.errorPopularComicMessage.isNotEmpty) {
                              return Center(
                                child: Text(controller.errorPopularComicMessage.value,
                                    style: const TextStyle(color: Colors.white)),
                              );
                            } else if (controller.newComics.isEmpty) {
                              return const Center(child: Text("No comics available", style: TextStyle(color: Colors.white)));
                            } else {
                              return _buildCarouselSlider(controller.newComics);
                            }
                          }),
                          _buildSectionTitle("Category"),
                          _buildCategoryScroll([
                            CategoryComics.withLinkDetail("Action", "action") ,
                            CategoryComics.withLinkDetail("Romance", "romance") ,
                            CategoryComics.withLinkDetail("Thriller", 'thriller'),
                            CategoryComics.withLinkDetail("Comedy", 'comedy'),
                            CategoryComics.withLinkDetail("Drama", 'drama'),
                            CategoryComics.withLinkDetail("Adventure", 'adventure'),
                            CategoryComics.withLinkDetail("Supernatural", 'supernatural'),
                            CategoryComics.withLinkDetail("Slice of Life", 'slice of life'),
                          ]),
                          _buildSectionTitle("Last Update"),
                          Obx(() {
                            if (controller.isLoadingComics.value) {
                              return Center(child: LoadingWidget());
                            } else if (controller.errorMessage.isNotEmpty) {
                              return Center(
                                child: Text(controller.errorMessage.value,
                                    style: const TextStyle(color: Colors.white)),
                              );
                            } else {
                              return _buildNewComicsGrid(controller.comics);
                            }
                          }),
                          _buildSectionTitle("Other"),
                          Obx(() {
                            if (controller.isLoadingComics.value) {
                              return Center(child: LoadingWidget());
                            } else if (controller.errorMessage.isNotEmpty) {
                              return Center(
                                child: Text(controller.errorMessage.value,
                                    style: const TextStyle(color: Colors.white)),
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
    if (comics.isEmpty) {
      return const Center(child: Text("No comics to display", style: TextStyle(color: Colors.white)));
    }
    return CarouselSliderWidget(
      comics: comics,
      onPageChanged: (index) {},
      onTapItem: (ComicsModel comic) {
        controller.comic.value = comic;
        controller.fetchComic(comic.linkDetail);
        Get.to(() => ComicMortalsDetail());
      },
    );
  }


  Widget _buildSectionTitle(String title) {
    return SectionTitle(title: title);
  }

  Widget _buildCategoryScroll(List<CategoryComics> genres) {
    if (genres == null || genres.isEmpty) {
      return const Center(child: Text("No genres available"));
    }
    return CategoryScroll(
      genres: genres,
      onGenreTap: (url) async {
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
        children: comics.mapIndexed((i, comic) {
          double? leftPadding = 2.5.w;
          double? rightPadding = 18.px;

          if (i > 0 && i < comics.length - 1) {
            leftPadding = null;
          }

          if (i == comics.length - 1) {
            rightPadding = 2.5.w;
            leftPadding = null;
          }

          return Padding(
            padding: EdgeInsets.only(
              left: leftPadding ?? 0.0,
              right: rightPadding,
            ),
            child: NewComicCard(
              comic: comic,
              onTapItem: (ComicsModel comic) {
                controller.comic.value = comic;
                controller.fetchComic(comic.linkDetail);
                Get.to(() => ComicMortalsDetail());
              },
              onTapChapterItem: (ComicsModel comic, List<Chapter> chapters, int index) async {
                controller.getChapterImg(comic.chapters[index].linkDetail);
                controller.comic.value = comic;
                controller.fetchComic(comic.linkDetail);
                Get.to(() => ChapDetail(
                    isShowFromDetail: false,
                    index: index));
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
        controller.comic.value = comic;
        controller.fetchComic(comic.linkDetail);
        Get.to(() => ComicMortalsDetail());
      },
    );
  }

}
