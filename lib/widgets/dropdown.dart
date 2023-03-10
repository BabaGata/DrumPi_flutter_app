import 'package:flutter/material.dart';

class DropMenu extends StatefulWidget {
  const DropMenu({super.key, required this.list, required this.callbackValue});
  final List<String> list;
  final Function callbackValue;

  @override
  State<DropMenu> createState() => _DropMenuState();
}

class _DropMenuState extends State<DropMenu> {
  late String dropdownValue;

  @override
  void initState() {
    super.initState();
    dropdownValue = widget.list.first;
    widget.callbackValue(dropdownValue);
  }

  @override
  Widget build(BuildContext context){
    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      onChanged: (String? value) {
        // This is called when the user selects an item.
        setState(() {
          dropdownValue = value!;
          widget.callbackValue(dropdownValue);
        });
      },
      items: widget.list.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}