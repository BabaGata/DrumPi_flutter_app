import 'dart:convert';
import 'package:flutter/material.dart';
import 'play.dart';
import 'widgets/dropdown.dart';
import 'sounds.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Module Controller',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  final String title = 'Module Controls';

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final data = GetStorage();
  String setName = '';

  Set<String> drumSetList = {};

  readWithGetStorage(String storageKey) => data.read(storageKey);

  callbackValue(varValue) async {
    setName = varValue;
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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text('Select your sound set:'),
                  ]),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(0, 30, 0, 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (data.read('drum_set_list') != null)
                    DropMenu(
                        list: drumSetList.toList(),
                        callbackValue: callbackValue),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return SoundsPage(
                            title: 'Sounds',
                            setName: setName,
                            onSave: () => setState(() {
                                  drumSetList = Set<String>.from(jsonDecode(
                                      readWithGetStorage('drum_set_list')));
                                }));
                      }));
                    },
                    child: const Text('EDIT'),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(0, 30, 0, 30),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const PlayPage(title: 'Playing');
                  }));
                },
                child: const Text('PLAY'),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(0, 30, 0, 30),
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    data.remove('drum_set_list');
                  });
                },
                child: const Text('remove'),
              ),
            ),
            // Text(data.queue as String)
          ],
        ),
      ),
    );
  }
}
