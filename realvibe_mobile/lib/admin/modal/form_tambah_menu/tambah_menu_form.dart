import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../feature/menu/menu_model.dart';
import '../../feature/menu/menu_service.dart';

class MenuForm extends StatefulWidget {
  const MenuForm({
    super.key,
    this.menuItem,
    required this.onSaved,
    this.title = 'TAMBAH MENU',
    this.isDialog = false,
  });

  final MenuItemInfo? menuItem;
  final VoidCallback onSaved;
  final String title;
  final bool isDialog;

  @override
  State<MenuForm> createState() => _MenuFormState();
}

class _MenuFormState extends State<MenuForm> {
  late TextEditingController _namaController;
  late TextEditingController _hargaController;
  int? _selectedKategoriId;
  late String _stok;
  Uint8List? _pickedImageBytes;
  String? _pickedImageName;
  bool _isSaving = false;
  final ImagePicker _picker = ImagePicker();

  List<KategoriMenuInfo> _kategoriList = [];
  bool _isLoadingKategori = true;

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(text: widget.menuItem?.namaMenu ?? '');
    _hargaController = TextEditingController(text: widget.menuItem?.harga.toStringAsFixed(0) ?? '');
    _selectedKategoriId = widget.menuItem?.idKategoriMenu;
    _stok = widget.menuItem?.stok ?? 'tersedia';
    _fetchKategori();
  }

  Future<void> _fetchKategori() async {
    try {
      final list = await MenuService.fetchKategoriMenu();
      if (mounted) {
        setState(() {
          _kategoriList = list;
          _isLoadingKategori = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingKategori = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memuat kategori: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _hargaController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final selectedImage = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (selectedImage != null) {
      final bytes = await selectedImage.readAsBytes();
      if (mounted) {
        setState(() {
          _pickedImageBytes = bytes;
          _pickedImageName = selectedImage.name;
        });
      }
    }
  }

  Future<void> _saveMenu() async {
    final namaMenu = _namaController.text.trim();
    final harga = double.tryParse(_hargaController.text.trim()) ?? -1;
    final idKategori = _selectedKategoriId ?? -1;

    if (namaMenu.isEmpty || idKategori <= 0 || harga < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mohon isi semua field dengan benar'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final messenger = ScaffoldMessenger.of(context);
    setState(() {
      _isSaving = true;
    });

    try {
      if (widget.menuItem == null) {
        await MenuService.createMenu(
          namaMenu: namaMenu,
          idKategoriMenu: idKategori,
          harga: harga,
          stok: _stok,
          imageBytes: _pickedImageBytes,
          imageFileName: _pickedImageName,
        );
        messenger.showSnackBar(
          const SnackBar(
            content: Text('Menu berhasil ditambahkan'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        await MenuService.updateMenu(
          id: widget.menuItem!.id,
          namaMenu: namaMenu,
          idKategoriMenu: idKategori,
          harga: harga,
          stok: _stok,
          imageBytes: _pickedImageBytes,
          imageFileName: _pickedImageName,
        );
        messenger.showSnackBar(
          const SnackBar(
            content: Text('Menu berhasil diperbarui'),
            backgroundColor: Colors.green,
          ),
        );
      }

      widget.onSaved();
      if (mounted && widget.isDialog) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menyimpan menu: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  Widget _buildImagePreview() {
    if (_pickedImageBytes != null) {
      return ClipOval(
        child: Image.memory(
          _pickedImageBytes!,
          fit: BoxFit.cover,
          width: 80,
          height: 80,
        ),
      );
    }

    if (widget.menuItem != null && widget.menuItem!.hasServerImage) {
      return ClipOval(
        child: Image.network(
          widget.menuItem!.gambarUrl,
          fit: BoxFit.cover,
          width: 80,
          height: 80,
          errorBuilder: (_, __, ___) => const Icon(Icons.photo_camera, color: Colors.white, size: 30),
        ),
      );
    }

    return const Icon(Icons.photo_camera, color: Colors.white, size: 30);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      decoration: BoxDecoration(
        color: const Color(0xFF8F1A1A),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(20),
            blurRadius: 18,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: const BoxDecoration(
                color: Color(0xFFA32020),
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              ),
              child: Center(
                child: Text(
                  widget.menuItem == null ? 'TAMBAH MENU' : 'EDIT MENU',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Material(
              color: Colors.transparent,
              shape: const CircleBorder(),
              child: InkWell(
                onTap: _pickImage,
                customBorder: const CircleBorder(),
                child: Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                    color: const Color(0xFFB13A2C),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white.withAlpha(50), width: 2),
                  ),
                  child: Center(child: _buildImagePreview()),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _pickedImageName ?? 'Unggah Foto',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 11,
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: _pickImage,
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: const Color(0xFFB13A2C),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              ),
              child: const Text('Pilih Gambar'),
            ),
            const SizedBox(height: 16),
            _FieldLabel(text: 'Nama Menu'),
            _InputField(controller: _namaController, hintText: 'Masukkan nama menu'),
            const SizedBox(height: 12),
            _FieldLabel(text: 'Kategori'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: _isLoadingKategori
                    ? const Padding(
                        padding: EdgeInsets.symmetric(vertical: 14),
                        child: SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF8F1A1A)),
                        ),
                      )
                    : DropdownButtonHideUnderline(
                        child: DropdownButton<int>(
                          value: _kategoriList.any((k) => k.id == _selectedKategoriId) ? _selectedKategoriId : null,
                          isExpanded: true,
                          hint: const Text('Pilih Kategori', style: TextStyle(fontSize: 13, color: Colors.grey)),
                          items: _kategoriList.map((KategoriMenuInfo kategori) {
                            return DropdownMenuItem<int>(
                              value: kategori.id,
                              child: Text(kategori.namaKategori, style: const TextStyle(fontSize: 13)),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) setState(() => _selectedKategoriId = val);
                          },
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 12),
            _FieldLabel(text: 'Harga (Rp)'),
            _InputField(controller: _hargaController, hintText: '15000', keyboardType: TextInputType.number),
            const SizedBox(height: 12),
            _FieldLabel(text: 'Status Stok'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _stok,
                    isExpanded: true,
                    items: ['tersedia', 'habis'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _stok = val);
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
              child: Row(
                children: [
                  if (widget.menuItem != null)
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('BATAL', style: TextStyle(color: Colors.white70)),
                      ),
                    ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isSaving ? null : _saveMenu,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF2A53A),
                        foregroundColor: const Color(0xFF4A2B14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        elevation: 0,
                      ),
                      child: Text(
                        _isSaving ? 'MENYIMPAN...' : 'SIMPAN',
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TambahMenuFormCard extends StatelessWidget {
  const TambahMenuFormCard({
    super.key,
    required this.onSaved,
  });

  final VoidCallback onSaved;

  @override
  Widget build(BuildContext context) {
    return MenuForm(onSaved: onSaved);
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  const _InputField({
    required this.controller,
    required this.hintText,
    this.keyboardType = TextInputType.text,
  });

  final TextEditingController controller;
  final String hintText;
  final TextInputType keyboardType;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: const TextStyle(fontSize: 13),
        decoration: InputDecoration(
          isDense: true,
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey[400], fontSize: 13),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 10,
          ),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
