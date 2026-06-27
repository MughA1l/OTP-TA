class RolePermissionModel {
  final String role;
  final List<String> allowedModules;

  const RolePermissionModel({
    required this.role,
    this.allowedModules = const [],
  });

  factory RolePermissionModel.fromMap(Map<String, dynamic> map, String docId) {
    return RolePermissionModel(
      role: docId, // Usually 'admin', 'doctor', 'receptionist', 'patient'
      allowedModules: List<String>.from(map['allowedModules'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'allowedModules': allowedModules,
    };
  }

  RolePermissionModel copyWith({
    String? role,
    List<String>? allowedModules,
  }) {
    return RolePermissionModel(
      role: role ?? this.role,
      allowedModules: allowedModules ?? this.allowedModules,
    );
  }
}
