class UserProfile {
  final String id;
  final String name;
  final String email;
  final String initials;
  final String gender;
  final double heightCm;
  final double weightKg;
  final bool profileCompleted;

  const UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.initials,
    required this.gender,
    required this.heightCm,
    required this.weightKg,
    required this.profileCompleted,
  });

  factory UserProfile.fromMap(String id, Map<String, dynamic> map) {
    return UserProfile(
      id: id,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      initials: map['initials'] ?? '',
      gender: map['gender'] ?? '',
      heightCm: (map['heightCm'] as num?)?.toDouble() ?? 0,
      weightKg: (map['weightKg'] as num?)?.toDouble() ?? 0,
      profileCompleted: map['profileCompleted'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'initials': initials,
      'gender': gender,
      'heightCm': heightCm,
      'weightKg': weightKg,
      'profileCompleted': profileCompleted,
    };
  }
}
