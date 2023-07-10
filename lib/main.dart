import 'package:flutter/material.dart';
import 'package:postman_app/provider/loginprovider.dart';
import 'package:postman_app/screens/get_books.dart';
import 'package:postman_app/screens/splash.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  Future<bool> checkLoginStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userId = prefs.getString('userId');
    final String? username = prefs.getString('username');
    final String? email = prefs.getString('email');
    print(userId.toString());
    print(username.toString());
    //print(email.toString());
    return userId != null && username != null;
  }

  @override
  Widget build(BuildContext context) {

    return FutureBuilder<bool>(
      future: checkLoginStatus(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else {
          final bool isLoggedIn = snapshot.data ?? false;

          print(isLoggedIn.toString());
          return MultiProvider(
            providers: [
              ChangeNotifierProvider<AuthProvider>(
                create: (_) => AuthProvider(),
              ),
            ],
            child: MaterialApp(
              title: 'Books Library',
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                primarySwatch: Colors.blue,
              ),
              home: isLoggedIn ? const GetBooks() : const SplashScreen(),
            ),
          );
        }
      },
    );
  }
}

