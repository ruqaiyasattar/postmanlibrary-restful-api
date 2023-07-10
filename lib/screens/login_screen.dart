import 'package:flutter/material.dart';
import 'package:postman_app/provider/loginprovider.dart';
import 'package:postman_app/screens/get_books.dart';
import 'package:postman_app/util/toast.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {

  LoginScreen({
    super.key,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();

}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController _usernameController = TextEditingController();

  late TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
   _passwordController = TextEditingController();
   _usernameController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _usernameController.clear();
    _passwordController.clear();
    super.dispose();
  }

  void _login(BuildContext context) {
    final String username = _usernameController.text;
    final String password = _passwordController.text;

    final AuthProvider authProvider =
    Provider.of<AuthProvider>(context, listen: false);
    authProvider.login(username, password);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                  labelText: 'Username',
              ),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 16.0),
            Consumer<AuthProvider>(
              builder: (context, authProvider, _) {
                return ElevatedButton(
                  onPressed: authProvider.isLoading
                      ? null
                      : () {
                    if(_usernameController.text.isNotEmpty && _passwordController.text.isNotEmpty) {
                      _login(context);
                      Navigator.push(
                        context, MaterialPageRoute(builder: (
                          context) => const GetBooks()),
                      );
                    } else {
                      toast("one or both field are empty");
                    }
                    },
                  child: authProvider.isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Login'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
