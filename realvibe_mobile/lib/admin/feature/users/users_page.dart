import 'package:flutter/material.dart';

import '../../modal/form_tambah_user/tambah_user_form.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({
    super.key,
    required this.isMobile,
    this.onOpenDrawer,
  });

  final bool isMobile;
  final VoidCallback? onOpenDrawer;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 24,
        vertical: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _UsersHeader(isMobile: isMobile, onOpenDrawer: onOpenDrawer),
          const SizedBox(height: 18),
          Row(
            children: [
              const Text(
                'Daftar Users',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF3B1F1B),
                ),
              ),
              const Spacer(),
              InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (_) => const TambahUserForm(),
                  );
                },
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF8F1A1A),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.person_add, color: Colors.white, size: 16),
                      SizedBox(width: 6),
                      Text(
                        'Tambah User',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _UsersTable(isMobile: isMobile),
        ],
      ),
    );
  }
}

class _UsersHeader extends StatelessWidget {
  const _UsersHeader({required this.isMobile, this.onOpenDrawer});

  final bool isMobile;
  final VoidCallback? onOpenDrawer;

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
          if (onOpenDrawer != null)
            IconButton(
              constraints: const BoxConstraints(),
              padding: EdgeInsets.zero,
              onPressed: onOpenDrawer,
              icon: const Icon(Icons.menu, color: Color(0xFF8E1C1C), size: 20),
            ),
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
          if (!isMobile) const _HeaderSearch(),
        ],
      ),
    );
  }
}

class _HeaderSearch extends StatelessWidget {
  const _HeaderSearch();

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

class _UsersTable extends StatelessWidget {
  const _UsersTable({required this.isMobile});

  final bool isMobile;

  @override
  Widget build(BuildContext context) {
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
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFF6F2EF),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Row(
              children: [
                Expanded(child: _HeaderText('ID')),
                Expanded(child: _HeaderText('Nama')),
                Expanded(child: _HeaderText('Username')),
                Expanded(child: _HeaderText('Password')),
                Expanded(child: _HeaderText('No. Telp')),
              ],
            ),
          ),
          const SizedBox(height: 6),
          ..._users
              .map(
                (u) => Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Color(0xFFE7DDD6)),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(child: _RowText(u.id)),
                      Expanded(
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 10,
                              backgroundColor: const Color(0xFFF2E2D8),
                              child: Text(
                                u.name.characters.first,
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF8F1A1A),
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Expanded(child: _RowText(u.name)),
                          ],
                        ),
                      ),
                      Expanded(child: _RowText(u.username)),
                      Expanded(child: _RowText('••••••')),
                      Expanded(child: _RowText(u.phone)),
                    ],
                  ),
                ),
              )
              .toList(),
        ],
      ),
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

class _UserRow {
  const _UserRow({
    required this.id,
    required this.name,
    required this.username,
    required this.phone,
  });

  final String id;
  final String name;
  final String username;
  final String phone;
}

const List<_UserRow> _users = [
  _UserRow(
    id: 'U001',
    name: 'Rina Pratama',
    username: 'rina.p',
    phone: '0812-3344-2211',
  ),
  _UserRow(
    id: 'U002',
    name: 'Andi Saputra',
    username: 'andi.s',
    phone: '0813-7788-9900',
  ),
  _UserRow(
    id: 'U003',
    name: 'Dewi Lestari',
    username: 'dewi.l',
    phone: '0821-6677-4455',
  ),
];
