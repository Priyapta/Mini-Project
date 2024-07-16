import 'package:flutter/material.dart';

class selectDate extends StatefulWidget {
  final VoidCallback onTap;
  final String text;
  final String hintText;

  const selectDate({
    super.key,
    required this.onTap,
    required this.text,
    required this.hintText,
  });

  @override
  State<selectDate> createState() => _selectDateState();
}

class _selectDateState extends State<selectDate> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      width: screenWidth * 0.3,
      child: TextField(
        decoration: InputDecoration(
          labelText: widget.hintText.isEmpty ? widget.text : widget.hintText,
          filled: true,
          hintText: widget.hintText,
          prefixIcon: Icon(Icons.calendar_today),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
        ),
        readOnly: true,
        onTap: widget.onTap,
      ),
    );
  }
}
