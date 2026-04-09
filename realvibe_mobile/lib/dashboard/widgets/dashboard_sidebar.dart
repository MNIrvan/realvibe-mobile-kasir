import 'package:flutter/material.dart';

import '../../login/login_page.dart';

class DashboardSidebar extends StatelessWidget {
  const DashboardSidebar({
    required this.isCollapsed,
    required this.onToggle,
    super.key,
  });

  final bool isCollapsed;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFB11D1D),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isCollapsed ? 14 : 20,
              vertical: 22,
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.white,
                  child: Text(
                    'RV',
                    style: TextStyle(
                      color: const Color(0xFFB11D1D),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                if (!isCollapsed) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Real-Vibe',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Real Cafe Djatirto',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
                IconButton(
                  onPressed: onToggle,
                  icon: Icon(
                    isCollapsed
                        ? Icons.keyboard_double_arrow_right
                        : Icons.keyboard_double_arrow_left,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _SidebarMenuItem(
            icon: Icons.dashboard,
            label: 'Dashboard',
            isCollapsed: isCollapsed,
            isActive: true,
          ),
          _SidebarMenuItem(
            icon: Icons.bar_chart,
            label: 'Laporan',
            isCollapsed: isCollapsed,
          ),
          _SidebarMenuItem(
            icon: Icons.restaurant_menu,
            label: 'Menu',
            isCollapsed: isCollapsed,
          ),
          _SidebarMenuItem(
            icon: Icons.schedule,
            label: 'Jadwal Kereta',
            isCollapsed: isCollapsed,
          ),
          _SidebarMenuItem(
            icon: Icons.info_outline,
            label: 'Informasi',
            isCollapsed: isCollapsed,
          ),
          _SidebarMenuItem(
            icon: Icons.feedback_outlined,
            label: 'Masukan',
            isCollapsed: isCollapsed,
          ),
          const Spacer(),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isCollapsed ? 14 : 20,
              vertical: 18,
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(18),
                onTap: () {
                  if (Scaffold.of(context).isDrawerOpen) {
                    Navigator.of(context).pop();
                  }
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const LoginPage()),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    children: [
                      const Icon(Icons.logout, color: Colors.white),
                      if (!isCollapsed) ...[
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            'Logout',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SidebarMenuItem extends StatelessWidget {
  const _SidebarMenuItem({
    required this.icon,
    required this.label,
    required this.isCollapsed,
    this.isActive = false,
  });

  final IconData icon;
  final String label;
  final bool isCollapsed;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isCollapsed ? 8 : 12,
        vertical: 6,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: isActive ? Colors.white.withAlpha(46) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            const SizedBox(width: 8),
            Icon(icon, color: Colors.white, size: 22),
            if (!isCollapsed) ...[
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
