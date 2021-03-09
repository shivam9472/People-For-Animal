// import 'dart:io';

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:peopleforanimal/screens/adminloginscreen.dart';
// import 'package:peopleforanimal/screens/adminscreen.dart';

// class AdminOtppage extends StatefulWidget {
//   final String phone;

//   AdminOtppage({
//     Key key,
//     this.phone,
//   }) : super(key: key);

//   @override
//   _AdminOtppageState createState() => _AdminOtppageState();
// }

// class _AdminOtppageState extends State<AdminOtppage> {
//   final databaseReference = FirebaseDatabase.instance.reference();

//   String smscode;
//   String _verificationCode;
//   bool loading = false;
//   _verifyPhone() async {
//     await FirebaseAuth.instance.verifyPhoneNumber(
//         phoneNumber: '+91${widget.phone}',
//         verificationCompleted: (PhoneAuthCredential credential) async {
//           setState(() {
//             loading = true;
//           });
//           await FirebaseAuth.instance
//               .signInWithCredential(credential)
//               .then((value) async {
//             if (value.user != null) {
//               Navigator.pushAndRemoveUntil(
//                   context,
//                   MaterialPageRoute(builder: (context) => Adminscreen()),
//                   (route) => false);
//             }
//           });
//           setState(() {
//             loading = false;
//           });
//         },
//         verificationFailed: (FirebaseAuthException e) {
//           print(e.message);
//         },
//         codeSent: (String verficationID, int resendToken) {
//           setState(() {
//             _verificationCode = verficationID;
//           });
//         },
//         codeAutoRetrievalTimeout: (String verificationID) {
//           setState(() {
//             _verificationCode = verificationID;
//           });
//         },
//         timeout: Duration(seconds: 120));
//   }

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     _verifyPhone();
//   }

//   final _formKey = GlobalKey<FormState>();
//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Contact Details"),
//       ),
//       body: loading
//           ? Center(
//               child: CircularProgressIndicator(),
//             )
//           : SingleChildScrollView(
//               child: Column(
//                 children: [
//                   Container(
//                     height: (size.height * 0.7),
//                     margin: EdgeInsets.all(40),
//                     child: Form(
//                       key: _formKey,
//                       child: Column(
//                         children: [
//                           SizedBox(
//                             height: 30,
//                           ),
//                           TextFormField(
//                               textAlign: TextAlign.center,
//                               keyboardType: TextInputType.number,
//                               maxLength: 6,
//                               decoration: InputDecoration(
//                                 hintText: 'OTP',
//                                 hintStyle: TextStyle(
//                                   fontSize: 16,
//                                 ),
//                                 border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(8),
//                                   borderSide: BorderSide(
//                                     width: 3,
//                                     style: BorderStyle.none,
//                                   ),
//                                 ),
//                                 contentPadding: EdgeInsets.all(16),
//                               ),
//                               onChanged: (val) {
//                                 smscode = val;
//                               },
//                               validator: (val) {
//                                 if (val.length == 0)
//                                   return "This field Can't Be empty";
//                               }),
//                         ],
//                       ),
//                     ),
//                   ),
//                   Container(
//                     height: 50,
//                     width: double.infinity,
//                     child: Expanded(
//                       child: ElevatedButton(
//                         onPressed: () async {
//                           setState(() {
//                             loading = true;
//                           });
//                           try {
//                             await FirebaseAuth.instance
//                                 .signInWithCredential(
//                                     PhoneAuthProvider.credential(
//                                         verificationId: _verificationCode,
//                                         smsCode: smscode))
//                                 .then((value) async {
//                               if (value.user != null) {
//                                 databaseReference
//                                     .child("Users")
//                                     .child(value.user.uid)
//                                     .once()
//                                     .then((snapshot) {
//                                   // print(snapshot.value["role"]);
//                                   if (snapshot.value == null) {
//                                     Platform.isIOS
//                                         ? showCupertinoDialog(
//                                             barrierDismissible: false,
//                                             context: context,
//                                             builder: (ctx) {
//                                               return CupertinoAlertDialog(
//                                                 title:
//                                                     Text("You are not a Admin"),
//                                                 actions: [
//                                                   CupertinoDialogAction(
//                                                       child: Text("OK"),
//                                                       onPressed: () => Navigator
//                                                               .of(context)
//                                                           .pushAndRemoveUntil(
//                                                               MaterialPageRoute(
//                                                                   builder: (ctx) =>
//                                                                       AdminLoginPage()),
//                                                               (route) =>
//                                                                   false)),
//                                                 ],
//                                               );
//                                             })
//                                         : showDialog(
//                                             barrierDismissible: false,
//                                             context: context,
//                                             builder: (ctx) {
//                                               return AlertDialog(
//                                                 title:
//                                                     Text("You are not a Admin"),
//                                                 actions: [
//                                                   FlatButton(
//                                                       child: Text("OK"),
//                                                       onPressed: () => Navigator
//                                                               .of(context)
//                                                           .pushAndRemoveUntil(
//                                                               MaterialPageRoute(
//                                                                   builder: (ctx) =>
//                                                                       AdminLoginPage()),
//                                                               (route) =>
//                                                                   false)),
//                                                 ],
//                                               );
//                                             });
//                                   }

