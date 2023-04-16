import 'package:cast/cast.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_flutter/main.dart';
import 'package:streamit_flutter/utils/AppWidgets.dart';
import 'package:streamit_flutter/utils/resources/Colors.dart';

class VideoCastDeviceListScreen extends StatefulWidget {
  final String videoURL;
  final String videoTitle;
  final String videoImage;

  const VideoCastDeviceListScreen({
    Key? key,
    required this.videoURL,
    required this.videoTitle,
    required this.videoImage,
  }) : super(key: key);

  @override
  State<VideoCastDeviceListScreen> createState() => _VideoCastDeviceListScreenState();
}

class _VideoCastDeviceListScreenState extends State<VideoCastDeviceListScreen> {
  CastDevice? _castDevice;
  CastSession? _castSession;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _connectAndPlayMedia(BuildContext context, CastDevice object) async {
    final session = await CastSessionManager().startSession(object);
    _castSession = session;
    session.stateStream.listen((state) {
      if (state == CastSessionState.connected) {
        final snackBar = SnackBar(content: Text(language!.deviceConnectedSuccessfully, style: primaryTextStyle()));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        _castDevice = object;
        setState(() {});
      }else if(state == CastSessionState.closed){
        _castSession!.close();
        _castSession = null;
        _castDevice = null;
        setState(() {});
      }
    });

    var index = 0;

    session.messageStream.listen((message) {
      index += 1;

      print(index);
      print('receive message: $message');

      if (index == 2) {
        Future.delayed(const Duration(seconds: 5)).then((x) {
          _sendMessagePlayVideo(session);
        });
      }
    });

    session.sendMessage(CastSession.kNamespaceReceiver, {
      'type': 'LAUNCH',
      'appId': 'CC1AD845', // set the appId of your app here
    });
  }

  void _sendMessagePlayVideo(CastSession session) {
    print('_sendMessagePlayVideo');

    var message = {
      // Here you can plug an URL to any mp4, webm, mp3 or jpg file with the proper contentType.
      'contentId': widget.videoURL,
      'contentType': 'video/mp4',
      'streamType': 'BUFFERED', // or LIVE

      // Title and cover displayed while buffering
      'metadata': {
        'type': 0,
        'metadataType': 0,
        'title': widget.videoTitle,
        'images': [
          {'url': widget.videoImage}
        ]
      }
    };

    session.sendMessage(CastSession.kNamespaceMedia, {
      'type': 'LOAD',
      'autoPlay': true,
      'currentTime': 0,
      'media': message,
    });
  }

  Future<void> closeConnection(BuildContext context) async {
    _castSession!.close();
    _castSession = null;
    _castDevice = null;
    setState(() {});
    final snackBar = SnackBar(content: Text(language!.deviceDisconnectedSuccessfully));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_castSession != null) {
          closeConnection(context);
        }
        await Future.delayed(Duration.zero);
        return Future.value(true);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("${language!.cast} ${widget.videoTitle}", style: boldTextStyle(size: 16, color: Colors.white)),
          elevation: 0,
        ),
        body: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.redAccent.withOpacity(0.2),
              ),
              child: Text(
                language!.notCloseCastScreen,
                style: secondaryTextStyle(color: Colors.redAccent, fontStyle: FontStyle.italic),
              ),
            ),
            if (_castDevice != null)
              Column(
                children: [
                  commonCacheImageWidget(widget.videoURL, width: context.width(), height: 220),
                  16.height,
                  AppButton(
                    text: language!.closeConnection,
                    textStyle: boldTextStyle(),
                    color: colorPrimary,
                    onTap: () {
                      closeConnection(context);
                    },
                  )
                ],
              ),
            16.height,
            if (_castDevice == null)
              StatefulBuilder(
                builder: (ctx, changeState) {
                  return FutureBuilder<List<CastDevice>>(
                    key: UniqueKey(),
                    future: CastDiscoveryService().search(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            'Error: ${snapshot.error.toString()}',
                            style: boldTextStyle(),
                          ),
                        );
                      } else if (!snapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(color: colorPrimary),
                        );
                      }

                      if (snapshot.data!.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(language!.noCastingDeviceFounded, style: boldTextStyle(color: colorPrimary)),
                              16.height,
                              AppButton(
                                onTap: () {
                                  changeState(() {});
                                },
                                text: language!.refresh,
                                textStyle: boldTextStyle(color: Colors.white),
                                color: colorPrimary,
                              )
                            ],
                          ),
                        );
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(language!.castDeviceList, style: boldTextStyle()),
                          16.height,
                          AnimatedListView(
                            itemCount: snapshot.data.validate().length,
                            itemBuilder: (ctx, index) {
                              final device = snapshot.data.validate()[index];
                              return ListTile(
                                leading: Text("${index + 1}", style: boldTextStyle()),
                                title: Text(device.name),
                                onTap: () async {
                                  _connectAndPlayMedia(context, device);
                                  // connectAndPlayMedia(context, device, widget.videoURL, widget.videoTitle, widget.videoImage);
                                },
                              );
                            },
                          ).expand(),
                        ],
                      );
                    },
                  );
                },
              ).expand(),
          ],
        ),
      ),
    );
  }
}
