import 'package:cewers/controller/storage.dart';
import 'package:cewers/custom_widgets/button.dart';
import 'package:cewers/custom_widgets/cewer_title.dart';
import 'package:cewers/model/media-upload.dart';
import 'package:cewers/notifier/recorder.dart';
import 'package:cewers/notifier/upload.dart';
import 'package:cewers/screens/media-upload.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';
import 'package:provider/provider.dart';

class VoiceRecodeScreen extends StatefulWidget {
  static String route = "voiceRecoder";
  _VoiceRecodeScreenState createState() => _VoiceRecodeScreenState();
}

class _VoiceRecodeScreenState extends State<VoiceRecodeScreen> {
  String audioFilePath;
  int timeStamp;
  BuildContext _context;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    bloc.stop();
    bloc.dispose();
    super.dispose();
  }

  RecorderNotifier bloc;
  @override
  Widget build(BuildContext context) {
    _context = context;
    bloc = Provider.of<RecorderNotifier>(context);
    bloc.context = context;
    var screen = Scaffold(
      appBar: AppBar(title: CewerAppBar("Record Voice", "")),
      body: Container(
        color: Color.fromRGBO(246, 246, 246, 1),
        alignment: Alignment.center,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Consumer<RecorderNotifier>(builder: (_, _bloc, __) {
              debugPrint(_bloc.currentStatus.toString());
              if (_bloc.currentStatus == RecordingStatus.Unset) {
                _bloc.init();
              }
              var isRecording =
                  _bloc.currentStatus == RecordingStatus.Recording;
              var hasStoppedRecord =
                  _bloc.currentStatus == RecordingStatus.Stopped;
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    isRecording ? "Tap to stop recording" : "Tap to Record",
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: InkWell(
                      onTap: () {
                        isRecording ? bloc.stop() : bloc.start();
                        // ignore: unnecessary_statements
                      },
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Icon(
                          isRecording ? Icons.stop : Icons.mic,
                          size: 46,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        roundCard(
                          Icon(_bloc.isPlayingAudio
                              ? Icons.stop
                              : Icons.play_arrow),
                          50,
                          _bloc.currentStatus == RecordingStatus.Stopped
                              ? () async {
                                  _bloc.isPlayingAudio
                                      ? await _bloc.stopPlayingAudio()
                                      : await _bloc.playAudio();
                                }
                              : null,
                        ),
                        roundCard(
                          Icon(
                            Icons.delete,
                            color: hasStoppedRecord ? Colors.red : null,
                          ),
                          50,
                          hasStoppedRecord
                              ? () async {
                                  _bloc.init();
                                }
                              : null,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }),
            Positioned(
              width: MediaQuery.of(context).size.width - 100,
              bottom: 45,
              left: 50,
              child: Consumer<RecorderNotifier>(
                builder: (_, _bloc, __) {
                  var isRecording =
                      _bloc.currentStatus == RecordingStatus.Recording;
                  return IgnorePointer(
                    ignoring: isRecording,
                    child: ActionButtonBar(
                      action: _bloc.currentStatus == RecordingStatus.Stopped
                          ? () {
                              audioFilePath = _bloc.filePath;
                              timeStamp = _bloc.timeStamp;
                              debugPrint(
                                  "Filepath $audioFilePath Timestamp $timeStamp");
                              uploadAudioFile();
                            }
                          : null,
                      text: "SEND",
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );

    return screen;
  }

  uploadAudioFile() {
    if (audioFilePath != null && timeStamp != null) {
      var pathArray = audioFilePath.split("/");
      var fileName = pathArray[(pathArray.length - 1)];
      var payload = MediaUploadModel(audioFilePath, timeStamp, fileName,
          "Audio alert", "6.455058,3.39481", true);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ChangeNotifierProvider<UploadNotifier>(
            create: (_) => UploadNotifier(StorageController()),
            child: MediaUploadScreen(payload),
          ),
        ),
      );
    } else {
      Scaffold.of(_context).removeCurrentSnackBar();
      Scaffold.of(_context).showSnackBar(
        SnackBar(
          content: Text(
            "Audio file error",
            textAlign: TextAlign.left,
          ),
          action: SnackBarAction(
            label: 'Dismiss',
            onPressed: closeSnackBar,
          ),
        ),
      );
    }
  }

  closeSnackBar() {
    Scaffold.of(context).removeCurrentSnackBar();
  }

  Widget roundCard(Widget icon, double size, Function action) {
    return Container(
      alignment: Alignment.center,
      width: size,
      height: size,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(size / 2))),
      margin: EdgeInsets.all(5),
      child: FlatButton(
        onPressed: action,
        padding: EdgeInsets.zero,
        height: size,
        minWidth: size,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(size / 2),
          ),
        ),
        child: icon,
      ),
    );
  }
}
