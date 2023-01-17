class Patient {
  String id;
  String fullName;
  String email;
  String phone;
  String address;
  String age;

  Patient({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.address,
    required this.age,
  });

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      id: json['id'],
      fullName: json['fullName'],
      email: json['email'],
      phone: json['phone'],
      address: json['address'],
      age: json['age'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'address': address,
      'age': age,
    };
  }

  // to map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'address': address,
      'age': age,
    };
  }

  // from map

  factory Patient.fromMap(Map<String, dynamic> map) {
    return Patient(
      id: map['id'],
      fullName: map['fullName'],
      email: map['email'],
      phone: map['phone'],
      address: map['address'],
      age: map['age'],
    );
  }

  @override
  String toString() {
    return 'Patient{id: $id, fullName: $fullName, email: $email, phone: $phone, address: $address, age: $age}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Patient &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          fullName == other.fullName &&
          email == other.email &&
          phone == other.phone &&
          address == other.address &&
          age == other.age;

  @override
  int get hashCode =>
      id.hashCode ^
      fullName.hashCode ^
      email.hashCode ^
      phone.hashCode ^
      address.hashCode ^
      age.hashCode;

  Patient copyWith({
    String? id,
    String? fullName,
    String? email,
    String? phone,
    String? address,
    String? age,
  }) {
    return Patient(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      age: age ?? this.age,
    );
  }

  Patient copyWithId(String id) {
    return Patient(
      id: id,
      fullName: this.fullName,
      email: this.email,
      phone: this.phone,
      address: this.address,
      age: this.age,
    );
  }

  Patient copyWithFullName(String fullName) {
    return Patient(
      id: this.id,
      fullName: fullName,
      email: this.email,
      phone: this.phone,
      address: this.address,
      age: this.age,
    );
  }

  Patient copyWithEmail(String email) {
    return Patient(
      id: this.id,
      fullName: this.fullName,
      email: email,
      phone: this.phone,
      address: this.address,
      age: this.age,
    );
  }

  Patient copyWithPhone(String phone) {
    return Patient(
      id: this.id,
      fullName: this.fullName,
      email: this.email,
      phone: phone,
      address: this.address,
      age: this.age,
    );
  }

  Patient copyWithAddress(String address) {
    return Patient(
      id: this.id,
      fullName: this.fullName,
      email: this.email,
      phone: this.phone,
      address: address,
      age: this.age,
    );
  }

  Patient copyWithAge(String age) {
    return Patient(
      id: this.id,
      fullName: this.fullName,
      email: this.email,
      phone: this.phone,
      address: this.address,
      age: age,
    );
  }

  Patient copyWithAll({
    String? id,
    String? fullName,
    String? email,
    String? phone,
    String? address,
    String? age,
  }) {
    return Patient(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      age: age ?? this.age,
    );
  }

  // create getter and setter for each field
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

  String get getAge => age;
  set setAge(String age) => this.age = age;
}
