import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';

class storing extends StatefulWidget {
  const storing({super.key});

  @override
  State<storing> createState() => _storingState();
}

class _storingState extends State<storing> {
  late Box _mybox;
  final TextEditingController _controller = TextEditingController();
  void init() {
    super.initState();
    _mybox = Hive.box('mybox');
  }

  void _addData() {
    final String value = _controller.text;
    if (value.isNotEmpty) {
      final int key = _mybox.length + 1;
      _mybox.put('key$key', value);
      Navigator.pop(context); // Return to the previous screen
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
