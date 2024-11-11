import 'package:flutter/material.dart';

class SaleSlipTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? label;
  final VoidCallback? onTap;
  final bool readOnly;
  final TextInputType? keyboardType;
  final bool autoFocus;

  const SaleSlipTextField(
      {super.key,
      required this.controller,
      this.label,
      this.onTap,
      this.readOnly = false,
      this.autoFocus = false,
      this.keyboardType});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: TextFormField(
        controller: controller,
        autofocus: autoFocus,
        decoration: InputDecoration(
          labelText: label,
          fillColor: readOnly
              ? Colors.grey[300]
              : const Color.fromARGB(255, 213, 228, 253),
          filled: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 10.0),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
        ),
        onTap: onTap,
        keyboardType: keyboardType,
        readOnly: readOnly,
      ),
    );
  }
}
