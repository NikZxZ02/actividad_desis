import 'package:actividad_desis/providers/auth_provider.dart';
import 'package:actividad_desis/views/auth/login_screen.dart';
import 'package:actividad_desis/views/list/list_screen.dart';
import 'package:actividad_desis/views/main/main_screen.dart';
import 'package:actividad_desis/views/register/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

class CustomDrawer extends StatefulWidget {
  final bool isHome;

  const CustomDrawer({super.key, required this.isHome});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  final storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
  }

  void logOut() async {
    final authUser = Provider.of<AuthProvider>(context, listen: false);
    authUser.logout();
    await storage.deleteAll();
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
      );
    }
  }

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
              if (widget.isHome) {
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
                      builder: (context) => const RegisterScreen(
                            newUser: false,
                          )));
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
          ),
          const SizedBox(
            height: 150,
          ),
          ListTile(
            tileColor: Colors.redAccent[100],
            title: const Text(
              'Cerrar Sesión',
              style: TextStyle(fontSize: 15, color: Colors.white),
            ),
            onTap: () {
              logOut();
            },
            trailing: const Icon(Icons.arrow_forward_ios),
          )
        ],
      ),
    );
  }
}
