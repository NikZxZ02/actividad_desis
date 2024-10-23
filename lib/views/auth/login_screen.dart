import 'package:actividad_desis/db/database.dart';
import 'package:actividad_desis/views/main/main_screen.dart';
import 'package:actividad_desis/views/register/widgets/custom_button.dart';
import 'package:actividad_desis/widgets/message_status.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  bool isVisible = true;
  DBSqlite database = DBSqlite();

  @override
  void initState() {
    super.initState();
  }

  void logIn() async {
    final user =
        await database.getUser(_emailController.text, _passController.text);
    if (user != null) {
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return const MainScreen();
            },
          ),
        );
      }
    } else {
      if (mounted) {
        MessagesStatus.showStatusMessage(
            context, "Correo y/o contraseña incorrectos", true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Facturacion.cl",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF1A90D9),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 25.0,
            vertical: 155.0,
          ),
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                    icon: Icon(
                      Icons.person,
                    ),
                    hintText: "Usuario"),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _passController,
                obscureText: isVisible,
                decoration: InputDecoration(
                  icon: const Icon(Icons.key),
                  hintText: "Contraseña",
                  suffixIcon: IconButton(
                    icon: Icon(isVisible
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined),
                    onPressed: () => setState(() {
                      isVisible = !isVisible;
                    }),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              CustomButton(
                onPress: () {
                  logIn();
                },
                label: "Ingresar",
                width: MediaQuery.of(context).size.width,
                color: const Color(0xFF1A90D9),
              )
            ],
          ),
        ),
      ),
    );
  }
}
