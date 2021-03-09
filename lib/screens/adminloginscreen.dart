// import 'dart:io';

// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:peopleforanimal/models/teamname.dart';
// import 'package:peopleforanimal/screens/adminotpscreen.dart';
// import 'package:peopleforanimal/screens/adminscreen.dart';
// import 'package:peopleforanimal/screens/teamscreen.dart';

// enum WidgetMarker { admin, team }

// class AdminLoginPage extends StatefulWidget {
//   AdminLoginPage({Key key}) : super(key: key);

//   @override
//   _AdminLoginPageState createState() => _AdminLoginPageState();
// }

// class _AdminLoginPageState extends State<AdminLoginPage> {
//   WidgetMarker selectedWidgetMarker = WidgetMarker.admin;
//   final databaseReference = FirebaseDatabase.instance.reference();
//   String phoneno;
//   final _formKey = GlobalKey<FormState>();
//   var keys;

//   bool loading = false;

//   void searchteam() {
//     var teamrefrence = FirebaseDatabase.instance.reference().child("Teams");
//     setState(() {
//       loading = true;
//     });

//     teamrefrence.once().then((datasnapshot) {
//       keys = datasnapshot.value.keys;
//     });
//     setState(() {
//       loading = false;
//     });
//   }

//   bool valid(String phone) {
//     int c = 0;
//     for (var key in keys) {
//       print(key);
//       print(phone);
//       if (key.toString() == phone) {
//         print("Found");
//         setState(() {
//           c++;
//         });
//         break;
//       }
//     }
//     if (c > 0)
//       return true;
//     else {
//       return false;
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     searchteam();
//   }

//   Widget getAdminWidget() {
//     return Form(
//       key: _formKey,
//       child: Container(
//         padding: EdgeInsets.all(20),
//         child: TextFormField(
//           textAlign: TextAlign.center,
//           keyboardType: TextInputType.number,
//           maxLength: 10,
//           decoration: InputDecoration(
//             hintText: 'Your Contact Number',
//             hintStyle: TextStyle(
//               fontSize: 16,
//             ),
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8),
//               borderSide: BorderSide(
//                 width: 3,
//                 style: BorderStyle.none,
//               ),
//             ),
//             contentPadding: EdgeInsets.all(16),
//           ),
//           onChanged: (val) {
//             phoneno = val;
//           },
//           validator: (val) {
//             if (val.length == 0 || val.length != 10)
//               return "This field Can't Be empty";
//           },
//         ),
//       ),
//     );
//   }

//   Widget getRescueteamWidget() {
//     return Form(
//       key: _formKey,
//       child: Container(
//         padding: EdgeInsets.all(20),
//         child: TextFormField(
//           textAlign: TextAlign.center,
//           keyboardType: TextInputType.number,
//           maxLength: 10,
//           decoration: InputDecoration(
//             hintText: 'Your Contact Number',
//             hintStyle: TextStyle(
//               fontSize: 16,
//             ),
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8),
//               borderSide: BorderSide(
//                 width: 3,
//                 style: BorderStyle.none,
//               ),
//             ),
//             contentPadding: EdgeInsets.all(16),
//           ),
//           onChanged: (val) {
//             phoneno = val;
//           },
//           validator: (val) {
//             if (val.length == 0 || val.length != 10)
//               return "This field Can't Be empty";
//           },
//         ),
//       ),
//     );
//   }

//   Widget getCustomContainer() {
//     switch (selectedWidgetMarker) {
//       case WidgetMarker.admin:
//         return getAdminWidget();
//       case WidgetMarker.team:
//         return getRescueteamWidget();
//     }

