import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class PopButton extends StatefulWidget {
  const PopButton({super.key, required this.callback});
  final Function callback;

  @override
  State<PopButton> createState() => _PopButtonState();
}

class _PopButtonState extends State<PopButton> {
  final data = GetStorage();
  Set<String> drumSetList = {};

  readWithGetStorage(String storageKey) => data.read(storageKey);

  @override
  void initState() {
    super.initState();
    if (data.read('drum_set_list') != null) {
      drumSetList =
          Set<String>.from(jsonDecode(readWithGetStorage('drum_set_list')));
      drumSetList.add('New');
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      child: const SizedBox(
          width: 40,
          child: Icon(
            Icons.arrow_drop_down_rounded,
            size: 40,
          )),
      itemBuilder: (context) => List<PopupMenuEntry<String>>.from(
        drumSetList.map(
          (item) => PopupMenuItem(
            value: item,
            child: Text(item),
          ),
        ),
      ),
      onSelected: (value) => widget.callback(value),
    );
  }
}
