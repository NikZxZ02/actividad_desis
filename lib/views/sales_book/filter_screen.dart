import 'package:actividad_desis/views/register/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Búsqueda",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xFF1A90D9),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 15.0),
        child: Column(
          children: [
            const Text('Periodo Contable'),
            CustomButton(
              onPress: () {},
              label: "Buscar",
              width: MediaQuery.of(context).size.width,
              color: Colors.blue[800]!,
            )
          ],
        ),
      ),
    );
  }
}
