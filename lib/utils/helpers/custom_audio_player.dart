// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'dart:io';

import 'package:app_chat/utils/helpers/seek_bar.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class CustomAudioPlayerWidget extends StatefulWidget {
  const CustomAudioPlayerWidget({Key? key, required this.url})
      : super(key: key);
  final String url;

  @override
  State<CustomAudioPlayerWidget> createState() =>
      _CustomAudioPlayerWidgetState();
}

class _CustomAudioPlayerWidgetState extends State<CustomAudioPlayerWidget> {
  AudioPlayer player = AudioPlayer();

  late StreamSubscription durationSubscription;
  late StreamSubscription positionSubscription;
  late StreamSubscription playerCompleteSubscription;

  Duration? duration;
  Duration position = Duration.zero;

  PlayerState playerState = PlayerState.stopped;
  bool positionSubscriptionInitialized = false;
  bool playerCompleteSubscriptionInitialized = false;
  bool durationSubscriptionInitialized = false;

  bool loading = false;
  bool loadingDone = false;
  late File file;
  bool fileCannotLoaded = false;

  Future<void> initAudioPlayer() async {
    await AudioPlayer.global.changeLogLevel(LogLevel.error);
    final AudioContext audioContext = AudioContext(
        android: AudioContextAndroid(
          isSpeakerphoneOn: false,
          stayAwake: true,
          contentType: AndroidContentType.music,
          usageType: AndroidUsageType.media,
          audioFocus: AndroidAudioFocus.gain,
        ),
        iOS: AudioContextIOS(
            defaultToSpeaker: false,
            category: AVAudioSessionCategory.playback,
            options: [AVAudioSessionOptions.mixWithOthers] +
                [AVAudioSessionOptions.allowAirPlay] +
                [AVAudioSessionOptions.allowBluetooth] +
                [AVAudioSessionOptions.allowBluetoothA2DP]));
    await AudioPlayer.global.setGlobalAudioContext(audioContext);

    durationSubscription = player.onDurationChanged.listen((durationPlayer) {
      durationSubscriptionInitialized = true;
      setState(() => duration = durationPlayer);
    });
    // it caches the audio file and take it from local cache. if not avaliable downloads it
    try {
      if (widget.url.contains('wav') && Platform.isIOS) {
        // if the url is wav file and platform is ios
        // get the file from cache manager
        // it will be cached in the local cache if it haven't been cached before
        file = await DefaultCacheManager().getSingleFile(widget.url);
        // after caching the file, wav file will cached as x-wav,
        // so we need to change the file extension to wav
        final File newFile =
            await file.copy(file.path.replaceAll('x-wav', 'wav'));
        // the set the new wav file to file variable
        file = await newFile.create();
      } else {
        file = await DefaultCacheManager().getSingleFile(widget.url);

        // some audio files are saving with octet-stream extension, so we need to change the extension to mp3
        if (file.path.contains('octet-stream')) {
          final File newFile =
              await file.copy(file.path.replaceAll('octet-stream', 'mp3'));
          file = await newFile.create();
        }
      }
    } catch (e) {
      debugPrint(
          "DefaultCacheManager().getSingleFile(widget.url) exception : $e");
      debugPrint(
          "Default deleted fortune recored info audio will be played from assets ");
      fileCannotLoaded = true;
    }

    positionSubscription = player.onPositionChanged.listen((p) {
      positionSubscriptionInitialized = true;
      setState(() {
        position = p;
        playerState = PlayerState.playing;
      });
    });

    playerCompleteSubscription = player.onPlayerComplete.listen((event) {
      playerCompleteSubscriptionInitialized = true;
      debugPrint('completed');
      setState(() {
        playerState = PlayerState.stopped;
        // if (duration != null) {
        position = duration!;
        ended = true;
        // }
      });
    });

    player.onPlayerStateChanged.listen((state) {
      if (!mounted) return;
      setState(() {
        playerState = state;
        if (playerState == PlayerState.paused) {
          setState(() {
            loading = false;
          });
        }
      });
    });

    setState(() {
      loadingDone = true;
    });
  }

  Future<int> play() async {
    final playPosition = (position.inMilliseconds > 0 &&
            position.inMilliseconds < duration!.inMilliseconds)
        ? position
        : null;
    setState(() {
      loading = true;
      _isPaused = false;
      ended = false;
    });
    var result = -1;
    try {
      if (fileCannotLoaded) {
        await player.play(AssetSource('audio/deletedFortuneInfo.mp3'));
      } else {
        await player
            .play(DeviceFileSource(file.path), position: playPosition)
            .then((value) => result = 1);
      }
    } catch (e) {
      result = -1;
      debugPrint("play() expcetion : $e");
    }

    if (result == 1) {
      setState(() {
        playerState = PlayerState.playing;
      });
    }

    return result;
  }

  Future<void> pause() async {
    await player.pause();
    setState(() {
      playerState = PlayerState.paused;
      _isPaused = true;
      ended = false;
    });
  }

  Future<int> stop() async {
    int result = -1;
    try {
      await player.stop().then((value) => result = 1);
      if (result == 1) {
        setState(() {
          playerState = PlayerState.stopped;
          position = Duration.zero;
          _isPaused = false;
        });
      }
    } catch (e) {
      debugPrint("stop() expcetion : $e");
      result = -1;
    }

    return result;
  }

  void resume() {
    player.resume();
    playerState = PlayerState.playing;
    _isPaused = false;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    initAudioPlayer();
  }

  @override
  void dispose() {
    if (durationSubscriptionInitialized) {
      durationSubscription.cancel();
    }
    if (positionSubscriptionInitialized) {
      positionSubscription.cancel();
    }
    if (playerCompleteSubscriptionInitialized) {
      playerCompleteSubscription.cancel();
    }

    player.dispose();
    super.dispose();
  }

  bool get _isPlaying => playerState == PlayerState.playing;
  bool _isPaused = false;
  bool ended = false;

  @override
  Widget build(BuildContext context) {
    debugPrint(playerState.toString());
    return Row(
      children: [
        if (loadingDone)
          if (!_isPlaying || _isPaused || ended)
            IconButton(
              icon: const Icon(Icons.play_arrow),
              color: Colors.white,
              iconSize: 30.0,
              onPressed: _isPaused ? resume : play,
            )
          else if (playerState != PlayerState.completed)
            IconButton(
              icon: const Icon(Icons.pause),
              color: Colors.white,
              iconSize: 30.0,
              onPressed: () async {
                await pause();
                setState(() {});
              },
            )
          else
            IconButton(
              icon: const Icon(Icons.replay),
              color: Colors.blue,
              iconSize: 30.0,
              onPressed: () {},
            )
        else
          const Center(
              child: Center(
            child: CircularProgressIndicator(),
          )),
        Expanded(
          child: SeekBar(
            duration: duration ?? Duration.zero,
            position: position,
            bufferedPosition: Duration.zero,
            onChangeEnd: player.seek,
            onChanged: (dur) {},
          ),
        ),
      ],
    );
  }
}
