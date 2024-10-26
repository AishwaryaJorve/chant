
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class AudioPlayerScreen extends StatefulWidget {
  @override
  _AudioPlayerScreenState createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    try {
      await _audioPlayer.setUrl('https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3');
    } catch (e) {
      print("Error loading audio source: $e");
    }
  }

  void _play() async {
    await _audioPlayer.play();
    setState(() {
      _isPlaying = true;
    });
  }

  void _pause() async {
    await _audioPlayer.pause();
    setState(() {
      _isPlaying = false;
    });
  }

  void _stop() async {
    await _audioPlayer.stop();
    setState(() {
      _isPlaying = false;
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Audio Player')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              iconSize: 64.0,
              icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
              onPressed: _isPlaying ? _pause : _play,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _stop,
              child: Text('Stop'),
            ),
          ],
        ),
      ),
    );
  }
}
