class Validation {

  bool validateEmail(String email){
    if(email.isNotEmpty && email.contains('@')){
      return true;;
    }
    return false;
  }

  bool validatePassword(String password){
    if(password.isNotEmpty){
      return true;
    }
    return false;
  }
}