import 'package:flutter/material.dart';
import 'menu_model.dart';
import 'menu_service.dart';
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
  bool _isGridView = true;
  bool _isLoading = true;
  String? _errorMessage;
  List<MenuItemInfo> _menuItems = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadMenus();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadMenus() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final menus = await MenuService.fetchMenus();
      if (mounted) {
        setState(() {
          _menuItems = menus;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
          _menuItems = List<MenuItemInfo>.from(dummyMenuItems);
        });
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    final isMobile = widget.isMobile;
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
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _ViewToggle(
                title: 'Grid View',
                icon: Icons.grid_view,
                isSelected: _isGridView,
                onTap: () => setState(() => _isGridView = true),
              ),
              const SizedBox(width: 8),
              _ViewToggle(
                title: 'Table View',
                icon: Icons.table_chart,
                isSelected: !_isGridView,
                onTap: () => setState(() => _isGridView = false),
              ),
            ],
          ),
          const SizedBox(height: 18),
          if (_isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(40),
                child: CircularProgressIndicator(color: Color(0xFF8F1A1A)),
              ),
            )
          else if (_errorMessage != null)
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.orange.withAlpha(30),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.warning_amber, color: Colors.orange, size: 18),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text(
                            'Menggunakan data offline. Server tidak tersedia.',
                            style: TextStyle(fontSize: 11, color: Colors.orange),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.refresh, size: 18),
                          onPressed: _loadMenus,
                        ),
                      ],
                    ),
                  ),
                ),
                _buildContent(isMobile),
              ],
            )
          else
            _buildContent(isMobile),
        ],
      ),
    );
  }

  Widget _buildContent(bool isMobile) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) => _isGridView
                    ? _MenuGrid(
                        isMobile: isMobile,
                        constraints: constraints,
                        items: _filteredMenuItems,
                        onEdit: _showEditForm,
                        onDelete: _showDeleteConfirm,
                      )
                    : _MenuTable(
                        isMobile: isMobile,
                        items: _filteredMenuItems,
                        onEdit: _showEditForm,
                        onDelete: _showDeleteConfirm,
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
                    TambahMenuFormCard(onSaved: _loadMenus),
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
            TambahMenuFormCard(onSaved: _loadMenus),
          ],
        ],
      ],
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

  List<MenuItemInfo> get _filteredMenuItems {
    final query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) return _menuItems;
    return _menuItems
        .where((item) => item.namaMenu.toLowerCase().contains(query))
        .toList();
  }

  void _showEditForm(MenuItemInfo item) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: MenuForm(
          menuItem: item,
          onSaved: _loadMenus,
          isDialog: true,
        ),
      ),
    );
  }

  void _showDeleteConfirm(MenuItemInfo item) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Hapus Menu'),
        content: Text('Yakin ingin menghapus "${item.namaMenu}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              final messenger = ScaffoldMessenger.of(context);
              try {
                await MenuService.deleteMenu(item.id);
                if (!mounted) return;
                setState(() {
                  _menuItems.removeWhere((menu) => menu.id == item.id);
                });
                messenger.showSnackBar(
                  const SnackBar(
                    content: Text('Menu berhasil dihapus'),
                    backgroundColor: Colors.green,
                  ),
                );
                _loadMenus();
              } catch (e) {
                if (!mounted) return;
                messenger.showSnackBar(
                  SnackBar(
                    content: Text('Gagal menghapus: $e'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8F1A1A),
              foregroundColor: Colors.white,
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
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
    required this.constraints,
    required this.items,
    required this.onEdit,
    required this.onDelete,
  });

  final bool isMobile;
  final BoxConstraints constraints;
  final List<MenuItemInfo> items;
  final Function(MenuItemInfo) onEdit;
  final Function(MenuItemInfo) onDelete;

  @override
  Widget build(BuildContext context) {
    const spacing = 14.0;
    final columns = isMobile ? 2 : 5;
    final maxWidth = constraints.maxWidth;
    final cardWidth = (maxWidth - (columns - 1) * spacing) / columns;
    final cardHeight = cardWidth + (isMobile ? 18 : 20);

    return Wrap(
      spacing: spacing,
      runSpacing: 16,
      children: items
          .map(
            (item) => _MenuCard(
              item: item,
              width: cardWidth,
              height: cardHeight,
              onTap: () => _showMenuDetail(context, item),
            ),
          )
          .toList(),
    );
  }

  void _showMenuDetail(BuildContext context, MenuItemInfo item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFFFDFBF9),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: EdgeInsets.zero,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              children: [
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF4ECE3),
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: _buildMenuImage(item),
                  ),
                ),
                Positioned(
                  right: 8,
                  top: 8,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Color(0xFF8F1A1A)),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          item.namaMenu,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF3B1F1B),
                          ),
                        ),
                      ),
                      _StatusBadge(stok: item.stok),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Kategori ID: ${item.idKategoriMenu}',
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Rp ${item.harga.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF8F1A1A),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                            onEdit(item);
                          },
                          icon: const Icon(Icons.edit, size: 18),
                          label: const Text('Edit'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.blue[700],
                            side: BorderSide(color: Colors.blue[700]!),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                            onDelete(item);
                          },
                          icon: const Icon(Icons.delete, size: 18),
                          label: const Text('Hapus'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF8F1A1A),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            elevation: 0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuImage(MenuItemInfo item) {
    if (item.hasServerImage) {
      return Image.network(
        item.gambarUrl,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => const Icon(Icons.fastfood, color: Color(0xFF8F1A1A), size: 40),
      );
    } else if (item.hasLocalImage) {
      return Image.asset(item.imagePath, fit: BoxFit.contain);
    }
    return const Icon(Icons.fastfood, color: Color(0xFF8F1A1A), size: 40);
  }
}

