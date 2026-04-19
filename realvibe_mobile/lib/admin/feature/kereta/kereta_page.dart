import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../modal/form_kereta/form_kereta.dart';
import 'kereta_service.dart';

class KeretaPage extends StatefulWidget {
  const KeretaPage({super.key, required this.isMobile});

  final bool isMobile;

  @override
  State<KeretaPage> createState() => _KeretaPageState();
}

class _KeretaPageState extends State<KeretaPage> {
  PickedKeretaImage? _pickedImage;
  String? _serverImageUrl;
  int? _keretaId;
  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadKereta();
  }

  Future<void> _loadKereta() async {
    try {
      final kereta = await KeretaService.fetchFirstKereta();
      if (!mounted) return;
      setState(() {
        _keretaId = kereta?.id;
        _serverImageUrl = kereta?.gambarUrl;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _saveImage() async {
    if (_pickedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih gambar terlebih dahulu.')),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final result = _keretaId == null
          ? await KeretaService.createKeretaFoto(
              imageBytes: _pickedImage!.bytes,
              imageFileName: _pickedImage!.fileName,
            )
          : await KeretaService.uploadKeretaFoto(
              id: _keretaId!,
              imageBytes: _pickedImage!.bytes,
              imageFileName: _pickedImage!.fileName,
            );

      if (!mounted) return;
      setState(() {
        _keretaId = result.id;
        _serverImageUrl = result.gambarUrl;
        _pickedImage = null;
        _isSaving = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Foto jadwal berhasil disimpan.')),
      );
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _isSaving = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyimpan gambar: $error')),
      );
    }
  }

  Future<void> _openForm() async {
    final result = await showDialog<PickedKeretaImage>(
      context: context,
      builder: (_) => FormKereta(
        initialImage: _pickedImage?.bytes,
        initialFileName: _pickedImage?.fileName,
      ),
    );
    if (result != null && mounted) {
      setState(() {
        _pickedImage = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = widget.isMobile;

    return Stack(
      children: [
        SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 16 : 24,
            vertical: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _KeretaHeader(isMobile: isMobile),
              const SizedBox(height: 18),
              const _KeretaTitle(),
              const SizedBox(height: 18),
              Center(
                child: Column(
                  children: [
                    _UploadCard(
                      imageBytes: _pickedImage?.bytes,
                      serverImageUrl: _serverImageUrl,
                      isLoading: _isLoading,
                      onTap: _openForm,
                    ),
                    const SizedBox(height: 16),
                    _SaveButton(
                      onTap: _saveImage,
                      enabled: !_isSaving && _pickedImage != null,
                      isSaving: _isSaving,
                    ),
                  ],
                ),
              ),
              SizedBox(height: isMobile ? 160 : 220),
            ],
          ),
        ),
        Positioned(
          right: isMobile ? 32 : 56,
          bottom: isMobile ? 40 : 56,
          child: Image.asset(
            'assets/icons/maskot.png',
            width: isMobile ? 100 : 140,
          ),
        ),
      ],
    );
  }
}

class _KeretaHeader extends StatelessWidget {
  const _KeretaHeader({required this.isMobile});

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
          if (!isMobile) SizedBox(width: 320, child: _SearchBar()),
        ],
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320,
      child: TextField(
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

class _KeretaTitle extends StatelessWidget {
  const _KeretaTitle();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(left: 20),
      child: Text(
        'Jadwal Kereta',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: Color(0xFF3B1F1B),
        ),
      ),
    );
  }
}

class _UploadCard extends StatelessWidget {
  const _UploadCard({
    required this.imageBytes,
    required this.serverImageUrl,
    required this.isLoading,
    required this.onTap,
  });

  final Uint8List? imageBytes;
  final String? serverImageUrl;
  final bool isLoading;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    Widget content;

    if (isLoading) {
      content = const Center(
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      );
    } else if (imageBytes != null) {
      content = ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.memory(
          imageBytes!,
          fit: BoxFit.cover,
        ),
      );
    } else if (serverImageUrl != null) {
      content = ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.network(
          serverImageUrl!,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => const Center(
            child: Icon(Icons.broken_image, color: Colors.white, size: 34),
          ),
          loadingBuilder: (_, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            );
          },
        ),
      );
    } else {
      content = const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.photo_camera, color: Colors.white, size: 34),
          SizedBox(height: 8),
          Text(
            '+ Tambah Foto',
            style: TextStyle(
              fontSize: 12,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      );
    }

    return Container(
      width: 560,
      height: 440,
      decoration: BoxDecoration(
        color: const Color(0xFF8F1A1A),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(12),
            blurRadius: 16,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: content,
      ),
    );
  }
}

class _SaveButton extends StatelessWidget {
  const _SaveButton({
    required this.onTap,
    required this.enabled,
    required this.isSaving,
  });

  final VoidCallback onTap;
  final bool enabled;
  final bool isSaving;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 120,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: enabled ? const Color(0xFF8F1A1A) : const Color(0xFFB29B99),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: isSaving
              ? const SizedBox(
                  height: 16,
                  width: 16,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : const Text(
                  'Ganti Gambar',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
        ),
      ),
    );
  }
}
