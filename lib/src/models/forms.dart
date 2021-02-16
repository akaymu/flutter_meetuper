class LoginFormData {
  String email = '';
  String password = '';

  Map<String, dynamic> toJson() {
    return {'email': this.email, 'password': this.password};
  }
}

class RegisterFormData {
  String email = '';
  String username = '';
  String name = '';
  String password = '';
  String passwordConfirmation = '';
  String avatar = '';

  Map<String, dynamic> toJson() => {
        'email': email,
        'username': username,
        'name': name,
        'password': password,
        'passwordConfirmation': passwordConfirmation,
        'avatar': avatar
      };
}
