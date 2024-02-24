import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'Home.dart';
import 'Login.dart';
import 'firebaseauth services.dart';


class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}



class _SignupState extends State<Signup>  {

  final FirebaseAuthService _auth = FirebaseAuthService();


  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();


  @override
  void dispose() {
    _usernameController.dispose();
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
        title: Text("Signup"),
      ),
      //body applied with background image
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Container(
            height: double.infinity,
            width: double.infinity,


            //overall column
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [

                //card
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Container(
                    height: 300,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(10),
                    ),

                    //textField & button
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [


                          TextFormField(
                            controller: _usernameController,
                            keyboardType: TextInputType.text,
                            style: TextStyle( color: Colors.grey),
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.mail),
                              labelText: "Username *",
                              hintText: "Enter a username ",
                              border: OutlineInputBorder(),
                            ),

                            validator: (value){
                              if (value == null || value.isEmpty) {
                                return 'Please enter a username';
                              }

                              return null;
                            },
                          ),


                          //email
                          TextFormField(
                            controller: _emailController,
                            style: TextStyle( color: Colors.grey),
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.mail),
                              labelText: "Email *",
                              hintText: "Enter your email address ",
                              border: OutlineInputBorder(
                              ),
                            ),

                            validator: (value)
                            {
                              if (value == null || value.isEmpty)
                              {
                                return 'Please enter your email address';
                              }
                              if (!emailRegEx.hasMatch(value))
                              {
                                return 'Please enter valid email address';
                              }
                              return null;
                            },
                          ),

                          //password
                          TextFormField(
                            controller: _passwordController,
                            obscureText: _isVisible ? false : true,
                            style: TextStyle( color: Colors.grey),
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
                                    _signUp();
                                    // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=> Login()), (route) => false);
                                  }
                                },
                                child: Text("Signup")
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Already a User? "),
                              GestureDetector(
                                  onTap: (){
                                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=> Login()),(route) => false);
                                  },
                                  child: Text(" Login",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),))
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

  void _signUp() async{

    String username = _usernameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;


    User? user = await _auth.signUpWithEmailAndPassword(email, password);

    if (user!= null){
      print("User is successfully created");
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=> home()), (route) => false);
    } else {
      print("Some Error happened");
    }
  }
}
