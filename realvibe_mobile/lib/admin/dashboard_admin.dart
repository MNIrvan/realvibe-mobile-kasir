import 'package:flutter/material.dart';

import '../admin/feature/kereta/kereta_page.dart';
import '../admin/feature/masukan/masukan_page.dart';
import '../admin/feature/menu/menu_page.dart';
import '../admin/feature/informasi/informasi_page.dart';
import '../admin/feature/laporan/laporan_page.dart';
import '../admin/feature/users/users_page.dart';
import '../dashboard/dashboard_section.dart';
import '../dashboard/widgets/dashboard_sidebar.dart';
import '../dashboard/widgets/revenue_chart.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  bool isSidebarExpanded = true;
  DashboardSection selectedSection = DashboardSection.dashboard;
  final GlobalKey _trendingKey = GlobalKey();
  double? _trendingHeight;

  void toggleSidebar() {
    setState(() {
      isSidebarExpanded = !isSidebarExpanded;
    });
  }

  void handleSectionSelect(DashboardSection section) {
    setState(() {
      selectedSection = section;
    });
  }

  void _updateTrendingHeight() {
    final context = _trendingKey.currentContext;
    if (context == null) return;
    final box = context.findRenderObject() as RenderBox?;
    if (box == null) return;
    final newHeight = box.size.height;
    if (_trendingHeight == null ||
        (newHeight - _trendingHeight!).abs() > 1) {
      setState(() {
        _trendingHeight = newHeight;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 900;
    final sidebarWidth = isSidebarExpanded ? 260.0 : 80.0;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _updateTrendingHeight();
    });

    return Scaffold(
      backgroundColor: const Color(0xFFFCF5ED),
      drawer: isMobile
          ? Drawer(
              child: DashboardSidebar(
                isCollapsed: false,
                onToggle: toggleSidebar,
                selectedSection: selectedSection,
                onSelect: handleSectionSelect,
              ),
            )
          : null,
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isMobile)
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: sidebarWidth,
                decoration: const BoxDecoration(color: Color(0xFFB11D1D)),
                child: DashboardSidebar(
                  isCollapsed: !isSidebarExpanded,
                  onToggle: toggleSidebar,
                  selectedSection: selectedSection,
                  onSelect: handleSectionSelect,
                ),
              ),
            Expanded(
              child: _DashboardBody(
                isMobile: isMobile,
                screenWidth: screenWidth,
                theme: theme,
                selectedSection: selectedSection,
                onOpenDrawer: () => Scaffold.of(context).openDrawer(),
                trendingKey: _trendingKey,
                trendingHeight: _trendingHeight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardBody extends StatelessWidget {
  const _DashboardBody({
    required this.isMobile,
    required this.screenWidth,
    required this.theme,
    required this.selectedSection,
    required this.onOpenDrawer,
    required this.trendingKey,
    required this.trendingHeight,
  });

  final bool isMobile;
  final double screenWidth;
  final ThemeData theme;
  final DashboardSection selectedSection;
  final VoidCallback onOpenDrawer;
  final GlobalKey trendingKey;
  final double? trendingHeight;

  @override
  Widget build(BuildContext context) {
    if (selectedSection == DashboardSection.menu) {
      return MenuPage(isMobile: isMobile);
    }
    if (selectedSection == DashboardSection.jadwal) {
      return KeretaPage(isMobile: isMobile);
    }
    if (selectedSection == DashboardSection.informasi) {
      return InformasiPage(isMobile: isMobile);
    }
    if (selectedSection == DashboardSection.masukan) {
      return MasukanPage(isMobile: isMobile);
    }
    if (selectedSection == DashboardSection.laporan) {
      return LaporanPage(isMobile: isMobile);
    }
    if (selectedSection == DashboardSection.users) {
      return UsersPage(isMobile: isMobile);
    }

    if (selectedSection != DashboardSection.dashboard) {
      return _ComingSoonSection(
        title: _sectionLabel(selectedSection),
        isMobile: isMobile,
        onOpenDrawer: onOpenDrawer,
      );
    }

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 24,
        vertical: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isMobile)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.menu,
                      color: Colors.black87,
                    ),
                    onPressed: onOpenDrawer,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Real-Vibe Admin',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 20,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(13),
                  blurRadius: 24,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        'Welcome Admin !',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF2A1E1A),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: SizedBox(
                          width: isMobile ? screenWidth * 0.55 : 420,
                          child: TextField(
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 14,
                                horizontal: 18,
                              ),
                              hintText: 'Telusuri disini',
                              hintStyle: const TextStyle(
                                color: Color(0xFF8A8A8A),
                              ),
                              prefixIcon: const Icon(
                                Icons.menu,
                                color: Color(0xFF8A8A8A),
                              ),
                              suffixIcon: const Icon(
                                Icons.search,
                                color: Color(0xFF8A8A8A),
                              ),
                              filled: true,
                              fillColor: const Color(0xFFF5F1EE),
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _DashboardSummaryPanel(isMobile: isMobile),
          const SizedBox(height: 24),
          Flex(
            direction: isMobile ? Axis.vertical : Axis.horizontal,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Flexible(
                flex: 2,
                fit: FlexFit.loose,
                child: Column(
                  children: [
                    _ChartCard(isMobile: isMobile),
                    const SizedBox(height: 16),
                    _NotificationCard(isMobile: isMobile),
                  ],
                ),
              ),
              SizedBox(
                width: isMobile ? 0 : 20,
                height: isMobile ? 20 : 0,
              ),
              Flexible(
                fit: FlexFit.loose,
                child: Column(
                  children: [
                              _TrendingCard(isMobile: isMobile, key: trendingKey),
                              const SizedBox(height: 16),
                              _BestSellerCard(isMobile: isMobile),
                            ],
                          ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ComingSoonSection extends StatelessWidget {
  const _ComingSoonSection({
    required this.title,
    required this.isMobile,
    required this.onOpenDrawer,
  });

  final String title;
  final bool isMobile;
  final VoidCallback onOpenDrawer;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 24,
        vertical: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isMobile)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.menu, color: Colors.black87),
                    onPressed: onOpenDrawer,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Real-Vibe Admin',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Color(0xFF2A1E1A),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Halaman ini masih dalam pengembangan.',
            style: TextStyle(color: Color(0xFF7C6F6A)),
          ),
        ],
      ),
    );
  }
}

