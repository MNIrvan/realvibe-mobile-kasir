import 'package:flutter/material.dart';
import 'dart:async';

class DashboardCS extends StatefulWidget {
  @override
  _DashboardCSState createState() => _DashboardCSState();
}

class _DashboardCSState extends State<DashboardCS> {
  final PageController _bannerController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    // Auto-scroll banner logic
    Timer.periodic(Duration(seconds: 3), (Timer timer) {
      if (_currentPage < 2) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _bannerController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 350),
        curve: Curves.easeIn,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                _buildSearchBar(),
                _buildBanner(),
                _buildCategories(),
                _buildTopMenu(),
                SizedBox(height: 100), // Spacer agar konten tidak tertutup nav
              ],
            ),
          ),
          // Floating WhatsApp
          Positioned(
            bottom: 100,
            left: 20,
            child: FloatingActionButton(
              backgroundColor: Colors.green,
              onPressed: () {
                // Implementasi url_launcher untuk buka WA
              },
              child: Icon(Icons.chat_bubble, color: Colors.white),
            ),
          ),
          // Floating Bottom Nav
          Align(
            alignment: Alignment.bottomCenter,
            child: _buildFloatingBottomNav(),
          ),
        ],
      ),
    );
  }

  // --- WIDGET HELPER ---

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 50, 20, 20),
      decoration: BoxDecoration(
        color: Color(0xFFC02700), // Warna oranye-merah sesuai desain
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(backgroundColor: Colors.white, child: Icon(Icons.person, color: Colors.grey)),
              SizedBox(width: 10),
              Text("Welcome, Customer", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ],
          ),
          Icon(Icons.shopping_cart, color: Colors.white),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: TextField(
        decoration: InputDecoration(
          hintText: "Telusuri disini",
          prefixIcon: Icon(Icons.menu),
          suffixIcon: Icon(Icons.search),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
          contentPadding: EdgeInsets.symmetric(vertical: 0),
        ),
      ),
    );
  }

  Widget _buildBanner() {
    return Container(
      height: 180,
      child: PageView(
        controller: _bannerController,
        children: [
          _bannerItem("Burgers Real 10% OFF"),
          _bannerItem("Spesial Promo Hari Ini"),
        ],
      ),
    );
  }

  Widget _bannerItem(String title) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.brown[800],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(child: Text(title, style: TextStyle(color: Colors.white, fontSize: 20))),
    );
  }

  Widget _buildFloatingBottomNav() {
    return Container(
      margin: EdgeInsets.all(20),
      padding: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navItem(Icons.restaurant, "Menu"),
          _navItem(Icons.train, "Jadwal Kereta"),
          _navItem(Icons.assignment, "Reservasi"),
        ],
      ),
    );
  }

  Widget _navItem(IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.brown),
        Text(label, style: TextStyle(fontSize: 12)),
      ],
    );
  }

}