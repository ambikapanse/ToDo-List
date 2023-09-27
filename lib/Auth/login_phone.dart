import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:to_do/Auth/verify_code.dart';
import 'package:to_do/toast.dart';

import '../Widgets/round_button.dart';

class LoginWithPhone extends StatefulWidget {
  const LoginWithPhone({Key? key}) : super(key: key);

  @override
  State<LoginWithPhone> createState() => _LoginWithPhoneState();
}

class _LoginWithPhoneState extends State<LoginWithPhone> {
  bool loading = false;
  final auth = FirebaseAuth.instance;
  final phoneController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Column(
        children: [
          const SizedBox(height:50),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextFormField(
              controller: phoneController,
              decoration: const InputDecoration(
                  hintText: 'Phone Number',
                helperText: '+1 234 5678 910'
              ),
            ),
          ),
          const SizedBox(height:50),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Roundbutton(title: 'Login',loading: loading, onTap: (){
              setState(() {
                loading = true;
              });
              auth.verifyPhoneNumber(
                  phoneNumber: phoneController.text,
                  verificationCompleted: (_){
                    setState(() {
                      loading = false;
                    });
                  },
                  verificationFailed: (e){
                    setState(() {
                      loading = false;
                    });
                    ToastMsg(e.toString());
                  },
                  codeSent: (String verification , int? token){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>VerifyCodeScreen(verificationid: verification,)));
                    setState(() {
                      loading = false;
                    });
                  },
                  codeAutoRetrievalTimeout: (e){
                    setState(() {
                      loading = false;
                    });
                    ToastMsg(e.toString());
                  });
            }),
          )

        ],
      ),
    );
  }
}
