import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:login_app/src/models/signup_response_model.dart';

class _AuthApi {
  /// define a method that takes email, password and gender
  /// posts that data to out backend server and returns the result back
  /// to the caller
  
  Future<SignUpResponseModel?> signup(String email, String password, String gender) async {
    final requestBody = {  //we send data in this format
      "email":email,
      "password":password,
      "gender":gender,
    };

    final url = Uri.parse("https://api.fresco-meat.com/api/albums/signup");
    try{
      final response = await post(
          url,
          body: jsonEncode(requestBody),
          headers: {"Content-Type": "application/json"}
      );
     final body = response.body;
     final code = response.statusCode;
     if(code!= HttpStatus.created){
       print("Error");
       return null;
     }
     final parsedMap = jsonDecode(body);
     print("The signup response $parsedMap");
     final SignUpResponseModel responseModel = SignUpResponseModel.fromJson(parsedMap);
     return responseModel;
    }catch(e){
      print("Exception $e");
      return null;
      
    }
    
  }

}

final authApi = _AuthApi();       //singleton design pattern ..create only one instance