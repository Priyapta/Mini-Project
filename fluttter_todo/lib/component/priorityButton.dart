import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class priorityButton extends StatefulWidget {
  const priorityButton({
    super.key,
    required this.onPressed,
    required this.text,
    required this.priority,
    required this.icon,
  });
  final VoidCallback onPressed;
  final String text;
  final bool priority;
  final IconData icon;

  @override
  State<priorityButton> createState() => _priorityButtonState();
}

class _priorityButtonState extends State<priorityButton> {
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: widget.onPressed,
      child: Row(
        children: [
          Icon(widget.icon),
          Text(widget.text),
        ],
      ),
      color: widget.priority ? Colors.deepPurple[300] : Colors.grey[350],
      minWidth: 150,
    );
  }
}
