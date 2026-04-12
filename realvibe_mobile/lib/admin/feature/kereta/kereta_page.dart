import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../modal/form_kereta/form_kereta.dart';

class KeretaPage extends StatefulWidget {
  const KeretaPage({super.key, required this.isMobile});

  final bool isMobile;

  @override
  State<KeretaPage> createState() => _KeretaPageState();
}

class _KeretaPageState extends State<KeretaPage> {
  Uint8List? _imageBytes;

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
                      imageBytes: _imageBytes,
                      onTap: _openForm,
                    ),
                    const SizedBox(height: 16),
                    const _SaveButton(),
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
    required this.onTap,
  });

  final Uint8List? imageBytes;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
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
        child: imageBytes == null
            ? const Column(
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
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.memory(
                  imageBytes!,
                  fit: BoxFit.cover,
                ),
              ),
      ),
    );
  }
}

extension on _KeretaPageState {
  Future<void> _openForm() async {
    final result = await showDialog<Uint8List>(
      context: context,
      builder: (_) => FormKereta(initialImage: _imageBytes),
    );
    if (result != null && mounted) {
      setState(() {
        _imageBytes = result;
      });
    }
  }
}

class _SaveButton extends StatelessWidget {
  const _SaveButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF8F1A1A),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Center(
        child: Text(
          'Ganti Gambar',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
