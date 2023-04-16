import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_flutter/components/FileVideoPlayerWidget.dart';
import 'package:streamit_flutter/main.dart';
import 'package:streamit_flutter/utils/Common.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class EmbedWidget extends StatefulWidget {
  final String data;
  final String? title;
  final String? image;
  final String videoId;

  EmbedWidget(this.data, {this.title, this.image, required this.videoId});

  @override
  _EmbedWidgetState createState() => _EmbedWidgetState();
}

class _EmbedWidgetState extends State<EmbedWidget> {
  bool isYoutubeUrl = false;
  YoutubePlayerController? _controller;
  String urlFromIframe = '';

  @override
  void initState() {
    urlFromIframe = widget.data.validate().urlFromIframe;
    isYoutubeUrl = urlFromIframe.isYoutubeUrl;

    if (isYoutubeUrl) {
      _controller = YoutubePlayerController(
        initialVideoId: widget.data.validate().urlFromIframe.toYouTubeId(),
        flags: const YoutubePlayerFlags(),
      );
    }
    super.initState();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        return isYoutubeUrl
            ? SizedBox(
                width: context.width(),
                height: appStore.hasInFullScreen ? context.height() - context.statusBarHeight : context.height() * 0.3,
                child: YoutubePlayerBuilder(
                  player: YoutubePlayer(
                    controller: _controller!,
                    onReady: () {
                      //
                    },
                    onEnded: (data) {
                      //
                    },
                  ),
                  onEnterFullScreen: () {
                    appStore.setToFullScreen(true);
                  },
                  onExitFullScreen: () {
                    appStore.setToFullScreen(false);
                  },
                  builder: (context, player) {
                    return player;
                  },
                ),
              )
            : widget.data.validate().urlFromIframe.isVideoPlayerFile
                ? FileVideoPlayerWidget(
                    videoUrl: widget.data.validate().urlFromIframe,
                    videoImage: widget.image.validate(),
                    videoTitle: widget.title.validate(),
                    videoId: widget.videoId,
                  )
                : SizedBox(
                    width: context.width(),
                    height: appStore.hasInFullScreen ? context.height() - context.statusBarHeight : context.height() * 0.3,
                    child: Stack(
                      children: [
                        WebView(
                          initialUrl: Uri.dataFromString(movieEmbedCode, mimeType: "text/html").toString(),
                          javascriptMode: JavascriptMode.unrestricted,
                          onWebViewCreated: (controller) {},
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: IconButton(
                            onPressed: () {
                              if (appStore.hasInFullScreen) {
                                appStore.setToFullScreen(false);
                              } else {
                                appStore.setToFullScreen(true);
                              }
                            },
                            icon: Icon(appStore.hasInFullScreen ? Icons.fullscreen_exit : Icons.fullscreen_sharp),
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  );
      },
    );
  }

  String get movieEmbedCode => '''<html>
      <head>
      <script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.1/jquery.min.js"></script>
      </head>
      <body style="background-color: #000000;">
        <iframe></iframe>
      </body>
      <script>
        \$(function(){
        \$('iframe').attr('src','$urlFromIframe');
        \$('iframe').css('border','none');
        \$('iframe').attr('width','100%');
        \$('iframe').attr('height','100%');
        });
      </script>
    </html> ''';
}
