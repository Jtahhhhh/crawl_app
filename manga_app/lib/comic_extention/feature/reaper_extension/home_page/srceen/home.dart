
import 'package:flutter/cupertino.dart';
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

import '../controller/controller.dart';


class HomePageReaper extends StatelessWidget {
  final ComicReaperController controller = Get.find();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                TransparentAppBar(title: "ReaperScan",),
                SizedBox(height: 1.5.h,),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async{
                      controller.pullRefresh();
                    } ,
                    color: Colors.red,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Obx((){
                            if (controller.isComicsLoading.value) {
                              return Center(child: LoadingWidget());
                            } else if (controller.errorComicsMessage.isNotEmpty) {
                              return Center(
                                child: Text(
                                  controller.errorComicsMessage.value,
                                  style: TextStyle(color: Colors.white,
                                  ),
                                ),
                              );
                            } else {
                              return _buildCarouselSlider(controller.newComics);
                            }
                          }),
                          _buildSectionTitle("Category"),
                          Obx((){
                            if (controller.isCategoryLoading .value) {
                              return Center(child: LoadingWidget());
                            } else if (controller.errorCategoryMessage.isNotEmpty) {
                              return Center(
                                child: Text(controller.errorCategoryMessage.value,
                                    style: TextStyle(color: Colors.white)),
                              );
                            } else {
                              return _buildCategoryScroll(controller.category);
                            }
                          }),

                          _buildSectionTitle("Last Update"),
                          Obx((){
                            if (controller.isLoading.value) {
                              return Center(child: LoadingWidget());
                            } else if (controller.errorMessage.isNotEmpty) {
                              return Center(
                                child: Text(controller.errorMessage.value,
                                    style: TextStyle(color: Colors.white)),
                              );
                            } else {
                              return _buildNewComicsGrid(controller.comicsPopular);
                            }
                          }),
                          _buildSectionTitle("Other"),
                          Obx((){
                            if (controller.isLoadingComicsAll.value) {
                              return Center(child: LoadingWidget());
                            } else if (controller.errorComicsAllMessage.isNotEmpty) {
                              return Center(
                                child: Text(controller.errorComicsAllMessage.value,
                                    style: TextStyle(color: Colors.white)),
                              );
                            } else {
                              return _buildPopularAll(controller.comics);
                            }
                          }
                          ),
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

        },
        onTapItem:(ComicsModel comic) async{
          await controller.fetchComic(comic.linkDetail);
          controller.comic.value= comic;
          Get.to(() => ComicReaperDetail());
        }
    );
  }

  Widget _buildSectionTitle(String title) {
    return SectionTitle(title: title);
  }

  Widget _buildCategoryScroll(List<CategoryComics> genres) {
    if (genres == null || genres.isEmpty) {
      return Center(child: Text("No genres available"));
    }
    return CategoryScroll(
      genres: genres,
      onGenreTap: (url) async {
        controller.genComics.clear();
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
              onTapItem:(ComicsModel comic)  {
                controller.fetchComic(comic.linkDetail);
                controller.comic.value= comic;
                Get.to(() => ComicReaperDetail());
              },
              onTapChapterItem: (ComicsModel comic, List<Chapter> chapters, int index) {
                controller.fetchComic(comic.linkDetail);
                controller.comic.value= comic;
                controller.getChapterImg(chapters[index].linkDetail,comic.linkDetail);
                Get.to(() => ChapReaperDetail(
                    isShowFromDetail: false,
                    index:index));
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPopularAll(List<ComicsModel> comics){
    return PopularAllGrid(
      comics: comics,
      onTap: (ComicsModel comic) {

        controller.comic.value= comic;
        controller.fetchComic(comic.linkDetail);
        Get.to(() => ComicReaperDetail());
      },
    );
  }
}
