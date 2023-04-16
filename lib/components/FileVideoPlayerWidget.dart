import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:stream_transform/stream_transform.dart';
import 'package:streamit_flutter/screens/VideoCastDeviceListWidget.dart';
import 'package:streamit_flutter/utils/Constants.dart';
import 'package:streamit_flutter/utils/resources/Colors.dart';

import '../main.dart';

class FileVideoPlayerWidget extends StatefulWidget {
  final String videoUrl;
  final String videoImage;
  final String videoTitle;
  final bool isFromLocalStorage;
  final String videoId;
  final bool hasResumePauseVideo;

  FileVideoPlayerWidget({
    Key? key,
    required this.videoUrl,
    this.videoImage = blankImage,
    this.videoTitle = "",
    this.isFromLocalStorage = false,
    required this.videoId,
    this.hasResumePauseVideo = false,
  }) : super(key: key);

  @override
  FileVideoPlayerWidgetState createState() => FileVideoPlayerWidgetState();
}

class FileVideoPlayerWidgetState extends State<FileVideoPlayerWidget> {
  late VlcPlayerController _controller;
  bool hasVideoPlayerInitialize = false;

  //
  final double initSnapshotRightPosition = 10;
  final double initSnapshotBottomPosition = 10;

  //
  double volumeValue = 50;
  double sliderValue = 0.0;
  String position = '';
  String duration = '';
  bool validPosition = false;

  bool _isShowController = false;

  double recordingTextOpacity = 0;
  DateTime lastRecordingShowTime = DateTime.now();
  bool isRecording = false;

  //
  List<double> playbackSpeeds = [0.5, 1.0, 2.0];
  int playbackSpeedIndex = 1;

  StreamController<bool> _controllerStream = StreamController();
  StreamController<Map<String, dynamic>> _videoPositionStream = StreamController();

  @override
  void initState() {
    super.initState();
    if (widget.isFromLocalStorage) {
      _controller = VlcPlayerController.file(File(widget.videoUrl));
    } else {
      _controller = VlcPlayerController.network(
        widget.videoUrl,
        hwAcc: HwAcc.full,
        options: VlcPlayerOptions(
          advanced: VlcAdvancedOptions([
            VlcAdvancedOptions.networkCaching(2000),
          ]),
          http: VlcHttpOptions([
            VlcHttpOptions.httpReconnect(true),
          ]),
          rtp: VlcRtpOptions([
            VlcRtpOptions.rtpOverRtsp(true),
          ]),
        ),
      );
    }
    _controller.addOnInitListener(() async {
      await _controller.startRendererScanning();
    });
    _controller.addOnRendererEventListener((type, id, name) {
      print('OnRendererEventListener $type $id $name');
    });
    _controller.addListener(listener);
    _controllerStream.stream.debounce(const Duration(seconds: 5)).listen((event) {
      if (mounted) {
        setState(() {
          _isShowController = event;
        });
      }
    });
  }

  void listener() async {
    if (!mounted) return;
    //
    if (_controller.value.isInitialized) {
      var oPosition = _controller.value.position;
      var oDuration = _controller.value.duration;

      if (oDuration.inHours == 0) {
        var strPosition = oPosition.toString().split('.')[0];
        var strDuration = oDuration.toString().split('.')[0];
        position = "${strPosition.split(':')[1]}:${strPosition.split(':')[2]}";
        duration = "${strDuration.split(':')[1]}:${strDuration.split(':')[2]}";
      } else {
        position = oPosition.toString().split('.')[0];
        duration = oDuration.toString().split('.')[0];
      }
      validPosition = oDuration.compareTo(oPosition) >= 0;
      sliderValue = validPosition ? oPosition.inSeconds.toDouble() : 0;

      Map<String, dynamic> req = {
        "position": position,
        "duration": duration,
        "validPosition": validPosition,
        "sliderValue": sliderValue,
      };

      _videoPositionStream.add(req);
    }
    if (_controller.value.isBuffering) {
      appStore.setVideoLoader(true);
    } else if (_controller.value.isPlaying) {
      appStore.setVideoLoader(false);
    }
  }

  void setVideoLastPosition() {
    _controller.removeListener(listener);
    _controllerStream.close();
    _videoPositionStream.close();
  }

