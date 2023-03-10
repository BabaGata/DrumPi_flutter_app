import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'pop_button.dart';

class PopFieldButton extends StatefulWidget {
  const PopFieldButton(
      {super.key, required this.onSave, required this.callback, required this.newIndicator});

  final VoidCallback onSave;
  final Function callback;
  final Function newIndicator;

  @override
  State<PopFieldButton> createState() => _PopFieldButtonState();
}

class _PopFieldButtonState extends State<PopFieldButton> {
  final data = GetStorage();
  final myController = TextEditingController();
  Set<String> drumSetList = {};

  saveListWithGetStorage(String storageKey, List<dynamic> storageValue) async =>
      await data.write(storageKey, jsonEncode(storageValue));

  readWithGetStorage(String storageKey) => data.read(storageKey);

  callbackChild(varName) {
    widget.callback(varName);
    varName == 'New' ? widget.newIndicator(false) : widget.newIndicator(true);
  }

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
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(10, 10, 0, 20),
          child: Row(
            children: [
              if (data.read('drum_set_list') != null) PopButton(callback: callbackChild),
              Expanded(
                child: TextField(
                  controller: myController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: 'Name of new sound set',
                    suffixIcon: IconButton(
                        onPressed: () {
                          myController.clear();
                        },
                        icon: const Icon(Icons.clear)),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(5, 0, 10, 0),
                child: ElevatedButton(
                  onPressed: () {
                    widget.callback(myController.text);
                    drumSetList.add(myController.text);
                    setState(
                      () {
                        saveListWithGetStorage(
                            'drum_set_list', drumSetList.toList());
                      },
                    );
                    widget.newIndicator(true);
                    widget.onSave();
                  },
                  child: const Text('SAVE'),
                ),
              ),
            ],
          ),
        ),
        const Text('SELECT YOUR SOUNDS'),
      ],
    );
  }
}
