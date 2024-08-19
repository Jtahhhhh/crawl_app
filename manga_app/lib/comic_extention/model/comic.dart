import 'dart:typed_data';

import 'package:hive/hive.dart';

part 'comic.g.dart';

@HiveType(typeId:3)
class ComicsModel{
  @HiveField(0)
  String image = '';
  @HiveField(1)
  String title = '';
  @HiveField(2)
  String linkDetail = '';

  ComicsModel.small({required this.image,required this.title,required this.linkDetail});
  ComicsModel();

  String rating = '';
  String type = '';
  List<CategoryComics> categoryComics = [];
  String description = '';
  String status = '';
  String? author = '';
  String? artist = '';

  ComicsModel.banner(
      this.image,
      this.title,
      this.linkDetail,
      this.rating,
      this.type,
      this.categoryComics,
      this.description,
      this.status);

  List<Chapter> chapters = [];
  List<ImgChap> imgChap = [];
  ComicsModel.lastestUpdate(
      this.image, this.title, this.linkDetail, this.chapters);

  ComicsModel.popular(
      this.image, this.title,this.rating, this.categoryComics,this.linkDetail);

  ComicsModel.search(
      this.image,this.title,this.rating,this.linkDetail);

  ComicsModel.detail(
      this.image,this.title,this.rating,this.linkDetail,this.status,this.categoryComics,this.chapters,this.description,
      [this.author = null, this.artist = null,]
      );
  ComicsModel.dow(this.imgChap,this.title);
  ComicsModel.error();

  @override
  String toString() {
    return 'ComicsModel{image: $image, title: $title, linkDetail: $linkDetail, rating: $rating, type: $type, categoryComics: $categoryComics, description: $description, status: $status, chapters: $chapters}';
  }
}

@HiveType(typeId: 4)
class Chapter{
  @HiveField(0)
  String name;
  @HiveField(1)
  String linkDetail;
  @HiveField(2)
  String dateUpdate;
  Chapter(this.name, this.linkDetail, this.dateUpdate);

  @override
  String toString() {
    return 'Chapter{name: $name, linkDetail: $linkDetail, dateUpdate: $dateUpdate}';
  }
}

class CategoryComics{
  String name = '';
  String linkDetail = '';
  String value = '';
  CategoryComics.withLinkDetail(this.name, this.linkDetail);
  CategoryComics.value(this.name, this.value);

  @override
  String toString() {
    return 'CategoryComics{name: $name, linkDetail: $linkDetail, value: $value}';
  }
}

@pragma('vm:entry-point')
@HiveType(typeId: 10)
class ImgChap{
  @HiveField(0)
  String chapname;
  @HiveField(1)
  String title;
  @HiveField(2)
  late Uint8List imagesmall;

  ImgChap(this.chapname,this.title);
  ImgChap.init(this.imagesmall, this.title, this.chapname);
  ImgChap.dow(this.chapname,this.title,this.imagesmall);
}

@pragma('vm:entry-point')
@HiveType(typeId: 11)
class Chapterinfo{
  @HiveField(0)
  String chapname;
  @HiveField(1)
  late List<Uint8List> listimg;
  @HiveField(2)
  late DateTime dateupdate;
  @HiveField(3)
  late int state;
  @HiveField(4)
  int? currentIndex;
  @HiveField(5)
  int? total;

  int get getCurrentIndex => this.currentIndex ?? 0;
  int get getTotal => this.total ?? 1;

  Chapterinfo(this.chapname,this.listimg,this.dateupdate);
  Chapterinfo.crawl(this.chapname);
  Chapterinfo.init(this.chapname,this.listimg,this.dateupdate,this.state);

  @override
  String toString() {
    return 'Chapterinfo{chapname: $chapname, dateupdate: $dateupdate, state: $state, currentIndex: $currentIndex, total: $total}';
  }
}