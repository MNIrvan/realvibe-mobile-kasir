import 'package:flutter/material.dart';

import 'cashier_models.dart';
import 'cashier_service.dart';

class RevenueDashboard extends StatefulWidget {
  const RevenueDashboard({super.key, required this.cashierUser});

  final CashierUser cashierUser;

  @override
  State<RevenueDashboard> createState() => _RevenueDashboardState();
}

enum _KasirTab { bukaKasir, tutupKasir, produk, cetak }

class _RevenueDashboardState extends State<RevenueDashboard> {
  static const Color _primary = Color(0xFFB5270E);
  static const Color _deep = Color(0xFF632117);
  static const Color _bg = Color(0xFFE6E1D5);

  _KasirTab _activeTab = _KasirTab.bukaKasir;
  CashierSession? _activeSession;
  bool _loading = false;

  final TextEditingController _openingBalanceController =
      TextEditingController(text: '0');
  final TextEditingController _cashPaymentController =
      TextEditingController(text: '0');
  final TextEditingController _nonCashPaymentController =
      TextEditingController(text: '0');

  @override
  void initState() {
    super.initState();
    _loadActiveSession();
  }

  @override
  void dispose() {
    _openingBalanceController.dispose();
    _cashPaymentController.dispose();
    _nonCashPaymentController.dispose();
    super.dispose();
  }

