class CustomUser {
  final String name;
  final String nationalNumber;
  final String dateOfBirth;
  final String title;
  final String photo;
  final String phone;
  final String email;

  CustomUser(
      {required this.name,
      required this.nationalNumber,
      required this.dateOfBirth,
      required this.title,
      required this.photo,
      required this.phone,
      required this.email});

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "national_number": nationalNumber,
      "date_of_birth": dateOfBirth,
      "title": title,
      "photo": photo,
      "phone": phone,
      "email": email
    };
  }
}
