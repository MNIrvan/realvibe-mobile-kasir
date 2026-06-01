import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class CashierOrdersDashboard extends StatefulWidget {
  const CashierOrdersDashboard({super.key});

  @override
  State<CashierOrdersDashboard> createState() => _CashierOrdersDashboardState();
}

class _CashierOrdersDashboardState extends State<CashierOrdersDashboard> {
  static const Color primaryMaroon = Color(0xFFA62A1B);
  static const Color darkCard = Color(0xFF632117);
  static const Color bgKrem = Color(0xFFF7EFE5);

  Timer? _timer;

  // Data pesanan simulasi dari web (1800 detik = 30 menit)
  List<Map<String, dynamic>> incomingOrders = [
    {
      "id": "#RV-001",
      "name": "Budi Haryono",
      "total": 60000,
      "items": [
        {"name": "2x Mie Goreng", "price": "Rp 30.000"},
        {"name": "1x Es Teh", "price": "Rp 5.000"}
      ],
      "timeRemaining": 1800, 
    },
    {
      "id": "#RV-002",
      "name": "Siti Aminah",
      "total": 20000,
      "items": [
        {"name": "2x Tahu Crispy", "price": "Rp 20.000"}
      ],
      "timeRemaining": 60, // Sisa 1 menit (untuk testing hilang otomatis)
    }
  ];

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        // Hapus otomatis pesanan yang waktunya habis (0 detik)
        incomingOrders.removeWhere((order) => order['timeRemaining'] <= 0);
        
