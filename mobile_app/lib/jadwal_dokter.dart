import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'booking_dokter.dart';

void main() {
  runApp(JadwalDokter());
}

class JadwalDokter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: Color.fromARGB(255, 255, 255, 255),
      ),
      home: Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(100),
            child: AppBar(
              backgroundColor: const Color.fromRGBO(154, 212, 166, 1),
              title: Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: Text(
                  'Jadwal Dokter',
                  style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              centerTitle: true,
              leading: Padding(
                padding: const EdgeInsets.only(left: 16.0, top: 30.0),
                child: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    if (Navigator.of(context).canPop()) {
                      Navigator.of(context).pop();
                    } else {
                      print('Error');
                    }
                  },
                ),
              ),
            )),
        body: JadwalPage(),
      ),
      routes: {
        '/bookingdokter': (context) => BookingDokter(
            doctor: Doctor(
                name: '',
                unit: '',
                specialty: '',
                schedule: '')), // dummy data for initialization
      },
    );
  }
}

class Doctor {
  final String name;
  final String unit;
  final String specialty;
  final String schedule;

  Doctor({
    required this.name,
    required this.unit,
    required this.specialty,
    required this.schedule,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      name: json['name'] ?? '',
      unit: json['unit'] ?? '',
      specialty: json['spesialis'] ?? '',
      schedule: json['jadwal'] ?? '',
    );
  }
}

class JadwalPage extends StatefulWidget {
  @override
  _JadwalPageState createState() => _JadwalPageState();
}

class _JadwalPageState extends State<JadwalPage> {
  late Future<List<Doctor>> _futureDoctors;

  @override
  void initState() {
    super.initState();
    _futureDoctors = fetchDoctors();
  }

  Future<List<Doctor>> fetchDoctors() async {
    final response =
        await http.get(Uri.parse('http://192.168.8.171:3001/profiles'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Doctor.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load doctors');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Doctor>>(
      future: _futureDoctors,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          final doctors = snapshot.data!;
          return ListView(
            children:
                doctors.map((doctor) => DokterCard(doctor: doctor)).toList(),
          );
        }
      },
    );
  }
}

class DokterCard extends StatelessWidget {
  final Doctor doctor;

  const DokterCard({required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        color: Color.fromRGBO(154, 212, 166, 1),
        elevation: 4,
        child: Column(
          children: [
            ListTile(
              contentPadding: EdgeInsets.all(16),
              title: Text(
                doctor.name,
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 8),
                  Text(
                    'Unit: ${doctor.unit}',
                    style: TextStyle(fontSize: 14, color: Colors.black),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Specialty: ${doctor.specialty}',
                    style: TextStyle(fontSize: 14, color: Colors.black),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Schedule: ${doctor.schedule}',
                    style: TextStyle(fontSize: 14, color: Colors.black),
                  ),
                ],
              ),
            ),
            ButtonBar(
              alignment: MainAxisAlignment.start,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookingDokter(doctor: doctor),
                      ),
                    );
                  },
                  child: Text('Booking'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    textStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
