import 'package:actividad_desis/views/list/list_screen.dart';
import 'package:actividad_desis/views/main/main_screen.dart';
import 'package:actividad_desis/views/register/register_screen.dart';
import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  final bool isHome;

  const CustomDrawer({super.key, required this.isHome});

  @override
  Widget build(BuildContext context) {
    return Drawer(
        surfaceTintColor: Colors.white,
        child: ListView(
          children: [
            ListTile(
              title: const Text(
                'Inicio',
                style: TextStyle(fontSize: 15),
              ),
              onTap: () {
                if (isHome) {
                  Navigator.pop(context);
                } else {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return const MainScreen();
                    },
                  ));
                }
              },
              trailing: const Icon(Icons.arrow_forward_ios),
            ),
            ListTile(
              title: const Text(
                'Creación Cuenta',
                style: TextStyle(fontSize: 15),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const RegisterScreen()));
              },
              trailing: const Icon(Icons.arrow_forward_ios),
            ),
            ListTile(
              title: const Text(
                'Listado',
                style: TextStyle(fontSize: 15),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const UserListScreen()));
              },
              trailing: const Icon(Icons.arrow_forward_ios),
            )
          ],
        ));
  }
}
