import 'dart:async';

import 'package:app_gestion_savon/main.dart';
import 'package:app_gestion_savon/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EmailChecking extends StatefulWidget{
  const EmailChecking({Key? key}) : super(key: key);

  @override
  _EmailCheckingState createState() => _EmailCheckingState();
}

class _EmailCheckingState extends State<EmailChecking>{
  bool isEmailVerified = false;
  bool canResendEmail = true;
  Timer? timer;

  @override
  void initState(){
    super.initState();
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

    if(!isEmailVerified){
      sendEmailVerification();

      timer = Timer.periodic(
        const Duration(seconds: 3),
          (_) => checkEmailVerified(),
      );
    }
  }

  Future<void> sendEmailVerification() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user!= null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
  }

  @override
  void dispose(){
    timer?.cancel();

    super.dispose();
  }

  Future checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();

    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if(isEmailVerified) timer?.cancel();
  }

  Future sendVerificationEmail() async {
    try{
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();

      setState(() => canResendEmail = false);
      await Future.delayed(const Duration(seconds: 5));
      setState(() => canResendEmail = true);
    } catch(e) {
      print("error");
    }
  }

  @override
  Widget build(BuildContext context){
    if(!isEmailVerified){
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(width: 200.0, height: 20.0,),
          const Text(
            'Un email de vérification vous a été envoyer.',
            style: TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
          ),
          const SizedBox(width: 200.0, height: 20.0,),
          Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                canResendEmail ? StyledButton(
                  txt: 'Renvoyer l\'email de vérification',
                  onPressed: () async {
                    sendVerificationEmail();
                  },
                ): Container(),
                const SizedBox(width: 16),
                StyledButton2(
                  txt: 'Annuler',
                  onPressed: () => FirebaseAuth.instance.signOut(),
                ),
                const SizedBox(width: 16),
              ]
          ),
        ],
      );
    }
    else{
      return const HomePage();
    }
  }
}