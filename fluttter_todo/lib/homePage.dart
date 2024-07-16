import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttter_todo/EditTask.dart';
import 'package:fluttter_todo/addTask.dart';
import 'package:fluttter_todo/component/dialogbox.dart';
import 'package:fluttter_todo/component/todotile.dart';
import 'package:fluttter_todo/storing/database.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //reference to box
  final mybox = Hive.box("mybox");
  Tododatabase db = Tododatabase();

  List todoList = [];
  TextEditingController _controller = TextEditingController();
  TextEditingController _addTask = TextEditingController();
  TextEditingController dateStartController = TextEditingController();
  TextEditingController dateEndController = TextEditingController();

  void initState() {
    if (mybox.get("TODOLIST") == null) {
      db.create();
      db.updateTask();
    } else {
      db.loadTask();
    }
    setState(() {
      todoList = db.todoList;
    });
    super.initState();
  }

  void saveTask() {
    setState(() {
      db.todoList.add({
        "Tugas": _addTask.text,
        "Task": false,
        "Start": dateStartController.text,
        "End": dateEndController.text,
        "Priority": false,
      });
      db.updateTask();
    });
  }

  //Untuk merubah indikator warna jika dia is priority true
  void toggleTask(bool? value, int index) {
    setState(() {
      db.todoList[index]["Task"] = !db.todoList[index]["Task"];

      db.updateTask();
    });
  }

  //untuk menghapus dari isi database
  void deleteTask(int index) {
    setState(() {
      db.todoList.removeAt(index);
      db.updateTask();
      todoList = db.todoList;
    });
  }

  //Refrseh task method untuk load object masuk kedalam database
  void refreshTasks() {
    setState(() {
      db.loadTask();
    });
  }

  //Melakukan update task pada homepage
  void updateCurrentList() {
    todoList = db.todoList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Text(
          "TO-DO APP",
          style: TextStyle(
              fontSize: 55,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple[300]),
        )),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: todoList.length,
              itemBuilder: (context, index) {
                return TodoTile(
                  taskName: db.todoList[index]["Tugas"],
                  taskComplete: db.todoList[index]["Task"],
                  onChanged: (value) => toggleTask(value, index),
                  onTap: () async {
                    bool? result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => editTask(
                          task: db.todoList[index]["Tugas"],
                          indexDic: index,
                          indexObj: db.todoList[index]
                              ["Tugas"], // Assuming you have an id field
                          db: db,
                          todoList: db.todoList,
                          dateStart: db.todoList[index]["Start"],
                          dateEnd: db.todoList[index]["End"],
                        ),
                      ),
                    );
                    if (result == true) {
                      refreshTasks(); // Refresh the tasks if changes were made
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => addTask(
                db: db,
                controller: _addTask,
                text: "select Date",
                onPreseed: saveTask,
                hintText: "Add Task",
                dateStartController: dateStartController,
                dateEndController: dateEndController,
              ),
            ),
          );

          updateCurrentList(); // Refresh the tasks if changes were made

          // Add a new task for demonstration purposes
          // setState(() {
          //   createNewTask();

          // });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
