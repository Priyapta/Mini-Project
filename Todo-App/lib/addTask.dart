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
    required this.isChecked,
    required this.updateChecked,
  });
  final TextEditingController controller;
  final VoidCallback onPreseed;
  final String text;
  final String hintText;
  final Tododatabase db;
  final TextEditingController dateStartController;
  final TextEditingController dateEndController;
  final bool isChecked;
  final Function(bool) updateChecked;
  @override
  State<addTask> createState() => _nameState();
}

class _nameState extends State<addTask> {
  final mybox = Hive.box("mybox");
  late bool isChecked;

  @override
  void initState() {
    super.initState();
    isChecked =
        widget.isChecked; // Initialize local state from widget parameter
  }

  void _toggleChecked() {
    setState(() {
      isChecked = !isChecked; // Toggle isChecked locally
    });
    widget.updateChecked(isChecked); // Notify parent widget about the change
  }

  @override
  Widget build(BuildContext context) {
    // bool isDesktop(BuildContext context) =>
    //     MediaQuery.of(context).size.width >= 600;
    // bool isMobile(BuildContext context) =>
    //     MediaQuery.of(context).size.width <= 600;
    final double screenWidth = MediaQuery.of(context).size.width * 0.8;
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
              child: Container(
                width: screenWidth,
                child: TextField(
                  controller: widget.controller,
                  decoration: InputDecoration(
                    hintText: "Add Task",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ),
          ),
          Container(
            width: screenWidth,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: selectDate(
                onTap: () {
                  _selectdateStart();
                },
                text: "Start",
                hintText: widget.dateStartController.text,
              ),
            ),
          ),
          Container(
            width: screenWidth,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: selectDate(
                onTap: () {
                  _selectdateEnd();
                },
                text: "End",
                hintText: widget.dateEndController.text,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Container(
              width: screenWidth / 2,
              child: MaterialButton(
                minWidth: 300,
                onPressed: _toggleChecked,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(isChecked ? Icons.priority_high : Icons.sunny),
                    Text(isChecked ? "Priority" : "Daily"),
                  ],
                ),
                color: isChecked ? Colors.deepPurple[300] : Colors.grey[350],
              ),
            ),
          ),
          SizedBox(
            width: screenWidth / 4,
            child: Button(
              text: "Add",
              onPressed: widget.onPreseed,
            ),
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
