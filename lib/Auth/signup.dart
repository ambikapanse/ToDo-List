import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:to_do/Auth/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:to_do/toast.dart';
import '../Widgets/round_button.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {

  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  void dispose() {
    super.dispose();
    // TODO: implement dispose
    emailController.dispose();
    passwordController.dispose();
  }
  void login(){
    setState(() {
      loading = true;
    });
    _auth.createUserWithEmailAndPassword(email: emailController.text.toString(), password: passwordController.text.toString()).then((value){
      setState(() {
        loading = false;
      });
    }).onError((error, stackTrace){
      ToastMsg(error.toString());
    }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Form(
                key:_formKey,
                child: Column(
                    children: [
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        controller: emailController,
                        decoration: const InputDecoration(
                          hintText: 'Email',
                          helperText: 'E.g. john_appleseed@gmail.com',
                          prefixIcon: Icon(Icons.mail_outline_rounded),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter Email';
                          }
                          else if(!EmailValidator.validate(value)){
                            return 'Enter appropriate email address';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                            hintText: 'Password',
                            prefixIcon: Icon(Icons.lock_outline_rounded)
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter Password';
                          }
                          return null;
                        },
                      ),
                    ]
                )
            ),
            const SizedBox(height: 50),
            Roundbutton(
              title: 'Sign Up',
              loading: loading,
              onTap:(){
                if(_formKey.currentState!.validate()==true){
                   login();
                }
              },
            ),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child:Row(
                    children:[
                      const Text("Already have an account?"),
                      TextButton(onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>const LoginScreen()));
                      },
                          child: const Text('Login'))
                    ]
                )
            ),
          ],
        ),
      ),
    );
  }
}
