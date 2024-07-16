import 'package:flutter/material.dart';

class TodoTile extends StatelessWidget {
  final String taskName;
  final bool taskComplete;
  final Function(bool?)? onChanged;
  final VoidCallback? onTap;

  const TodoTile({
    super.key,
    required this.taskName,
    required this.taskComplete,
    required this.onChanged,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color textColor = taskComplete ? Colors.deepPurple : Colors.black;
    Color boxColor = taskComplete ? Colors.white : Colors.deepPurpleAccent;
    Color borderColor = taskComplete ? Colors.grey.shade400 : Colors.black;

    return Padding(
      padding: const EdgeInsets.all(12),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(24),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  taskName,
                  style: TextStyle(
                    fontFamily: "roboto",
                    fontSize: 15,
                    color: textColor,
                  ),
                ),
              ),
              Checkbox(value: taskComplete, onChanged: onChanged)
            ],
          ),
          decoration: BoxDecoration(
            color: boxColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: borderColor, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3),
              )
            ],
          ),
        ),
      ),
    );
  }
}
