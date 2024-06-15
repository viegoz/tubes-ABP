import 'package:flutter/material.dart';
import 'package:barcode/barcode.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:math';

import 'package:mobile_app/main.dart';

class InvoicePage extends StatelessWidget {
  final Map<String, dynamic> bookingDetails;

  InvoicePage({required this.bookingDetails});

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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
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
                    ),
                    SizedBox(height: 20),
                    Text('NIK: ${bookingDetails['NIK']}'),
                    Text('Nama Pasien: ${bookingDetails['Nama_Pasien']}'),
                    Text('Jenis Pasien: ${bookingDetails['Jenis_Pasien']}'),
                    Text('Nomor HP: ${bookingDetails['Nomor_HP']}'),
                    Text('Dokter: ${bookingDetails['Dokter']}'),
                    Text('Poli: ${bookingDetails['Poli']}'),
                    Text(
                        'Tanggal Periksa: ${bookingDetails['Tanggal_Periksa']}'),
                    SizedBox(height: 20),
                    Center(child: barcodeSvg),
                  ],
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
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _generateRandomData() {
    final random = Random();
    const chars = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    return List.generate(10, (index) => chars[random.nextInt(chars.length)])
        .join();
  }
}