//     return getAdminWidget();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     return Scaffold(
//       body: loading
//           ? Center(
//               child: CircularProgressIndicator(),
//             )
//           : SingleChildScrollView(
//               child: Container(
//                 height: size.height,
//                 width: size.width,
//                 child: Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           ClipRRect(
//                             borderRadius: BorderRadius.circular(24),
//                             child: Container(
//                               width: size.width * 0.45,
//                               child: Expanded(
//                                 child: RaisedButton(
//                                   color:
//                                       selectedWidgetMarker == WidgetMarker.admin
//                                           ? Colors.blue
//                                           : Colors.white,
//                                   child: Text(
//                                     "Admin",
//                                     style: TextStyle(
//                                       color: selectedWidgetMarker ==
//                                               WidgetMarker.admin
//                                           ? Colors.white
//                                           : Colors.blue,
//                                     ),
//                                   ),
//                                   onPressed: () {
//                                     setState(() {
//                                       selectedWidgetMarker = WidgetMarker.admin;
//                                     });
//                                   },
//                                 ),
//                               ),
//                             ),
//                           ),
//                           ClipRRect(
//                               borderRadius: BorderRadius.circular(24),
//                               child: Container(
//                                   width: size.width * 0.45,
//                                   child: Expanded(
//                                     child: RaisedButton(
//                                       color: selectedWidgetMarker ==
//                                               WidgetMarker.team
//                                           ? Colors.blue
//                                           : Colors.white,
//                                       child: Text(
//                                         "Rescue Team",
//                                         style: TextStyle(
//                                           color: selectedWidgetMarker ==
//                                                   WidgetMarker.team
//                                               ? Colors.white
//                                               : Colors.blue,
//                                         ),
//                                       ),
//                                       onPressed: () {
//                                         setState(() {
//                                           selectedWidgetMarker =
//                                               WidgetMarker.team;
//                                         });
//                                       },
//                                     ),
//                                   )))
//                         ],
//                       ),
//                       SizedBox(
//                         height: 20,
//                       ),
//                       Container(
//                         child: getCustomContainer(),
//                       ),
//                       ElevatedButton(
//                         onPressed: () {
//                           if (_formKey.currentState.validate()) {
//                             if (selectedWidgetMarker == WidgetMarker.admin) {
//                               Navigator.of(context).push(
//                                 MaterialPageRoute(
//                                     builder: (ctx) => AdminOtppage(
//                                           phone: phoneno,
//                                         )),
//                               );
//                             } else {
//                               if (valid(phoneno)) {
//                                 setState(() {
//                                   loading = true;
//                                 });

//                                 var teamrefrence = FirebaseDatabase.instance
//                                     .reference()
//                                     .child("Teams")
//                                     .child(phoneno);
//                                 teamrefrence.once().then((datasnapshot) {
//                                   setState(() {
//                                     loading = false;
//                                   });

//                                   if (datasnapshot.value["active"] == "true") {
//                                     Navigator.of(context).pushAndRemoveUntil(
//                                         MaterialPageRoute(
//                                             builder: (ctx) => Teamscreen(
//                                                   teamphone: phoneno,
//                                                 )),
//                                         (route) => false);
//                                   } else {
//                                     Platform.isIOS
//                                         ? showCupertinoDialog(
//                                             barrierDismissible: false,
//                                             context: context,
//                                             builder: (ctx) {
//                                               return CupertinoAlertDialog(
//                                                 title: Text(
//                                                     "You Have Blocked By Admin.Please Contact Admin"),
//                                                 actions: [
//                                                   CupertinoDialogAction(
//                                                       child: Text("OK"),
//                                                       onPressed: () =>
//                                                           Navigator.of(context)
//                                                               .pop(false)),
//                                                 ],
//                                               );
//                                             })
//                                         : showDialog(
//                                             barrierDismissible: false,
//                                             context: context,
//                                             builder: (ctx) {
//                                               return AlertDialog(
//                                                 title: Text(
//                                                     "You Have Blocked By Admin.Please Contact Admin"),
//                                                 actions: [
//                                                   FlatButton(
//                                                       child: Text("OK"),
//                                                       onPressed: () =>
//                                                           Navigator.of(context)
//                                                               .pop(false)),
//                                                 ],
//                                               );
//                                             });
//                                   }
//                                 });
//                               } else {
//                                 Platform.isIOS
//                                     ? showCupertinoDialog(
//                                         barrierDismissible: false,
//                                         context: context,
//                                         builder: (ctx) {
//                                           return CupertinoAlertDialog(
//                                             title: Text(
//                                                 "You are not a Team Member"),
//                                             actions: [
//                                               CupertinoDialogAction(
//                                                   child: Text("OK"),
//                                                   onPressed: () =>
//                                                       Navigator.of(context)
//                                                           .pop(false)),
//                                             ],
//                                           );
//                                         })
//                                     : showDialog(
//                                         barrierDismissible: false,
//                                         context: context,
//                                         builder: (ctx) {
//                                           return AlertDialog(
//                                             title: Text(
//                                                 "You are not a Team Member"),
//                                             actions: [
//                                               FlatButton(
//                                                   child: Text("OK"),
//                                                   onPressed: () =>
//                                                       Navigator.of(context)
//                                                           .pop(false)),
//                                             ],
//                                           );
//                                         });
//                               }
//                             }
//                           }
//                         },
//                         child: selectedWidgetMarker == WidgetMarker.admin
//                             ? Text("Get OTP")
//                             : Text("Login"),
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//     );
//   }
// }
