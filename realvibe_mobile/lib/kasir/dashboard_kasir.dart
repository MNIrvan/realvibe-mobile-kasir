import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class RevenueDashboard extends StatelessWidget {
  const RevenueDashboard({super.key});

  // Konstanta Warna untuk konsistensi UI/UX
  static const Color primaryMaroon = Color(0xFFA62A1B);
  static const Color darkCard = Color(0xFF632117);
  static const Color bgKrem = Color(0xFFF7EFE5);

  @override
  Widget build(BuildContext context) {
    // Menggunakan LayoutBuilder agar responsif
    return Scaffold(
      backgroundColor: bgKrem,
      appBar: _buildModernAppBar(),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Cek jika layar lebar (Tablet/Desktop mode) atau sempit (Mobile)
          bool isMobile = constraints.maxWidth < 800;

          return AnimationLimiter(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: isMobile 
                ? Column(children: _buildContent(context)) // Tampilan tumpuk untuk HP
                : Row( // Tampilan samping untuk Tablet/Web
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 5, child: Column(children: _buildLeftSection())),
                      const SizedBox(width: 25),
                      Expanded(flex: 4, child: Column(children: _buildRightSection())),
                    ],
                  ),
            ),
          );
        },
      ),
    );
  }

  // --- APPBAR MODERN ---
  PreferredSizeWidget _buildModernAppBar() {
    return AppBar(
      elevation: 0,
      toolbarHeight: 100,
      backgroundColor: primaryMaroon,
      flexibleSpace: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Pendapatan',
                    style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  _buildUserBadge('Adinda dian'),
                ],
              ),
              const Text(
                'Real-Vibe',
                style: TextStyle(color: Colors.white24, fontSize: 28, fontWeight: FontWeight.w900, fontStyle: FontStyle.italic),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserBadge(String name) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white30),
      ),
      child: Row(
        children: [
          const CircleAvatar(radius: 4, backgroundColor: Colors.orangeAccent),
          const SizedBox(width: 6),
          Text(name, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  // --- LOGIC TATA LETAK ---
  List<Widget> _buildContent(BuildContext context) {
    return [
      ..._buildLeftSection(),
      const SizedBox(height: 25),
      ..._buildRightSection(),
    ];
  }

  List<Widget> _buildLeftSection() {
    return [
      _animateWidget(_buildDateHeader()),
      const SizedBox(height: 20),
      _animateWidget(_buildStatCards()),
      const SizedBox(height: 25),
      _animateWidget(_buildGraphSection()),
    ];
  }

  List<Widget> _buildRightSection() {
    return [
      _animateWidget(_buildActionButtons()),
      const SizedBox(height: 30),
      _animateWidget(const Align(
        alignment: Alignment.centerLeft,
        child: Text('Pesanan Masuk', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: darkCard)),
      )),
      const SizedBox(height: 15),
      _animateWidget(_buildOrderCard("#RV-001", "Budi Haryono", "Rp 60.000")),
      const SizedBox(height: 15),
      _animateWidget(_buildOrderCard("#RV-002", "Budi Hariyadi", "Rp 30.000")),
    ];
  }

  // --- WIDGET KOMPONEN ---

  Widget _buildDateHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [primaryMaroon, darkCard]),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: primaryMaroon.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: const Row(
        children: [
          Icon(Icons.calendar_month_rounded, color: Colors.white),
          SizedBox(width: 15),
          Text('30 Maret 2026', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildStatCards() {
    return Row(
      children: [
        _statItem("Total Pendapatan", "Rp 23.000", Icons.payments_outlined),
        const SizedBox(width: 15),
        _statItem("Total Transaksi", "2", Icons.shopping_bag_outlined),
      ],
    );
  }

  Widget _statItem(String title, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: darkCard,
          borderRadius: BorderRadius.circular(18),
          image: DecorationImage(
            image: const NetworkImage('https://www.transparenttextures.com/patterns/carbon-fibre.png'),
            opacity: 0.05,
            repeat: ImageRepeat.repeat,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.white54, size: 20),
            const SizedBox(height: 12),
            Text(title, style: const TextStyle(color: Colors.white70, fontSize: 13)),
            const SizedBox(height: 5),
            Text(value, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildGraphSection() {
    return Container(
      height: 300,
      padding: const EdgeInsets.fromLTRB(10, 20, 20, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: Column(
        children: [
          const Text('Trend Pendapatan Mingguan', style: TextStyle(fontWeight: FontWeight.bold, color: primaryMaroon)),
          const SizedBox(height: 25),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: true, drawVerticalLine: false, getDrawingHorizontalLine: (value) => FlLine(color: Colors.grey.withOpacity(0.1), strokeWidth: 1)),
                titlesData: FlTitlesData(
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 30, getTitlesWidget: (value, meta) {
                    const days = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum'];
                    return Text(days[value.toInt() % 5], style: const TextStyle(color: Colors.grey, fontSize: 12));
                  })),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: [const FlSpot(0, 3), const FlSpot(1, 1.5), const FlSpot(2, 5), const FlSpot(3, 2.5), const FlSpot(4, 4)],
                    isCurved: true,
                    gradient: const LinearGradient(colors: [primaryMaroon, Colors.orange]),
                    barWidth: 5,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(show: true, gradient: LinearGradient(colors: [primaryMaroon.withOpacity(0.2), primaryMaroon.withOpacity(0)])),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        _actionBtn(Icons.add_shopping_cart, "Buka Kasir", Colors.green),
        _actionBtn(Icons.no_meals, "Tutup Kasir", Colors.redAccent),
        _actionBtn(Icons.inventory, "Produk", Colors.blueAccent),
        _actionBtn(Icons.print_rounded, "Cetak", Colors.orange),
      ],
    );
  }

  Widget _actionBtn(IconData icon, String label, Color color) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withOpacity(0.5)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 18, color: color),
              const SizedBox(width: 8),
              Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderCard(String id, String name, String total) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 5))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(id, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: primaryMaroon)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: Colors.red[50], borderRadius: BorderRadius.circular(8)),
                child: Row(
                  children: const [
                    Icon(Icons.timer_outlined, color: Colors.red, size: 14),
                    SizedBox(width: 4),
                    Text("10.00", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 12)),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 5),
          Text(name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1),
          ),
          _orderRow("2x Mie Goreng", "Rp 30.000"),
          _orderRow("1x Es Teh", "Rp 5.000"),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Total", style: TextStyle(color: Colors.grey)),
              Text(total, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: darkCard)),
            ],
          ),
        ],
      ),
    );
  }
  Widget _orderRow(String item, String price) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(item, style: const TextStyle(color: Colors.black87)),
          Text(price, style: const TextStyle(color: Colors.black54, fontSize: 13)),
        ],
      ),
    );
  }
  // Helper untuk animasi masuk
  Widget _animateWidget(Widget child) {
    return AnimationConfiguration.staggeredList(
      position: 0,
      duration: const Duration(milliseconds: 600),
      child: SlideAnimation(
        verticalOffset: 30.0,
        child: FadeInAnimation(child: child),
      ),
    );
  }
}