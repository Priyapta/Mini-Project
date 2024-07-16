// import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Tododatabase {
  //Data base berisi array of list {
  //       "Tugas": ,
  //       "Task": ,
  //       "Start": ,
  //       "End": ,
  //       "Priority": ,
  //     } 
  List<Map<String, dynamic>> todoList = [];
  final mybox = Hive.box("mybox");
  void create() {
    todoList = [];
    updateTask();
  }
  //Untuk memasukan object kedalam database load
  void loadTask() {
    List<dynamic> rawList = mybox.get("TODOLIST", defaultValue: []);
    todoList = List<Map<String, dynamic>>.from(
        rawList.map((item) => Map<String, dynamic>.from(item)));
  }
  //Update list kedalam database
  void updateTask() {
    mybox.put("TODOLIST", todoList);
  }
}
