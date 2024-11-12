import 'package:flutter/material.dart';

class CustomRowText extends StatelessWidget {
  final String label;
  final String value;
  final FontWeight? fontWeight;
  final Color? color;
  const CustomRowText(
      {super.key,
      required this.label,
      required this.value,
      this.fontWeight = FontWeight.normal,
      this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style:
                  TextStyle(fontSize: 16, fontWeight: fontWeight, color: color),
            ),
          ),
        ],
      ),
    );
  }
}
