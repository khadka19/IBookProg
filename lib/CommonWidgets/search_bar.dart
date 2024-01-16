import 'package:flutter/material.dart';
// ignore: must_be_immutable
class CustomSearchBar extends StatefulWidget {
  final TextEditingController controller;
  final ValueChanged<String?> onChanged;
  String hintText;
   CustomSearchBar({
    required this.controller,
    required this.onChanged,
    required this.hintText,
    Key? key,
  }) : super(key: key);

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.06,
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 226, 222, 222),
        borderRadius: BorderRadius.circular(20),
      ),
      child:  TextFormField(
        controller: widget.controller,
        onChanged: widget.onChanged,
        decoration:  InputDecoration(
          hintText: widget.hintText,
          icon: const Icon(Icons.search),
          border: InputBorder.none,
        ),
      ),
    );
  }
}