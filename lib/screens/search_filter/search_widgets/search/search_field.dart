import 'package:flutter/material.dart';

class SearchField extends StatelessWidget {
  final TextEditingController controller;
  final Function() onSearch;

  const SearchField({
    Key? key,
    required this.controller,
    required this.onSearch,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Padding(
          padding: EdgeInsets.only(right: 8.0),
          child: CircleAvatar(
            radius: 20,
            backgroundImage: AssetImage('assets/images/ampifylogo.png'),
          ),
        ),
        Expanded(
          child: TextField(
            controller: controller,
            style: const TextStyle(color: Colors.black),
            decoration: InputDecoration(
              hintText: 'Search products...',
              hintStyle: const TextStyle(color: Colors.grey),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(36),
                borderSide: const BorderSide(color: Colors.grey, width: 1.2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(36),
                borderSide: const BorderSide(color: Colors.black54, width: 1.5),
              ),
              suffixIcon: IconButton(
                icon: const Icon(Icons.search, color: Colors.black54),
                onPressed: onSearch,
              ),
            ),
            onSubmitted: (_) => onSearch(),
          ),
        ),
      ],
    );
  }
}
