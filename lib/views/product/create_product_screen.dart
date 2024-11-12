import 'package:actividad_desis/db/database.dart';
import 'package:actividad_desis/models/product.dart';
import 'package:actividad_desis/views/main/main_screen.dart';
import 'package:actividad_desis/views/register/widgets/custom_button.dart';
import 'package:actividad_desis/widgets/message_status.dart';
import 'package:flutter/material.dart';

class CreateProductScreen extends StatefulWidget {
  const CreateProductScreen({super.key});

  @override
  State<CreateProductScreen> createState() => _CreateProductScreenState();
}

class _CreateProductScreenState extends State<CreateProductScreen> {
  final _codeController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _unityPrice = TextEditingController();
  final items = [
    {'Si': 1},
    {'No': 0}
  ];
  DBSqlite database = DBSqlite();
  bool isValid = false;
  int isActive = 1;

  @override
  void initState() {
    super.initState();
    _codeController.addListener(checkIfForm);
    _descriptionController.addListener(checkIfForm);
    _unityPrice.addListener(checkIfForm);
  }

  void checkIfForm() {
    setState(() {
      isValid = _codeController.text.isNotEmpty &&
          _descriptionController.text.isNotEmpty &&
          _unityPrice.text.isNotEmpty;
    });
  }

  void saveProduct() {
    final product = Product(
        code: _codeController.text,
        description: _descriptionController.text,
        unitPrice: _unityPrice.text,
        active: isActive);
    database.insertProduct(product);
    MessagesStatus.showStatusMessage(
        context, 'Producto guardado con exito', false);
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const MainScreen(),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Crear Producto",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xFF1A90D9),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
        child: Column(
          children: [
            TextFormField(
              controller: _codeController,
              decoration: const InputDecoration(
                labelText: "Código",
              ),
            ),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: "Descripción",
              ),
            ),
            TextFormField(
              controller: _unityPrice,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Precio unitario",
              ),
            ),
            DropdownMenu(
              dropdownMenuEntries: items
                  .map<DropdownMenuEntry<Map<String, int>>>(
                      (Map<String, int> value) =>
                          DropdownMenuEntry<Map<String, int>>(
                            value: value,
                            label: value.entries.first.key,
                          ))
                  .toList(),
              width: MediaQuery.of(context).size.width,
              label: const Text("Activo"),
              inputDecorationTheme: const InputDecorationTheme(
                outlineBorder: BorderSide.none,
              ),
              onSelected: (value) {
                setState(() {
                  isActive = value!.values.first;
                });
              },
            ),
            const SizedBox(
              height: 10.0,
            ),
            CustomButton(
              onPress: () {
                saveProduct();
              },
              label: "Guardar",
              width: MediaQuery.of(context).size.width,
              height: 50,
              color: Colors.blue[800]!,
              isDisabled: !isValid,
            )
          ],
        ),
      ),
    );
  }
}
