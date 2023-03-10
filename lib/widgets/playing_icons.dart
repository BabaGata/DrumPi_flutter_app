import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class PLayingIcons extends StatefulWidget {
  const PLayingIcons({super.key, required this.item});

  final String item;

  @override
  State<PLayingIcons> createState() => _PLayingIconsState();
}

class _PLayingIconsState extends State<PLayingIcons> {
  bool isPlaying = false;
  AudioPlayer advancedPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();

    advancedPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        isPlaying = state == PlayerState.playing;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        if (isPlaying) {
          await advancedPlayer.pause();
        } else {
          await advancedPlayer.play(
              DeviceFileSource(widget.item)
          );
        }
      },
      icon: Icon(
          isPlaying ? Icons.pause : Icons.play_arrow
      ),
    );
  }
}