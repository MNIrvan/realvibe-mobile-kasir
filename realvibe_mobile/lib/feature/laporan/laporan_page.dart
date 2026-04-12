import 'package:flutter/material.dart';

import '../../data/laporan_data.dart';
import '../../modal/form_laporan_cetak/form_laporan_cetak.dart';

enum LaporanFilter { tunai, nonTunai, uangKeluar, keseluruhan }

class LaporanPage extends StatefulWidget {
  const LaporanPage({super.key, required this.isMobile});

  final bool isMobile;

  @override
  State<LaporanPage> createState() => _LaporanPageState();
}

class _LaporanPageState extends State<LaporanPage> {
  LaporanFilter selected = LaporanFilter.tunai;
  final TextEditingController _searchController = TextEditingController();

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
          _LaporanHeader(
            isMobile: isMobile,
            controller: _searchController,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 18),
          _FilterTabs(
            isMobile: isMobile,
            selected: selected,
            onSelect: (value) => setState(() => selected = value),
          ),
          const SizedBox(height: 10),
          _ReportCard(
            isMobile: isMobile,
            selected: selected,
            searchQuery: _searchController.text,
          ),
        ],
      ),
    );
  }
}

class _LaporanHeader extends StatelessWidget {
  const _LaporanHeader({
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
    );
  }
}

class _FilterTabs extends StatelessWidget {
  const _FilterTabs({
    required this.isMobile,
    required this.selected,
    required this.onSelect,
  });

  final bool isMobile;
  final LaporanFilter selected;
  final ValueChanged<LaporanFilter> onSelect;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _FilterTab(
          label: 'Pembayaran Tunai',
          icon: Icons.attach_money,
          isActive: selected == LaporanFilter.tunai,
          onTap: () => onSelect(LaporanFilter.tunai),
        ),
        const SizedBox(width: 10),
        _FilterTab(
          label: 'Pembayaran Non Tunai',
          icon: Icons.credit_card,
          isActive: selected == LaporanFilter.nonTunai,
          onTap: () => onSelect(LaporanFilter.nonTunai),
        ),
        const SizedBox(width: 10),
        _FilterTab(
          label: 'Uang Keluar',
          icon: Icons.logout,
          isActive: selected == LaporanFilter.uangKeluar,
          onTap: () => onSelect(LaporanFilter.uangKeluar),
        ),
        const SizedBox(width: 10),
        _FilterTab(
          label: 'Keseluruhan',
          icon: Icons.task_alt,
          isActive: selected == LaporanFilter.keseluruhan,
          onTap: () => onSelect(LaporanFilter.keseluruhan),
        ),
        const Spacer(),
        const Icon(Icons.refresh, color: Color(0xFF8F1A1A)),
      ],
    );
  }
}

class _FilterTab extends StatelessWidget {
  const _FilterTab({
    required this.label,
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = isActive ? const Color(0xFF8F1A1A) : const Color(0xFF6F6561);
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Container(
            height: 3,
            width: 100,
            color: isActive ? const Color(0xFF8F1A1A) : Colors.transparent,
          ),
        ],
      ),
    );
  }
}

class _ReportCard extends StatelessWidget {
  const _ReportCard({
    required this.isMobile,
    required this.selected,
    required this.searchQuery,
  });

  final bool isMobile;
  final LaporanFilter selected;
  final String searchQuery;

  @override
  Widget build(BuildContext context) {
    final entries = selected == LaporanFilter.tunai
        ? laporanTunai
        : selected == LaporanFilter.nonTunai
            ? laporanNonTunai
            : selected == LaporanFilter.keseluruhan
                ? laporanKeseluruhan()
                : const <LaporanEntry>[];
    final query = searchQuery.trim().toLowerCase();
    final filtered = query.isEmpty
        ? entries
        : entries.where((e) {
            return e.kode.toLowerCase().contains(query) ||
                e.pembeli.toLowerCase().contains(query) ||
                e.detail.toLowerCase().contains(query) ||
                e.kasir.toLowerCase().contains(query) ||
                e.metode.toLowerCase().contains(query) ||
                e.total.toLowerCase().contains(query) ||
                e.tanggal.toLowerCase().contains(query);
          }).toList();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0D2C8)),
      ),
      child: Column(
        children: [
          _ReportToolbar(selected: selected),
          const SizedBox(height: 12),
          if (selected == LaporanFilter.uangKeluar)
            const _EmptyState()
          else
            _ReportTable(entries: filtered, isMobile: isMobile),
        ],
      ),
    );
  }
}

class _ReportToolbar extends StatelessWidget {
  const _ReportToolbar({required this.selected});