//                                   if (snapshot.value["role"] == "admin") {
//                                     Navigator.pushAndRemoveUntil(
//                                         context,
//                                         MaterialPageRoute(
//                                             builder: (context) =>
//                                                 Adminscreen()),
//                                         (route) => false);
//                                   } else {
//                                     Platform.isIOS
//                                         ? showCupertinoDialog(
//                                             barrierDismissible: false,
//                                             context: context,
//                                             builder: (ctx) {
//                                               return CupertinoAlertDialog(
//                                                 title:
//                                                     Text("You are not a Admin"),
//                                                 actions: [
//                                                   CupertinoDialogAction(
//                                                       child: Text("OK"),
//                                                       onPressed: () => Navigator
//                                                               .of(context)
//                                                           .pushAndRemoveUntil(
//                                                               MaterialPageRoute(
//                                                                   builder: (ctx) =>
//                                                                       AdminLoginPage()),
//                                                               (route) =>
//                                                                   false)),
//                                                 ],
//                                               );
//                                             })
//                                         : showDialog(
//                                             barrierDismissible: false,
//                                             context: context,
//                                             builder: (ctx) {
//                                               return AlertDialog(
//                                                 title:
//                                                     Text("You are not a Admin"),
//                                                 actions: [
//                                                   FlatButton(
//                                                       child: Text("OK"),
//                                                       onPressed: () => Navigator
//                                                               .of(context)
//                                                           .pushAndRemoveUntil(
//                                                               MaterialPageRoute(
//                                                                   builder: (ctx) =>
//                                                                       AdminLoginPage()),
//                                                               (route) =>
//                                                                   false)),
//                                                 ],
//                                               );
//                                             });
//                                   }
//                                 });
//                               }
//                             });
//                             setState(() {
//                               loading = false;
//                             });
//                           } catch (e) {
//                             setState(() {
//                               loading = false;
//                             });
//                             Platform.isIOS
//                                 ? showCupertinoDialog(
//                                     context: context,
//                                     builder: (ctx) {
//                                       return CupertinoAlertDialog(
//                                         title: Text(e.code),
//                                         // content: Expanded(
//                                         //   child: Text(e.message),
//                                         // ),
//                                         actions: [
//                                           CupertinoDialogAction(
//                                             child: Text("OK"),
//                                             onPressed: () =>
//                                                 Navigator.of(context)
//                                                     .pop(false),
//                                           ),
//                                         ],
//                                       );
//                                     })
//                                 : showDialog(
//                                     context: context,
//                                     builder: (ctx) {
//                                       return AlertDialog(
//                                         title: Text(e.code),
//                                         // content: Expanded(
//                                         //   child: Text(e.message),
//                                         // ),
//                                         actions: [
//                                           FlatButton(
//                                             child: Text("OK"),
//                                             onPressed: () =>
//                                                 Navigator.of(context)
//                                                     .pop(false),
//                                           ),
//                                         ],
//                                       );
//                                     });
//                           }
//                         },
//                         child: Text("Submit"),
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//             ),
//     );
//   }
// }
