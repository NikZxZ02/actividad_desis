import 'package:actividad_desis/db/database.dart';
import 'package:actividad_desis/models/user.dart';
import 'package:actividad_desis/services/user_service.dart';
import 'package:actividad_desis/views/list/list_screen.dart';
import 'package:actividad_desis/views/list/widgets/user_detail_data.dart';
import 'package:actividad_desis/views/list/widgets/weather_card.dart';
import 'package:actividad_desis/views/register/widgets/custom_button.dart';
import 'package:actividad_desis/widgets/message_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class UserDetails extends StatefulWidget {
  final User user;
  const UserDetails({super.key, required this.user});

  @override
  State<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  DBSqlite database = DBSqlite();
  bool isLoading = false;
  final userService = UserService();
  Map<String, dynamic> weather = {};

  @override
  void initState() {
    getWeatherUserCountry();
    super.initState();
  }

  void setIsLoading(bool loading) {
    setState(() {
      isLoading = loading;
    });
  }

  void getWeatherUserCountry() async {
    setIsLoading(true);
    final weahterData = await userService.getWeather(
        widget.user.coordinates.first, widget.user.coordinates.last);
    setState(() {
      weather = weahterData;
      isLoading = false;
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
        padding: const EdgeInsets.symmetric(horizontal: 35.0, vertical: 45),
        child: Column(
          children: [
            WeatherCard(
              weather: weather,
              isLoading: isLoading,
            ),
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
            UserDetailData(
              label: "lat:",
              data: widget.user.coordinates.first.toString(),
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
            ),
            Expanded(
              child: FlutterMap(
                options: MapOptions(
                  onTap: (tapPosition, point) {
                    _showMap(context);
                  },
                  initialCenter: LatLng(
                    widget.user.coordinates.first,
                    widget.user.coordinates.last,
                  ),
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.actividad_desis.app',
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: LatLng(
                          widget.user.coordinates.first,
                          widget.user.coordinates.last,
                        ),
                        width: 80,
                        height: 80,
                        child: const Icon(Icons.location_on),
                      ),
                    ],
                  ),
                ],
              ),
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

  void _showMap(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          content: SizedBox(
            width: 350,
            height: 450,
            child: FlutterMap(
              options: MapOptions(
                initialCenter: LatLng(
                  widget.user.coordinates.first,
                  widget.user.coordinates.last,
                ),
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.actividad_desis.app',
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: LatLng(
                        widget.user.coordinates.first,
                        widget.user.coordinates.last,
                      ),
                      width: 80,
                      height: 80,
                      child: const Icon(Icons.location_on),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
