import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class GameScreen extends StatefulWidget {

  final String question;

  GameScreen({
    @required this.question,
  });

  @override
  _GameScreenState createState() => _GameScreenState();
}

enum TtsState { playing, stopped }

class _GameScreenState extends State<GameScreen> {
  FlutterTts flutterTts;

  TtsState ttsState = TtsState.stopped;

  get isPlaying => ttsState == TtsState.playing;

  get isStopped => ttsState == TtsState.stopped;

  Future _speak(String word) async {
    await flutterTts.speak(word);
  }

  initTts() {
    flutterTts = new FlutterTts();

    flutterTts.setStartHandler(() {
      setState(() {
        ttsState = TtsState.playing;
      });
    });

    flutterTts.setCompletionHandler(() {
      setState(() {
        ttsState = TtsState.stopped;
      });
    });

    flutterTts.setErrorHandler((msg) {
      setState(() {
        ttsState = TtsState.stopped;
      });
    });

    _setVolume();
  }

  _setVolume() async {
    await flutterTts.setVolume(1.0);
  }

  @override
  void initState() {
    super.initState();
    initTts();
  }

  @override
  void dispose() {
    super.dispose();
    flutterTts.stop();
  }

  @override
  Widget build(BuildContext context) {

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "${widget.question}",
            style: TextStyle(
              fontSize: 45.0,
              letterSpacing: 5.0
            ),
          ),
          SizedBox(height: 10.0),
          Container(
            padding: EdgeInsets.fromLTRB(60.0, 0.0, 60.0, 0.0),
            child: TextField(
              maxLength: widget.question.length,
              onChanged: (value) {
                print("Changed value: $value");
              },
              onSubmitted: (value) {
                print("Submitted value: $value");
              },
              style: TextStyle(
                fontSize: 30.0
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 100.0),
            height: 70.0,
            width: 70.0,
            child: FittedBox(
              child: FloatingActionButton(
                onPressed: () {
                  _speak("${widget.question}");
                },
                backgroundColor: Theme.of(context).primaryColor,
                child: Icon(
                  Icons.speaker_phone,
                  size: 35.0,
                ),
              )
            )
          )
        ],
      ),
    );
  }
}