String _sectionLabel(DashboardSection section) {
  switch (section) {
    case DashboardSection.dashboard:
      return 'Dashboard';
    case DashboardSection.menu:
      return 'Menu';
    case DashboardSection.laporan:
      return 'Laporan';
    case DashboardSection.jadwal:
      return 'Jadwal Kereta';
    case DashboardSection.informasi:
      return 'Informasi';
    case DashboardSection.masukan:
      return 'Masukan';
    case DashboardSection.users:
      return 'Users';
  }
}

class _DashboardMetricCard extends StatelessWidget {
  const _DashboardMetricCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF8F1A1A),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(18),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 52,
            width: 52,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: const Color(0xFF8F1A1A), size: 26),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RevenueSummaryCard extends StatelessWidget {
  const _RevenueSummaryCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF9E2323), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(12),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.currency_exchange, color: Color(0xFF8F1A1A), size: 38),
          SizedBox(height: 8),
          Text(
            'Rp. 1.699.000',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Color(0xFF351B1B),
            ),
          ),
          SizedBox(height: 2),
          Text(
            'Total Pendapatan',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF8B8B8B),
            ),
          ),
        ],
      ),
    );
  }
}

class _DashboardSummaryPanel extends StatelessWidget {
  const _DashboardSummaryPanel({required this.isMobile});

  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    if (isMobile) {
      return Column(
        children: const [
          _DashboardMetricCard(
            icon: Icons.menu_book,
            label: 'Total Menu',
            value: '25',
          ),
          SizedBox(height: 12),
          _DashboardMetricCard(
            icon: Icons.shopping_cart_outlined,
            label: 'Total Penjualan',
            value: '450',
          ),
          SizedBox(height: 12),
          _RevenueSummaryCard(),
        ],
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF8EFE5),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE0C9BC)),
      ),
      child: Row(
        children: const [
          Expanded(
            child: _DashboardMetricCard(
              icon: Icons.menu_book,
              label: 'Total Menu',
              value: '25',
            ),
          ),
          SizedBox(width: 20),
          Expanded(
            child: _DashboardMetricCard(
              icon: Icons.shopping_cart_outlined,
              label: 'Total Penjualan',
              value: '450',
            ),
          ),
          SizedBox(width: 20),
          Expanded(child: _RevenueSummaryCard()),
        ],
      ),
    );
  }
}

class _MiniCalendarCard extends StatelessWidget {
  const _MiniCalendarCard();

