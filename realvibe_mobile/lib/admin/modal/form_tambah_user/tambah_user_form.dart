import 'package:flutter/material.dart';
import '../../feature/users/user_service.dart';

class TambahUserForm extends StatefulWidget {
  const TambahUserForm({super.key});

  @override
  State<TambahUserForm> createState() => _TambahUserFormState();
}

class _TambahUserFormState extends State<TambahUserForm> {
  final UserService _service = UserService();
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _isLoading = false;

  Future<void> _submit() async {
    setState(() => _isLoading = true);
    try {
      await _service.addUser({
        'name': _nameController.text,
        'username': _usernameController.text,
        'password': _passwordController.text,
        'phone': _phoneController.text,
        'role': 'kasir',
      });
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      debugPrint('Failed to add user: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final id = 'RV001';
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Container(
        width: 320,
        decoration: BoxDecoration(
          color: const Color(0xFF8F1A1A),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(24),
              blurRadius: 20,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: const BoxDecoration(
                color: Color(0xFFA32020),
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'TAMBAH USER',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    borderRadius: BorderRadius.circular(10),
                    child: const Padding(
                      padding: EdgeInsets.all(6),
                      child: Icon(Icons.close, color: Colors.white, size: 16),
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              height: 64,
              width: 64,
              decoration: const BoxDecoration(
                color: Color(0xFFB13A2C),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.person, color: Colors.white, size: 28),
            ),
            const SizedBox(height: 6),
            const Text(
              '+ Foto Profil',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 11,
              ),
            ),
            const SizedBox(height: 12),
            const _FieldLabel(text: 'ID'),
            _InputField(
              readOnly: true,
              initialValue: id,
              hintText: id,
            ),
            const SizedBox(height: 10),
            const _FieldLabel(text: 'Nama'),
            _InputField(controller: _nameController, hintText: 'Contoh: Rina Pratama'),
            const SizedBox(height: 10),
            const _FieldLabel(text: 'Username'),
            _InputField(controller: _usernameController, hintText: 'Contoh: rina.p'),
            const SizedBox(height: 10),
            const _FieldLabel(text: 'Password'),
            _InputField(
              controller: _passwordController,
              hintText: 'Contoh: ********',
              obscureText: true,
            ),
            const SizedBox(height: 10),
            const _FieldLabel(text: 'No. Telp'),
            _InputField(controller: _phoneController, hintText: 'Contoh: 0812-3344-2211'),
            const SizedBox(height: 14),
            Align(
              alignment: Alignment.centerRight,
              child: InkWell(
                onTap: _isLoading ? null : _submit,
                child: Container(
                  margin: const EdgeInsets.only(right: 16, bottom: 16),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2A53A),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: _isLoading 
                    ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Text(
                    'SIMPAN',
                    style: TextStyle(
                      color: Color(0xFF4A2B14),
                      fontWeight: FontWeight.w700,
                      fontSize: 11,
                    ),
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

class _FieldLabel extends StatelessWidget {
  const _FieldLabel({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
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
    this.hintText,
    this.obscureText = false,
    this.readOnly = false,
    this.initialValue,
    this.controller,
  });

  final String? hintText;
  final bool obscureText;
  final bool readOnly;
  final String? initialValue;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        readOnly: readOnly,
        controller: controller ?? (initialValue == null
            ? null
            : TextEditingController(text: initialValue)),
        obscureText: obscureText,
        decoration: InputDecoration(
          isDense: true,
          hintText: hintText,
          hintStyle: const TextStyle(
            fontSize: 12,
            color: Color(0xFFB0B0B0),
            fontWeight: FontWeight.w400,
          ),
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
