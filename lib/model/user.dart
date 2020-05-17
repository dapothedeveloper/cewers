class User {
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String password;
  final String gender;
  final String male;
  final String userType;
  // final String updatedAt;
  // final String createdAt;
  User(this.firstName, this.lastName, this.phoneNumber, this.password,
      this.gender, this.male, this.userType);

  factory User.from(dynamic json) {
    return User(
        json['firstName'] as String,
        json['lastName'] as String,
        json["phoneNumber"] as String,
        json["password"] as String,
        json["gender"] as String,
        json["male"] as String,
        json["userType"] as String);
  }
}
