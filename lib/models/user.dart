import 'address.dart';
import 'user_scheme.dart';

enum UserStatus { active, inactive }

class User {
  final String id;
  final String name;
  final String mobileNumber;
  final Address permanentAddress;
  final Address? temporaryAddress;
  final String serialNumber;
  final String? selectedScheme;
  final UserStatus status;
  final DateTime createdAt;
  final List<UserScheme> schemes;

  User({
    required this.id,
    required this.name,
    required this.mobileNumber,
    required this.permanentAddress,
    this.temporaryAddress,
    required this.serialNumber,
    this.selectedScheme,
    required this.status,
    required this.createdAt,
    required this.schemes,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      mobileNumber: json['mobileNumber'] ?? '',
      permanentAddress: Address.fromJson(json['permanentAddress'] ?? {}),
      temporaryAddress: json['temporaryAddress'] != null
          ? Address.fromJson(json['temporaryAddress'])
          : null,
      serialNumber: json['serialNumber'] ?? json['employeeId'] ?? 'c_01',
      selectedScheme: json['selectedScheme'],
      status: UserStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
        orElse: () => UserStatus.active,
      ),
      createdAt: DateTime.parse(json['createdAt']),
      schemes:
          (json['schemes'] as List<dynamic>?)
              ?.map((scheme) => UserScheme.fromJson(scheme))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'mobileNumber': mobileNumber,
      'permanentAddress': permanentAddress.toJson(),
      'temporaryAddress': temporaryAddress?.toJson(),
      'serialNumber': serialNumber,
      'selectedScheme': selectedScheme,
      'status': status.toString().split('.').last,
      'createdAt': createdAt.toIso8601String(),
      'schemes': schemes.map((scheme) => scheme.toJson()).toList(),
    };
  }

  User copyWith({
    String? id,
    String? name,
    String? mobileNumber,
    Address? permanentAddress,
    Address? temporaryAddress,
    String? serialNumber,
    String? selectedScheme,
    UserStatus? status,
    DateTime? createdAt,
    List<UserScheme>? schemes,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      permanentAddress: permanentAddress ?? this.permanentAddress,
      temporaryAddress: temporaryAddress ?? this.temporaryAddress,
      serialNumber: serialNumber ?? this.serialNumber,
      selectedScheme: selectedScheme ?? this.selectedScheme,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      schemes: schemes ?? this.schemes,
    );
  }
}
