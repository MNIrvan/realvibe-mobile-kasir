import 'package:flutter/material.dart';

import '../../modal/form_tambah_menu/tambah_menu_form.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({
    super.key,
    required this.isMobile,
  });

  final bool isMobile;

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  bool showTambahMenu = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = widget.isMobile;
    final screenWidth = MediaQuery.of(context).size.width;
    final contentPadding = EdgeInsets.symmetric(
      horizontal: isMobile ? 16 : 24,
      vertical: 20,
    );

    return SingleChildScrollView(
      padding: contentPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _MenuHeader(isMobile: isMobile),
          const SizedBox(height: 18),
          _SearchBar(
            isMobile: isMobile,
            controller: _searchController,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 18),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) => _MenuGrid(
                    isMobile: isMobile,
                    maxWidth: constraints.maxWidth,
                    items: _filteredMenuItems,
                  ),
                ),
              ),
              if (!isMobile) ...[
                const SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _FeaturePanel(
                      onAddMenu: _toggleTambahMenu,
                      onCloseForm: _closeTambahMenu,
                      showCollapsed: showTambahMenu,
                    ),
                    if (showTambahMenu) ...[
                      const SizedBox(height: 12),
                      const TambahMenuFormCard(),
                    ],
                  ],
                ),
              ],
            ],
          ),
          if (isMobile) ...[
            const SizedBox(height: 16),
            _FeaturePanel(
              onAddMenu: _toggleTambahMenu,
              onCloseForm: _closeTambahMenu,
              showCollapsed: showTambahMenu,
            ),
            if (showTambahMenu) ...[
              const SizedBox(height: 12),
              const TambahMenuFormCard(),
            ],
          ],
        ],
      ),
    );
  }

  void _toggleTambahMenu() {
    setState(() {
      showTambahMenu = !showTambahMenu;
    });
  }

  void _closeTambahMenu() {
    setState(() {
      showTambahMenu = false;
    });
  }

  List<_MenuItem> get _filteredMenuItems {
    final query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) return _menuItems;
    return _menuItems
        .where((item) => item.title.toLowerCase().contains(query))
        .toList();
  }
}

class _MenuHeader extends StatelessWidget {
  const _MenuHeader({required this.isMobile});

  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          if (isMobile)
            const Icon(Icons.menu, color: Color(0xFF8E1C1C), size: 20),
          if (isMobile) const SizedBox(width: 10),
          const Expanded(
            child: Text(
              'Welcome Admin !',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF3B1F1B),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({
    required this.isMobile,
    required this.controller,
    required this.onChanged,
  });

  final bool isMobile;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            vertical: 14,
            horizontal: 18,
          ),
          hintText: 'Daftar stok Menu',
          hintStyle: const TextStyle(color: Color(0xFF6F6460)),
          prefixIcon: const Icon(Icons.menu, color: Color(0xFF8E1C1C)),
          suffixIcon: const Icon(Icons.search, color: Color(0xFF8E1C1C)),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(28),
          ),
        ),
      ),
    );
  }
}

class _MenuGrid extends StatelessWidget {
  const _MenuGrid({
    required this.isMobile,
    required this.maxWidth,
    required this.items,
  });

  final bool isMobile;
  final double maxWidth;
  final List<_MenuItem> items;

  @override
  Widget build(BuildContext context) {
    const spacing = 14.0;
    final columns = isMobile ? 2 : 5;
    final cardWidth = (maxWidth - (columns - 1) * spacing) / columns;
    final cardHeight = cardWidth + (isMobile ? 18 : 20);

    return Wrap(
      spacing: spacing,
      runSpacing: 16,
      children: items
          .map(
            (item) => _MenuCard(
              title: item.title,
              imagePath: item.imagePath,
              width: cardWidth,
              height: cardHeight,
            ),
          )
          .toList(),
    );
  }
}

class _MenuCard extends StatelessWidget {
  const _MenuCard({
    required this.title,
    required this.imagePath,
    required this.width,
    required this.height,
  });

  final String title;
  final String imagePath;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: const Color(0xFF8F1A1A),
        borderRadius: BorderRadius.circular(9),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(12),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(7),
              child: Container(
                color: const Color(0xFFF4ECE3),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _FeaturePanel extends StatelessWidget {
  const _FeaturePanel({
    required this.onAddMenu,
    required this.onCloseForm,
    required this.showCollapsed,
  });

  final VoidCallback onAddMenu;
  final VoidCallback onCloseForm;
  final bool showCollapsed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      decoration: BoxDecoration(
        color: const Color(0xFF8F1A1A),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'FITUR',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                ),
                if (showCollapsed)
                  InkWell(
                    onTap: onCloseForm,
                    borderRadius: BorderRadius.circular(8),
                    child: const Padding(
                      padding: EdgeInsets.all(4),
                      child:
                          Icon(Icons.open_in_full, color: Colors.white, size: 14),
                    ),
                  ),
                if (!showCollapsed)
                  const Icon(Icons.open_in_full, color: Colors.white, size: 14),
              ],
            ),
          ),
          if (!showCollapsed) ...[
            const Divider(height: 1, color: Color(0x55FFFFFF)),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Text(
                'Stok',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ),
            const Divider(height: 1, color: Color(0x55FFFFFF)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: onAddMenu,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFA92A2A),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: Text(
                        '+Tambah Menu',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _MenuItem {
  const _MenuItem(this.title, this.imagePath);

  final String title;
  final String imagePath;
}

const List<_MenuItem> _menuItems = [
  _MenuItem('Ayam geprek', 'assets/images/menu9.png'),
  _MenuItem('Tahu', 'assets/images/menu8.png'),
  _MenuItem('Roti Bakar', 'assets/images/menu2.png'),
  _MenuItem('Kentang', 'assets/images/menu6.png'),
  _MenuItem('Tahu', 'assets/images/menu8.png'),
  _MenuItem('Tahu Crispy', 'assets/images/menu10.png'),
  _MenuItem('Burger', 'assets/images/menu1.png'),
  _MenuItem('Mie goreng', 'assets/images/menu7.png'),
  _MenuItem('Es Teh', 'assets/images/menu3.png'),
  _MenuItem('Burger', 'assets/images/menu1.png'),
  _MenuItem('Ayam geprek', 'assets/images/menu9.png'),
  _MenuItem('Tahu', 'assets/images/menu8.png'),
  _MenuItem('Roti Bakar', 'assets/images/menu2.png'),
  _MenuItem('Kentang', 'assets/images/menu6.png'),
  _MenuItem('Tahu', 'assets/images/menu8.png'),
];
