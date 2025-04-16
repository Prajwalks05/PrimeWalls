import 'package:flutter/material.dart';

class SearchInput extends StatelessWidget {
  final TextEditingController textController;
  final String hintText;
  final Function(String) onSubmitted;

  const SearchInput({
    required this.textController,
    required this.hintText,
    required this.onSubmitted,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textController,
      onSubmitted: onSubmitted, // Call onSubmitted when user submits input
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.search),
        hintText: hintText,
        border: OutlineInputBorder(),
      ),
    );
  }
}
