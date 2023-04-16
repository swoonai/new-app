import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:stream_transform/stream_transform.dart';
import 'package:streamit_flutter/components/LoadingDotWidget.dart';
import 'package:streamit_flutter/main.dart';
import 'package:streamit_flutter/models/MovieData.dart';
import 'package:streamit_flutter/network/RestApis.dart';
import 'package:streamit_flutter/screens/VoiceSearchScreen.dart';
import 'package:streamit_flutter/utils/AppWidgets.dart';
import 'package:streamit_flutter/utils/resources/Colors.dart';
import 'package:streamit_flutter/utils/resources/Images.dart';
import 'package:streamit_flutter/utils/resources/Size.dart';

import '../components/LoaderWidget.dart';
import '../screens/movieDetailComponents/MovieGridWidget.dart';

class SearchFragment extends StatefulWidget {
  static String tag = '/SearchFragment';

  @override
  SearchFragmentState createState() => SearchFragmentState();
}

class SearchFragmentState extends State<SearchFragment> {
  List<MovieData> movies = [];

  Future<List<MovieData>>? future;

  TextEditingController searchController = TextEditingController();

  int page = 1;

  StreamController<String> searchStream = StreamController();

  @override
  void initState() {
    super.initState();
    init();
    searchStream.stream.debounce(Duration(seconds: 2)).listen((s) {
      page = 1;
      init();
      setState(() {});
    });
  }

  Future<void> init({bool isLoading = true}) async {
    future = searchMovie(searchController.text, page: page, movies: movies, isLoading: isLoading);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(language!.search, showBack: false, color: Theme.of(context).cardColor, textColor: Colors.white),
      body: RefreshIndicator(
        onRefresh: () async {
          page = 1;
          init(isLoading: false);
          setState(() {});
          return await 2.seconds.delay;
        },
        child: Stack(
          children: [
            AnimatedScrollView(
              padding: EdgeInsets.only(bottom: 24),
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              onNextPage: () {
                page = page + 1;
                init();
                setState(() {});
              },
              children: [
                Container(
                  color: search_edittext_color,
                  padding: EdgeInsets.only(left: spacing_standard_new, right: spacing_standard),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: TextFormField(
                          controller: searchController,
                          textInputAction: TextInputAction.search,
                          style: TextStyle(fontSize: ts_normal, color: Theme.of(context).textTheme.headline6!.color),
                          decoration: InputDecoration(
                            hintText: language!.searchMoviesTvShowsVideos,
                            hintStyle: TextStyle(color: Theme.of(context).textTheme.subtitle2!.color),
                            border: InputBorder.none,
                            filled: false,
                          ),
                          onChanged: (s) {
                            searchStream.add(s);
                          },
                          onFieldSubmitted: (s) {
                            page = 1;
                            if (s.isNotEmpty) init();

                            setState(() {});
                          },
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          page = 1;
                          searchController.clear();
                          hideKeyboard(context);

                          setState(() {});
                        },
                        icon: Icon(Icons.cancel, color: colorPrimary, size: 20),
                      ).visible(searchController.text.isNotEmpty),
                      IconButton(
                        onPressed: () {
                          VoiceSearchScreen().launch(context).then((value) {
                            if (value != null) {
                              searchController.text = value;

                              hideKeyboard(context);
                              page = 1;
                              init();
                            }
                          });
                        },
                        icon: Icon(Icons.keyboard_voice, color: colorPrimary, size: 20),
                      ).visible(searchController.text.isEmpty),
                    ],
                  ),
                ),
                SnapHelperWidget<List<MovieData>>(
                  future: future,
                  errorBuilder: (e) {
                    return NoDataWidget(
                      title: e.toString(),
                      onRetry: () {
                        page = 1;
                        init();
                        setState(() {});
                      },
                    );
                  },
                  loadingWidget: Offstage(),
                  onSuccess: (data) {
                    if (data.validate().isEmpty) {
                      return NoDataWidget(
                        imageWidget: Image.asset(ic_empty, height: 130),
                        title: language!.noData,
                      ).center();
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        headingText(language!.resultFor + " \'" + searchController.text + "\'").paddingOnly(left: 16, right: 16, top: 16, bottom: 12).visible(searchController.text.isNotEmpty),
                        MovieGridList(data.validate()),
                      ],
                    );
                  },
                ),
              ],
            ).makeRefreshable,
            Observer(
              builder: (_) {
                if (page == 1) {
                  return LoaderWidget().center().visible(appStore.isLoading);
                } else {
                  return Positioned(
                    left: 0,
                    right: 0,
                    bottom: 16,
                    child: LoadingDotsWidget(),
                  ).visible(appStore.isLoading);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
