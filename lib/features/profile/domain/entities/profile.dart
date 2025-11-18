import 'package:equatable/equatable.dart';
import 'user_role.dart';



class Profile extends Equatable {
  final String id;
  final String? email;
  final UserRole role;

  final String fullName;
  final String? phone;
  final String? city; 
  final String? governorate;
  final String? locality;
  final DateTime? dateOfBirth;
  final String? bio;
  final String? avatarUrl;

  final int yearsExperience;
  final List<String> certifications;
  final String? specialization;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Profile({
    required this.id,
    this.email,
    required this.role,
    required this.fullName,
    this.phone,
    this.city,
    this.governorate,
    this.locality,
    this.dateOfBirth,
    this.bio,
    this.avatarUrl,
    this.yearsExperience = 0,
    this.certifications = const [],
    this.specialization,
    this.createdAt,
    this.updatedAt,
  });

  
  bool get isProfessional => role == UserRole.professional;

  
  bool get isClient => role == UserRole.client;

  
  int? get age {
    if (dateOfBirth == null) return null;
    final now = DateTime.now();
    int age = now.year - dateOfBirth!.year;
    if (now.month < dateOfBirth!.month ||
        (now.month == dateOfBirth!.month && now.day < dateOfBirth!.day)) {
      age--;
    }
    return age;
  }

  
  bool get isComplete {
    final hasBasicInfo =
        fullName.isNotEmpty &&
        phone != null &&
        (governorate != null ||
            city != null); 
    if (!hasBasicInfo) return false;

    if (isProfessional) {
      return specialization != null && specialization!.isNotEmpty;
    }

    return true;
  }

  Profile copyWith({
    String? id,
    String? email,
    UserRole? role,
    String? fullName,
    String? phone,
    String? city,
    String? governorate,
    String? locality,
    DateTime? dateOfBirth,
    String? bio,
    String? avatarUrl,
    int? yearsExperience,
    List<String>? certifications,
    String? specialization,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Profile(
      id: id ?? this.id,
      email: email ?? this.email,
      role: role ?? this.role,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      city: city ?? this.city,
      governorate: governorate ?? this.governorate,
      locality: locality ?? this.locality,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      bio: bio ?? this.bio,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      yearsExperience: yearsExperience ?? this.yearsExperience,
      certifications: certifications ?? this.certifications,
      specialization: specialization ?? this.specialization,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    email,
    role,
    fullName,
    phone,
    city,
    governorate,
    locality,
    dateOfBirth,
    bio,
    avatarUrl,
    yearsExperience,
    certifications,
    specialization,
    createdAt,
    updatedAt,
  ];
}
