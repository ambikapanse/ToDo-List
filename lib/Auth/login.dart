import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/services.dart';
import 'package:to_do/Auth/login_phone.dart';
import 'package:to_do/Auth/signup.dart';
import 'package:to_do/toast.dart';
import '../Widgets/round_button.dart';
import '../homescrn.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _auth = FirebaseAuth.instance;

  void login(){
    setState(() {
      loading = true;
    });
    _auth.signInWithEmailAndPassword(email: emailController.text.toString(), password: passwordController.text.toString()).then((value){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>const Homepage()));
        setState(() {
          loading = false;
        });
    }).onError((error, stackTrace){
      ToastMsg(error.toString());
      setState(() {
        loading = false;
      });
    });
  }


  @override
  void dispose() {
    super.dispose();
    // TODO: implement dispose
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (bool didPop){
        SystemNavigator.pop();
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('Login'),
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
                title: 'Login',
                loading: loading,
                onTap:(){
                  if(_formKey.currentState!.validate()){
                    login();
                  }
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                  child:Row(
                    children:[
                      const Text("Don't have an account?"),
                      TextButton(onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>const SignupScreen()));
                      },
                      child: const Text('Sign Up'))
                    ]
                ),
              ),
              const SizedBox(height:30),
              InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>const LoginWithPhone()));

                },
                child: Container(
                  height:50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(
                      color: Colors.deepPurple
                    )
                  ),
                  child: const Center(
                    child: Text('Login using Phone Number')
                  )
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
