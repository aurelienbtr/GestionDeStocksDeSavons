import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../main.dart';
import '../../widgets/appbar.dart';
import '../../widgets/drawer.dart';
import 'emailChecking.dart';
import '../../widgets/widgets.dart';

enum ApplicationLoginState {
  loggedOut,
  register,
  password,
  loggedIn,
}

class Authentication extends StatelessWidget {
  const Authentication({Key? key,
    required this.loginState,
    required this.email,
    required this.startLoginFlow,
    required this.verifyEmail,
    required this.signInWithEmailAndPassword,
    required this.cancelRegistration,
    required this.registerAccount,
    required this.signOut,
  }) : super(key: key);

  final ApplicationLoginState loginState;
  final String? email;
  final void Function() startLoginFlow;
  final void Function(
      String email,
      void Function(Exception e) error,
      ) verifyEmail;
  final void Function(
      String email,
      String password,
      void Function(Exception e) error,
      ) signInWithEmailAndPassword;
  final void Function() cancelRegistration;
  final void Function(
      String email,
      String displayName,
      String password,
      void Function(Exception e) error,
      ) registerAccount;
  final void Function() signOut;

  static int lvl = 0;

  @override
  Widget build(BuildContext context) {
    switch (loginState) {
      case ApplicationLoginState.loggedOut:
        return page(
          EmailForm(
            callback: (email) => verifyEmail(
                email, (e) => _showErrorDialog(context, 'Email invalide', e)),
            txt : 'Se connecter',
          ),
          0,
        );
      case ApplicationLoginState.password:
        return page(
          PasswordForm(
            email: email!,
            login: (email, password) {
              signInWithEmailAndPassword(email, password,
                      (e) => _showErrorDialog(context, 'Connexion échouée', e));
            },
            cancel: () {
              cancelRegistration();
            },
          ),
          0,
        );
      case ApplicationLoginState.register:
        return page(
          RegisterForm(
            email: email!,
            cancel: () {
              cancelRegistration();
            },
            registerAccount: (
                email,
                displayName,
                password,
                ) {
              registerAccount(
                  email,
                  displayName,
                  password,
                      (e) =>
                      _showErrorDialog(context, 'Création échouée', e));
            },
          ),
          0,
        );
      case ApplicationLoginState.loggedIn:
        String mail = FirebaseAuth.instance.currentUser!.email!;
        getLvl(mail);
        bool isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
        if(!isEmailVerified){
          return page(const EmailChecking(), 0,);
        }
        else{
          return Page(lvl: lvl, mail: mail,);
        }
      default:
        return page(
          Row(
            children: const [
              Text('Erreur interne'),
            ],
          ),
          0,
        );
    }
  }

  void _showErrorDialog(BuildContext context, String title, Exception e) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            title,
            style: const TextStyle(fontSize: 24),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  '${(e as dynamic).message}',
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            StyledButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              txt: 'OK',
            ),
          ],
        );
      },
    );
  }

  Widget page(Widget input, int connected){
    AppBar t;
    ListView l;
    if(connected == 1){
      return const DrawerWidget();
    }
    else{
      t = AppBarWidget().getAppBar3('Connexion');
      l = welcome(input);
    }
    return Scaffold(
      appBar: t,
      body: l,
    );
  }

  ListView welcome(Widget input){
    return ListView(
      children: <Widget>[
        Image.asset('assets/images/savon.png'),
        const SizedBox(height: 8),
        input,
        const Divider(
          height: 8,
          thickness: 1,
          indent: 8,
          endIndent: 8,
          color: Colors.grey,
        ),
        const Header('Gestion de Stocks'),
        const Paragraph(
          'Cette application est destiné à gérer un stock de savon',
        ),
      ],
    );
  }

  static Future<void> getLvl(String mail) async {
    int newLvl = lvl;
    lvl = await FirebaseFirestore.instance
        .collection('users')
        .where('mail', isEqualTo: mail)
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        if(doc['lvl'] != newLvl){
          newLvl = doc['lvl'];
        }
      }
      return newLvl;
    });
  }
}

