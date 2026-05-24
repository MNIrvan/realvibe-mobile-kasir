import 'package:flutter/material.dart';
import 'masukan_model.dart';
import 'masukan_service.dart';

class MasukanPage extends StatefulWidget {
  const MasukanPage({super.key, required this.isMobile});

  final bool isMobile;

  @override
  State<MasukanPage> createState() => _MasukanPageState();
}

class _MasukanPageState extends State<MasukanPage> {
  String selectedFilter = 'Terbaru';
  final TextEditingController _searchController = TextEditingController();
  final MasukanService _service = MasukanService();
  List<MasukanModel> _masukanData = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchMasukan();
  }

  Future<void> _fetchMasukan() async {
    try {
      final data = await _service.getMasukan();
      setState(() {
        _masukanData = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _markAsRead(MasukanModel item) async {
    try {
      await _service.markAsRead(item.id);
      _fetchMasukan();
    } catch (e) {
      debugPrint('Failed to mark read: $e');
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = widget.isMobile;
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 24,
        vertical: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _MasukanHeader(
            isMobile: isMobile,
            controller: _searchController,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 18),
          _SectionHeader(
            isMobile: isMobile,
            selectedFilter: selectedFilter,
            onSelect: (value) => setState(() => selectedFilter = value),
          ),
          const SizedBox(height: 14),
          Center(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFDAC2B8)),
              ),
              child: _isLoading 
                ? const Center(child: Padding(
                    padding: EdgeInsets.all(24.0),
                    child: CircularProgressIndicator(color: Color(0xFF8F1A1A)),
                  ))
                : Column(
                children: [
                  ..._filteredItems
                      .map(
                        (item) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _FeedbackCard(
                            name: item.namaPelanggan,
                            date: item.createdAt,
                            rating: item.rating,
                            message: item.pesan,
                            isRead: item.isRead,
                            onRead: () => _markAsRead(item),
                          ),
                        ),
                      )
                      .toList(),
                  const SizedBox(height: 4),
                  const _PaginationBar(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MasukanHeader extends StatelessWidget {
  const _MasukanHeader({
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
          if (!isMobile)
            _HeaderSearch(
              controller: controller,
              onChanged: onChanged,
            ),
        ],
      ),
    );
  }
}

class _HeaderSearch extends StatelessWidget {
  const _HeaderSearch({
    required this.controller,
    required this.onChanged,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320,
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            vertical: 14,
            horizontal: 18,
          ),
          hintText: 'Telusuri disini',
          hintStyle: const TextStyle(color: Color(0xFF8A8A8A)),
          prefixIcon: const Icon(Icons.menu, color: Color(0xFF8A8A8A)),
          suffixIcon: const Icon(Icons.search, color: Color(0xFF8A8A8A)),
          filled: true,
          fillColor: const Color(0xFFF5F1EE),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.isMobile,
    required this.selectedFilter,
    required this.onSelect,
  });

  final bool isMobile;
  final String selectedFilter;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 3, height: 18, color: const Color(0xFF8F1A1A)),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Masukan Pelanggan',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF3B1F1B),
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Sebagai bahan evaluasi layanan',
                style: TextStyle(fontSize: 11, color: Color(0xFF8F8079)),
              ),
            ],
          ),
        ),
        _FilterChip(
          isMobile: isMobile,
          selectedFilter: selectedFilter,
          onSelect: onSelect,
        ),
        const SizedBox(width: 12),
        const Icon(Icons.refresh, color: Color(0xFF8F1A1A)),
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.isMobile,
    required this.selectedFilter,
    required this.onSelect,
  });

  final bool isMobile;
  final String selectedFilter;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: onSelect,
      itemBuilder: (context) => const [
        PopupMenuItem(value: 'Terbaru', child: Text('Terbaru')),
        PopupMenuItem(value: 'Terlama', child: Text('Terlama')),
        PopupMenuItem(value: 'Belum dibaca', child: Text('Belum dibaca')),
      ],
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFF8F1A1A)),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              selectedFilter,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Color(0xFF8F1A1A),
              ),
            ),
            const SizedBox(width: 6),
            const Icon(
              Icons.keyboard_arrow_down,
              size: 14,
              color: Color(0xFF8F1A1A),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeedbackCard extends StatelessWidget {
  const _FeedbackCard({
    required this.name,
    required this.date,
    required this.rating,
    required this.message,
    required this.isRead,
    required this.onRead,
  });

  final String name;
  final String date;
  final int rating;
  final String message;
  final bool isRead;
  final VoidCallback onRead;

  @override
  Widget build(BuildContext context) {
    final initial = name.isNotEmpty ? name.characters.first : '?';
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFD6C2B8)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: const Color(0xFFF2E2D8),
                child: Text(
                  initial,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF8F1A1A),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                        color: Color(0xFF3B1F1B),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      date,
                      style: const TextStyle(
                        fontSize: 10,
                        color: Color(0xFF8F8079),
                      ),
                    ),
                  ],
                ),
              ),
              _RatingStars(rating: rating),
              const SizedBox(width: 8),
              if (!isRead)
                InkWell(
                  onTap: onRead,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF17C39A),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'Konfirmasi',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'Dibaca',
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                      color: Colors.black54,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: const TextStyle(
              fontSize: 10.5,
              height: 1.5,
              color: Color(0xFF6F6561),
            ),
          ),
        ],
      ),
    );
  }
}

extension on _MasukanPageState {
  List<MasukanModel> get _filteredItems {
    var items = _masukanData;
    
    // Sort logic based on filter
    if (selectedFilter == 'Terbaru') {
      items.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } else if (selectedFilter == 'Terlama') {
      items.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    } else if (selectedFilter == 'Belum dibaca') {
      items = items.where((e) => !e.isRead).toList();
    }

    final query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) return items;
    return items.where((item) {
      return item.namaPelanggan.toLowerCase().contains(query) ||
          item.createdAt.toLowerCase().contains(query) ||
          item.pesan.toLowerCase().contains(query);
    }).toList();
  }
}

class _RatingStars extends StatelessWidget {
  const _RatingStars({required this.rating});

  final int rating;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(5, (index) {
        final active = index < rating;
        return Icon(
          Icons.star,
          size: 14,
          color: active ? const Color(0xFFFFC107) : const Color(0xFFDAD2CD),
        );
      }),
    );
  }
}

class _PaginationBar extends StatelessWidget {
  const _PaginationBar();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const Text(
          '1 2 3 4 5 6 >',
          style: TextStyle(fontSize: 10, color: Color(0xFF8F8079)),
        ),
        const SizedBox(width: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFD0C3BC)),
          ),
          child: const Text(
            'Previous',
            style: TextStyle(fontSize: 9, color: Color(0xFF6F6561)),
          ),
        ),
        const SizedBox(width: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFD0C3BC)),
          ),
          child: const Text(
            'Next',
            style: TextStyle(fontSize: 9, color: Color(0xFF6F6561)),
          ),
        ),
      ],
    );
  }
}
