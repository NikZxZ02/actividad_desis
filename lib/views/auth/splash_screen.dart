import 'dart:convert';
import 'dart:developer';

import 'package:actividad_desis/db/database.dart';
import 'package:actividad_desis/providers/auth_provider.dart';
import 'package:actividad_desis/views/auth/login_screen.dart';
import 'package:actividad_desis/views/main/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final storage = const FlutterSecureStorage();
  DBSqlite database = DBSqlite();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      isLogin(context);
    });
  }

  Future<void> isLogin(BuildContext context) async {
    final authUser = Provider.of<AuthProvider>(context, listen: false);
    try {
      final storageToken = await storage.read(key: "userdata");
      if (storageToken == null) {
        log('[SPLASH SCREEN] No hay datos');
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) {
                return const LoginScreen();
              },
            ),
          );
        }
        return;
      }
      final userData = jsonDecode(storageToken);
      final user =
          await database.getUser(userData['email'], userData['password']);
      if (user != null) {
        authUser.setUser(user);
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) {
                return const MainScreen();
              },
            ),
          );
        }
        return;
      }
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) {
              return const LoginScreen();
            },
          ),
        );
      }
    } catch (error) {
      log('[SPLASH SCREEN] Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Colors.blueAccent),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 100,
            height: 2,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: const LinearProgressIndicator(),
            ),
          ),
        ],
      ),
    );
  }
}
