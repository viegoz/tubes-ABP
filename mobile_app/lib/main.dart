import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'question_provider.dart';
import 'login_page.dart';
import 'user_provider.dart';
import 'signup.dart';
import 'home.dart';
import 'custom_navigation_bar.dart';
import 'notifikasi.dart';
import 'profile.dart';
import 'booking.dart';
import 'tanya_dokter.dart';
import 'jadwal_dokter.dart';
import 'booking_dokter.dart';
import 'invoice_booking.dart';
import 'add_tanya.dart';
import 'admin_home.dart';
import 'invoice.dart';
import 'buy_bronze.dart';
import 'buy_silver.dart';
import 'buy_gold.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => QuestionProvider()),
        ChangeNotifierProvider(
            create: (_) => UserProvider()), // Add UserProvider
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Custom Navigation Bar',
      initialRoute: '/',
      routes: {
        '/': (context) => LogInPage(),
        '/signup': (context) => SignUpPage(),
        '/home': (context) => HomePageWithNavigationBar(),
        '/admin_home': (context) => AdminHomePage(),
        '/notifikasi': (context) => NotifPageWithNavigationBar(),
        '/profile': (context) => ProfilePageWithNavigationBar(),
        '/booking': (context) => BookingPage(),
        '/tanya_dokter': (context) => TanyaPage(),
        '/jadwal_dokter': (context) => JadwalDokter(),
        '/add': (context) => AddTanyaPage(),
        '/buy_member': (context) => MemberPage(),
        '/buy_silver': (context) => SilverPage(),
        '/buy_gold': (context) => GoldPage(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/bookingdokter') {
          final doctor = settings.arguments as Doctor;
          return MaterialPageRoute(
            builder: (context) => BookingDokter(doctor: doctor),
          );
        } else if (settings.name == '/invoice') {
          final bookingDetails = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) => InvoiceBookingPage(
              bookingDetails: bookingDetails,
            ),
          );
        }
        return null; // default return null
      },
    );
  }
}

class HomePageWithNavigationBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          HomePage(),
          Positioned(
            left: 0,
            bottom: 0,
            right: 0,
            child: CustomNavigationBar(),
          ),
        ],
      ),
    );
  }
}

class NotifPageWithNavigationBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          NotifPage(),
          Positioned(
            left: 0,
            bottom: 0,
            right: 0,
            child: CustomNavigationBar(),
          ),
        ],
      ),
    );
  }
}

class ProfilePageWithNavigationBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ProfilePage(),
          Positioned(
            left: 0,
            bottom: 0,
            right: 0,
            child: CustomNavigationBar(),
          ),
        ],
      ),
    );
  }
}
