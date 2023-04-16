import 'dart:collection';
import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' show parse;
import 'package:http/http.dart' as http;
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_flutter/components/EmbedWidget.dart';
import 'package:streamit_flutter/components/FileVideoPlayerWidget.dart';
import 'package:streamit_flutter/screens/movieDetailComponents/MovieURLWidget.dart';
import 'package:streamit_flutter/utils/AppWidgets.dart';
import 'package:streamit_flutter/utils/Constants.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../main.dart';

class VideoContentWidget extends StatelessWidget {
  final String? choice;
  final String? urlLink;
  final String? embedContent;
  final String? fileLink;
  final String? image;
  final String? title;
  final String videoId;
  final bool? isUserResumeVideo;

  VideoContentWidget({
    this.choice,
    this.urlLink,
    this.embedContent,
    this.fileLink,
    this.image,
    this.title,
    required this.videoId,
    this.isUserResumeVideo = false,
  });

  @override
  Widget build(BuildContext context) {
    if (choice.validate() == movieChoiceURL || choice.validate() == videoChoiceURL || choice.validate() == episodeChoiceURL) {
      return MovieURLWidget(urlLink.validate(), title: title.validate(), image: image.validate(), videoId: videoId);
    } else if (choice.validate() == movieChoiceEmbed || choice.validate() == videoChoiceEmbed || choice.validate() == episodeChoiceEmbed) {
      String src = getVideoLink(embedContent.validate());
      if (src.contains('https://player.vimeo.com/')) {
        String videoId = src.split('/').last.split('?').first;
        return FutureBuilder<String>(
          future: getQualitiesAsync(videoId),
          builder: (ctx, snap) {
            if (snap.hasData) {
              return snap.data!.contains('https://player.vimeo.com/')
                  ? Container(
                      width: context.width(),
                      height: appStore.hasInFullScreen ? context.height() - context.statusBarHeight : context.height() * 0.3,
                      child: WebView(
                        initialUrl: getVideoLink(embedContent.validate()),
                        javascriptMode: JavascriptMode.unrestricted,
                        backgroundColor: Colors.black,
                      ),
                    )
                  : FileVideoPlayerWidget(
                      videoUrl: snap.data.validate(),
                      videoImage: image.validate(),
                      videoTitle: title.validate(),
                      videoId: videoId,
                      hasResumePauseVideo: isUserResumeVideo!,
                    );
            }
            return Loader().withHeight(context.height() * 0.3);
          },
        );
      } else {
        return EmbedWidget(embedContent.validate(), videoId: videoId);
      }
    } else if (choice.validate() == movieChoiceFile || choice.validate() == videoChoiceFile || choice.validate() == episodeChoiceFile) {
      return FileVideoPlayerWidget(
        videoUrl: fileLink.validate(),
        videoImage: image.validate(),
        videoTitle: title.validate(),
        videoId: videoId,
        hasResumePauseVideo: isUserResumeVideo!,
      );
    } else {
      return Container(
        width: context.width(),
        height: appStore.hasInFullScreen ? context.height() - context.statusBarHeight : context.height() * 0.3,
        child: commonCacheImageWidget(image.validate(), fit: BoxFit.cover),
      );
    }
  }

  String getVideoLink(String htmlData) {
    var document = parse(htmlData);
    dom.Element? link = document.querySelector('iframe');
    String? iframeLink = link != null ? link.attributes['src'].validate() : '';
    return iframeLink.validate();
  }

  Future<String> getQualitiesAsync(String videoId) async {
    try {
      log("=====>Video Id : $videoId <=====");
      log("=====> URL : https://player.vimeo.com/video/' + ${videoId.validate()} + '/config <=====");
      var response = await http.get(Uri.parse('https://player.vimeo.com/video/' + videoId.validate() + '/config'));
      var jsonData = jsonDecode(response.body)['request']['files']['progressive'];
      if ((jsonData as List).isNotEmpty) {
        SplayTreeMap videoList = SplayTreeMap.fromIterable(jsonData, key: (item) => "${item['quality']}", value: (item) => item['url']);

        var getSourceQuality = videoList.keys.map((e) => e.toString().getNumericOnly().toInt()).toList();
        var maxiQuality = getSourceQuality.reduce(math.max);
        return videoList["${maxiQuality}p"];
      } else {
        return getVideoLink(embedContent.validate());
      }
    } catch (error) {
      log('=====> REQUEST ERROR: $error <=====');
      return getVideoLink(embedContent.validate());
    }
  }
}
