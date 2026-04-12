import 'package:flutter/material.dart';

import '../../auth/login.dart';
import '../dashboard_section.dart';

class DashboardSidebar extends StatelessWidget {
  const DashboardSidebar({
    required this.isCollapsed,
    required this.onToggle,
    required this.selectedSection,
    required this.onSelect,
    super.key,
  });

  final bool isCollapsed;
  final VoidCallback onToggle;
  final DashboardSection selectedSection;
  final ValueChanged<DashboardSection> onSelect;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isNarrow = screenWidth < 900;
    final itemVertical = isNarrow ? 8.0 : 6.0;
    final itemFont = isNarrow ? 17.0 : 16.0;
    final iconSize = isNarrow ? 26.0 : 24.0;
    final itemHeight = isNarrow ? 46.0 : 42.0;
    return Container(
      color: const Color(0xFFB11D1D),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isCollapsed ? 14 : 20,
              vertical: 18,
            ),
            child: isCollapsed
                ? Column(
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: Colors.white,
                        child: ClipOval(
                          child: Image.asset(
                            'assets/icons/logo.png',
                            width: 30,
                            height: 30,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      InkWell(
                        onTap: onToggle,
                        borderRadius: BorderRadius.circular(12),
                        child: const Padding(
                          padding: EdgeInsets.all(6),
                          child: Icon(
                            Icons.keyboard_double_arrow_right,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  )
                : Row(
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: Colors.white,
                        child: ClipOval(
                          child: Image.asset(
                            'assets/icons/logo.png',
                            width: 30,
                            height: 30,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        SizedBox(
                          height: 20,
                          child: FittedBox(
                            alignment: Alignment.centerLeft,
                            fit: BoxFit.contain,
                            child: Image.asset(
                              'assets/icons/textrealvibe.png',
                                  filterQuality: FilterQuality.high,
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Real Cafe Djatirto',
                              style:
                                  TextStyle(color: Colors.white70, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: onToggle,
                        icon: const Icon(
                          Icons.menu,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
          ),
          const SizedBox(height: 12),
          if (isCollapsed) const SizedBox(height: 6),
          _SidebarMenuItem(
            icon: Icons.dashboard,
            label: 'Dashboard',
            isCollapsed: isCollapsed,
            isActive: selectedSection == DashboardSection.dashboard,
            onTap: () => onSelect(DashboardSection.dashboard),
            verticalPadding: itemVertical,
            fontSize: itemFont,
            iconSize: iconSize,
            itemHeight: itemHeight,
          ),
          _SidebarMenuItem(
            icon: Icons.bar_chart,
            label: 'Laporan',
            isCollapsed: isCollapsed,
            isActive: selectedSection == DashboardSection.laporan,
            onTap: () => onSelect(DashboardSection.laporan),
            verticalPadding: itemVertical,
            fontSize: itemFont,
            iconSize: iconSize,
            itemHeight: itemHeight,
          ),
          _SidebarMenuItem(
            icon: Icons.restaurant_menu,
            label: 'Menu',
            isCollapsed: isCollapsed,
            isActive: selectedSection == DashboardSection.menu,
            onTap: () => onSelect(DashboardSection.menu),
            verticalPadding: itemVertical,
            fontSize: itemFont,
            iconSize: iconSize,
            itemHeight: itemHeight,
          ),
          _SidebarMenuItem(
            icon: Icons.schedule,
            label: 'Jadwal Kereta',
            isCollapsed: isCollapsed,
            isActive: selectedSection == DashboardSection.jadwal,
            onTap: () => onSelect(DashboardSection.jadwal),
            verticalPadding: itemVertical,
            fontSize: itemFont,
            iconSize: iconSize,
            itemHeight: itemHeight,
          ),
          _SidebarMenuItem(
            icon: Icons.info_outline,
            label: 'Informasi',
            isCollapsed: isCollapsed,
            isActive: selectedSection == DashboardSection.informasi,
            onTap: () => onSelect(DashboardSection.informasi),
            verticalPadding: itemVertical,
            fontSize: itemFont,
            iconSize: iconSize,
            itemHeight: itemHeight,
          ),
          _SidebarMenuItem(
            icon: Icons.feedback_outlined,
            label: 'Masukan',
            isCollapsed: isCollapsed,
            isActive: selectedSection == DashboardSection.masukan,
            onTap: () => onSelect(DashboardSection.masukan),
            verticalPadding: itemVertical,
            fontSize: itemFont,
            iconSize: iconSize,
            itemHeight: itemHeight,
          ),
          _SidebarMenuItem(
            icon: Icons.person_outline,
            label: 'Users',
            isCollapsed: isCollapsed,
            isActive: selectedSection == DashboardSection.users,
            onTap: () => onSelect(DashboardSection.users),
            verticalPadding: itemVertical,
            fontSize: itemFont,
            iconSize: iconSize,
            itemHeight: itemHeight,
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
    required this.onTap,
    required this.verticalPadding,
    required this.fontSize,
    required this.iconSize,
    required this.itemHeight,
    this.isActive = false,
  });

  final IconData icon;
  final String label;
  final bool isCollapsed;
  final bool isActive;
  final VoidCallback onTap;
  final double verticalPadding;
  final double fontSize;
  final double iconSize;
  final double itemHeight;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isCollapsed ? 8 : 12,
        vertical: verticalPadding,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Container(
            height: itemHeight,
            decoration: BoxDecoration(
              color: isActive ? Colors.white.withAlpha(46) : Colors.transparent,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const SizedBox(width: 8),
                Icon(icon, color: Colors.white, size: iconSize),
                if (!isCollapsed) ...[
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      label,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: fontSize,
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
    );
  }
}
