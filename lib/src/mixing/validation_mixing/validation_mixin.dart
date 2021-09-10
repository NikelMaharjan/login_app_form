class ValidationMixin{
  String? validateEmail (String? value) {
    if (value!.contains("@") && value.contains(".")) {
      return null;
    } else {
      return "Invalid email address";
    }
  }

  String? validatePassword  (String? value) {
    if (value!.length >= 5) {
      return null;
    } else {
      return "Password must be at least 5 characters long";
    }
  }

  String? validateGender (String? value) {
    if (value != null) {
      return null;
    } else {
      return "Please select one option";
    }
  }
}