import 'package:flutter/material.dart';
import 'package:fluttter_todo/component/priorityButton.dart';
import 'package:fluttter_todo/component/selectDate.dart';
import 'package:fluttter_todo/storing/database.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';

class editTask extends StatefulWidget {
  const editTask(
      {super.key,
      required this.task,
      required this.indexDic,
      required this.indexObj,
      required this.db,
      required this.todoList,
      required this.dateStart,
      required this.dateEnd});
  final String task;
  final int indexDic;
  final String indexObj;
  final Tododatabase db;
  final List todoList;
  final String dateStart;
  final String dateEnd;

  @override
  State<editTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<editTask> {
  final mybox = Hive.box("mybox");
  late TextEditingController _textFieldController;
  String hintText = "";

  @override
  void initState() {
    super.initState();
    _textFieldController = TextEditingController();
    hintText = widget.db.todoList[widget.indexDic]["Tugas"];
    widget.db.loadTask();

    setState(() {
      widget.db.todoList = widget.db.todoList;
    });
  }

  void changeTask(String name, int indexDic, String index, String dateStart,
      String dateEnd) {
    setState(() {
      if (!dateStart.isEmpty && !dateEnd.isEmpty) {
        widget.db.todoList[indexDic]["Start"] = dateStart;
        widget.db.todoList[indexDic]["End"] = dateEnd;
      }
      if (!name.isEmpty) {
        widget.db.todoList[indexDic]["Tugas"] = name;
      }
      widget.db.todoList = widget.db.todoList;
      widget.db.updateTask();
      widget.db.loadTask();
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
        onPressed: () {
          setState(() {
            Navigator.pop(context, true);
          });
        },
        icon: Icon(Icons.arrow_back),
      )),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(left: screenWidth * 0.1),
                child: selectDate(                  //widget untuk memilih tanggal
                    onTap: () {
                      _selectdateStart();
                    },
                    hintText: widget.db.todoList[widget.indexDic]["Start"],
                    text: "select Date"),
              ),
              Padding(
                padding: EdgeInsets.only(right: screenWidth * 0.1),
                child: selectDate(                 //widget untuk memilih tanggal
                    onTap: () {
                      _selectdateEnd();
                    },
                    hintText: widget.db.todoList[widget.indexDic]["End"],
                    text: "select Date"),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextField(
              controller: _textFieldController,
              onSubmitted: (_) {},
              decoration: InputDecoration(
                  hintText: widget.db.todoList[widget.indexDic]["Tugas"],
                  border: OutlineInputBorder()),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                priorityButton(
                  icon: Icons.priority_high,
                  onPressed: () {
                    setState(() {
                      if (!widget.db.todoList[widget.indexDic]["Priority"]) {
                        widget.db.todoList[widget.indexDic]["Priority"] =
                            !widget.db.todoList[widget.indexDic]["Priority"];
                      }
                    });
                  },
                  text: "Priorty",
                  priority: widget.db.todoList[widget.indexDic]["Priority"],
                ),
                priorityButton(
                  icon: Icons.sunny,
                  onPressed: () {
                    setState(() {
                      if (widget.db.todoList[widget.indexDic]["Priority"]) {
                        widget.db.todoList[widget.indexDic]["Priority"] =
                            !widget.db.todoList[widget.indexDic]["Priority"];
                      }
                    });
                  },
                  text: "Daily",
                  priority: !widget.db.todoList[widget.indexDic]["Priority"],
                ),
              ],
            ),
          ),
          ElevatedButton(
              onPressed: () {
                changeTask(
                  _textFieldController.text,
                  widget.indexDic,
                  widget.indexObj,
                  widget.db.todoList[widget.indexDic]["Start"],
                  widget.db.todoList[widget.indexDic]["End"],
                );
                setState(() {
                  hintText = _textFieldController.text;
                  _textFieldController.clear();
                  // Navigator.of(context).pop();
                });
              },
              child: Text("Edit"))
        ],
      ),
    );
  }

  Future<void> _selectdateStart() async {
    DateTime initialDate =
        DateTime.now(); // Initial date if widget.dateEnd is not initialized yet

    if (widget.dateStart.isNotEmpty) {
      List<String> dateComponents =
          widget.db.todoList[widget.indexDic]["Start"].split("-");
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
        widget.db.todoList[widget.indexDic]["Start"] =
            _picked.toString().split(" ")[0];

        print(widget.db.todoList[widget.indexDic]["Start"]);
        print(initialDate);
      });
    }
  }

  Future<void> _selectdateEnd() async {
    DateTime initialDate =
        DateTime.now(); // Initial date if widget.dateEnd is not initialized yet

    if (widget.dateEnd.isNotEmpty) {
      List<String> dateComponents =
          widget.db.todoList[widget.indexDic]["End"].split("-");
      int year = int.parse(dateComponents[0]);
      int month = int.parse(dateComponents[1]);
      int day = int.parse(dateComponents[2]);
      initialDate = DateTime(year, month, day);
      print(dateComponents);
    }

    DateTime? _picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (_picked != null) {
      setState(() {
        widget.db.todoList[widget.indexDic]["End"] =
            _picked.toString().split(" ")[0];
        // widget.db.updateTask();
        print(widget.db.todoList[widget.indexDic]["End"]);
        print(initialDate);
      });
    }
  }
}
