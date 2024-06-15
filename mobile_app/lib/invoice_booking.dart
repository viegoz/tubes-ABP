import 'package:flutter/material.dart';
import 'package:barcode/barcode.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_app/main.dart';

class InvoiceBookingPage extends StatelessWidget {
  final Map<String, dynamic> bookingDetails;

  InvoiceBookingPage({required this.bookingDetails});

  String _generateRandomData() {
    final random = DateTime.now().millisecondsSinceEpoch.toString();
    return random;
  }

  @override
  Widget build(BuildContext context) {
    final String randomData = _generateRandomData();
    final Barcode barcode = Barcode.code128();
    final SvgPicture barcodeSvg = SvgPicture.string(
      barcode.toSvg(randomData, width: 200, height: 80),
      fit: BoxFit.contain,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Invoice'),
        backgroundColor: Color(0xFF9AD4A6),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Invoice',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  Text('NIK: ${bookingDetails['NIK']}'),
                  Text('Nama Pasien: ${bookingDetails['Nama_Pasien']}'),
                  Text('Jenis Pasien: ${bookingDetails['Jenis_Pasien']}'),
                  Text('Nomor HP: ${bookingDetails['Nomor_HP']}'),
                  Text('Dokter: ${bookingDetails['Dokter']}'),
                  Text('Poli: ${bookingDetails['Poli']}'),
                  Text('Tanggal Periksa: ${bookingDetails['Tanggal_Periksa']}'),
                  Text(
                      'Metode Pembayaran: ${bookingDetails['Metode_Pembayaran']}'),
                  SizedBox(height: 20),
                  barcodeSvg,
                  SizedBox(height: 20),
                  Text(
                    'Total Harga: 70000 IDR',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HomePageWithNavigationBar()),
                        (Route<dynamic> route) => false,
                      );
                    },
                    child: Text('Oke'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF9AD4A6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
