import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebaseauth/sign.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'Home.dart';
import 'firebaseauth services.dart';


class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}



class _LoginState extends State<Login>  {




  final FirebaseAuthService _auth = FirebaseAuthService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;



  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }




  //this is used to find the state of the form
  final _formKey = GlobalKey<FormState>();

  //email validation regex
  final emailRegEx = RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+');

  //password hide & show
  bool _isVisible = false;

  void updateStatus(){
    setState(() {
      _isVisible = !_isVisible;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(child: Text("Login")),
      ),
      //body applied with background image
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Container(
            height: MediaQuery.of(context).size.height*1,
            width:MediaQuery.of(context).size.width*1,


            //overall column
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                //card
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Container(
                    height:MediaQuery.of(context).size.height*0.5,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(20),
                    ),

                    //textField & button
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [

                          //email
                          TextFormField(
                            controller:_emailController,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.mail),
                              labelText: "Email *",
                              hintText: "Enter your email address ",
                              border: OutlineInputBorder(),
                            ),

                            validator: (value){
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email address';
                              }
                              if (!emailRegEx.hasMatch(value)) {
                                return 'Please enter valid email address';
                              }
                              return null;
                            },
                          ),

                          //password
                          TextFormField(
                            controller: _passwordController,
                            obscureText: _isVisible ? false : true,
                            decoration: InputDecoration(
                              prefixIcon:Icon(Icons.lock_outline) ,
                              labelText: "Password *",
                              hintText: "Enter your password ",
                              suffixIcon:IconButton(
                                onPressed: () => updateStatus(),
                                icon:Icon(_isVisible ? Icons.visibility: Icons.visibility_off),
                              ),
                              border: OutlineInputBorder(),
                            ),

                            validator: (value){
                              if (value == null || value.isEmpty){
                                return "Please enter your password";
                              }
                              return null;
                            },
                          ),

                          Container(
                            width: 200,
                            height: 40,
                            child: ElevatedButton(
                                onPressed: (){
                                  if(_formKey.currentState!.validate()){
                                    _signIn();
                                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => home()),(route) => false);
                                  }
                                },
                                child: Text("LOGIN")
                            ),
                          ),


                          GestureDetector(
                            onTap: (){
                              _signInWithGoogle();
                            },

                            child: Container(
                              height: 35,
                              width: 35,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(30),
                                  border: Border.all(color: Colors.black,width: 1)
                              ),
                              child: Container(
                                decoration: BoxDecoration(

                                    image: DecorationImage(
                                      image: AssetImage("assets/googleIcon.png"),
                                    )
                                ),
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("New User? "),
                              GestureDetector(
                                  onTap: (){
                                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=> Signup()),(route) => false);
                                  },
                                  child: Text(" Signup",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold)))
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
  void _signIn() async{
    String email = _emailController.text;
    String password = _passwordController.text;


    User? user = await _auth.signInWithEmailAndPassword(email, password);

    if (user!= null){
      print("User is successfully signed in");
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=> home()), (route) => false);
    } else {
      print("Some Error happened");
    }
  }


  _signInWithGoogle()async{



    try {
      final GoogleSignIn _googleSignIn = GoogleSignIn(clientId:
      "406105297801-bs8ildfgagj1akhie8adj0nbkpg2licg.apps.googleusercontent.com");

      final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();

      if(googleSignInAccount != null ){
        final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,


        );

        await _firebaseAuth.signInWithCredential(credential);
        Navigator.push(context, MaterialPageRoute(builder: (context)=>home()));



      }
    }

    catch(e)
    {print( "some error occured $e");}

  }
}
