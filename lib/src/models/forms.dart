class LoginFormData {
  String email = '';
  String password = '';

  Map<String, dynamic> toJson() {
    return {'email': this.email, 'password': this.password};
  }
}