class _MenuCard extends StatelessWidget {
  const _MenuCard({
    required this.item,
    required this.width,
    required this.height,
    required this.onTap,
  });

  final MenuItemInfo item;
  final double width;
  final double height;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(9),
      child: Container(
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
                  child: _buildCardImage(item),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              item.namaMenu,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardImage(MenuItemInfo item) {
    if (item.hasServerImage) {
      return Image.network(
        item.gambarUrl,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => const Icon(Icons.fastfood, color: Color(0xFF8F1A1A), size: 30),
      );
    } else if (item.hasLocalImage) {
      return Image.asset(item.imagePath, fit: BoxFit.contain);
    }
    return const Icon(Icons.fastfood, color: Color(0xFF8F1A1A), size: 30);
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.stok});
  final String stok;

  @override
  Widget build(BuildContext context) {
    final isTersedia = stok == 'tersedia';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isTersedia ? Colors.green.withAlpha(30) : Colors.red.withAlpha(30),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        stok,
        style: TextStyle(
          color: isTersedia ? Colors.green[800] : Colors.red[800],
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
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

class _ViewToggle extends StatelessWidget {
  const _ViewToggle({
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF8F1A1A) : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? const Color(0xFF8F1A1A) : const Color(0xFFE0D8D5),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? Colors.white : const Color(0xFF6F6460),
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : const Color(0xFF6F6460),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuTable extends StatelessWidget {
  const _MenuTable({
    required this.isMobile,
    required this.items,
    required this.onEdit,
    required this.onDelete,
  });

  final bool isMobile;
  final List<MenuItemInfo> items;
  final Function(MenuItemInfo) onEdit;
  final Function(MenuItemInfo) onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerTheme: const DividerThemeData(thickness: 0.5, color: Color(0xFFE0D8D5)),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width - (isMobile ? 32 : 300)),
            child: DataTable(
              horizontalMargin: 4,
              columnSpacing: 8,
              headingRowHeight: 56,
              dataRowMaxHeight: 64,
              headingRowColor: WidgetStateProperty.resolveWith((states) => const Color(0xFFF4ECE3)),
              columns: const [
                DataColumn(label: Text('ID', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12))),
                DataColumn(label: Text('Gambar', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12))),
                DataColumn(label: Text('Nama Menu', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12))),
                DataColumn(label: Text('Kat.', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12))),
                DataColumn(label: Text('Harga', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12))),
                DataColumn(label: Text('Stok', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12))),
                DataColumn(label: Text('Aksi', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12))),
              ],
              rows: items.map((item) {
                return DataRow(cells: [
                  DataCell(Text(item.id.toString(), style: const TextStyle(fontSize: 12))),
                  DataCell(
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          width: 40,
                          height: 40,
                          color: const Color(0xFFF4ECE3),
                          child: _buildTableImage(item),
                        ),
                      ),
                    ),
                  ),
                  DataCell(
                    SizedBox(
                      width: 100,
                      child: Text(
                        item.namaMenu,
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  DataCell(Text(item.idKategoriMenu.toString(), style: const TextStyle(fontSize: 12))),
                  DataCell(Text('Rp ${item.harga.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12))),
                  DataCell(_StatusBadge(stok: item.stok)),
                  DataCell(
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _TableActionButton(
                          icon: Icons.edit_rounded,
                          color: Colors.blue,
                          tooltip: 'Edit Menu',
                          onTap: () => onEdit(item),
                        ),
                        const SizedBox(width: 4),
                        _TableActionButton(
                          icon: Icons.delete_rounded,
                          color: const Color(0xFF8F1A1A),
                          tooltip: 'Hapus Menu',
                          onTap: () => onDelete(item),
                        ),
                      ],
                    ),
                  ),
                ]);
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTableImage(MenuItemInfo item) {
    if (item.hasServerImage) {
      return Image.network(
        item.gambarUrl,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => const Icon(Icons.fastfood, size: 20),
      );
    } else if (item.hasLocalImage) {
      return Image.asset(item.imagePath, fit: BoxFit.contain);
    }
    return const Icon(Icons.fastfood, size: 20);
  }
}

class _TableActionButton extends StatelessWidget {
  const _TableActionButton({
    required this.icon,
    required this.color,
    required this.onTap,
    required this.tooltip,
  });

  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              icon,
              size: 18,
              color: color,
            ),
          ),
        ),
      ),
    );
  }
}
