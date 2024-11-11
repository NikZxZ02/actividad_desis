import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class EmailServices {
  final String apiKey = dotenv.get('API_KEY', fallback: 'URL env is required');
  final String email = dotenv.get('EMAIL', fallback: 'URL env is required');

  Future<int> sendDocumentEmail(String emailTo, File saleSlip) async {
    final response = await http.post(
      Uri.parse('https://api.sendgrid.com/v3/mail/send'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: json.encode({
        'personalizations': [
          {
            'to': [
              {'email': emailTo}
            ],
          }
        ],
        'from': {'email': email},
        'subject': 'Envio de boleta electronica',
        'content': [
          {'type': 'text/plain', 'value': 'Se envia documento adjunto'},
        ],
        'attachments': [
          {
            'content': base64Encode(saleSlip.readAsBytesSync()),
            'filename': 'boleta_temporal.pdf',
            'type': 'application/pdf',
            'disposition': 'attachment',
          },
        ],
      }),
    );

    if (response.statusCode == 202) {
      log('Correo enviado con éxito');
      return 200;
    } else {
      log('Error al enviar el correo: ${response.body}');
      return 404;
    }
  }
}