  @override
  Widget build(BuildContext context) {
    const days = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
    final now = DateTime.now();
    final firstDay = DateTime(now.year, now.month, 1);
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    final leadingBlanks = firstDay.weekday % 7;
    final dates = [
      ...List<String>.filled(leadingBlanks, ''),
      ...List<String>.generate(daysInMonth, (i) => '${i + 1}'),
    ];
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE0D2C8)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                  color: const Color(0xFFF3E6DE),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.calendar_today,
                  color: Color(0xFF8F1A1A),
                  size: 16,
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${months[now.month - 1]} ${now.year}',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF3B1F1B),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Today: ${now.day} ${months[now.month - 1].substring(0, 3)}',
                    style: const TextStyle(
                      fontSize: 9,
                      color: Color(0xFF8F8079),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          LayoutBuilder(
            builder: (context, constraints) {
              final maxWidth = constraints.maxWidth;
              const gap = 4.0;
              final cellSize =
                  ((maxWidth - gap * 6) / 7).clamp(16.0, 24.0);
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: days
                        .map(
                          (d) => SizedBox(
                            width: cellSize,
                            child: Text(
                              d,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 9,
                                color: Color(0xFF8F8079),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 6),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 7,
                      crossAxisSpacing: gap,
                      mainAxisSpacing: gap,
                      childAspectRatio: 1,
                    ),
                    itemCount: dates.length,
                    itemBuilder: (context, index) {
                      final d = dates[index];
                      final isToday = d == '${now.day}';
                      return Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: d.isEmpty
                              ? Colors.transparent
                              : isToday
                                  ? const Color(0xFF8F1A1A)
                                  : const Color(0xFFF8EFE5),
                          borderRadius: BorderRadius.circular(cellSize / 2),
                        ),
                        child: Text(
                          d,
                          style: TextStyle(
                            fontSize: 9,
                            color: isToday
                                ? Colors.white
                                : const Color(0xFF6F6561),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}


class _ChartCard extends StatelessWidget {
  const _ChartCard({required this.isMobile});

  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFCBB5AC), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13), 
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Grafik Pendapatan',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF3A1F1B),
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(height: isMobile ? 260 : 300, child: const RevenueChart()),
        ],
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  const _NotificationCard({required this.isMobile});

  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF8EFE5),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFDBC0B6), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(
                Icons.notifications_active_outlined,
                color: Color(0xFF8F1A1A),
              ),
              SizedBox(width: 10),
              Text(
                'Notifikasi',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF3A1F1B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _NotificationEntry(
            text: 'Pelanggan baru saja mengirimkan masukan...',
            date: '31/3/2026',
          ),
          const SizedBox(height: 10),
          _NotificationEntry(
            text: 'Grafik pendapatan meningkat drastis',
            date: '2/4/2026',
          ),
          const SizedBox(height: 10),
          _NotificationEntry(
            text: 'Kasir baru saja menambahkan transaksi tunai',
            date: '5/4/2026',
          ),
          const SizedBox(height: 10),
          _NotificationEntry(
            text: 'Stok bahan baku kopi hampir habis',
            date: '7/4/2026',
          ),
        ],
      ),
    );
  }
}

class _NotificationEntry extends StatelessWidget {
  const _NotificationEntry({required this.text, required this.date});

  final String text;
  final String date;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 6),
          height: 6,
          width: 6,
          decoration: const BoxDecoration(
            color: Color(0xFF8F1A1A),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                text,
                style: const TextStyle(
                  fontSize: 13,
                  height: 1.5,
                  color: Color(0xFF3D3534),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                date,
                style: const TextStyle(fontSize: 12, color: Color(0xFF8F8A8A)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TrendingCard extends StatelessWidget {
  const _TrendingCard({required this.isMobile, super.key});

  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F2E9),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2D2C2), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Trending Menu Harian',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF3A1F1B),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            '3 Menu tertinggi',
            style: TextStyle(fontSize: 12, color: Color(0xFF8B8B8B)),
          ),
          const SizedBox(height: 18),
          const _TrendingItem(
            title: 'Burger',
            subtitle: 'Beef Burger',
            price: 'Rp. 10.000,00',
            imagePath: 'assets/images/menu1.png',
          ),
          const SizedBox(height: 14),
          const _TrendingItem(
            title: 'Es Teh',
            subtitle: 'Iced Tea',
            price: 'Rp. 5.000,00',
            imagePath: 'assets/images/menu3.png',
          ),
          const SizedBox(height: 14),
          const _TrendingItem(
            title: 'Tahu crispy',
            subtitle: 'Crispy Tofu',
            price: 'Rp. 15.000,00',
            imagePath: 'assets/images/menu5.png',
          ),
        ],
      ),
    );
  }
}

class _TrendingItem extends StatelessWidget {
  const _TrendingItem({
    required this.title,
    required this.subtitle,
    required this.price,
    required this.imagePath,
  });

  final String title;
  final String subtitle;
  final String price;
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFF7E2D9),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Padding(
              padding: const EdgeInsets.all(6),
              child: Image.asset(imagePath, fit: BoxFit.contain),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2F2A28),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF7F7A7A),
                  ),
                ),
              ],
            ),
          ),
          Text(
            price,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Color(0xFF8F1A1A),
            ),
          ),
        ],
      ),
    );
  }
}

class _BestSellerCard extends StatelessWidget {
  const _BestSellerCard({required this.isMobile});

  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 14),
            child: Row(
              children: const [
                Icon(
                  Icons.calendar_today,
                  color: Color(0xFF8F1A1A),
                  size: 18,
                ),
                SizedBox(width: 8),
                Text(
                  'Kalender',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF3A1F1B),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
            child: const Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: 260,
                child: _MiniCalendarCard(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}