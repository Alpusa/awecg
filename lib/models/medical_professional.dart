import 'dart:convert';

class MedicalProfessional {
  String id;
  String fullName;
  String email;
  String phone;
  String address;
  String specialty;
  String place;

  MedicalProfessional({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.address,
    required this.specialty,
    required this.place,
  });

  MedicalProfessional copyWithId(String id) {
    return MedicalProfessional(
      id: id,
      fullName: this.fullName,
      email: this.email,
      phone: this.phone,
      address: this.address,
      specialty: this.specialty,
      place: this.place,
    );
  }

  MedicalProfessional copyWithFullName(String fullName) {
    return MedicalProfessional(
      id: this.id,
      fullName: fullName,
      email: this.email,
      phone: this.phone,
      address: this.address,
      specialty: this.specialty,
      place: this.place,
    );
  }

  MedicalProfessional copyWithEmail(String email) {
    return MedicalProfessional(
      id: this.id,
      fullName: this.fullName,
      email: email,
      phone: this.phone,
      address: this.address,
      specialty: this.specialty,
      place: this.place,
    );
  }

  MedicalProfessional copyWithPhone(String phone) {
    return MedicalProfessional(
      id: this.id,
      fullName: this.fullName,
      email: this.email,
      phone: phone,
      address: this.address,
      specialty: this.specialty,
      place: this.place,
    );
  }

  MedicalProfessional copyWithAddress(String address) {
    return MedicalProfessional(
      id: this.id,
      fullName: this.fullName,
      email: this.email,
      phone: this.phone,
      address: address,
      specialty: this.specialty,
      place: this.place,
    );
  }

  MedicalProfessional copyWithAge(String age) {
    return MedicalProfessional(
      id: this.id,
      fullName: this.fullName,
      email: this.email,
      phone: this.phone,
      address: this.address,
      specialty: this.specialty,
      place: this.place,
    );
  }

  MedicalProfessional copyWithSpecialty(String specialty) {
    return MedicalProfessional(
      id: this.id,
      fullName: this.fullName,
      email: this.email,
      phone: this.phone,
      address: this.address,
      specialty: specialty,
      place: this.place,
    );
  }

  MedicalProfessional copyWithPlace(String place) {
    return MedicalProfessional(
      id: this.id,
      fullName: this.fullName,
      email: this.email,
      phone: this.phone,
      address: this.address,
      specialty: this.specialty,
      place: place,
    );
  }

  MedicalProfessional copyWith({
    String? id,
    String? fullName,
    String? email,
    String? phone,
    String? address,
    String? specialty,
    String? place,
  }) {
    return MedicalProfessional(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      specialty: specialty ?? this.specialty,
      place: place ?? this.place,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'address': address,
      'specialty': specialty,
      'place': place,
    };
  }

  factory MedicalProfessional.fromMap(Map<String, dynamic> map) {
    return MedicalProfessional(
      id: map['id'],
      fullName: map['fullName'],
      email: map['email'],
      phone: map['phone'],
      address: map['address'],
      specialty: map['specialty'],
      place: map['place'],
    );
  }

  String toJson() => json.encode(toMap());

  factory MedicalProfessional.fromJson(String source) =>
      MedicalProfessional.fromMap(json.decode(source));

  @override
  String toString() {
    return 'MedicalProfessional(id: $id, fullName: $fullName, email: $email, phone: $phone, address: $address, specialty: $specialty, place: $place)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MedicalProfessional &&
        other.id == id &&
        other.fullName == fullName &&
        other.email == email &&
        other.phone == phone &&
        other.address == address &&
        other.specialty == specialty &&
        other.place == place;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        fullName.hashCode ^
        email.hashCode ^
        phone.hashCode ^
        address.hashCode ^
        specialty.hashCode ^
        place.hashCode;
  }

  // creare getter and setter for each field
  String get getId => id;
  set setId(String id) => this.id = id;

  String get getFullName => fullName;
  set setFullName(String fullName) => this.fullName = fullName;

  String get getEmail => email;
  set setEmail(String email) => this.email = email;

  String get getPhone => phone;
  set setPhone(String phone) => this.phone = phone;

  String get getAddress => address;
  set setAddress(String address) => this.address = address;

  String get getSpecialty => specialty;
  set setSpecialty(String specialty) => this.specialty = specialty;

  String get getPlace => place;
  set setPlace(String place) => this.place = place;
}
