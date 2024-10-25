import 'package:flutter/material.dart';

class WeatherCard extends StatelessWidget {
  final Map<String, dynamic> weather;
  final bool isLoading;

  const WeatherCard({
    super.key,
    required this.weather,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blue[300],
      elevation: 5,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 20,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blue[100]!,
              Colors.blue[600]!,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: !isLoading
            ? Stack(
                children: [
                  Positioned(
                    left: 50,
                    child: Image.network(
                      "https://openweathermap.org/img/w/${weather["weather"][0]["icon"]}.png",
                      height: 50,
                      width: 50,
                    ),
                  ),
                  Column(
                    children: [
                      Text(
                        "${weather["main"]["temp"]}°C",
                        style: const TextStyle(
                            fontSize: 27,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            "Humedad: ${weather["main"]["humidity"]}%",
                            style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          Text(
                            "Clima: ${weather["weather"][0]["main"]}",
                            style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          )
                        ],
                      ),
                    ],
                  ),
                ],
              )
            : const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