  final LaporanFilter selected;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          selected == LaporanFilter.tunai
              ? 'Transaksi Tunai'
              : selected == LaporanFilter.nonTunai
                  ? 'Transaksi Non Tunai'
                  : selected == LaporanFilter.keseluruhan
                      ? 'Transaksi Keseluruhan'
                      : 'Uang Keluar',
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 14,
            color: Color(0xFF3B1F1B),
          ),
        ),
        const Spacer(),
        const Text(
          'Tanggal:',
          style: TextStyle(fontSize: 11, color: Color(0xFF8F8079)),
        ),
        const SizedBox(width: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFD5C7BE)),
            borderRadius: BorderRadius.circular(6),
          ),
          child: const Text(
            '22/7/2024',
            style: TextStyle(fontSize: 10),
          ),
        ),
        const SizedBox(width: 8),
        _ToolbarButton(
          label: 'Filter',
          color: const Color(0xFF1D4ED8),
          icon: Icons.tune,
        ),
        const SizedBox(width: 6),
        _ToolbarButton(
          label: 'Cetak',
          color: const Color(0xFF1D4ED8),
          icon: Icons.print,
          onTap: () {
            final entries = selected == LaporanFilter.tunai
                ? laporanTunai
                : selected == LaporanFilter.nonTunai
                    ? laporanNonTunai
                    : selected == LaporanFilter.keseluruhan
                        ? laporanKeseluruhan()
                        : const <LaporanEntry>[];
            final title = selected == LaporanFilter.tunai
                ? 'Pembayaran Tunai'
                : selected == LaporanFilter.nonTunai
                    ? 'Pembayaran Non Tunai'
                    : selected == LaporanFilter.keseluruhan
                        ? 'Keseluruhan'
                        : 'Uang Keluar';
            showDialog(
              context: context,
              builder: (_) => FormLaporanCetak(
                title: title,
                entries: entries,
              ),
            );
          },
        ),
      ],
    );
  }
}

class _ToolbarButton extends StatelessWidget {
  const _ToolbarButton({
    required this.label,
    required this.color,
    required this.icon,
    this.onTap,
  });

  final String label;
  final Color color;
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 10,
              ),
            ),
            const SizedBox(width: 4),
            Icon(icon, size: 12, color: Colors.white),
          ],
        ),
      ),
    );
  }
}

class _ReportTable extends StatelessWidget {
  const _ReportTable({required this.entries, required this.isMobile});

  final List<LaporanEntry> entries;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFF6F2EF),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            children: const [
              Expanded(child: _HeaderText('Kode Pesanan')),
              Expanded(child: _HeaderText('Nama Pembeli')),
              Expanded(child: _HeaderText('Detail Pesanan')),
              Expanded(child: _HeaderText('Nama Kasir')),
              Expanded(child: _HeaderText('Metode')),
              Expanded(child: _HeaderText('Total Transaksi')),
              Expanded(child: _HeaderText('Tanggal Transaksi')),
            ],
          ),
        ),
        const SizedBox(height: 6),
        ...entries.map(
          (entry) => Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: const Color(0xFFE7DDD6)),
              ),
            ),
            child: Row(
              children: [
                Expanded(child: _RowText(entry.kode)),
                Expanded(child: _RowText(entry.pembeli)),
                Expanded(child: _RowText(entry.detail)),
                Expanded(child: _RowText(entry.kasir)),
                Expanded(child: _RowText(entry.metode)),
                Expanded(child: _RowText(entry.total)),
                Expanded(child: _RowText(entry.tanggal)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: const [
            Text(
              'Menampilkan 1 sampai 9 dari 9 entri',
              style: TextStyle(fontSize: 10, color: Color(0xFF8F8079)),
            ),
            Spacer(),
            Text(
              '<<  Sebelumnya   1   Berikutnya  >>',
              style: TextStyle(fontSize: 10, color: Color(0xFF8F8079)),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            'Total Transaksi : Rp 390.000',
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 11,
              color: Color(0xFF3B1F1B),
            ),
          ),
        ),
      ],
    );
  }
}

class _HeaderText extends StatelessWidget {
  const _HeaderText(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w700,
        color: Color(0xFF3B1F1B),
      ),
    );
  }
}

class _RowText extends StatelessWidget {
  const _RowText(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 10,
        color: Color(0xFF5F5752),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: const [
          Icon(Icons.money_off, size: 48, color: Color(0xFFB79E92)),
          SizedBox(height: 10),
          Text(
            'Belum ada uang keluar',
            style: TextStyle(
              color: Color(0xFF8F8079),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
