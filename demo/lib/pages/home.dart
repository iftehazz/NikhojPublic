import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/pages/create_account.dart';
import 'package:demo/pages/newhome.dart';
import 'package:demo/pages/profile.dart';
import 'package:demo/pages/search.dart';
import 'package:demo/pages/upload.dart';
import 'package:demo/pages/verify.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'activity_feed.dart';
import 'feed.dart';
import 'verify.dart';
import 'package:demo/models/user.dart';

final GoogleSignIn googleSignIn = GoogleSignIn();
final auth = FirebaseAuth.instance;
final userRef = FirebaseFirestore.instance.collection('users');
final DateTime timestamp = DateTime.now();
Uuser currentUser;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isAuth = false;
  PageController pageController;
  int pageIndex = 0;

  String _email, _password;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  //final _formkey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    pageController = PageController();
    //detects when user signed in
    googleSignIn.onCurrentUserChanged.listen((account) {
      handleSignIn(account);
    }, onError: (err) {
      print('Error signin in: $err');
    });
    //reauthenticate user when app is opened
    googleSignIn.signInSilently(suppressErrors: false).then((account) {
      handleSignIn(account);
    }).catchError((err) {
      print('Error signin in: $err');
    });
  }

  handleSignIn(GoogleSignInAccount account) {
    if (account != null) {
      //print('User signed in!: $account');
      createUserInFirestore();

      setState(() {
        isAuth = true;
      });
    } else {
      setState(() {
        isAuth = false;
      });
    }
  }

  createUserInFirestore() async {
    final GoogleSignInAccount user = googleSignIn.currentUser;
    DocumentSnapshot doc = await userRef.doc(user.id).get();
    if (!doc.exists) {
      final username = await Navigator.push(
          context, MaterialPageRoute(builder: (context) => CreateAccount()));

      userRef.doc(user.id).set({
        "id": user.id,
        "username": username,
        "email": user.email,
        "timestamp": timestamp,
      });
      doc = await userRef.doc(user.id).get();
      print("User is created in firestore");
    }
    currentUser = Uuser.fromDocument(doc);
    
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  login() {
    googleSignIn.signIn();
  }

  logout() {
    googleSignIn.signOut();
  }

  onPageChanged(int pageIndex) {
    setState(() {
      this.pageIndex = pageIndex;
    });
  }

  onTap(int pageIndex) {
    pageController.animateToPage(
      pageIndex,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Scaffold buildAuthScreen() {
    return Scaffold(
      body: PageView(
        children: <Widget>[
          Feed(currentUser: currentUser),
          // ActivityFeed(),
          Upload(currentUser: currentUser),
          Search(),
          Profile(profileId: currentUser?.id),
        ],
        controller: pageController,
        onPageChanged: onPageChanged,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: CupertinoTabBar(
        currentIndex: pageIndex,
        onTap: onTap,
        activeColor: Theme.of(context).primaryColor,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.whatshot),
          ),
          //BottomNavigationBarItem(icon: Icon(Icons.notifications_active),),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.photo_camera,
              size: 35.0,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
          ),
        ],
      ),
    );
  }

  Scaffold buildUnAuthScreen() {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      body: Column(
        children: <Widget>[
          Container(
            child: Stack(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.fromLTRB(0.0, 110.0, 0.0, 0.0),
                  child: Text(
                    'Nikhoj',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 80.0,
                        fontFamily: "Signatra",
                        fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    //hintText: 'Password'
                    border: OutlineInputBorder(),
                    labelText: "Email",
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 22.0,
                    ),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey))),
                onChanged: (value) {
                  setState(() {
                    _email = value.trim();
                    print("email is being typed");
                  });
                },
              ),
            ),
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                obscureText: true,
                decoration: InputDecoration(
                    hintText: 'Must be at least 6 character',
                    border: OutlineInputBorder(),
                    labelText: "Password",
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 22.0,
                    ),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey))),
                autovalidate: true,
                validator: (value) {
                  if (value.trim().length < 6 || value.isEmpty) {
                    print("password is too short, at least 6 character");
                    return "password too short";
                  } else {
                    print("password is okay");
                    return null;
                  }
                },
                onChanged: (value) {
                  setState(() {
                    _password = value.trim();
                    print("password is being typed");
                  });
                },
              ),
            ),
          ),

//combining sign in and sign up

          Container(
            child: RaisedButton(
                color: Theme.of(context).accentColor,
                child: Text('SignIn'),
                onPressed: () {
                  auth
                      .signInWithEmailAndPassword(
                          email: _email, password: _password)
                      .then((_) {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => NewHome()));
                        print("Sign in done");
                  }).catchError((e) {    SnackBar snackbar = SnackBar(content: Text("Email or Password is Wrong"));
    _scaffoldKey.currentState.showSnackBar(snackbar);
    print("snackbar is being used to show email or password is wrong");
    });
                }),
          ),

          ///signup
          Container(
            child: RaisedButton(
                color: Theme.of(context).accentColor,
                child: Text('SignUp'),
                onPressed: () {
                  auth
                      .createUserWithEmailAndPassword(
                          email: _email, password: _password)
                      .then((_) {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => VerifyScreen()));
                        print("Sign up form is done heading to email verification");
                  }).catchError((e){
                    print(e);
                    print("Error occured");

                  });
                }),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              RaisedButton(
                onPressed: login,
                child: Container(
                    padding: EdgeInsets.all(8.0),
                    width: 220.0,
                    height: 60.0,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                      image:
                          AssetImage('assets/images/google_signin_button.png'),
                      fit: BoxFit.cover,
                    ))),
              )
            ],
          ),
        ],
      ),
      backgroundColor: Theme.of(context).accentColor,
    );
  }

  ////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    return isAuth ? buildAuthScreen() : buildUnAuthScreen();
  }
}
