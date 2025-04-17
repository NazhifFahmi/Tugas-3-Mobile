import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade800, Colors.blueAccent.shade400],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo/Header Section
                Container(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Icon(
                        Icons.account_circle,
                        size: 80,
                        color: Colors.white,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Welcome Back',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Sign in to continue',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40),
                
                // Login Card
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ), // Fixed missing closing parenthesis here
                  elevation: 8,
                  shadowColor: Colors.black.withOpacity(0.2),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        // Username Field
                        TextField(
                          controller: _usernameController,
                          decoration: InputDecoration(
                            labelText: 'Username',
                            prefixIcon: Icon(Icons.person_outline),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.grey.withOpacity(0.1),
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 16, horizontal: 16),
                          ),
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 20),
                        
                        // Password Field
                        TextField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            prefixIcon: Icon(Icons.lock_outline),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.grey.withOpacity(0.1),
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 16, horizontal: 16),
                          ),
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 24),
                        
                        // Login Button
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: _isLoading
                              ? Center(child: CircularProgressIndicator())
                              : ElevatedButton(
                                  onPressed: _login,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue.shade700,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 2,
                                    padding: EdgeInsets.symmetric(vertical: 14),
                                  ),
                                  child: Text(
                                    'LOGIN',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
                
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _login() async {
    if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Username dan password harus diisi'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: Colors.red.shade400,
        ),
      );
      return;
    }

    if (_usernameController.text != 'admin' || _passwordController.text != 'password') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Username atau password salah'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: Colors.red.shade400,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulasi proses login
    await Future.delayed(Duration(seconds: 2));

    // Simpan status login ke shared preferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('username', _usernameController.text);

    setState(() {
      _isLoading = false;
    });

    // Navigasi ke halaman utama
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
  }
}