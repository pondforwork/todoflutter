import 'package:flutter/material.dart';

// ignore: must_be_immutable
class tododescrip extends StatelessWidget {
  final String name;
  final String description;

  const tododescrip(this.name, this.description, {super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(20),
      ),
      height: 100,
      child: Center(
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(color: Colors.white, fontSize: 24),
                ),
                Expanded(
                    child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    description,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ))
              ],
            )),
      ),
    );
  }
}
