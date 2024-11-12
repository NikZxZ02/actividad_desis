import 'dart:typed_data';

class SaleSlip {
  final int? id;
  final int folio;
  final String rut;
  final int totalAmount;
  final String date;
  final String datetime;
  final Uint8List saleSlip;

  SaleSlip(
      {this.id,
      required this.folio,
      required this.rut,
      required this.totalAmount,
      required this.date,
      required this.datetime,
      required this.saleSlip});

  factory SaleSlip.fromJson(Map<String, dynamic> json) {
    return SaleSlip(
      id: null,
      folio: json['folio'],
      rut: json['rut'],
      totalAmount: json['totalAmount'],
      date: json['date'],
      datetime: json['datetime'],
      saleSlip: json['sale_slip'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'folio': folio,
      'rut': rut,
      'totalAmount': totalAmount,
      'date': date,
      'datetime': datetime,
      'sale_slip': saleSlip,
    };
  }
}
