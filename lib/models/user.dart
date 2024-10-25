class User {
  final int? id;
  final String name;
  final String email;
  final String birthDate;
  final String address;
  final String phoneNumber;
  final String password;
  final List<double> coordinates;

  User(
      {this.id,
      required this.name,
      required this.email,
      required this.birthDate,
      required this.phoneNumber,
      required this.address,
      required this.password,
      required this.coordinates});

  factory User.fromJson(Map<String, dynamic> json) {
    String fullName = '${json['name']['first']} ${json['name']['last']}';
    String jsonAddress = '${json['location']['country']}';
    String birthDate = json['dob']['date'];
    double latitude = double.parse(json['location']['coordinates']['latitude']);
    double longitude =
        double.parse(json['location']['coordinates']['longitude']);

    return User(
      id: null,
      name: fullName,
      email: json['email'],
      birthDate: birthDate,
      phoneNumber: json['phone'],
      address: jsonAddress,
      password: json['login']['password'],
      coordinates: [latitude, longitude],
    );
  }

  factory User.fromMap(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      birthDate: json['birthDate'],
      phoneNumber: json['phoneNumber'],
      address: json['address'],
      password: json['password'],
      coordinates: [
        json['latitude'],
        json['longitude'],
      ],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'birthDate': birthDate,
      'address': address,
      'password': password,
      'latitude': coordinates[0],
      'longitude': coordinates[1],
    };
  }
}
