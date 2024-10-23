import 'package:actividad_desis/db/database.dart';
import 'package:actividad_desis/models/user.dart';
import 'package:actividad_desis/views/list/list_screen.dart';
import 'package:actividad_desis/views/list/widgets/user_detail_data.dart';
import 'package:actividad_desis/views/register/widgets/custom_button.dart';
import 'package:actividad_desis/widgets/message_status.dart';
import 'package:flutter/material.dart';

class UserDetails extends StatefulWidget {
  final User user;
  const UserDetails({super.key, required this.user});

  @override
  State<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  DBSqlite database = DBSqlite();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  void setIsLoading(bool loading) {
    setState(() {
      isLoading = loading;
    });
  }

  void delete() async {
    database.deleteUser(widget.user.id!);

    if (mounted) {
      Navigator.push(context, MaterialPageRoute(
        builder: (context) {
          return const UserListScreen();
        },
      ));
      MessagesStatus.showStatusMessage(
          context, "Cuenta eliminada con exito", false);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Detalle Cuenta",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xFF1A90D9),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 35.0, vertical: 55),
        child: Column(
          children: [
            UserDetailData(
              label: "Nombre:",
              data: widget.user.name,
            ),
            UserDetailData(
              label: "Correo Electronico:",
              data: widget.user.email,
            ),
            UserDetailData(
              label: "Dirección:",
              data: widget.user.address,
            ),
            UserDetailData(
              label: "Numero teléfono:",
              data: widget.user.phoneNumber,
            ),
            UserDetailData(
              label: "Fecha de Nacimiento:",
              data: widget.user.birthDate,
            ),
            UserDetailData(
              label: "Contraseña:",
              data: widget.user.password,
            ),
            const SizedBox(
              height: 55,
            ),
            CustomButton(
              onPress: () {
                _showAlert(context);
              },
              label: "Eliminar Cuenta",
              width: MediaQuery.of(context).size.width,
              height: 70,
              color: Colors.red[400]!,
              isDisabled: isLoading,
              isLoading: isLoading,
            )
          ],
        ),
      ),
    );
  }

  void _showAlert(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
          title: const Center(
              child: Text(
            'Eliminar Cuenta',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          )),
          content: const Text(
            '¿Estas seguro de eliminar esta cuenta?',
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[400]!,
                minimumSize: const Size(100, 35),
              ),
              child: const Text(
                "No",
                style: TextStyle(color: Colors.white),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                delete();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A90D9),
                minimumSize: const Size(100, 35),
              ),
              child: const Text(
                "Si",
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
          actionsAlignment: MainAxisAlignment.center,
        );
      },
    );
  }
}
