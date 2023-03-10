import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'playing_icons.dart';
import 'dart:convert';
import 'package:get_storage/get_storage.dart';

class SoundItem extends StatefulWidget {
  const SoundItem({super.key, required this.drumName});

  final String drumName;

  @override
  State<SoundItem> createState() => _SoundItemState();
}

class _SoundItemState extends State<SoundItem> {
  String? _selectedPath;
  FilePickerResult? result;
  List<File> _files = [];
  final Set<String> _soundFiles = {};

  final data = GetStorage();
  Set<String> drumSetList = {};

  saveListWithGetStorage(String storageKey, List<dynamic> storageValue) async =>
      await data.write(storageKey, jsonEncode(storageValue));

  readWithGetStorage(String storageKey) => data.read(storageKey);

  @override
  void initState() {
    super.initState();
    if (data.read('drum_set_list') != null) {
      drumSetList =
        Set<String>.from(jsonDecode(readWithGetStorage('drum_set_list')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              children: [
                Text(
                    widget.drumName,
                    style: const TextStyle(fontWeight: FontWeight.bold)
                ),
              ],
            ),
          ),
          Expanded(
            flex: 4,
            child: Wrap(
              children: List.generate(
                _soundFiles.length,
                (int index) {
                  return InkWell(
                      onTap: () {
                        setState(() {
                          _selectedPath = _soundFiles.elementAt(index);
                        });
                      },
                      child: ListTile(
                        title: Text(
                          _soundFiles.elementAt(index).split('/').last,
                          style: TextStyle(
                            color: _selectedPath == _soundFiles.elementAt(index)
                                ? Colors.blue
                                : Colors.black,
                          ),
                        ),
                        leading: PLayingIcons(item: _soundFiles.elementAt(index),),
                        trailing: IconButton(
                            onPressed: () async {
                              setState(() {
                                _soundFiles.remove(_soundFiles.elementAt(index));
                              });
                            },
                            icon: const  Icon(Icons.remove)
                        ),
                        contentPadding: const EdgeInsets.all(0),
                        visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                      ),
                  );
                },
              ),
            ),
          ),
          Expanded(
            child: Column(
              children: [
                IconButton(
                    onPressed: () async {
                      result = await FilePicker.platform
                          .pickFiles(type: FileType.audio, allowMultiple: true);

                      if (result != null) {
                        _files =
                            result!.paths.map((path) => File(path!)).toList();
                        setState(() {
                          for (var file in _files) {
                            _selectedPath = file.path.toString();
                            _soundFiles.add(file.path.toString());
                          }
                        });
                      } else {
                        // User canceled the picker
                      }
                    },
                    icon: const Icon(
                      Icons.add,
                      color: Colors.blue,
                      size: 25
                    ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}