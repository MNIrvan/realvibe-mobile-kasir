import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Real-Vibe Login',
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
  final Color _textColor = const Color(0xFF8B4513); // Coklat Real-Vibe
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
      
      print('Mencoba login dengan: $username');
      
      // Tampilkan notifikasi sederhana
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Mencoba Login sebagai $username...')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Menggunakan LayoutBuilder agar responsif (misal di web vs mobile)
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Tampilan Desktop/Tablet (Dua Kolom)
          if (constraints.maxWidth > 800) {
            return _buildDesktopLayout();
          } 
          // Tampilan Mobile (Satu Kolom bertumpuk)
          else {
            return _buildMobileLayout();
          }
        },
      ),
    );
  }

  // --- Layout Desktop (Dua Kolom) ---
  Widget _buildDesktopLayout() {
    return Container(
      // -- Ganti dengan kode ini jika Anda memiliki gambar latar belakang: --
      // decoration: const BoxDecoration(
      //   image: DecorationImage(
      //     image: AssetImage('assets/bg_pattern.png'), // Pastikan file ada di assets
      //     fit: BoxFit.cover,
      //     opacity: 0.5, // Mengatur transparansi pola agar tidak terlalu mencolok
      //   ),
      // ),
      // -----------------------------------------------------------------
      child: Center(
        child: SingleChildScrollView( // Agar bisa di-scroll jika layar pendek
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Kolom Kiri: Sambutan dan Logo
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(60.0),
                  child: _buildWelcomeColumn(),
                ),
              ),
              
              // Kolom Kanan: Form Login
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(60.0),
                  child: _buildLoginFormColumn(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- Layout Mobile (Satu Kolom) ---
  Widget _buildMobileLayout() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
      child: Column(
        children: [
          _buildWelcomeColumn(),
          const SizedBox(height: 50),
          _buildLoginFormColumn(),
        ],
      ),
    );
  }

  // --- Sub-Widget: Kolom Kiri (Logo & Sambutan) ---
  Widget _buildWelcomeColumn() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // --- TEMPAT LOGO (RANDOM) --- 
        Image.asset('assets/icon/icon-realvibe.png', height: 250),

        const SizedBox(height: 40),
        
        // Judul Besar
        Text(
          'Selamat Datang',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: _textColor,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 15),
        
        // Deskripsi Kecil
        Text(
          'Real Cafe Jatiroto\n'
          'Temukan setiap sudut, setiap cita,\n dan cerita yang menunggu untuk kamu rasakan.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: _textColor,
            fontSize: 14,
            height: 1.5, // Spasi antar baris
          ),
        ),
      ],
    );
  }

  // --- Sub-Widget: Kolom Kanan (Form Login) ---
  Widget _buildLoginFormColumn() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon User Besar
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.black12,
            child: Icon(Icons.person, size: 70, color: _textColor),
          ),
          const SizedBox(height: 20),
          
          // Judul Form
          Text(
            'Login Kasir',
            style: TextStyle(
              color: _textColor,
              fontSize: 26,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          
          // Sub-judul Form
          Text(
            'Silahkan masukkan Username dan Password Anda',
            style: TextStyle(
              color: _textColor.withOpacity(0.8),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 30),
          
          // Field Username
          _buildTextField(
            controller: _usernameController,
            hintText: 'Username',
            icon: Icons.person_outline,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Username tidak boleh kosong';
              }
              return null;
            },
          ),
          
          const SizedBox(height: 15),
          
          // Field Password
          _buildTextField(
            controller: _passwordController,
            hintText: 'Password',
            icon: Icons.lock_outline,
            isPassword: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Password tidak boleh kosong';
              }
              if (value.length < 6) {
                return 'Password minimal 6 karakter';
              }
              return null;
            },
          ),
          
          const SizedBox(height: 30),
          
          // Tombol Login
          SizedBox(
            width: 150, // Lebar tombol disesuaikan
            height: 50,
            child: ElevatedButton(
              onPressed: _handleLogin,
              style: ElevatedButton.styleFrom(
                backgroundColor: _buttonColor,
                foregroundColor: _textColor, // Warna teks tombol
                elevation: 0, // Matikan bayangan agar flat seperti desain
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Login',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- Helper: Widget Pembuat Text Field ---
  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool isPassword = false,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          // Sedikit bayangan lembut agar pop-up
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        style: TextStyle(color: _textColor),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: _textColor.withOpacity(0.5)),
          prefixIcon: Icon(icon, color: _textColor.withOpacity(0.7)),
          // Hilangkan border bawaan karena sudah pakai container decoration
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
        validator: validator,
      ),
    );
  }
}