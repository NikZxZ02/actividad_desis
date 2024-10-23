import 'package:flutter/material.dart';

class UserDetailData extends StatelessWidget {
  final String label;
  final String data;
  const UserDetailData({
    super.key,
    required this.label,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          Expanded(
            child: Text(
              data,
              style: const TextStyle(fontSize: 16),
            ),
          )
        ],
      ),
    );
  }
}
