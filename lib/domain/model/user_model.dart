class UserModel {
  final String email;
  final String username;
  final double? height;
  final double? weight;

  UserModel({
    required this.email,
    required this.username,
    required this.height,
    required this.weight,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        email: json['email'],
        username: json['username'],
        height: json['height'],
        weight: json['weight'],
      );

  @override
  String toString() {
    return 'UserModel{email: $email, username: $username, height: $height, weight: $weight}';
  }
}
