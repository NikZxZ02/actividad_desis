import 'dart:io';

import 'package:actividad_desis/views/main/main_screen.dart';
import 'package:actividad_desis/views/register/widgets/custom_button.dart';
import 'package:actividad_desis/views/sales_slip/widgets/pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class FinishedScreen extends StatelessWidget {
  final int folio;
  final File pdf;
  const FinishedScreen({super.key, required this.folio, required this.pdf});

  void sharePDF() async {
    await Share.shareXFiles([XFile(pdf.path)],
        text: "Documento N° $folio emitido");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Folio N° $folio ha sido ingresado al Libro de Ventas del período Noviembre 2024",
              style: TextStyle(
                color: Colors.blue[900],
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(
                vertical: 15.0,
              ),
              child: Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 55,
              ),
            ),
            CustomButton(
              onPress: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          PdfPreviewScreen(pdfPreview: pdf.path),
                    ));
              },
              label: "Ver PDF",
              color: Colors.blue[700]!,
              width: MediaQuery.of(context).size.width,
            ),
            CustomButton(
              onPress: () {
                sharePDF();
              },
              label: "Compartir",
              color: Colors.blue[700]!,
              width: MediaQuery.of(context).size.width,
            ),
            CustomButton(
              onPress: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MainScreen(),
                  ),
                );
              },
              label: "Aceptar",
              color: Colors.green[400]!,
              width: MediaQuery.of(context).size.width,
            ),
          ],
        ),
      ),
    );
  }
}
