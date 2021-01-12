import 'package:flutter/material.dart';
//import 'SecondRoute.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Drawer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
  ));
}

String name, email, photoUrl;

class MyApp extends StatefulWidget {
  final User user;

  const MyApp({Key key, this.user}) : super(key: key);
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<String> signInWithGoogle() async {
    await Firebase.initializeApp();

    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final UserCredential authResult =
        await _auth.signInWithCredential(credential);
    final User user = authResult.user;

    if (user != null) {
      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      final User currentUser = _auth.currentUser;
      assert(user.uid == currentUser.uid);

      print('signInWithGoogle succeeded: $user');

      return '$user';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          ClipPath(
            clipper: MyClipPath(),
            child: Container(
              height: 250,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    "assets/images/pic.png",
                  ),
                  fit: BoxFit.fill,
                ),
                color: Colors.blue,
              ),
            ),
          ),
          //SizedBox(height: ),
          Form(
            //key: _key,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: "Username",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: BorderSide(
                            color: Colors.amber, style: BorderStyle.solid),
                      ),
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return "name can't be empty";
                      } else if (value.length <= 4) {
                        return "too short for validation";
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: "Password",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: BorderSide(
                            color: Colors.amber, style: BorderStyle.solid),
                      ),
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return "password can't be empty";
                      } else if (value.length <= 4) {
                        return "too short for validation";
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 3,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(230, 0, 0, 0),
            child: Text("Forget Password?"),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: new RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                disabledTextColor: Colors.white,
                disabledColor: Colors.red,
                child: Text(
                  "sign in",
                ),
                onPressed: () {}
                // onPressed: () => signInWithGoogle()
                //     .then((UserCredential user) => print(user))
                //     .catchError((e) => print(e)),
                ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: new RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                disabledTextColor: Colors.white,
                disabledColor: Colors.red,
                child: Text(
                  "Register",
                ),
                onPressed: () {
                  // Navigator.of(context).push(
                  //   MaterialPageRoute(builder: (context) {
                  //     return Register();
                  //   }),
                  // );
                }),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(50, 0, 0, 0),
            child: Text(
              "Don't have an account? Create One",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 3,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(120.0, 0, 0, 0),
            child: Text(
              "Or Log in with",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          RaisedButton(
            onPressed: () {
              signInWithGoogle().then((result) {
                if (result != null) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return FirstScreen();
                      },
                    ),
                  );
                }
              });
            },
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            disabledColor: Colors.white,
            disabledTextColor: Colors.blue,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Sign in with google"),
            ),
          ),
          RaisedButton(
            onPressed: () {},
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            disabledColor: Colors.white,
            disabledTextColor: Colors.blue,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Sign in with facebook"),
            ),
          )
        ],
      ),
    );
  }
}

class MyClipPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();
    path.lineTo(0, size.height * 0.78); //vertical line
    path.cubicTo(size.width / 3, size.height, 2 * size.width / 3,
        size.height * 0.6, size.width, size.height * 0.78); //cubic curve
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
