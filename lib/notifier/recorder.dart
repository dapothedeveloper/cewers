import 'dart:async';
import 'dart:io' as io;

import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';
import 'package:path_provider/path_provider.dart';
import 'package:audioplayers/audioplayers.dart';

class RecorderNotifier extends ChangeNotifier {
  FlutterAudioRecorder _recorder;
  Recording _current;
  RecordingStatus currentStatus = RecordingStatus.Unset;
  AudioPlayer advancedPlayer = AudioPlayer();
  AudioCache audioCache = AudioCache();
  BuildContext context;
  io.Directory appDocDirectory;
  bool isPlayingAudio = false;
  String filePath;
  int timeStamp;

  init() async {
    try {
      if (await FlutterAudioRecorder.hasPermissions) {
        if (io.Platform.isIOS) {
          if (audioCache.fixedPlayer != null) {
            audioCache.fixedPlayer.startHeadlessService();
          }
          advancedPlayer.startHeadlessService();
        }
        String customPath = '/audio_file_';
        //io.Directory appDocDirectory = await getApplicationDocumentsDirectory();
        if (io.Platform.isIOS) {
          appDocDirectory = await getApplicationDocumentsDirectory();
        } else {
          appDocDirectory = await getExternalStorageDirectory();
        }

        // can add extension like ".mp4" ".wav" ".m4a" ".aac"
        timeStamp = DateTime.now().millisecondsSinceEpoch;
        customPath = appDocDirectory.path + customPath + timeStamp.toString();

        // .wav <---> AudioFormat.WAV
        // .mp4 .m4a .aac <---> AudioFormat.AAC
        // AudioFormat is optional, if given value, will overwrite path extension when there is conflicts.
        _recorder = FlutterAudioRecorder(customPath);

        await _recorder.initialized;
        // after initialization
        var current = await _recorder.current(channel: 0);
        debugPrint(current.toString());

        _current = current;
        currentStatus = current.status;
        debugPrint(currentStatus.toString());
        notifyListeners();
      } else {
        Scaffold.of(context).showSnackBar(
            SnackBar(content: Text("You must accept permissions")));
      }
    } catch (e) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e?.message?.toString() ?? e.toString(),
            textAlign: TextAlign.left,
            style: TextStyle(color: Colors.white),
          ),
          duration: Duration(minutes: 2),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  start() async {
    try {
      await _recorder.start();
      var recording = await _recorder.current(channel: 0);

      _current = recording;
      const tick = const Duration(milliseconds: 50);
      Timer.periodic(tick, (Timer t) async {
        if (currentStatus == RecordingStatus.Stopped) {
          t.cancel();
        }

        var current = await _recorder.current(channel: 0);

        _current = current;
        currentStatus = _current.status;
        notifyListeners();
      });
    } catch (e) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e?.message ?? e.toString(),
            textAlign: TextAlign.left,
            style: TextStyle(color: Colors.white),
          ),
          duration: Duration(minutes: 2),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  resume() async {
    await _recorder.resume();
    notifyListeners();
  }

  delete() async {}

  pause() async {
    await _recorder.pause();
    notifyListeners();
  }

  stop() async {
    try {
      var result = await _recorder.stop();
      debugPrint("Stop recording: ${result.path}");
      debugPrint("Created file path");

      _current = result;
      currentStatus = _current.status;
      filePath = result.path;
      notifyListeners();
    } catch (e) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e?.message?.toString() ?? e.toString(),
            textAlign: TextAlign.left,
            style: TextStyle(color: Colors.white),
          ),
          duration: Duration(minutes: 2),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> playAudio() async {
    debugPrint(filePath);
    // ignore: unused_local_variable
    int x = await advancedPlayer.play(filePath, isLocal: true);
    isPlayingAudio = true;
    notifyListeners();
  }

  Future<void> stopPlayingAudio() async {
    // ignore: unused_local_variable
    int x = await advancedPlayer.stop();
    isPlayingAudio = false;
    notifyListeners();
  }
}
