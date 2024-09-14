import 'package:flutter/material.dart';
import '../model/model.dart';

class ComicsExtensionProvider with ChangeNotifier {
  static String getLogoWeb({required String url}) =>
      'https://t3.gstatic.com/faviconV2?client=SOCIAL&type=FAVICON&fallback_opts=TYPE,SIZE,URL&url=$url&size=128';

  List<ComicsExtension> _dataDefault = [
    ComicsExtension(name: 'Zscan', logo: getLogoWeb(url: 'https://zscans.com/')),
    ComicsExtension(name: 'Mortals Groove', logo: 'https://mortalsgroove.com/'),
    ComicsExtension(name: 'ReaperScan', logo: getLogoWeb(url: 'https://reaperscans.com')),
  ];

  List<ComicsExtension> data = [];
  List<ComicsExtension> dataInstalled = [];

  Future<void> initData() async {
    data = List.from(_dataDefault)..sort((el1, el2) => el1.isInstall ? -1 : 1);
    dataInstalled = List.from(data.where((el) => el.isInstall))
      ..sort((el1, el2) => el1.isPin ? -1 : 1);
    notifyListeners();
  }

  Future<void> updateComicsExtension({required ComicsExtension extension}) async {
    final index = _dataDefault.indexWhere((d) => d.name == extension.name);
    if (index != -1) {
      _dataDefault[index] = extension;

      data = List.from(_dataDefault)..sort((el1, el2) => el1.isInstall ? -1 : 1);
      dataInstalled = List.from(data.where((el) => el.isInstall))
        ..sort((el1, el2) => el1.isPin ? -1 : 1);
    }
    notifyListeners();
  }
}
