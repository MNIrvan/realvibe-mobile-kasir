import 'dart:typed_data';

import 'package:excel/excel.dart' as ex;
import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';

import '../../feature/laporan/laporan_model.dart';

class FormLaporanCetak extends StatelessWidget {
  const FormLaporanCetak({
    super.key,
    required this.title,
    required this.entries,
  });

  final String title;
  final List<LaporanModel> entries;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Container(
        width: 420,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(28),
              blurRadius: 20,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Spacer(),
                InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  borderRadius: BorderRadius.circular(8),
                  child: const Padding(
                    padding: EdgeInsets.all(2),
                    child: Icon(Icons.close, size: 18, color: Color(0xFF8F1A1A)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            const Text(
              'LAPORAN PENJUALAN',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 13,
                color: Color(0xFF3B1F1B),
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Real Cafe Jatiroto',
              style: TextStyle(
                fontSize: 10,
                color: Color(0xFF8F8079),
              ),
            ),
            const SizedBox(height: 10),
            _SummaryRow(),
            const SizedBox(height: 10),
            _ExcelTable(entries: entries),
            const SizedBox(height: 10),
            Row(
              children: const [
                Text(
                  'TOTAL TRANSAKSI: 19',
                  style: TextStyle(
                    fontSize: 9,
                    color: Color(0xFF6F6561),
                  ),
                ),
                Spacer(),
                Text(
                  'TOTAL PENJUALAN: Rp 338.000',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF3B1F1B),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: InkWell(
                onTap: () async {
                  await _downloadExcel(title, entries);
                  if (context.mounted) {
                    showDialog(
                      context: context,
                      builder: (_) => const _DownloadSuccessDialog(),
                    );
                  }
                },
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2A53A),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.download, size: 14, color: Color(0xFF4A2B14)),
                      SizedBox(width: 6),
                      Text(
                        'UNDUH',
                        style: TextStyle(
                          color: Color(0xFF4A2B14),
                          fontWeight: FontWeight.w700,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _downloadExcel(String title, List<LaporanModel> entries) async {
    final excel = ex.Excel.createExcel();
    final sheet = excel['Laporan'];
    sheet.appendRow([
      ex.TextCellValue('Kode Pesanan'),
      ex.TextCellValue('Nama Pembeli'),
      ex.TextCellValue('Detail Pesanan'),
      ex.TextCellValue('Nama Kasir'),
      ex.TextCellValue('Metode'),
      ex.TextCellValue('Total Transaksi'),
      ex.TextCellValue('Tanggal Transaksi'),
    ]);
    for (final e in entries) {
      sheet.appendRow([
        ex.TextCellValue(e.kode),
        ex.TextCellValue(e.pembeli),
        ex.TextCellValue(e.detail),
        ex.TextCellValue(e.kasir),
        ex.TextCellValue(e.metode),
        ex.TextCellValue(e.total),
        ex.TextCellValue(e.tanggal),
      ]);
    }
    final bytes = excel.save();
    if (bytes == null) return;
    final data = Uint8List.fromList(bytes);
    await FileSaver.instance.saveFile(
      name: 'laporan_${title.toLowerCase().replaceAll(' ', '_')}',
      bytes: data,
      ext: 'xlsx',
      mimeType: MimeType.microsoftExcel,
    );
  }
}

class _SummaryRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F2EF),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          _SummaryItem(label: 'TOTAL TRANSAKSI', value: '19'),
          _SummaryItem(label: 'PESANAN TUNAI', value: '28'),
          _SummaryItem(label: 'TOTAL TUNAI', value: 'Rp 0'),
          _SummaryItem(label: 'NON TUNAI', value: 'Rp 338.000'),
        ],
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  const _SummaryItem({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 8,
            color: Color(0xFF8F8079),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w700,
            color: Color(0xFF3B1F1B),
          ),
        ),
      ],
    );
  }
}

class _ExcelTable extends StatelessWidget {
  const _ExcelTable({required this.entries});

  final List<LaporanModel> entries;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE0D2C8)),
      ),
      child: Column(
        children: [
          Container(
            color: const Color(0xFFF6F2EF),
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
            child: const Row(
              children: [
                Expanded(child: _HeaderCell('ID PESANAN')),
                Expanded(child: _HeaderCell('WAKTU')),
                Expanded(child: _HeaderCell('TIPE')),
                Expanded(child: _HeaderCell('KASIR')),
                Expanded(child: _HeaderCell('TOTAL BAYAR')),
              ],
            ),
          ),
          ...entries.map(
            (e) => Container(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: const Color(0xFFEAE0DA)),
                ),
              ),
              child: Row(
                children: [
                  Expanded(child: _RowCell(e.kode)),
                  Expanded(child: _RowCell(e.tanggal)),
                  Expanded(child: _RowCell(e.metode)),
                  Expanded(child: _RowCell(e.kasir)),
                  Expanded(child: _RowCell(e.total)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderCell extends StatelessWidget {
  const _HeaderCell(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 8,
        fontWeight: FontWeight.w700,
        color: Color(0xFF3B1F1B),
      ),
    );
  }
}

class _RowCell extends StatelessWidget {
  const _RowCell(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 8,
        color: Color(0xFF6F6561),
      ),
    );
  }
}

class _DownloadSuccessDialog extends StatelessWidget {
  const _DownloadSuccessDialog();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 220,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(24),
              blurRadius: 16,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Spacer(),
                InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  borderRadius: BorderRadius.circular(8),
                  child: const Padding(
                    padding: EdgeInsets.all(2),
                    child: Icon(Icons.close, size: 18, color: Color(0xFF8F1A1A)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            const Icon(Icons.download, size: 42, color: Color(0xFF8F1A1A)),
            const SizedBox(height: 10),
            const Text(
              'FILE LAPORAN\nBERHASIL DI UNDUH',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: Color(0xFF3B1F1B),
              ),
            ),
            const SizedBox(height: 12),
            InkWell(
              onTap: () => Navigator.of(context).pop(),
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF8F1A1A),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Oke',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
