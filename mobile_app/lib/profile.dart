import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'user_provider.dart';
import 'login_page.dart';
import 'custom_navigation_bar.dart';

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

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: 390,
              height: 839,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(color: Color(0xFFF5F5F5)),
              child: Stack(
                children: [
                  Positioned(
                    left: 0,
                    top: 0,
                    child: Container(
                      width: 390,
                      padding: const EdgeInsets.only(
                        top: 42,
                        left: 12,
                        right: 20,
                        bottom: 16,
                      ),
                      decoration: ShapeDecoration(
                        color: Color(0xFF9AD4A6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image:
                                    AssetImage("assets/images/left_icon.png"),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(right: 104),
                            child: Text(
                              'Profile',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 25,
                                fontFamily: 'Raleway',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          SizedBox(
                              width: 28), // Placeholder to balance the space
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 14,
                    top: 120,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage:
                              AssetImage('assets/images/profile_icon.png'),
                        ),
                        SizedBox(height: 20),
                        Text(
                          userProvider.name,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                  Positioned(
                    left: 14,
                    top: 240,
                    right: 14,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 30),
                        Divider(),
                        ListTile(
                          leading: Icon(Icons.email),
                          title: Text('Email'),
                          subtitle: Text(userProvider.email),
                        ),
                        ListTile(
                          leading: Icon(Icons.verified_user),
                          title: Text('Status'),
                          subtitle: Text(userProvider.status),
                        ),
                        SizedBox(height: 30),
                        Text(
                          'Pengaturan Akun',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Divider(),
                        ListTile(
                          leading: Icon(Icons.lock),
                          title: Text('Ubah Kata Sandi'),
                          onTap: () {
                            // Tambahkan fungsi untuk mengubah kata sandi
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.logout),
                          title: Text('Keluar'),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Are you sure?'),
                                  content: Text('Do you want to log out?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('No'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        final userProvider =
                                            Provider.of<UserProvider>(context,
                                                listen: false);
                                        userProvider.clearUser();
                                        Navigator.of(context).pop();
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                LogInPage(),
                                          ),
                                        );
                                      },
                                      child: Text('Yes'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
