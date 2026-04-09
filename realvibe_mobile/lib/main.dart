import 'package:flutter/material.dart';

import 'login/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RealVibe Login',
      theme: ThemeData(
        // Palet warna dasar
        scaffoldBackgroundColor: const Color(0xFFF9F1EB), // Krem pucat (latar belakang)
        primaryColor: const Color(0xFF8B4513), // Cokelat (teks utama)
        useMaterial3: true,
      ),
      home: const LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // GlobalKey untuk validasi form
  final _formKey = GlobalKey<FormState>();

  // Controller untuk mengambil teks
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  // Warna-warna kustom berdasarkan desain
  final Color _textColor = const Color(0xFF8B4513); // Coklat RealVibe
  final Color _buttonColor = const Color(0xFFF0C4C1); // Pink pudar tombol

  @override
  void dispose() {
    // Selalu dispose controller untuk menghindari memory leak
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    // Validasi form sebelum proses
    if (_formKey.currentState!.validate()) {
      // Jika valid, lakukan logika login di sini
      String username = _usernameController.text;
      String password = _passwordController.text;

      if(username == 'admin' && password == 'password123') {
        // Jika login sukses
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DashboardPage()),
        );
      } else {
        // Jika login gagal
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login Gagal: Username atau Password salah'),
          backgroundColor: Colors.red,
          ),
        );
      }

      print('Mencoba login dengan: $username');

      // Tampilkan notifikasi sederhana
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Mencoba Login sebagai $username...')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F1EB), // Latar belakang krem
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo atau ikon
                Icon(
                  Icons.coffee,
                  size: 100,
                  color: _textColor,
                ),
                const SizedBox(height: 20),

                // Judul
                Text(
                  'RealVibe Cafe',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: _textColor,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Login ke Sistem Kasir',
                  style: TextStyle(
                    fontSize: 16,
                    color: _textColor.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 40),

                // Field Username
                TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    labelStyle: TextStyle(color: _textColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: _textColor),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Username tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Field Password
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(color: _textColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: _textColor),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),

                // Tombol Login
                ElevatedButton(
                  onPressed: _handleLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _buttonColor,
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 18,
                      color: _textColor,
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
}

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Kasir'),
        backgroundColor: const Color(0xFFF0C4C1),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // Fungsi Logout: kembali ke halaman login
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle_outline, size: 100, color: Colors.green),
            const SizedBox(height: 20),
            Text(
              'Login Berhasil!',
              style: TextStyle(fontSize: 24, color: Color(0xFF8B4513)),
            ),
            const Text('Selamat datang di sistem kasir Real Cafe.'),
          ],
        ),
      ),
    );
  }
}
}
=======
      home: const LoginPage(),
    );
  }
>>>>>>> 5bcfad15d41d5a6abae272bcb25d51eaca016720
}