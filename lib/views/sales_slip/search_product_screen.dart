import 'package:actividad_desis/db/database.dart';
import 'package:actividad_desis/models/product.dart';
import 'package:actividad_desis/providers/product_provider.dart';
import 'package:actividad_desis/views/register/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchProductScreen extends StatefulWidget {
  const SearchProductScreen({super.key});

  @override
  State<SearchProductScreen> createState() => _SearchProductScreenState();
}

class _SearchProductScreenState extends State<SearchProductScreen> {
  final _codeController = TextEditingController();
  final _descriptionController = TextEditingController();
  final items = [' ', 'Si', 'No'];
  DBSqlite database = DBSqlite();
  List<Product> products = [];
  bool isSearch = false;
  bool isValid = false;

  @override
  void initState() {
    super.initState();
    _codeController.addListener(checkIfForm);
    _descriptionController.addListener(checkIfForm);
  }

  void checkIfForm() {
    setState(() {
      isValid = _codeController.text.isNotEmpty ||
          _descriptionController.text.isNotEmpty;
    });
  }

  Future<void> loadProducts() async {
    final usersData = await database.getProducts(
        _codeController.text, _descriptionController.text);
    setState(() {
      products = usersData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Buscador de Producto",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xFF1A90D9),
      ),
      body: !isSearch
          ? Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
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
                  DropdownMenu(
                    dropdownMenuEntries: items
                        .map<DropdownMenuEntry<String>>(
                            (String value) => DropdownMenuEntry<String>(
                                  value: value,
                                  label: value,
                                ))
                        .toList(),
                    width: MediaQuery.of(context).size.width,
                    label: const Text("Activo"),
                    inputDecorationTheme: const InputDecorationTheme(
                      outlineBorder: BorderSide.none,
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  CustomButton(
                    onPress: () {
                      if (isValid) {
                        setState(() {
                          isSearch = !isSearch;
                        });
                        loadProducts();
                      } else {
                        _showAlert(context);
                      }
                    },
                    label: "Buscar",
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    color: Colors.blue[800]!,
                  )
                ],
              ))
          : _search(),
    );
  }

  Widget _search() {
    final productProvider = Provider.of<ProductProvider>(context);
    return Column(
      children: [
        Container(
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 223, 210, 225),
          ),
          height: 45,
          child: const Row(
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Otras coincidencias',
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  productProvider.setProduct(products.elementAt(index));
                  Navigator.pop(context);
                },
                child: ListTile(
                  tileColor:
                      (index % 2 == 0) ? Colors.blue[100] : Colors.blue[50],
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        products.elementAt(index).description,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '\$${products.elementAt(index).unitPrice}',
                        style: const TextStyle(fontSize: 13),
                      )
                    ],
                  ),
                  subtitle: Text(products.elementAt(index).code),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    size: 15,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

void _showAlert(BuildContext context) async {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        title: const Text(
          'Buscar Producto',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'Debe agregar algún parámetro de búsqueda',
          textAlign: TextAlign.justify,
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Aceptar"))
        ],
      );
    },
  );
}
