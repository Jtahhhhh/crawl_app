import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../data/model/model.dart';
import '../../data/provider/comicprovider.dart';
import '../../widget/backgroundwidget.dart';
import '../../widget/customicon.dart';
import '../moralsgroove_extension/home_page/screen/home.dart';
import '../reaper_extension/home_page/srceen/home.dart';
import '../zscan_extension/home_page/screen/home.dart';

class ComicsExtensionPage extends StatefulWidget {
  const ComicsExtensionPage({Key? key}) : super(key: key);

  @override
  State<ComicsExtensionPage> createState() => _ComicsExtensionPageState();
}

class _ComicsExtensionPageState extends State<ComicsExtensionPage> with TickerProviderStateMixin {
  late TabController _tabController = TabController(length: 2, vsync: this);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BackgroundWidget(),
        SafeArea(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              title: Text(
                'Extension',
                style: TextStyle(
                    fontSize: 20.sp,
                    color: Colors.white
                ),
              ),
              centerTitle: true,
              bottom: TabBar(
                controller: _tabController,
                indicatorColor: Colors.amber,
                labelStyle: TextStyle(
                    fontSize: 18.sp,
                    color: Colors.white
                ),
                tabs: const [
                  Tab(text: 'Source'),
                  Tab(text: 'Extensions'),
                ],
              ),
            ),
            body: TabBarView(
              controller: _tabController,
              physics: const BouncingScrollPhysics(),
              children: [
                // Tab 1: Installed Extensions
                Selector<ComicsExtensionProvider, List<ComicsExtension>>(
                  builder: (BuildContext context, List<ComicsExtension> data, _) {
                    return ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final extension = data[index];
                        return ListTile(
                          onTap: () {
                            // Navigate based on extension name
                            switch(extension.name) {
                              case 'ReaperScan':
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => HomePageReaper(),
                                  ),
                                ); break;
                              case 'Mortals Groove':
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => HomePageMotals(),
                                  ),
                                ); break;
                              case 'Zscan' :
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => HomePageZscan(),
                                  ),
                                ); break;
                            }
                          },
                          leading: CustomIcon(
                            image: extension.logo,
                            size: IconTheme.of(context).size! * 1.2,
                          ),
                          title: Text(
                            extension.name,
                            style: TextStyle(fontSize: 15.sp,color: Colors.white),
                          ),
                          trailing: InkWell(
                            onTap: () {
                              Provider.of<ComicsExtensionProvider>(context, listen: false)
                                  .updateComicsExtension(
                                  extension: extension..isPin = !extension.isPin);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: extension.isPin
                                  ? Icon(
                                Icons.push_pin,
                                color: Colors.yellow.shade700,
                              )
                                  : const Icon(Icons.push_pin_outlined),
                            ),
                          ),
                        );
                      },
                    );
                  },
                  selector: (_, state) => state.dataInstalled,
                ),

                Selector<ComicsExtensionProvider, List<ComicsExtension>>(
                  builder: (BuildContext context, List<ComicsExtension> data, _) {
                    return ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final extension = data[index];
                        return ListTile(
                          leading: CustomIcon(
                            image: extension.logo,
                            size: 2,
                          ),
                          title: Text(
                            extension.name,
                            style: TextStyle(fontSize: 15.sp,color: Colors.white),
                          ),
                          trailing: InkWell(
                            onTap: () {
                              final isInstall = !extension.isInstall;
                              Provider.of<ComicsExtensionProvider>(context, listen: false)
                                  .updateComicsExtension(
                                  extension: extension
                                    ..isInstall = isInstall
                                    ..isPin = isInstall ? extension.isPin : false);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                extension.isInstall ? 'Remove' : 'Add',
                                style: TextStyle(
                                  color: extension.isInstall ? Colors.lightBlueAccent : Colors.white,
                                  fontSize: 15.sp,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                  selector: (_, state) => state.data,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
