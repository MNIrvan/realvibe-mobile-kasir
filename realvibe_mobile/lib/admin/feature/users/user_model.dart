class UserModel {
  final int id;
  final String name;
  final String username;
  final String phone;
  final String role;

  UserModel({
    required this.id,
    required this.name,
    required this.username,
    required this.phone,
    required this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      username: json['username'] ?? '',
      phone: json['phone'] ?? '-',
      role: json['role'] ?? 'kasir',
    );
  }
}
