import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

void main() => runApp(const MaterialApp(home: RevenueDashboard()));

class RevenueDashboard extends StatelessWidget {
  const RevenueDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7EFE5), // Warna background krem
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: Container(
          color: const Color(0xFFA62A1B), // Warna merah marun
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          alignment: Alignment.bottomCenter,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Pendapatan',
                    style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      children: [
                        CircleAvatar(radius: 4, backgroundColor: Colors.orange),
                        SizedBox(width: 4),
                        Text('Adinda dian', style: TextStyle(fontSize: 10)),
                      ],
                    ),
                  )
                ],
              ),
              const Text(
                'Real-Vibe',
                style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
              )
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // SISI KIRI (Statistik & Grafik)
            Expanded(
              flex: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDateHeader(),
                  const SizedBox(height: 16),
                  _buildStatCards(),
                  const SizedBox(height: 20),
                  _buildGraphSection(),
                ],
              ),
            ),
            const SizedBox(width: 20),
            // SISI KANAN (Action Buttons & Pesanan)
            Expanded(
              flex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildActionButtons(),
                  const SizedBox(height: 20),
                  const Text('Pesanan Masuk', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  _buildOrderCard("#RV-001", "Budi Haryono", "Rp 60.000"),
                  const SizedBox(height: 12),
                  _buildOrderCard("#RV-002", "Budi Hariyadi", "Rp 30.000"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget Header Tanggal
  Widget _buildDateHeader() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFA62A1B),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Row(
        children: [
          Icon(Icons.calendar_today, color: Colors.white),
          SizedBox(width: 10),
          Text('30 Maret 2026', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  // Widget Kartu Total
  Widget _buildStatCards() {
    return Row(
      children: [
        _statItem("Total Pendapatan", "Rp 23.000"),
        const SizedBox(width: 12),
        _statItem("Total Transaksi", "2"),
      ],
    );
  }

  Widget _statItem(String title, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF632117), // Warna cokelat tua kartu
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(color: Colors.white70, fontSize: 12)),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  // Widget Grafik
  Widget _buildGraphSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFA62A1B)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          const Text('Grafik Pendapatan', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFA62A1B))),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: true, drawVerticalLine: false),
                titlesData: FlTitlesData(
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        List<String> years = ['2021', '2022', '2023', '2024', '2025'];
                        return Text(years[value.toInt()]);
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: const [FlSpot(0, 8), FlSpot(1, 18), FlSpot(2, 20), FlSpot(3, 33), FlSpot(4, 35)],
                    isCurved: true,
                    color: const Color(0xFFA62A1B),
                    barWidth: 4,
                    dotData: FlDotData(show: true),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget Action Buttons (Atas kanan)
  Widget _buildActionButtons() {
    return Wrap(
      spacing: 8,
      children: [
        _actionBtn(Icons.lock_open, "Buka Kasir"),
        _actionBtn(Icons.lock, "Tutup Kasir"),
        _actionBtn(Icons.inventory_2_outlined, "Produk"),
        _actionBtn(Icons.print, "Cetak"),
      ],
    );
  }

  Widget _actionBtn(IconData icon, String label) {
    return Chip(
      backgroundColor: Colors.grey[300],
      avatar: Icon(icon, size: 16),
      label: Text(label, style: const TextStyle(fontSize: 10)),
    );
  }

  // Widget Kartu Pesanan
  Widget _buildOrderCard(String id, String name, String total) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFD9D9D9),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(id, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const Row(
                children: [
                  Icon(Icons.access_time, color: Colors.red, size: 18),
                  SizedBox(width: 4),
                  Text("10.00", style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              )
            ],
          ),
          Text(name, style: const TextStyle(fontSize: 16)),
          const Divider(color: Colors.black54),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text("2x Mie Goreng"), Text("Rp 30.000")],
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text("1x Es Teh"), Text("Rp 5.000")],
          ),
          const SizedBox(height: 12),
          Text(total, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}