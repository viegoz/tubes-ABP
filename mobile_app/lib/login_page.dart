import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'auth_service.dart';
import 'user_provider.dart';
import 'home.dart';
import 'admin_home.dart';
import 'signup.dart';

class LogInPage extends StatefulWidget {
  @override
  _LogInPageState createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  void _login() async {
    if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
      _showErrorDialog('Please fill in both username and password.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final userDetails = await _authService.authenticate(
      _usernameController.text,
      _passwordController.text,
    );

    setState(() {
      _isLoading = false;
    });

    if (userDetails != null) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.setUser(userDetails);

      if (userDetails['status'] == 'user') {
        Navigator.pushReplacementNamed(context, '/home');
      } else if (userDetails['status'] == 'admin') {
        Navigator.pushReplacementNamed(context, '/admin_home');
      } else {
        _showErrorDialog('Login failed. Please check your credentials.');
      }
    } else {
      _showErrorDialog('Login failed. Please check your credentials.');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: size.width,
          height: size.height,
          color: const Color(0xFFF5F5F5),
          child: Stack(
            children: [
              _buildLogo(size),
              _buildInputSection(size),
              _buildLoginButton(context, size),
              if (_isLoading) Center(child: CircularProgressIndicator()),
              Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/signup');
                  },
                  child: Text(
                    "Don't have an account? Signup",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogo(Size size) {
    return Positioned(
      top: size.height * 0.1,
      left: size.width * 0.25,
      right: size.width * 0.25,
      child: Center(
        child: Image.asset(
          'assets/images/logo.png', // Adjust the path as needed
          width: size.width * 1,
        ),
      ),
    );
  }

  Widget _buildInputSection(Size size) {
    return Positioned(
      left: 12,
      top: size.height * 0.5,
      child: Container(
        width: size.width - 24,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField(_usernameController, 'Username'),
            const SizedBox(height: 15),
            _buildTextField(_passwordController, 'Password', obscureText: true),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hintText,
      {bool obscureText = false}) {
    return Container(
      width: double.infinity,
      height: 33,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
        ),
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context, Size size) {
    return Positioned(
      left: size.width * 0.25,
      top: size.height * 0.75,
      child: GestureDetector(
        onTap: _login,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFF9AD4A6),
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Color(0x3F000000),
                blurRadius: 1,
                offset: Offset(2, 4),
                spreadRadius: 0,
              ),
            ],
          ),
          child: Text(
            'Login',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 45,
              fontFamily: 'Raleway',
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
