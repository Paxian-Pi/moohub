class LoginRequestModel {
  String email;
  String password;

  LoginRequestModel({required this.email, required this.password});

  Map<String, dynamic> toJson() {
    final map = {
      'email': email.trim(),
      'password': password.trim(),
    };
    return map;
  }
}

class SignupRequestModel {
  String fullname;
  String email;
  String password;
  String password2;
  
  SignupRequestModel({
    required this.fullname,
    required this.email,
    required this.password,
    required this.password2,
  });

  Map<String, dynamic> toJson() {
    final map = {
      'firstName': fullname.trim(),
      'lastName': email.trim(),
      'password': password.trim(),
      'confirmPassword': password2.trim(),
    };
    return map;
  }
}
