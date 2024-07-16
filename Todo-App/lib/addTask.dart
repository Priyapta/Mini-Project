import 'package:flutter/material.dart';
import 'package:fluttter_todo/component/button.dart';
import 'package:fluttter_todo/component/selectDate.dart';
import 'package:fluttter_todo/storing/database.dart';
import 'package:hive/hive.dart';

class addTask extends StatefulWidget {
  const addTask({
    super.key,
    required this.controller,
    required this.text,
    required this.onPreseed,
    required this.hintText,
    required this.db,
    required this.dateStartController,
    required this.dateEndController,
  });
  final TextEditingController controller;
  final VoidCallback onPreseed;
  final String text;
  final String hintText;
  final Tododatabase db;
  final TextEditingController dateStartController;
  final TextEditingController dateEndController;

  @override
  State<addTask> createState() => _nameState();
}

class _nameState extends State<addTask> {
  final mybox = Hive.box("mybox");
  // void saveTask() {
  //   setState(() {
  //     widget.db.todoList.add({
  //       "Tugas": widget.controller.text,
  //       "Task": false,
  //       "Start": dateStartController.text,
  //       "End": dateEndController.text,
  //       "Priority": false,
  //     });
  //     widget.db.updateTask();
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            setState(() {
              Navigator.pop(context);
            });
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 100),
              child: TextField(
                controller: widget.controller,
                decoration: InputDecoration(
                  hintText: "Add Task",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ),
          selectDate(
            onTap: () {
              _selectdateStart();
            },
            text: widget.text,
            hintText: widget.dateStartController.text,
          ),
          selectDate(
            onTap: () {
              _selectdateEnd();
            },
            text: widget.text,
            hintText: widget.dateEndController.text,
          ),
          Button(
            text: "Add",
            onPressed: widget.onPreseed,
          )
        ],
      ),
    );
  }

  Future<void> _selectdateStart() async {
    DateTime initialDate =
        DateTime.now(); // Initial date if widget.dateEnd is not initialized yet

    if (!widget.dateStartController.text.isEmpty) {
      List<String> dateComponents = widget.dateStartController.text.split("-");
      int year = int.parse(dateComponents[0]);
      int month = int.parse(dateComponents[1]);
      int day = int.parse(dateComponents[2]);
      initialDate = DateTime(year, month, day);
    }

    DateTime? _picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (_picked != null) {
      setState(() {
        widget.dateStartController.text = _picked.toString().split(" ")[0];
      });
    }
  }

  Future<void> _selectdateEnd() async {
    DateTime initialDate =
        DateTime.now(); // Initial date if widget.dateEnd is not initialized yet

    if (!widget.dateEndController.text.isEmpty) {
      List<String> dateComponents = widget.dateEndController.text.split("-");
      int year = int.parse(dateComponents[0]);
      int month = int.parse(dateComponents[1]);
      int day = int.parse(dateComponents[2]);
      initialDate = DateTime(year, month, day);
    }

    DateTime? _picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (_picked != null) {
      setState(() {
        widget.dateEndController.text = _picked.toString().split(" ")[0];
      });
    }
  }
}
