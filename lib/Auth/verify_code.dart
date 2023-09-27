import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Widgets/round_button.dart';
import '../homescrn.dart';


class VerifyCodeScreen extends StatefulWidget {
  final String verificationid;
  const VerifyCodeScreen({Key? key, required this.verificationid}) : super(key: key);

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  bool loading = false;
  final auth = FirebaseAuth.instance;
  final codeController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verify'),
      ),
      body: Column(
        children: [
          SizedBox(height:50),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextFormField(
              keyboardType: TextInputType.number,
              controller: codeController,
              decoration: InputDecoration(
                  hintText: '6 digit code'
              ),
            ),
          ),
          SizedBox(height:50),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Roundbutton(title: 'Verify',loading: loading, onTap: ()async{
              setState(() {
                loading = true;
              });
              final credentials = PhoneAuthProvider.credential(
                verificationId: widget.verificationid,
                smsCode: codeController.text.toString()
              );
              try{
                await auth.signInWithCredential(credentials);
                Navigator.push(context, MaterialPageRoute(builder: (contex)=>Homepage()));
              }catch(e){
                setState(() {
                  loading = false;
                });
              }
            }),
          )

        ],
      ),
    );
  }
}
