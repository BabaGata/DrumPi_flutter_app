import 'package:flutter/material.dart';
import 'pop_button.dart';

class PopFieldSaved extends StatefulWidget {
  const PopFieldSaved({super.key, required this.onSave,
    required this.name, required this.callback, required this.newIndicator});

  final VoidCallback onSave;
  final Function newIndicator;
  final Function callback;
  final String name;

  @override
  State<PopFieldSaved> createState() => _PopFieldSavedState();
}

class _PopFieldSavedState extends State<PopFieldSaved> {
  callbackChild(varName) {
    widget.callback(varName);
    varName == 'New' ? widget.newIndicator(false) : widget.newIndicator(true);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 0, 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          PopButton(callback: callbackChild,),
          Text(
            widget.name,
            style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(5, 0, 10, 0),
            child: ElevatedButton(
              onPressed: () {
                widget.onSave();
              },
              child: const Text('UPDATE'),
            ),
          ),
        ],
      ),
    );
  }
}
