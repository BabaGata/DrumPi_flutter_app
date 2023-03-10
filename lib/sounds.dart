import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'widgets/pop_field_button.dart';
import 'widgets/pop_field_button_saved.dart';
import 'widgets/sound_item.dart';
import 'package:get_storage/get_storage.dart';

class SoundsPage extends StatefulWidget {
  const SoundsPage({super.key, required this.title, required this.onSave,
    required this.setName});
  final String title;
  final VoidCallback onSave;
  final String setName;

  @override
  State<SoundsPage> createState() => _SoundsPageState();
}

class _SoundsPageState extends State<SoundsPage> {
  bool savedIndicator = false;
  late String setName;
  final data = GetStorage();
  late SharedPreferences sharedPreferences;
  Map<String,String> drums = {
    'Snare':'',
    'Hi-Tom':'',
    'Mi-Tom':'',
    'Lo-Tom':'',
    'Hi-Hats':'',
    'Bass':'',
    'Crash':'',
    'Ride':'',
  };
  callback(varName) {
    setState(() {
      setName = varName;
    });
  }

  newIndicator(varIndicator) {
    savedIndicator = varIndicator;
  }
  @override
  void initState() {
    setName = widget.setName;
    data.read('drum_set_list') != null
        ? savedIndicator = true
        : savedIndicator = false;
    initialGetSavedData();
    super.initState();
  }

  Future<void> initialGetSavedData() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  void storeData() {
    String drumData = jsonEncode(drums);
    sharedPreferences.setString(setName, drumData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              savedIndicator
                  ? PopFieldSaved(
                      name: setName,
                      callback: callback,
                      newIndicator: newIndicator,
                      onSave: () {
                        widget.onSave();
                      },
                    )
                  : PopFieldButton(
                      callback: callback,
                      newIndicator: newIndicator,
                      onSave: () {
                        widget.onSave();
                      },
                    ),
              for (var drum in drums.keys.toList()) SoundItem(drumName: drum),
            ],
          ),
        ),
      ),
    );
  }
}
