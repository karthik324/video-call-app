import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:get/get.dart';
import 'package:video_call_app/controllers/controller.dart';
import 'package:video_call_app/core/app_colors.dart';
import 'package:video_call_app/core/app_styles.dart';
import 'package:video_call_app/core/constants.dart';

class VideoCallScreen extends StatefulWidget {
  const VideoCallScreen({super.key, required this.channelId});
  final String channelId;

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  final users = <int>[];
  final infoStrings = <String>[];
  bool muted = false;
  bool isCameraOn = false;
  late RtcEngine engine;
  int? _remoteUid;
  final controller = Controller.find;

  @override
  void initState() {
    super.initState();
    initialize();
  }

  @override
  void dispose() {
    users.clear();
    engine.leaveChannel();
    engine.release();
    controller.channelNameController.clear();
    super.dispose();
  }

  var _localUserJoined = false;

  Future<void> initialize() async {
    if (appId.isEmpty) {
      setState(() {
        infoStrings.add('APP_ID is missing');
        infoStrings.add('Agora engine is not starting');
      });
      return;
    }
    engine = createAgoraRtcEngine();
    await engine.initialize(const RtcEngineContext(
      appId: appId,
      channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
    ));
    addEventHandlers();
    await engine.setClientRole(role: controller.clientRoleType);
    await engine.enableVideo();
    await engine.startPreview();
    print('curr channel ${widget.channelId}');
    print('curr role ${controller.clientRoleType}');
    await engine.joinChannel(
      token: token,
      channelId: widget.channelId,
      uid: 0,
      options: ChannelMediaOptions(),
    );

    VideoEncoderConfiguration videoEncoderConfiguration =
        const VideoEncoderConfiguration();
    await engine.setVideoEncoderConfiguration(videoEncoderConfiguration);
  }

  void addEventHandlers() {
    engine.registerEventHandler(
      RtcEngineEventHandler(onError: (e, s) {
        setState(() {
          final info = 'Error $e, $s';
          infoStrings.add(info);
        });
      }, onJoinChannelSuccess: (c, i) {
        setState(() {
          final info = 'Join channel $c, int : $i';
          _localUserJoined = true;
          infoStrings.add(info);
        });
      }, onLeaveChannel: (i, state) {
        setState(() {
          infoStrings.add('Leave $i, state $state');
        });
      }, onUserJoined: (connection, remoteUid, elapsed) {
        setState(() {
          infoStrings.add('user joined $remoteUid');
          users.add(remoteUid);
          _remoteUid = remoteUid;
        });
      }, onUserOffline: (c, uid, reason) {
        setState(() {
          infoStrings.add('user offline $uid, reason $reason');
          users.remove(uid);
          _remoteUid = null;
        });
      }, onFirstRemoteVideoFrame: (con, i, j, k, l) {
        setState(() {
          infoStrings.add('First remote frame $con, $i x $j');
        });
      }),
    );
    print('infoStrings $infoStrings');
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Agora Video Call',
          style: AppStyles.header.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.normal,
            color: Colors.white,
          ),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.black,
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          if (_remoteUid == null)
            const Center(
              child: Text(
                'Please wait for remote user to join',
                textAlign: TextAlign.center,
              ),
            ),
          if (_remoteUid != null)
            Center(
              child: AgoraVideoView(
                controller: VideoViewController.remote(
                  rtcEngine: engine,
                  canvas: VideoCanvas(uid: _remoteUid),
                  connection: RtcConnection(channelId: widget.channelId),
                ),
              ),
            ),
          Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              width: 100,
              height: 150,
              child: Center(
                child: _localUserJoined
                    ? AgoraVideoView(
                        controller: VideoViewController(
                          rtcEngine: engine,
                          canvas: const VideoCanvas(uid: 0),
                        ),
                      )
                    : const CircularProgressIndicator(),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: muted
                      ? const Icon(
                          Icons.mic_off,
                          color: Colors.white,
                        )
                      : const Icon(
                          Icons.mic,
                          color: Colors.white,
                        ),
                  onPressed: () {
                    setState(() {
                      muted = !muted;
                      if (muted) {
                        engine.muteLocalAudioStream(true);
                      } else {
                        engine.muteLocalAudioStream(false);
                      }
                    });
                  },
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.blue,
                    minimumSize: const Size(50, 50),
                  ),
                ),
                IconButton(
                  icon: isCameraOn
                      ? const Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                  )
                      : const Icon(
                    Icons.disabled_by_default,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      isCameraOn = !isCameraOn;
                      if (!isCameraOn) {
                        engine.enableLocalVideo(false);
                      } else {
                        engine.enableLocalVideo(true);
                      }
                    });
                  },
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.blue,
                    minimumSize: const Size(50, 50),
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.cameraswitch,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      engine.switchCamera();
                    });
                  },
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.blue,
                    minimumSize: const Size(50, 50),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.call_end, size: 25),
                  color: Colors.white,
                  onPressed: () {
                    setState(() {
                      engine.leaveChannel();
                      engine.release();
                      Navigator.pop(context);
                    });
                  },
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.red,
                    minimumSize: const Size(60, 60),
                  ),
                ),
              ],
            ).paddingAll(size.width * 0.1),
          ),
          // AgoraVideoButtons(client: client),
        ],
      ),
    );
  }
}
