import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_flutter/main.dart';
import 'package:video_player/video_player.dart';

class MovieFileWidget extends StatefulWidget {
  final String url;
  final bool isFromLocalStorage;

  MovieFileWidget(this.url, {this.isFromLocalStorage = false});

  @override
  MovieFileWidgetState createState() => MovieFileWidgetState();
}

class MovieFileWidgetState extends State<MovieFileWidget> {
  late VideoPlayerController _videoPlayerController;
  bool isVideoPlay = false;
  bool isActionIconVisible = true;
  bool isVideoCompleted = false;
  bool isMute = false;
  bool isVideoBuffering = false;
  int currentVideoPlayerPosition = 0;

  late Future videoPlayerFuture;

  @override
  void initState() {
    super.initState();

    if (widget.isFromLocalStorage) {
      _videoPlayerController = VideoPlayerController.file(File(widget.url));
    } else {
      _videoPlayerController = VideoPlayerController.network(widget.url);
    }
    videoPlayerFuture = _videoPlayerController.initialize();

    _videoPlayerController.addListener(() {
      isVideoBuffering = _videoPlayerController.value.isBuffering;
      setState(() {});

      currentVideoPlayerPosition =
          _videoPlayerController.value.duration.inMilliseconds == 0 ? 0 : _videoPlayerController.value.position.inMilliseconds;
      if (!isVideoCompleted && _videoPlayerController.value.duration.inMilliseconds == currentVideoPlayerPosition) {
        isVideoCompleted = true;
        isActionIconVisible = true;
        isVideoPlay = false;
        _videoPlayerController.seekTo(Duration.zero);
        _videoPlayerController.pause();
        setState(() {});
        Future.delayed(Duration.zero, () {
          setState(() {
            isVideoCompleted = false;
          });
        });
      }
    });
  }

  void onPlayButtonClick() async {
    if (!isVideoPlay) {
      setState(() {
        isVideoPlay = true;
      });
      Future.delayed(Duration.zero, () {
        _videoPlayerController.play();
      });
    } else if (isVideoPlay) {
      setState(() {
        isVideoPlay = false;
      });
      Future.delayed(Duration.zero, () {
        _videoPlayerController.pause();
      });
    }
    Future.delayed(const Duration(seconds: 5), () {
      setState(() {
        isActionIconVisible = false;
      });
    });
  }

  void onForwardButtonClick() async {
    if (!isActionIconVisible) {
      setState(() {
        isActionIconVisible = true;
      });
      _videoPlayerController.seekTo(Duration(seconds: _videoPlayerController.value.position.inSeconds + 15));
      _videoPlayerController.play();
      isVideoPlay = true;

      Future.delayed(const Duration(seconds: 5), () {
        setState(() {
          isActionIconVisible = false;
        });
      });
    }
  }

  void onReverseButtonClick() async {
    if (!isActionIconVisible) {
      setState(() {
        isActionIconVisible = true;
      });
      _videoPlayerController.position.then((value) {
        if (value != null) {
          if (value.inSeconds != 0 && value.inSeconds > 15) {
            _videoPlayerController.seekTo(Duration(seconds: _videoPlayerController.value.position.inSeconds - 15));
            _videoPlayerController.play();
            isVideoPlay = true;
          } else {
            _videoPlayerController.seekTo(Duration.zero);
          }
        }
      });
      Future.delayed(const Duration(seconds: 5), () {
        setState(() {
          isActionIconVisible = false;
        });
      });
    }
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        return WillPopScope(
          onWillPop: () {
            if (appStore.hasInFullScreen) {
              appStore.setToFullScreen(false);
              setOrientationPortrait();
              return Future.value(false);
            }
            return Future.value(true);
          },
          child: SizedBox(
            width: context.width(),
            height: appStore.hasInFullScreen ? context.height() - context.statusBarHeight : context.height() * 0.3,
            child: FutureBuilder(
              future: videoPlayerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Stack(
                    children: [
                      VideoPlayer(_videoPlayerController),
                      Positioned(
                        right: 0,
                        left: 0,
                        top: 0,
                        bottom: 0,
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 350),
                          opacity: isActionIconVisible ? 1 : 0,
                          child: isActionIconVisible
                              ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                onPressed: () {
                                  onReverseButtonClick();
                                },
                                color: Colors.white,
                                icon: Icon(Icons.fast_rewind_rounded, size: 40),
                              ),
                              IconButton(
                                onPressed: () {
                                  onPlayButtonClick();
                                },
                                color: Colors.white,
                                icon: Icon(isVideoPlay ? Icons.pause_rounded : Icons.play_arrow_rounded, size: 40),
                              ),
                              IconButton(
                                onPressed: () {
                                  onForwardButtonClick();
                                },
                                color: Colors.white,
                                icon: Icon(Icons.fast_forward_rounded, size: 40),
                              ),
                            ],
                          )
                              : Offstage(),
                        ),
                      ),
                      Positioned(
                        right: 8,
                        bottom: 8,
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 350),
                          opacity: isActionIconVisible ? 1 : 0,
                          child: isActionIconVisible
                              ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(isMute ? Icons.volume_off_rounded : Icons.volume_up_rounded, color: Colors.white).onTap(() {
                                if (isMute) {
                                  _videoPlayerController.setVolume(100);
                                  _videoPlayerController.play();
                                  isMute = false;
                                  isVideoPlay = true;
                                } else {
                                  _videoPlayerController.setVolume(0);
                                  _videoPlayerController.play();
                                  isMute = true;
                                  isVideoPlay = true;
                                }
                                setState(() {});
                              }, splashColor: Colors.transparent, highlightColor: Colors.transparent),
                              8.width,
                              Icon(appStore.hasInFullScreen ? Icons.fullscreen_exit_rounded : Icons.fullscreen_rounded,
                                  size: 24, color: Colors.white)
                                  .onTap(() {
                                if (appStore.hasInFullScreen) {
                                  appStore.setToFullScreen(false);
                                } else {
                                  appStore.setToFullScreen(true);
                                }
                              }),
                            ],
                          )
                              : Offstage(),
                        ),
                      ),
                      if (isVideoBuffering)
                        Container(
                          width: context.width(),
                          alignment: Alignment.center,
                          height: appStore.hasInFullScreen ? context.height() : context.height() * 0.3,
                          color: Colors.black38,
                          child: CircularProgressIndicator(strokeWidth: 1.5),
                        ).center(),
                      // Positioned(
                      //   height: 6,
                      //   left: 0,
                      //   right: 0,
                      //   bottom: 0,
                      //   child: VideoPlayerProgressIndicatorWidget(
                      //     _videoPlayerController,
                      //     allowScrubbing: true,
                      //     colors: VideoProgressColors(playedColor: colorPrimary, backgroundColor: Colors.grey.shade500),
                      //   ),
                      // ),
                    ],
                  ).onTap(() {
                    setState(() {
                      isActionIconVisible = !isActionIconVisible;
                    });
                    if (isActionIconVisible) {
                      Future.delayed(const Duration(seconds: 5), () {
                        isActionIconVisible = false;
                      });
                    }
                  });
                }
                return CircularProgressIndicator(strokeWidth: 1.5).center();
              },
            ),
          ),
        );
      },
    );
  }
}
