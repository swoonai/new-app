import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_flutter/components/CommentShimmerWidget.dart';
import 'package:streamit_flutter/models/CommentModel.dart';
import 'package:streamit_flutter/network/RestApis.dart';
import 'package:streamit_flutter/screens/Signin.dart';
import 'package:streamit_flutter/utils/AppWidgets.dart';
import 'package:streamit_flutter/utils/Common.dart';
import 'package:streamit_flutter/utils/Constants.dart';
import 'package:streamit_flutter/utils/resources/Colors.dart';

import '../main.dart';

// ignore: must_be_immutable
class CommentWidget extends StatefulWidget {
  static String tag = '/CommentWidget';
  final int? postId;
  int? noOfComments;

  CommentWidget({this.postId, this.noOfComments});

  @override
  CommentWidgetState createState() => CommentWidgetState();
}

class CommentWidgetState extends State<CommentWidget> {
  late Future<List<CommentModel>> _getComment;

  @override
  void initState() {
    _getComment = getComments(postId: widget.postId, page: 1, commentPerPage: postPerPage);
    super.initState();
    init();
  }

  Future<void> init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<CommentModel>>(
      key: UniqueKey(),
      future: _getComment,
      builder: (ctx, snap) {
        if (snap.hasData) {
          if (snap.data.validate().isNotEmpty) {
            final data = snap.data.validate()[snap.data.validate().length - 1];
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    headingText(snap.data.validate().length > 1 ? language!.comments : language!.comment, fontSize: 24),
                    4.width,
                    Text("(${snap.data.validate().length})", style: primaryTextStyle(size: 20)),
                  ],
                ),
                8.height,
                SplashWidget(
                  onTap: () async {
                    await CommentListScreen(
                      postId: widget.postId.validate(),
                      commentList: snap.data.validate(),
                    ).launch(context, pageRouteAnimation: PageRouteAnimation.SlideBottomTop).then((value) {
                      if (value != null && value is Map) {
                        if (value['is_update']) {
                          setState(() {});
                        }
                      }
                    });
                  },
                  backgroundColor: Colors.grey.withOpacity(0.1),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                        alignment: Alignment.center,
                        child: Text(
                          data.authorName.validate()[0].validate(),
                          style: boldTextStyle(color: colorPrimary, size: 20),
                        ),
                      ),
                      16.width,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(data.authorName.validate(), style: primaryTextStyle()),
                          4.height,
                          Text(DateFormat(dateFormat).format(DateTime.parse(data.date.validate())), style: secondaryTextStyle(size: 12)),
                          4.height,
                          Text(
                            parseHtmlString(data.content!.rendered.validate()),
                            style: primaryTextStyle(size: 14),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          )
                        ],
                      ).expand(),
                      8.width,
                      Icon(Icons.arrow_drop_down_rounded, size: 30),
                    ],
                  ),
                ),
              ],
            );
          } else {
            return Offstage();
          }
        }
        if (snap.hasError) {
          log("=====>Error : ${snap.error.toString()}<=====");
          return Offstage();
        }
        return CommentShimmerWidget();
      },
    );
  }
}

class CommentListScreen extends StatelessWidget {
  final int postId;
  final List<CommentModel> commentList;

  CommentListScreen({Key? key, required this.postId, required this.commentList}) : super(key: key);

  final TextEditingController mainCommentCont = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: context.height(),
        width: context.width(),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    BackButton(),
                    8.width,
                    Text(
                      "${commentList.length > 1 ? language!.comments : language!.comment} (${commentList.length})",
                      style: boldTextStyle(size: 20),
                    ),
                  ],
                ),
                ListView.separated(
                  padding: EdgeInsets.only(left: 16, top: 16, right: 16, bottom: 70),
                  itemCount: commentList.length,
                  itemBuilder: (_, index) {
                    CommentModel comment = commentList[index];

                    return comment.parent == 0
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                                child: Text(
                                  comment.authorName![0].validate(),
                                  style: boldTextStyle(color: colorPrimary, size: 20),
                                ).center(),
                              ),
                              16.width,
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(comment.authorName.validate(), style: boldTextStyle(color: Colors.white)),
                                          Text(
                                            DateFormat(dateFormat).format(DateTime.parse(comment.date.validate())),
                                            style: secondaryTextStyle(),
                                          )
                                        ],
                                      ).expand(),
                                    ],
                                  ),
                                  4.height,
                                  Text(
                                    parseHtmlString(comment.content!.rendered.validate()),
                                    style: primaryTextStyle(color: Colors.grey, size: 14),
                                  ),
                                ],
                              ).expand(),
                            ],
                          )
                        : SizedBox();
                  },
                  separatorBuilder: (_, index) => Divider(color: textColorPrimary, thickness: 0.1, height: 0),
                ).expand(),
              ],
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: mIsLoggedIn
                  ? Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: context.scaffoldBackgroundColor,
                        boxShadow: [BoxShadow(color: Colors.white30, blurRadius: 8.0)],
                      ),
                      child: AppTextField(
                        controller: mainCommentCont,
                        textFieldType: TextFieldType.MULTILINE,
                        maxLines: 5,
                        minLines: 2,
                        keyboardType: TextInputType.multiline,
                        textStyle: primaryTextStyle(color: textColorPrimary),
                        errorThisFieldRequired: errorThisFieldRequired,
                        decoration: InputDecoration(
                          hintText: language!.addAComment,
                          hintStyle: secondaryTextStyle(),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.send),
                            color: colorPrimary,
                            onPressed: () {
                              hideKeyboard(context);
                              appStore.setLoading(true);

                              buildComment(content: mainCommentCont.text.trim(), postId: postId).then((value) {
                                appStore.setLoading(false);

                                mainCommentCont.clear();
                                commentList.add(value);
                                finish(context, {"is_update": true});
                              }).catchError((error) {
                                toast(language!.pleaseEnterComment);
                              });
                            },
                          ),
                          border: UnderlineInputBorder(borderSide: BorderSide(color: colorPrimary)),
                          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: colorPrimary)),
                          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: colorPrimary)),
                        ),
                      ),
                    )
                  : TextButton(
                      child: Text(
                        language!.loginToAddComment,
                        style: primaryTextStyle(color: colorPrimary, size: 18),
                        textAlign: TextAlign.center,
                      ),
                      onPressed: () {
                        SignInScreen().launch(context);
                      },
                    ),
            ),
            Observer(
              builder: (context) {
                return Loader().center().visible(appStore.isLoading);
              },
            ),
          ],
        ).paddingTop(context.statusBarHeight),
      ),
    );
  }
}

// ignore: must_be_immutable
class SplashWidget extends StatelessWidget {
  final double borderRadius;
  final Color color;
  final Color backgroundColor;
  final Widget child;
  final VoidCallback onTap;

  SplashWidget({
    Key? key,
    this.borderRadius = 16,
    this.color = Colors.white,
    this.backgroundColor = Colors.white,
    required this.child,
    required this.onTap,
  }) : super(key: key);

  /// Local variable
  bool isTap = false;

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, uptState) {
      return InkWell(
        onTap: () => onTap.call(),
        onTapDown: (s) {
          uptState(() {
            isTap = true;
          });
        },
        onTapUp: (s) {
          uptState(() {
            isTap = false;
          });
        },
        highlightColor: color.withOpacity(0.05),
        child: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(color: isTap ? color : Colors.transparent, width: 0.2),
          ),
          child: child,
        ),
      );
    });
  }
}
