import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_flutter/components/GenreGridListWidget.dart';
import 'package:streamit_flutter/components/LoaderWidget.dart';
import 'package:streamit_flutter/main.dart';
import 'package:streamit_flutter/models/GenreData.dart';
import 'package:streamit_flutter/models/topics_model.dart';
import 'package:streamit_flutter/network/RestApis.dart';
import 'package:streamit_flutter/utils/Constants.dart';
import 'package:streamit_flutter/utils/resources/Images.dart';

import '../utils/resources/Colors.dart';

class GenreListScreen extends StatefulWidget {
  static String tag = '/GenreListScreen';
  final String? type;

  GenreListScreen({this.type});

  @override
  GenreListScreenState createState() => GenreListScreenState();
}
class GenreListScreenState extends State<GenreListScreen> {
  ScrollController scrollController = ScrollController();
  List<TopicsBean> genreList = [];

  bool isLoading = true;
  bool loadMore = true;
  bool hasError = false;

  int page = 1;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(
      () {
        if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent) {
          if (loadMore) {
            page++;
            isLoading = true;
            setState(() {});

            init();
          }
        }
      },
    );
    init();
  }

  Future<void> init() async {
    getTopics().then((value) {
      isLoading = false;

      if (page == 1) genreList.clear();
      loadMore = value.length == postPerPage;

      genreList.addAll(value);

      setState(() {});
    }).catchError((error) {
      isLoading = false;
      hasError = true;
      log(error.toString());
      setState(() {});
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        init();
        return await 2.seconds.delay;
      },
      child: Scaffold(
        // backgroundColor: Colors.white,
        body: Container(
          height: context.height(),
          child: Stack(
            children: [
              // SingleChildScrollView(
              //   child: GenreGridListWidget(genreList, widget.type!),
              //   controller: scrollController,
              // ),
              ListView.builder(
                  itemCount: genreList.length,
                  padding: EdgeInsets.only(left: 20, right: 20, top:15),
                  itemBuilder: (_, index) => Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: Card(
                          margin: EdgeInsets.zero,
                          color: Colors.transparent,
                          elevation: 3,
                          shadowColor: Colors.transparent,
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(12)),
                            height: 60,
                            alignment: Alignment.center,
                            child: HtmlWidget(
                              genreList[index].name ?? '',
                              textStyle: TextStyle(
                                  color: textColorPrimary,
                                  fontSize: 20,
                                  fontFamily: 'RobotoCondensed',
                                  fontWeight: FontWeight.bold),

                            )
                          ),
                        ),
                      )),
              LoaderWidget().visible(isLoading),
              NoDataWidget(
                imageWidget: Image.asset(ic_empty, height: 130),
                title: language!.noData,
              ).center().visible(!isLoading && genreList.isEmpty && !hasError),
              Text(errorInternetNotAvailable,
                      style: boldTextStyle(color: Colors.white))
                  .center()
                  .visible(hasError),
            ],
          ).makeRefreshable,
        ),
      ),
    );
  }
}
