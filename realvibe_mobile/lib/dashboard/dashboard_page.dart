import 'package:flutter/material.dart';

import 'widgets/dashboard_sidebar.dart';
import 'widgets/revenue_chart.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  bool isSidebarExpanded = true;

  void toggleSidebar() {
    setState(() {
      isSidebarExpanded = !isSidebarExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 900;
    final sidebarWidth = isSidebarExpanded ? 260.0 : 80.0;

    return Scaffold(
      backgroundColor: const Color(0xFFFCF5ED),
      drawer: isMobile
          ? Drawer(
              child: DashboardSidebar(
                isCollapsed: false,
                onToggle: toggleSidebar,
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
                ),
              ),
            Expanded(
              child: SingleChildScrollView(
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
                              onPressed: () =>
                                  Scaffold.of(context).openDrawer(),
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
                                  style: theme.textTheme.headlineSmall
                                      ?.copyWith(
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
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                              vertical: 14,
                                              horizontal: 18,
                                            ),
                                        hintText: 'Telusuri disini',
                                        hintStyle: const TextStyle(
                                          color: Color(0xFF8A8A8A),
                                        ),
                                        prefixIcon: const Icon(
                                          Icons.search,
                                          color: Color(0xFF8A8A8A),
                                        ),
                                        filled: true,
                                        fillColor: const Color(0xFFF5F1EE),
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius: BorderRadius.circular(
                                            14,
                                          ),
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
                    Wrap(
                      runSpacing: 16,
                      spacing: 16,
                      children: [
                        _DashboardMetricCard(
                          icon: Icons.menu_book,
                          label: 'Total Menu',
                          value: '25',
                          width: isMobile ? double.infinity : 200,
                        ),
                        _DashboardMetricCard(
                          icon: Icons.shopping_cart_outlined,
                          label: 'Total Penjualan',
                          value: '450',
                          width: isMobile ? double.infinity : 200,
                        ),
                        _RevenueSummaryCard(
                          width: isMobile ? double.infinity : 320,
                        ),
                      ],
                    ),
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
                              _TrendingCard(isMobile: isMobile),
                              const SizedBox(height: 16),
                              _BestSellerCard(isMobile: isMobile),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardMetricCard extends StatelessWidget {
  const _DashboardMetricCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.width,
  });

  final IconData icon;
  final String label;
  final String value;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF8F1A1A),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(20),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 42,
            width: 42,
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(46),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: 22),
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}

class _RevenueSummaryCard extends StatelessWidget {
  const _RevenueSummaryCard({required this.width});

  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF9E2323), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 46,
            width: 46,
            decoration: BoxDecoration(
              color: const Color(0xFF8F1A1A).withAlpha(31),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.currency_exchange,
              color: Color(0xFF8F1A1A),
              size: 26,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Rp. 1.699.000',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF351B1B),
                  ),
                ),
                SizedBox(height: 6),
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
  const _TrendingCard({required this.isMobile});

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
          ),
          const SizedBox(height: 14),
          const _TrendingItem(
            title: 'Es Teh',
            subtitle: 'Iced Tea',
            price: 'Rp. 5.000,00',
          ),
          const SizedBox(height: 14),
          const _TrendingItem(
            title: 'Tahu crispy',
            subtitle: 'Crispy Tofu',
            price: 'Rp. 15.000,00',
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
  });

  final String title;
  final String subtitle;
  final String price;

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
            child: const Icon(Icons.fastfood, color: Color(0xFF8F1A1A)),
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
            child: const Text(
              'Best Seller Menu',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF3A1F1B),
              ),
            ),
          ),
          ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(18),
              bottomRight: Radius.circular(18),
            ),
            child: Image.network(
              'https://images.unsplash.com/photo-1551218808-94e220e084d2?auto=format&fit=crop&w=800&q=80',
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 180,
                  width: double.infinity,
                  color: const Color(0xFFF4ECE3),
                  child: const Icon(
                    Icons.restaurant_menu,
                    color: Color(0xFF8F1A1A),
                    size: 48,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