  Future<void> _loadActiveSession() async {
    setState(() => _loading = true);
    try {
      final session = await CashierService.getActiveSession(
        userId: widget.cashierUser.id,
      );
      if (!mounted) return;
      setState(() {
        _activeSession = session;
      });
    } catch (e) {
      if (!mounted) return;
      _showSnack('Error: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _openKasir() async {
    final openingBalance = _toDouble(_openingBalanceController.text);
    if (openingBalance < 0) {
      _showSnack('Saldo awal tidak valid');
      return;
    }

    setState(() => _loading = true);
    try {
      final session = await CashierService.openSession(
        userId: widget.cashierUser.id,
        openingBalance: openingBalance,
      );
      if (!mounted) return;
      setState(() {
        _activeSession = session;
      });
      _showSnack('Kasir berhasil dibuka');
    } catch (e) {
      if (!mounted) return;
      _showSnack('Gagal buka kasir: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _addOrEditEntry({CashierSessionEntry? entry}) async {
    final session = _activeSession;
    if (session == null) {
      _showSnack('Buka kasir dulu');
      return;
    }

    final titleController = TextEditingController(text: entry?.title ?? '');
    final amountController = TextEditingController(
      text: entry != null ? entry.amount.toStringAsFixed(0) : '',
    );
    final notesController = TextEditingController(text: entry?.notes ?? '');

    final isSaved = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(entry == null ? 'Tambah Uang Masuk' : 'Edit Uang Masuk'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Judul'),
              ),
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Nominal'),
              ),
              TextField(
                controller: notesController,
                decoration: const InputDecoration(labelText: 'Catatan'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );

    if (isSaved != true) return;

    final title = titleController.text.trim();
    final amount = _toDouble(amountController.text);
    final notes = notesController.text.trim().isEmpty
        ? null
        : notesController.text.trim();

    if (title.isEmpty || amount <= 0) {
      _showSnack('Judul dan nominal wajib diisi');
      return;
    }

    setState(() => _loading = true);
    try {
      if (entry == null) {
        await CashierService.addEntry(
          sessionId: session.id,
          entryType: 'in',
          title: title,
          amount: amount,
          notes: notes,
        );
      } else {
        await CashierService.updateEntry(
          sessionId: session.id,
          entryId: entry.id,
          title: title,
          amount: amount,
          notes: notes,
        );
      }

      await _loadActiveSession();
      _showSnack('Data kas disimpan');
    } catch (e) {
      _showSnack('Gagal simpan data kas: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _deleteEntry(CashierSessionEntry entry) async {
    final session = _activeSession;
    if (session == null) return;

    setState(() => _loading = true);
    try {
      await CashierService.deleteEntry(sessionId: session.id, entryId: entry.id);
      await _loadActiveSession();
      _showSnack('Entry dihapus');
    } catch (e) {
      _showSnack('Gagal hapus entry: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _closeKasir() async {
    final session = _activeSession;
    if (session == null) {
      _showSnack('Tidak ada sesi kasir aktif');
      return;
    }

    final cashPayment = _toDouble(_cashPaymentController.text);
    final nonCashPayment = _toDouble(_nonCashPaymentController.text);

    setState(() => _loading = true);
    try {
      await CashierService.closeSession(
        sessionId: session.id,
        totalCashPayment: cashPayment,
        totalNonCashPayment: nonCashPayment,
      );
      if (!mounted) return;
      setState(() {
        _activeSession = null;
      });
      _showSnack('Kasir ditutup');
    } catch (e) {
      _showSnack('Gagal tutup kasir: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : LayoutBuilder(
                      builder: (context, constraints) {
                        final isMobile = constraints.maxWidth < 760;
                        return SingleChildScrollView(
                          padding: EdgeInsets.all(isMobile ? 12 : 24),
                          child: isMobile
                              ? Column(
                                  children: [
                                    _buildTabBar(isMobile),
                                    const SizedBox(height: 14),
                                    _buildContent(isMobile),
                                  ],
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildTabBar(isMobile),
                                    const SizedBox(height: 18),
                                    _buildContent(isMobile),
                                  ],
                                ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: _primary,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        children: [
          const Icon(Icons.arrow_back, color: Colors.white),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _activeTab == _KasirTab.tutupKasir ? 'Tutup Kasir' : 'Buka Kasir',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 34,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    widget.cashierUser.name,
                    style: const TextStyle(fontSize: 11),
                  ),
                ),
              ],
            ),
          ),
          const Text(
            'Real-Vibe',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontStyle: FontStyle.italic,
              fontSize: 42,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar(bool isMobile) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        _tabChip(_KasirTab.bukaKasir, 'Buka Kasir', Icons.lock_open),
        _tabChip(_KasirTab.tutupKasir, 'Tutup Kasir', Icons.lock),
        _tabChip(_KasirTab.produk, 'Produk', Icons.sell_outlined),
        _tabChip(_KasirTab.cetak, 'Cetak', Icons.print),
      ],
    );
  }

  Widget _tabChip(_KasirTab tab, String text, IconData icon) {
    final active = _activeTab == tab;
    return InkWell(
      onTap: () => setState(() => _activeTab = tab),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: active ? const Color(0xFFD0D0D0) : const Color(0xFFE9E9E9),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16),
            const SizedBox(width: 6),
            Text(text, style: const TextStyle(fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(bool isMobile) {
    switch (_activeTab) {
      case _KasirTab.bukaKasir:
        return _buildBukaKasir(isMobile);
      case _KasirTab.tutupKasir:
        return _buildTutupKasir(isMobile);
      case _KasirTab.produk:
      case _KasirTab.cetak:
        return const _PlaceholderCard();
    }
  }

  Widget _buildBukaKasir(bool isMobile) {
    final session = _activeSession;
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 760),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _dateCard(),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: _deep,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Uang Masuk',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                ),
                Text(
                  _idr(session?.totalCashIn ?? 0),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 42,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          if (session == null)
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _openingBalanceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      labelText: 'Saldo Awal',
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _openKasir,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: const Text('Buka Kasir'),
                ),
              ],
            )
          else
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: session.entries.isEmpty
                        ? null
                        : () => _addOrEditEntry(entry: session.entries.first),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF2E418),
                      foregroundColor: Colors.white,
                    ),
                    icon: const Icon(Icons.edit, size: 16),
                    label: const Text('Edit'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _addOrEditEntry(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E7E2E),
                      foregroundColor: Colors.white,
                    ),
                    icon: const Icon(Icons.note_add, size: 16),
                    label: const Text('Tambah'),
                  ),
                ),
              ],
            ),
          const SizedBox(height: 16),
          const Text(
            'Total Uang Masuk',
            style: TextStyle(
              color: Color(0xFFC92A09),
              fontSize: 34,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            color: const Color(0xFFF2E9DF),
            child: session == null || session.entries.isEmpty
                ? const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('Belum ada entry uang masuk'),
                  )
                : Column(
                    children: session.entries.asMap().entries.map((entryItem) {
                      final index = entryItem.key;
                      final entry = entryItem.value;
                      return Container(
                        padding: const EdgeInsets.all(12),
                        decoration: const BoxDecoration(
                          border: Border(bottom: BorderSide(color: Color(0xFFE0D3C4))),
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 24,
                              child: Text(
                                '${index + 1}',
                                style: const TextStyle(fontWeight: FontWeight.w700),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    entry.title,
                                    style: const TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    '${_time(entry.happenedAt)}, ${_date(entry.happenedAt)}\nKasir : ${widget.cashierUser.username}',
                                    style: const TextStyle(fontSize: 11),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                _idr(entry.amount),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            PopupMenuButton<String>(
                              onSelected: (value) {
                                if (value == 'edit') {
                                  _addOrEditEntry(entry: entry);
                                } else {
                                  _deleteEntry(entry);
                                }
                              },
                              itemBuilder: (context) => const [
                                PopupMenuItem(value: 'edit', child: Text('Edit')),
                                PopupMenuItem(value: 'delete', child: Text('Hapus')),
                              ],
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildTutupKasir(bool isMobile) {
    final session = _activeSession;
    if (session == null) {
      return const _EmptyStateCard(
        title: 'Belum Ada Sesi Aktif',
        subtitle: 'Buka kasir terlebih dahulu sebelum tutup kasir.',
      );
    }

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 760),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _dateCard(),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _deep,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Subtotal Keseluruhan',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                ),
                Text(
                  _idr(session.subtotal),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 48,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          GridView.count(
            crossAxisCount: isMobile ? 1 : 2,
            shrinkWrap: true,
            childAspectRatio: isMobile ? 3.5 : 2.0,
            mainAxisSpacing: 6,
            crossAxisSpacing: 6,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _metricCard('Uang Masuk', session.totalCashIn),
              _metricCard('Uang Keluar', session.totalCashOut),
              _inputMetricCard('Pembayaran Tunai', _cashPaymentController),
              _inputMetricCard('Pembayaran Non Tunai', _nonCashPaymentController),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => setState(() => _activeTab = _KasirTab.bukaKasir),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF2E418),
                    foregroundColor: Colors.white,
                  ),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Kembali'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _closeKasir,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E7E2E),
                    foregroundColor: Colors.white,
                  ),
                  icon: const Icon(Icons.save),
                  label: const Text('Simpan'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _metricCard(String title, double value) {
    return Container(
      padding: const EdgeInsets.all(12),
      color: const Color(0xFFEFEFEF),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 28)),
          const SizedBox(height: 6),
          Center(
            child: Text(
              _idr(value),
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }

  Widget _inputMetricCard(String title, TextEditingController controller) {
    return Container(
      padding: const EdgeInsets.all(12),
      color: const Color(0xFFEFEFEF),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 28)),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              prefixText: 'Rp ',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _dateCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: _primary,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          const Icon(Icons.calendar_month, color: Colors.white),
          const SizedBox(width: 8),
          Text(
            _date(DateTime.now()),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 34,
            ),
          ),
        ],
      ),
    );
  }

  String _idr(double value) {
    final normalized = value.round();
    final text = normalized
        .toString()
        .replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.');
    return 'Rp $text';
  }

  String _date(DateTime dateTime) {
    const months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    return '${dateTime.day} ${months[dateTime.month - 1]} ${dateTime.year}';
  }

  String _time(DateTime dateTime) {
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  double _toDouble(String text) {
    final sanitized = text.replaceAll('.', '').replaceAll(',', '.').trim();
    return double.tryParse(sanitized) ?? 0;
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}

class _PlaceholderCard extends StatelessWidget {
  const _PlaceholderCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Text(
        'Fitur ini disiapkan sebagai placeholder sesuai scope saat ini.',
        style: TextStyle(fontSize: 16),
      ),
    );
  }
}

class _EmptyStateCard extends StatelessWidget {
  const _EmptyStateCard({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(subtitle),
        ],
      ),
    );
  }
}
