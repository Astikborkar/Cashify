/// User model representing the authenticated customer or staff member.
class UserModel {
  final String id;
  final String? phone;
  final String? email;
  final String fullName;
  final String? avatarUrl;
  final String role;
  final bool isPhoneVerified;
  final DateTime createdAt;

  const UserModel({
    required this.id,
    this.phone,
    this.email,
    required this.fullName,
    this.avatarUrl,
    this.role = 'customer',
    this.isPhoneVerified = false,
    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      fullName: (json['full_name'] as String?) ?? 'Cashify Customer',
      avatarUrl: json['avatar_url'] as String?,
      role: (json['role'] as String?) ?? 'customer',
      isPhoneVerified: (json['is_phone_verified'] as bool?) ?? false,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phone': phone,
      'email': email,
      'full_name': fullName,
      'avatar_url': avatarUrl,
      'role': role,
      'is_phone_verified': isPhoneVerified,
      'created_at': createdAt.toIso8601String(),
    };
  }

  UserModel copyWith({
    String? id,
    String? phone,
    String? email,
    String? fullName,
    String? avatarUrl,
    String? role,
    bool? isPhoneVerified,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      role: role ?? this.role,
      isPhoneVerified: isPhoneVerified ?? this.isPhoneVerified,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
