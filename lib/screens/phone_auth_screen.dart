import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:sms_autofill/sms_autofill.dart';

class PhoneAuthScreen extends StatefulWidget {
  @override
  _PhoneAuthScreenState createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _smsController = TextEditingController();
  String _verificationId;
  final SmsAutoFill _autoFill = SmsAutoFill();
  bool _isLoading=false;
  String _hintText="+92xxx-xxxxxxx";
  String _labelText="Enter phone number";
  String _authButtonText="Send Verification Code";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Phone Authentication"),
        centerTitle: true,
      ),
      resizeToAvoidBottomInset: false,
      body:ModalProgressHUD(
        inAsyncCall: _isLoading,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextField(
                  controller: _phoneNumberController,
                  decoration: InputDecoration(
                      labelText: _labelText,
                      border: OutlineInputBorder(),
                      hintText: _hintText
                  ),
                ),
                SizedBox(height: 10,),
                ElevatedButton( onPressed: () async {
                  setState(() {
                    _isLoading=true;
                  });
                  sendVerification();
                },
                    child: Text(_authButtonText))
              ],
            ),
          ),
        ),
      ),
    );
  }



  ///methods

  sendVerification() async{
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+923095251250',
      verificationCompleted: (PhoneAuthCredential credential) async {
        print("verification completed");
        await FirebaseAuth.instance.signInWithCredential(credential);
        //TODO:Navigate to home screen
        setState(() {
          _isLoading=false;
        });
      },




      verificationFailed: (FirebaseAuthException e) {
        print("verification failed: $e");
        Fluttertoast.showToast(msg: "Verification Failed");
        setState(() {
          _isLoading=false;
        });
      },



      codeSent: (String verificationId, int resendToken) {
        setState(() {
          _isLoading=false;
          _hintText="";
          _labelText="Enter Verification code here";
          _authButtonText = "Verify";
        });
        //TODO: autofill the code

        print("verification sent");
      },



      codeAutoRetrievalTimeout: (String verificationId) {
        print("verification timeout");
        Fluttertoast.showToast(msg: "Timeout!");
        setState(() {
          String _hintText="+92xxx-xxxxxxx";
          String _labelText="Enter phone number";
          String _authButtonText="Send Verification Code";
          _isLoading=false;
        });
      },
    );
  }

}
