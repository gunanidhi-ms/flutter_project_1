class User {
  int? id;
  final String firstName;
  final String middleName;
  final String lastName;
  final String email;
  final String dialCode;
  final String mobileNumber;
  final String password;
  final String country;
  final String state;
  final String city;
  final String houseNo;
  final String landmark;
  final String pincode;

  User({
    this.id,
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.email,
    required this.dialCode,
    required this.mobileNumber,
    required this.password,
    required this.country,
    required this.state,
    required this.city,
    required this.houseNo,
    required this.landmark,
    required this.pincode,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'first_name': firstName,
      'middle_name': middleName,
      'last_name': lastName,
      'email': email,
      'dial_code': dialCode,
      'mobile_number': mobileNumber,
      'password': password,
      'country': country,
      'state': state,
      'city': city,
      'house_no': houseNo,
      'landmark': landmark,
      'pincode': pincode,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      firstName: map['first_name'],
      middleName: map['middle_name'] ?? '',
      lastName: map['last_name'],
      email: map['email'],
      dialCode: map['dial_code'],
      mobileNumber: map['mobile_number'],
      password: map['password'],
      country: map['country'],
      state: map['state'],
      city: map['city'],
      houseNo: map['house_no'],
      landmark: map['landmark'] ?? '',
      pincode: map['pincode'],
    );
  }
}