  @override
  void dispose() {
    setVideoLastPosition();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (appStore.hasInFullScreen) {
          appStore.setToFullScreen(false);
          setOrientationPortrait();
          return Future.value(false);
        }
        return Future.value(true);
      },
      child: GestureDetector(
        onTap: () {
          setState(() {
            _isShowController = true;
          });
          _controllerStream.add(false);
        },
        child: ColoredBox(
          color: Colors.black12,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Observer(
                builder: (context) {
                  return VlcPlayer(
                    controller: _controller,
                    aspectRatio: context.width() / (appStore.hasInFullScreen ? context.height() : (context.height() * 0.3)),
                    placeholder: CircularProgressIndicator(strokeWidth: 1.5).center(),
                  );
                },
              ),
              Observer(
                builder: (context) {
                  return CircularProgressIndicator(strokeWidth: 1.5).visible(appStore.isVideoLoading);
                },
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 750),
                  opacity: _isShowController ? 1 : 0,
                  child: ColoredBox(
                    color: Colors.black26,
                    child: Row(
                      children: [
                        BackButton(),
                        Spacer(),
                        Stack(
                          children: [
                            IconButton(
                              icon: Icon(Icons.timer),
                              color: Colors.white,
                              onPressed: _cyclePlaybackSpeed,
                            ),
                            Positioned(
                              bottom: 7,
                              right: 3,
                              child: IgnorePointer(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.orange,
                                    borderRadius: BorderRadius.circular(1),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    vertical: 1,
                                    horizontal: 2,
                                  ),
                                  child: Text(
                                    '${playbackSpeeds.elementAt(playbackSpeedIndex)}x',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 8,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          onPressed: () async {
                            if (await _controller.isPlaying() ?? false) {
                              await _controller.pause();
                            }
                            VideoCastDeviceListScreen(
                              videoURL: widget.videoUrl,
                              videoTitle: widget.videoTitle,
                              videoImage: widget.videoImage,
                            ).launch(context);
                          },
                          icon: Icon(Icons.cast_rounded),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 750),
                  opacity: _isShowController ? 1 : 0,
                  child: ColoredBox(
                    color: Colors.black26,
                    child: StreamBuilder<Map<String, dynamic>>(
                      stream: _videoPositionStream.stream,
                      builder: (_, snap) {
                        if (snap.hasData) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              IconButton(
                                color: Colors.white,
                                icon: _controller.value.isPlaying ? Icon(Icons.pause_circle_outline) : Icon(Icons.play_circle_outline),
                                onPressed: _togglePlaying,
                              ),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Text(
                                      snap.data!["position"],
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    Expanded(
                                      child: SliderTheme(
                                        data: SliderThemeData(
                                          thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8),
                                          inactiveTrackColor: Colors.white12,
                                          activeTrackColor: colorPrimary,
                                          disabledActiveTrackColor: Colors.white12,
                                        ),
                                        child: Slider(
                                          activeColor: colorPrimary,
                                          inactiveColor: Colors.white70,
                                          value: snap.data!["sliderValue"],
                                          min: 0.0,
                                          max: !snap.data!["validPosition"] ? 1.0 : _controller.value.duration.inSeconds.toDouble(),
                                          onChanged: snap.data!["validPosition"] ? _onSliderPositionChanged : null,
                                          thumbColor: colorPrimary,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      snap.data!["duration"],
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: Icon(appStore.hasInFullScreen ? Icons.fullscreen_exit_rounded : Icons.fullscreen),
                                color: Colors.white,
                                onPressed: () {
                                  if (appStore.hasInFullScreen) {
                                    appStore.setToFullScreen(false);
                                  } else {
                                    appStore.setToFullScreen(true);
                                  }
                                },
                              ),
                            ],
                          );
                        }
                        return Offstage();
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /*
  * Change video playback speed e.g. 1.0x, 1.5x, 2.0x
  * */
  void _cyclePlaybackSpeed() async {
    playbackSpeedIndex++;
    if (playbackSpeedIndex >= playbackSpeeds.length) {
      playbackSpeedIndex = 0;
    }
    setState(() {});
    return await _controller.setPlaybackSpeed(playbackSpeeds.elementAt(playbackSpeedIndex));
  }

  /*
  * Play or pause video base on status
  * */
  void _togglePlaying() async {
    _controller.value.isPlaying ? await _controller.pause() : await _controller.play();
  }

  /*
  * Update video duration base on slider onChange event
  * */
  void _onSliderPositionChanged(double progress) {
    setState(() {
      sliderValue = progress.floor().toDouble();
    });
    _controller.setTime(sliderValue.toInt() * 1000);
  }
}
