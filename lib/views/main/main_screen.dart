import 'package:actividad_desis/views/list/list_screen.dart';
import 'package:actividad_desis/views/main/widgets/custom_card.dart';
import 'package:actividad_desis/views/register/register_screen.dart';
import 'package:actividad_desis/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Facturacion.cl",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        backgroundColor: const Color(0xFF1A90D9),
      ),
      drawer: const CustomDrawer(
        isHome: true,
      ),
      body: Column(
        children: [
          CustomCard(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const RegisterScreen(newUser: false)));
            },
            label: "Creación Cuenta",
            color: const Color(0xFF52C5F2),
          ),
          CustomCard(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const UserListScreen()));
            },
            label: "Listado",
            color: const Color(0xFF808080),
          ),
        ],
      ),
    );
  }
}