class Page extends StatefulWidget {
  const Page({Key? key, required this.lvl, required this.mail}) : super(key: key);

  final int lvl;
  final String mail;

  @override
  PageState createState() => PageState();
}

class PageState extends State<Page> {
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
        .collection('users')
        .where('mail', isEqualTo : widget.mail)
        .snapshots(includeMetadataChanges: true);

    return StreamBuilder<QuerySnapshot>(
        stream: _usersStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
            if(data['lvl'] != widget.lvl){
              FirebaseAuth.instance.signOut();
            }
            return ListTile(title: Row(children: const [],),);
          });
          return const DrawerWidget();
        }
    );


  }
}

class EmailForm extends StatefulWidget {
  const EmailForm({Key? key, required this.callback, required String txt}) : super(key: key);
  final void Function(String email) callback;

  @override
  _EmailFormState createState() => _EmailFormState();
}

class _EmailFormState extends State<EmailForm> {
  final _formKey = GlobalKey<FormState>(debugLabel: '_EmailFormState');
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Header('Entrez votre Email pour continuer'),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: TextFormField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'xxxx@gmail.com',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Entrez un email valide';
                      }
                      return null;
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 30),
                      child: StyledButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            widget.callback(_controller.text);
                          }
                        },
                        txt: 'Suivant',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class RegisterForm extends StatefulWidget {
  const RegisterForm({Key? key,
    required this.registerAccount,
    required this.cancel,
    required this.email,
  }) : super(key: key);
  final String email;
  final void Function(String email, String displayName, String password)
  registerAccount;
  final void Function() cancel;
  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>(debugLabel: '_RegisterFormState');
  final _emailController = TextEditingController();
  final _displayNameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _emailController.text = widget.email;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        const Text("Aucun compte n'est associé à cette addresse"),
        const SizedBox(height: 20),
        const Header('Creer un compte'),

        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      hintText: 'Entrez votre email',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Entrez votre Email pour continuer';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: TextFormField(
                    controller: _displayNameController,
                    decoration: const InputDecoration(
                      hintText: 'Nom de compte',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Entrez votre nom de compte';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      hintText: 'Mot de passe',
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Entrez votre mot de passe';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      StyledButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            Authentication.getLvl(_emailController.text);
                            widget.registerAccount(
                              _emailController.text,
                              _displayNameController.text,
                              _passwordController.text,
                            );
                          }
                        },
                        txt: 'Enregistrer',
                      ),
                      const SizedBox(width: 16),
                      StyledButton2(
                        onPressed: widget.cancel,
                        txt: 'Annuler',
                      ),
                      const SizedBox(width: 16),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class PasswordForm extends StatefulWidget {
  const PasswordForm({Key? key,
    required this.login,
    required this.email,
    required this.cancel,
  }) : super(key: key);
  final String email;
  final void Function(String email, String password) login;
  final void Function() cancel;
  @override
  _PasswordFormState createState() => _PasswordFormState();
}

class _PasswordFormState extends State<PasswordForm> {
  final _formKey = GlobalKey<FormState>(debugLabel: '_PasswordFormState');
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _emailController.text = widget.email;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Header('Se connecter'),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      hintText: 'Entrez votre email',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Entrez votre email pour continuer';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      hintText: 'Mot de passe',
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Entrez votre mot de passe';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      StyledButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            Authentication.getLvl(_emailController.text);
                            widget.login(
                              _emailController.text,
                              _passwordController.text,
                            );
                          }
                        },
                        txt: 'Se connecter',
                      ),
                      const SizedBox(width: 16),
                      StyledButton2(
                        onPressed: widget.cancel,
                        txt: 'Annuler',
                      ),
                      const SizedBox(width: 16),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}