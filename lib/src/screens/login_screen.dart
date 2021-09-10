import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login_app/src/api/auth_api.dart';
import 'package:login_app/src/mixing/validation_mixing/validation_mixin.dart';
import 'package:login_app/src/screens/second_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with ValidationMixin {
  // we use with so Instance of  ValidationMixin need not be called
  final formKey =
      GlobalKey<FormState>(); //we validate , reset, fetch values from formState
  String? email, password, gender;
  bool isLoading = false;
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Card(
          margin: EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            padding: EdgeInsets.all(20), //for child
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  buildEmailField(),
                  buildPasswordField(),
                  SizedBox(
                    height: 16,
                  ),
                  buildGenderField(),
                  SizedBox(
                    height: 16,
                  ),
                   buildSubmitButton(context),  //dont  need to pass context for snackbar in stateful. just to check
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildEmailField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      validator: validateEmail,
      onSaved: (String? val) {
        email = val;
      },
      decoration: InputDecoration(
          labelText: "Your email",
          hintText: "email@example.com",
          border: OutlineInputBorder()),
    );
  }

  Widget buildPasswordField() {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: TextFormField(
        validator: validatePassword,
        onSaved: (String? val) {
          password = val;
        },
        obscureText: obscureText,
        decoration: InputDecoration(
            labelText: "Your password",
            suffixIcon: IconButton(
              icon: Icon(Icons.visibility),
              onPressed: (){
                setState(() {
                  obscureText = !obscureText;
                });
              },
            ),
            hintText: '********',
            border: OutlineInputBorder()),
      ),
    );
  }

  Widget buildGenderField() {
    return DropdownButtonFormField(
      onChanged: (String? val) {},
      onSaved: (String? val) {
        gender = val;
      },
      validator: validateGender,
      items: [
        DropdownMenuItem(
          child: Text("Male"),
          value: "Male",
        ),
        DropdownMenuItem(
          child: Text("Female"),
          value: "Female",
        ),
        DropdownMenuItem(
          child: Text("Other"),
          value: "Other",
        ),
        DropdownMenuItem(
          child: Text("Rather Not Say"),
          value: "Rather Not Say",
        ),
      ],
      decoration: InputDecoration(
          hintText: "Your Gender",
          labelText: "Select your gender",
          border: OutlineInputBorder()),
    );
  }

  Widget buildSubmitButton(BuildContext context) {  // no need to pass context
    // return RaisedButton(
    //   onPressed: (){},
    //   child: Text("Submit"),
    //   color: Colors.blue,
    //   textColor: Colors.white,
    // );
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : () {
                // null value will make button invisible:  we set isLoading false first time so button will work: if isLoading true then null value assigned
                //formKey.currentState.reset();
                onSubmitButtonClick(context); //no need
              },
        child: isLoading ? CircularProgressIndicator() : Text("Submit"),
        // style: ButtonStyle(
        //     padding: MaterialStateProperty.all(EdgeInsets.all(16)),
        //     backgroundColor: MaterialStateProperty.all(Colors.green)),
        style: ElevatedButton.styleFrom(
            padding: EdgeInsets.all(16), primary: Colors.green),
      ),
    );
  }

  Future<void> onSubmitButtonClick(BuildContext ctx) async {  //no need to pass context
    bool validInput = formKey.currentState!.validate();
    if (validInput) {
      print("Email  $email password $password and gender $gender");
      formKey.currentState!.save();
      print("1: Email  $email password $password and gender $gender");
      // todo submit data
      setState(() {
        isLoading = true;
      });
      var response = await authApi.signup(email!, password!, gender!);
      setState(() {
        isLoading = false;
      });

      if (response == null) {
        ScaffoldMessengerState messenger = ScaffoldMessenger.of(
            ctx); //stateful widget so can pass such context
        messenger.showSnackBar(SnackBar(content: Text("Sign up failed")));
      } else {
        //todo navigate to the other page
        //await Navigator.of(context)
        var data = await Navigator.of(context)
            .push(MaterialPageRoute(builder: (BuildContext context) {
          return SecondScreen(email: email!);
        }));
        print("data from second screen $data");
      }
    }
  }
}
