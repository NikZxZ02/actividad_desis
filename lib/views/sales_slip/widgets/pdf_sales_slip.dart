import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class PdfSalesSlipCreate {
  static Future<File> generate(
      List<Map<String, dynamic>> saleSlip, int total, int? folio) async {
    final pdf = Document();

    pdf.addPage(
      Page(
        margin: const EdgeInsets.all(20),
        build: (context) {
          return Container(
            child: Column(
              children: [
                buildHeader(folio),
                SizedBox(height: 15),
                buildCostumerBox(),
                SizedBox(height: 15),
                Container(
                    height: double.infinity,
                    child: buildProductTable(saleSlip)),
                buildTotal(total),
              ],
            ),
          );
        },
      ),
    );
    final bytes = await pdf.save();
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/boleta_temporal.pdf');
    await file.writeAsBytes(bytes);

    return file;
  }

  static Widget buildHeader(int? folio) => Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              buildBusinessInfo(),
              buildSaleSlipInfo(folio),
            ],
          ),
        ],
      );

  static Widget buildBusinessInfo() => Expanded(
        child: Column(
          children: [
            Text("SERVICIOS Y TECNOLOGIA",
                style: TextStyle(fontWeight: FontWeight.bold)),
            Text("IMPORTACION Y EXPORTACION DE"),
            Text("SOFTWARE, SUMINISTROS Y COMPUTADORES"),
            Divider(indent: 20, endIndent: 20),
            Text("GRAN AVENIDA 5018, Depto. 218"),
            Text("SAN MIGUEL - SANTIAGO"),
            Text("Fono: (56-2) 550 552 51"),
            SizedBox(height: 15),
            Text("CASA MATRIZf-GRAN AVENIDA 5018, Depto."),
          ],
        ),
      );

  static Widget buildSaleSlipInfo(int? folio) {
    final now = DateTime.now();
    final nowDate = getLocalDate(now);

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: PdfColors.red,
              width: 2.0,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            child: Column(
              children: [
                Text(
                  "R.U.T 77.574.330-1",
                  style: TextStyle(
                    color: PdfColors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 15),
                Text(
                  "BOLETA ELECTRONICA",
                  style: TextStyle(
                    color: PdfColors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 15),
                Text(
                  folio != null ? "N° $folio" : "N° SIN FOLIO",
                  style: TextStyle(
                    color: PdfColors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 5),
        Text(
          "S.I.I SANTIAGO SUR",
          style: TextStyle(
            color: PdfColors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          "Santiago, ${nowDate.day} de ${getMonthName(nowDate.month)} de  ${nowDate.year}",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        )
      ],
    );
  }

  static Widget buildCostumerBox() => Container(
        width: double.infinity,
        decoration: BoxDecoration(border: Border.all()),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 0.8 * PdfPageFormat.cm),
            Container(
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "COD. Cliente:",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text(
                    "APP_FACTURACION",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            SizedBox(height: 0.8 * PdfPageFormat.cm),
          ],
        ),
      );

  static Widget buildProductTable(List<Map<String, dynamic>> saleSlip) {
    final headers = [
      'Item',
      'Codigo',
      'Descripcion',
      'U.M',
      'Cantidad',
      'Precio Unit.',
      'Valor'
    ];

    final data = saleSlip.asMap().entries.map((entry) {
      final index = entry.key;
      final product = entry.value;

      return [
        (index + 1).toString(),
        product["code"],
        product["description"],
        "U.N",
        product["quantity"],
        product["unitPrice"],
        product["totalValue"],
      ];
    }).toList();

    return TableHelper.fromTextArray(
      headers: headers,
      data: data,
      border: TableBorder.symmetric(
        inside: BorderSide.none,
        outside: const BorderSide(),
      ),
      headerStyle:
          TextStyle(fontWeight: FontWeight.bold, color: PdfColors.white),
      headerDecoration: const BoxDecoration(color: PdfColors.black),
      cellHeight: 30,
      cellAlignments: {
        0: Alignment.centerLeft,
        1: Alignment.centerRight,
        2: Alignment.centerRight,
        3: Alignment.centerRight,
        4: Alignment.centerRight,
        5: Alignment.centerRight,
        6: Alignment.centerRight,
      },
    );
  }

  static Widget buildTotal(int total) {
    int iva = (total * 0.19).toInt();

    return Container(
      child: Row(
        children: [
          Column(
            children: [
              Container(
                height: 100,
                width: 150,
                child: BarcodeWidget(
                  barcode: Barcode.pdf417(
                      moduleHeight: 5.0,
                      securityLevel: Pdf417SecurityLevel.level7,
                      preferredRatio: 1.8),
                  data: "Timbre Electronico",
                ),
              ),
              Text(
                "Timbre Electronico",
                style: const TextStyle(
                  fontSize: 10,
                ),
              ),
              Text("Resolución Nro. 80 del 22-08-2014"),
            ],
          ),
          Spacer(flex: 6),
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          "IVA:",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(
                        '\$ $iva',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Total:",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(
                        "\$ $total",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Divider(),
                Container(
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Valor a pagar:",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(
                        "\$ ${total + iva}",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

String getMonthName(int monthNumber) {
  const List<String> months = [
    'Enero',
    'Febrero',
    'Marzo',
    'Abril',
    'Mayo',
    'Junio',
    'Julio',
    'Agosto',
    'Septiembre',
    'Octubre',
    'Noviembre',
    'Diciembre'
  ];
  return months[monthNumber - 1];
}

DateTime getLocalDate(DateTime date) {
  tz.initializeTimeZones();
  var location = tz.getLocation('America/Santiago');

  return tz.TZDateTime.from(date, location);
}
