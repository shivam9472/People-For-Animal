import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:peopleforanimal/screens/otpscreen.dart';

class ContactDetailScreen extends StatefulWidget {
  ContactDetailScreen({
    Key key,
  }) : super(key: key);

  @override
  _ContactDetailScreenState createState() => _ContactDetailScreenState();
}

class _ContactDetailScreenState extends State<ContactDetailScreen> {
  // String name;
  String phoneno;
  String uid;
  final _formKey = GlobalKey<FormState>();

  void sumbit() {
    if (_formKey.currentState.validate()) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (ctx) => Otpscreen(
                phone: phoneno,

                // name: name,
              )));
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: Text("Contact Details"),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: (size.height * 0.7),
                margin: EdgeInsets.all(40),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 30,
                      ),
                      // TextFormField(
                      //   textAlign: TextAlign.center,
                      //   keyboardType: TextInputType.text,
                      //   decoration: InputDecoration(
                      //     hintText: 'Your Name',
                      //     hintStyle: TextStyle(
                      //       fontSize: 16,
                      //     ),
                      //     border: OutlineInputBorder(
                      //       borderRadius: BorderRadius.circular(8),
                      //       borderSide: BorderSide(
                      //         width: 3,
                      //         style: BorderStyle.none,
                      //       ),
                      //     ),
                      //     contentPadding: EdgeInsets.all(16),
                      //   ),
                      //   onChanged: (val) {
                      //     name = val;
                      //   },
                      //   validator: (val) {
                      //     if (val.length == 0)
                      //       return "This field Can't Be empty";
                      //   },
                      // ),
                      // SizedBox(
                      //   height: 10,
                      // ),
                      TextFormField(
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        maxLength: 10,
                        decoration: InputDecoration(
                          hintText: 'Your Contact Number',
                          hintStyle: TextStyle(
                            fontSize: 16,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              width: 3,
                              style: BorderStyle.none,
                            ),
                          ),
                          contentPadding: EdgeInsets.all(16),
                        ),
                        onChanged: (val) {
                          phoneno = val;
                        },
                        validator: (val) {
                          if (val.length == 0 || val.length != 10)
                            return "This field Can't Be empty";
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: 50,
                width: double.infinity,
                child: Expanded(
                  child: ElevatedButton(
                    onPressed: () => sumbit(),
                    child: Text("Request OTP"),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