        // Kurangi waktu untuk pesanan yang masih ada
        for (var order in incomingOrders) {
          if (order['timeRemaining'] > 0) {
            order['timeRemaining']--;
          }
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // --- FUNGSI FORMAT WAKTU ---
  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  // --- LOGIKA KASIR (POS) & PEMBAYARAN ---
  void _tampilkanModalPembayaran(Map<String, dynamic> orderDetails) {
    TextEditingController uangMasukController = TextEditingController();
    int grandTotal = orderDetails['total'] ?? 0;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            int uangMasuk = int.tryParse(uangMasukController.text.replaceAll('.', '')) ?? 0;
            int kembalian = uangMasuk - grandTotal;

            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: const Text("Proses Pembayaran", style: TextStyle(fontWeight: FontWeight.bold)),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Pesanan: ${orderDetails['id']} - ${orderDetails['name']}"),
                    const SizedBox(height: 10),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Grand Total", style: TextStyle(fontWeight: FontWeight.bold)),
                        Text("Rp $grandTotal", style: const TextStyle(fontWeight: FontWeight.bold, color: primaryMaroon, fontSize: 18)),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text("Uang Masuk (Rp)", style: TextStyle(fontSize: 12, color: Colors.grey)),
                    TextField(
                      controller: uangMasukController,
                      keyboardType: TextInputType.number,
                      onChanged: (val) {
                        setModalState(() {});
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Kembalian"),
                        Text(
                          kembalian < 0 ? "Uang Kurang!" : "Rp $kembalian",
                          style: TextStyle(
                            fontWeight: FontWeight.bold, 
                            color: kembalian < 0 ? Colors.red : Colors.green,
                            fontSize: 16
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Batal", style: TextStyle(color: Colors.grey)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: primaryMaroon, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                  onPressed: kembalian < 0 ? null : () {
                    // Berhasil dibayar, hapus dari antrean
                    setState(() {
                      incomingOrders.removeWhere((o) => o['id'] == orderDetails['id']);
                    });
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Pembayaran Berhasil!")));
                  },
                  child: const Text("Selesaikan Pembayaran"),
                ),
              ],
            );
          }
        );
      }
    );
  }

  void _tolakPesanan(String id) {
    setState(() {
      incomingOrders.removeWhere((order) => order['id'] == id);
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Pesanan $id ditolak.")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgKrem,
      appBar: _buildModernAppBar(),
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isMobile = constraints.maxWidth < 800;
          return AnimationLimiter(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: isMobile 
                ? Column(children: _buildContent(context)) 
                : Row(
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
                  const Text('Pendapatan', style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white30)),
                    child: Row(
                      children: const [
                        CircleAvatar(radius: 4, backgroundColor: Colors.orangeAccent),
                        SizedBox(width: 6),
                        Text('Kasir Aktif', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500)),
                      ],
                    ),
                  )
                ],
              ),
              const Text('Real-Vibe', style: TextStyle(color: Colors.white24, fontSize: 28, fontWeight: FontWeight.w900, fontStyle: FontStyle.italic))
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildContent(BuildContext context) {
    return [..._buildLeftSection(), const SizedBox(height: 25), ..._buildRightSection()];
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
        child: Text('Antrean Pesanan Web', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: darkCard)),
      )),
      const SizedBox(height: 15),
      if (incomingOrders.isEmpty)
        _animateWidget(const Padding(
          padding: EdgeInsets.all(20),
          child: Text("Tidak ada pesanan masuk.", style: TextStyle(color: Colors.grey)),
        )),
      ...incomingOrders.map((order) => _animateWidget(_buildOrderCard(order))).toList(),
    ];
  }

  Widget _buildDateHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [primaryMaroon, darkCard]),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: primaryMaroon.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: Row(
        children: const [
          Icon(Icons.calendar_month_rounded, color: Colors.white),
          SizedBox(width: 15),
          Text('Hari Ini', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildStatCards() {
    return Row(
      children: [
        _statItem("Total Pendapatan", "Rp 80.000", Icons.payments_outlined),
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
      ),
      child: const Center(child: Text("Grafik Pendapatan", style: TextStyle(color: Colors.grey))),
    );
  }

  Widget _buildActionButtons() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        _actionBtn(Icons.add_shopping_cart, "Buka POS (Kasir)", Colors.green, () {
          // Navigasi ke halaman POS atau show POS modal
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Fitur POS akan dibuka.")));
        }),
        _actionBtn(Icons.print_rounded, "Cetak Laporan", Colors.orange, () {}),
      ],
    );
  }

  Widget _actionBtn(IconData icon, String label, Color color, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
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

  Widget _buildOrderCard(Map<String, dynamic> order) {
    bool isWarning = order['timeRemaining'] < 300; // Kurang dari 5 menit warning

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
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
              Text(order['id'], style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: primaryMaroon)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isWarning ? Colors.red[50] : Colors.orange[50], 
                  borderRadius: BorderRadius.circular(8)
                ),
                child: Row(
                  children: [
                    Icon(Icons.timer_outlined, color: isWarning ? Colors.red : Colors.orange, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      _formatTime(order['timeRemaining']), 
                      style: TextStyle(color: isWarning ? Colors.red : Colors.orange, fontWeight: FontWeight.bold, fontSize: 12)
                    ),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 5),
          Text(order['name'], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Divider(height: 1)),
          
          ...List<Widget>.from(order['items'].map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(item['name'], style: const TextStyle(color: Colors.black87)),
                Text(item['price'], style: const TextStyle(color: Colors.black54, fontSize: 13)),
              ],
            ),
          ))),

          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Total Bayar", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
              Text("Rp ${order['total']}", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: darkCard)),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[50],
                    foregroundColor: Colors.red,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
                  ),
                  onPressed: () => _tolakPesanan(order['id']),
                  child: const Text("Tolak"),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
                  ),
                  onPressed: () => _tampilkanModalPembayaran(order),
                  child: const Text("Terima & Bayar"),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _animateWidget(Widget child) {
    return AnimationConfiguration.staggeredList(
      position: 0,
      duration: const Duration(milliseconds: 600),
      child: SlideAnimation(verticalOffset: 30.0, child: FadeInAnimation(child: child)),
    );
  }
}
