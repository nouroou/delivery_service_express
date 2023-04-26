import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sh_express_transport/screens/home_screen.dart';
import 'package:sh_express_transport/screens/register_screen.dart';
import 'package:sh_express_transport/services/auth_services.dart';

import '../utils/constants.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _passwordHidden = true;
  bool _submitting = false;

  String email = '', password = '';

  void _showPassword() {
    setState(() {
      _passwordHidden = !_passwordHidden;
    });
  }

  FocusNode emailNode = FocusNode();
  FocusNode passwordNode = FocusNode();
  FocusNode loginNode = FocusNode();

  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  AuthServices authServices = AuthServices();

  _submit() {
    setState(() {
      _submitting = true;
    });
    if (email.isNotEmpty &&
        email != '' &&
        password.isNotEmpty &&
        password != '') {
      authServices.loginUser(email, password).then((value) {
        if (value == User) {
          print('User logged in');
          return Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (_) => HomeScreen(user: value)));
        } else if (value == String) {
          print(value.toString());
          return showErrorDialog(context, 'Error', value);
        } else {
          print('User not logged in');
        }
      }).catchError((e) {
        print(e.message);
        return showErrorDialog(context, 'Error', e.message);
      });
      setState(() {
        _submitting = false;
      });
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          alignment: Alignment.center,
          constraints: const BoxConstraints(maxWidth: 500, minWidth: 180),
          child: SingleChildScrollView(
            child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('SH Express',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline3),
                  Text('Transport',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline3),
                  Constants().sizedBoxLarge,
                  _emailField(context),
                  Constants().sizedBox,
                  _paswordField(context),
                  Constants().sizedBox,
                  _loginButton(),
                  Constants().sizedBox,
                  _registerButton(context)
                ]),
          ),
        ),
      ),
    );
  }

  TextButton _registerButton(BuildContext context) {
    return TextButton(
      child: const Text('REGISTER'),
      onPressed: () => Navigator.push(
          context, MaterialPageRoute(builder: (_) => const RegisterScreen())),
    );
  }

  ElevatedButton _loginButton() {
    return ElevatedButton(
        focusNode: loginNode,
        style: ElevatedButton.styleFrom(
            padding: _submitting == true
                ? const EdgeInsets.symmetric(vertical: 10, horizontal: 0)
                : null),
        onPressed: () => _submit(),
        child: _submitting == true
            ? const CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 0.8,
              )
            : const Text('LOGIN'));
  }

  TextFormField _paswordField(BuildContext context) {
    return TextFormField(
      controller: passwordController,
      obscureText: _passwordHidden,
      textInputAction: TextInputAction.next,
      onChanged: (text) => setState(() {
        password = text;
      }),
      onFieldSubmitted: (term) {
        _fieldFocusChange(context, passwordNode, loginNode);
      },
      validator: (value) {
        RegExp regex = RegExp(
            r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
        if (value!.isEmpty) {
          return 'Please enter password';
        } else {
          if (!regex.hasMatch(value)) {
            return 'Enter valid password';
          } else {
            return null;
          }
        }
      },
      decoration: InputDecoration(
          hintText: 'Password',
          prefixIcon: const Icon(CupertinoIcons.lock, size: 20),
          suffixIcon: InkWell(
              onTap: () => _showPassword(),
              child: Icon(
                _passwordHidden
                    ? CupertinoIcons.eye_slash_fill
                    : CupertinoIcons.eye_fill,
                size: 20,
              ))),
    );
  }

  TextFormField _emailField(BuildContext context) {
    return TextFormField(
      controller: emailController,
      validator: (value) => EmailValidator.validate(value.toString())
          ? null
          : 'Please type a correct email',
      textInputAction: TextInputAction.next,
      onChanged: (text) {
        setState(() {
          email = text;
        });
      },
      onFieldSubmitted: (term) {
        _fieldFocusChange(context, emailNode, passwordNode);
      },
      decoration: const InputDecoration(
        hintText: 'Email',
        prefixIcon: Icon(CupertinoIcons.mail, size: 20),
      ),
    );
  }

  showErrorDialog(BuildContext context, String error, String description) {
    showDialog<dynamic>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(error),
            content: Text(description),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }
}
