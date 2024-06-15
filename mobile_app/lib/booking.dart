import 'package:flutter/material.dart';
import 'api_service.dart';
import 'invoice.dart'; // Pastikan Anda mengimpor file yang benar

class BookingPage extends StatefulWidget {
  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final _formKey = GlobalKey<FormState>();
  final _nikController = TextEditingController();
  final _namaController = TextEditingController();
  final _jenisController = TextEditingController();
  final _nomorHpController = TextEditingController();
  final _dokterController = TextEditingController();
  final _poliController = TextEditingController();
  final _tanggalController = TextEditingController();
  final ApiService _apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking Reguler'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nikController,
                decoration: InputDecoration(labelText: 'NIK'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your NIK';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _namaController,
                decoration: InputDecoration(labelText: 'Nama Pasien'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _jenisController,
                decoration: InputDecoration(labelText: 'Jenis Pasien'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter patient type';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _nomorHpController,
                decoration: InputDecoration(labelText: 'Nomor HP'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _dokterController,
                decoration: InputDecoration(labelText: 'Dokter'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter doctor name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _poliController,
                decoration: InputDecoration(labelText: 'Poli'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter poli';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _tanggalController,
                decoration:
                    InputDecoration(labelText: 'Tanggal Periksa (yyyy-mm-dd)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the checkup date';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    final tanggalPeriksa = _tanggalController.text;

                    final patientData = {
                      'NIK': _nikController.text,
                      'Nama_Pasien': _namaController.text,
                      'Jenis_Pasien': _jenisController.text,
                      'Nomor_HP': _nomorHpController.text,
                      'Dokter': _dokterController.text,
                      'Poli': _poliController.text,
                      'Tanggal_Periksa': tanggalPeriksa,
                    };

                    print('Patient data: $patientData');

                    try {
                      await _apiService.addPatient(patientData);

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => InvoicePage(
                            bookingDetails: patientData,
                          ),
                        ),
                      );
                    } catch (e) {
                      print('Error occurred: $e');
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Error'),
                          content:
                              Text('Failed to add booking. Please try again.'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('OK'),
                            ),
                          ],
                        ),
                      );
                    }
                  }
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nikController.dispose();
    _namaController.dispose();
    _jenisController.dispose();
    _nomorHpController.dispose();
    _dokterController.dispose();
    _poliController.dispose();
    _tanggalController.dispose();
    super.dispose();
  }
}
