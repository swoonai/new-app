import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_flutter/components/LoaderWidget.dart';
import 'package:streamit_flutter/main.dart';
import 'package:streamit_flutter/models/DashboardResponse.dart';
import 'package:streamit_flutter/network/RestApis.dart';
import 'package:streamit_flutter/screens/ViewAllMoviesScreen.dart';
import 'package:streamit_flutter/screens/movieDetailComponents/HomeSliderWidget.dart';
import 'package:streamit_flutter/screens/movieDetailComponents/ItemHorizontalList.dart';
import 'package:streamit_flutter/utils/AppWidgets.dart';
import 'package:streamit_flutter/utils/Constants.dart';
import 'package:streamit_flutter/utils/resources/Images.dart';

class HomeCategoryFragment extends StatefulWidget {
  static String tag = '/SubHomeFragment';
  final String type;

  HomeCategoryFragment({required this.type});

  @override
  HomeCategoryFragmentState createState() => HomeCategoryFragmentState();
}

class HomeCategoryFragmentState extends State<HomeCategoryFragment>
    with AutomaticKeepAliveClientMixin {
  late Future<DashboardResponse> future;

  @override
  void initState() {
    super.initState();
    future =
        getDashboardData({}, type: widget.type.validate(value: widget.type));
  }

  Future<void> savePref(AsyncSnapshot<DashboardResponse> snap) async {
    await setValue(REGISTRATION_PAGE, snap.data!.registerPage);
    await setValue(ACCOUNT_PAGE, snap.data!.accountPage);
    await setValue(LOGIN_PAGE, snap.data!.loginPage);
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return RefreshIndicator(
      onRefresh: () async {
        setState(() {});
        await 2.seconds.delay;
        return Future.value(true);
      },
      child: Scaffold(
        body: Container(
          alignment: Alignment.topCenter,
          child: FutureBuilder<DashboardResponse>(
            future: future,
            builder: (_, snap) {
              if (snap.hasData) {
                savePref(snap);

                if (snap.data!.banner.validate().isEmpty &&
                    snap.data!.sliders.validate().isEmpty) {
                  return NoDataWidget(
                    imageWidget: Image.asset(ic_empty, height: 130),
                    title: language!.noData,
                  );
                }
                log(snap.toString());
                return SingleChildScrollView(
                  padding: EdgeInsets.only(bottom: 60),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DashboardSliderWidget(snap.data!.banner.validate()),
                      Column(
                        children: snap.data!.sliders.validate().map(
                          (e) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                headingWidViewAll(
                                  context,
                                  e.title.validate(),
                                  callback: () async {
                                    youtubePlayerController!.pause();
                                    await ViewAllMoviesScreen(
                                            snap.data!.sliders!.indexOf(e),
                                            widget.type)
                                        .launch(context);
                                    youtubePlayerController!.play();
                                  },
                                )
                                    .paddingSymmetric(
                                        horizontal: 16, vertical: 16)
                                    .visible(e.viewAll.validate() ||
                                        e.data.validate().isNotEmpty),
                                ItemHorizontalList(e.data.validate()),
                              ],
                            );
                          },
                        ).toList(),
                      ),
                    ],
                  ),
                );
              } else {
                return snapWidgetHelper(
                  snap,
                  loadingWidget: LoaderWidget(),
                ).center();
              }
            },
          ).makeRefreshable,
        ),
      ),
    );
  }
}
