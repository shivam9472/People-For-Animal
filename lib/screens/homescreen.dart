import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:peopleforanimal/screens/adminscreen.dart';
import 'package:peopleforanimal/screens/contactdetailscreen.dart';
import 'package:peopleforanimal/screens/detailsscreen.dart';
import 'package:peopleforanimal/screens/landing_page.dart';
import 'package:peopleforanimal/screens/recueteamname.dart';
import 'package:peopleforanimal/screens/teamscreen.dart';
import 'package:peopleforanimal/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:uuid/uuid.dart';

class Homescreen extends StatefulWidget {
  final String phone;
  final String uid;
  final String role;
  final String completed;
  final String name;

  Homescreen(
      {Key key, this.phone, this.uid, this.role, this.completed, this.name})
      : super(key: key);

  @override
  _HomescreenState createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  double longitude;
  double latitude;
  String address1 = "";
  String address2 = "";
  var address;
  bool loading = false;
  var uuid = Uuid();
  Razorpay _razorpay;

  getcurrentlocation() async {
    bool serviceEnabled;
    LocationPermission permission;
    setState(() {
      loading = true;
    });
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permantly denied, we cannot request permissions.');
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      setState(() {
        loading = false;
      });
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return Future.error(
            'Location permissions are denied (actual value: $permission).');
      }
    }
    setState(() {
      loading = true;
    });
    final geoposition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    latitude = geoposition.latitude;
    longitude = geoposition.longitude;

    print(latitude.toString());
    print(longitude.toString());
    final cordinate = Coordinates(geoposition.latitude, geoposition.longitude);
    address = await Geocoder.local.findAddressesFromCoordinates(cordinate);

    address1 = address.first.featureName;
    address2 = address.first.addressLine;

    print(address2);
    setState(() {
      loading = false;
    });
  }

  void initState() {
    super.initState();
    getcurrentlocation();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    color = Colors.transparent;
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void openCheckout(int amount) async {
    var options = {
      'key': 'rzp_test_ZgdGYftBzgtwi0',
      'amount': amount * 100,
      'name': "People For Animals",
      'prefill': {'contact': '', 'email': ''},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint(e);
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    Fluttertoast.showToast(
        msg: "SUCCESS: " + response.paymentId, timeInSecForIosWeb: 4);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
        msg: "ERROR: " + response.code.toString() + " - " + response.message,
        timeInSecForIosWeb: 4);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET: " + response.walletName, timeInSecForIosWeb: 4);
  }

  void confirm(BuildContext context, String address3, double latitude1,
      double longitude1) {
    Platform.isIOS
        ? showCupertinoDialog(
            context: context,
            builder: (ctx) {
              return CupertinoAlertDialog(
                title: Text("Confirm Location"),
                content: Expanded(
                  child: Text(
                      "Please confirm the animal location.This location will be shared with the People For Animal Teams"),
                ),
                actions: [
                  CupertinoDialogAction(
                    child: Text(
                      "Change",
                      style: TextStyle(color: Colors.grey),
                    ),
                    onPressed: () => Navigator.of(context).pop(false),
                  ),
                  CupertinoDialogAction(
                      child: Text("Confirm"),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (ctx) => DetailsScreen(
                                  address: address3,
                                  latitue: latitude1,
                                  longitude: longitude1,
                                  phone: widget.phone,
                                  uid: widget.uid,
                                  role: widget.role,
                                )));
                      }),
                ],
              );
            })
        : showDialog(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                title: Text("Confirm Location"),
                content: Expanded(
                  child: Text(
                      "Please confirm the animal location . This location will be shared with the People For Animal Team "),
                ),
                actions: [
                  FlatButton(
                    child: Text(
                      "Change",
                      style: TextStyle(color: Colors.grey),
                    ),
                    onPressed: () => Navigator.of(context).pop(false),
                  ),
                  FlatButton(
                      child: Text("Confirm"),
                      onPressed: () =>
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (ctx) => DetailsScreen(
                                    address: address3,
                                    latitue: latitude1,
                                    longitude: longitude1,
                                    phone: widget.phone,
                                    uid: widget.uid,
                                    role: widget.role,
                                  )))),
                ],
              );
            });
  }

  GoogleMapController _controller;

  Color color = Colors.transparent;
  // Set<Marker> markers = Set.from([]);
  //  Marker marker = Marker(
  //                 markerId: MarkerId('1'),
  //                 position: coordinate,
  //                 draggable: true,
  //                 infoWindow: InfoWindow(title: address2));
  //             setState(() {
  //               markers.add(marker);
  //             });
  int amount = 100;
  void setamount(int givenamount, setState, Color color) {
    setState(() {
      amount = givenamount;
      color = Colors.blue;
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        actions: [
          PopupMenuButton(
              icon: Icon(Icons.more_vert),
              color: Colors.white,
              onSelected: (value) {
                if (value == 3) {
                  auth.signOut();
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (ctx) => ContactDetailScreen(),
                      ),
                      (route) => false);
                } else if (value == 2 && widget.role == "admin") {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (ctx) => Adminscreen(
                                uid: widget.uid,
                              )),
                      (route) => false);
                } else if (value == 2 && widget.role == "team") {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (ctx) => Teamscreen(
                                uid: widget.uid,
                                teamphone: widget.phone,
                              )),
                      (route) => false);
                } else if (value == 1) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (ctx) => RescueteamName(
                              uid: widget.uid,
                            )),
                  );
                }
              },
              itemBuilder: (context) {
                if (widget.role == "admin") {
                  return [
                    PopupMenuItem(value: 1, child: Text("Rescue Team")),
                    PopupMenuItem(value: 2, child: Text("Requests")),
                    PopupMenuItem(value: 3, child: Text("Logout")),
                  ];
                } else if (widget.role == "team") {
                  return [
                    PopupMenuItem(value: 2, child: Text("Requests")),
                    PopupMenuItem(value: 3, child: Text("Logout")),
                  ];
                } else {
                  return [
                    PopupMenuItem(value: 3, child: Text("Logout")),
                  ];
                }
              }),
        ],
        title: Text("Pin Animal Location"),
      ),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : Stack(children: [
              GoogleMap(
                myLocationEnabled: true,
                compassEnabled: true,
                myLocationButtonEnabled: true,

                // markers: markers,
                mapType: MapType.normal,
                initialCameraPosition: CameraPosition(
                  target: LatLng(latitude, longitude),
                  zoom: 14.4746,
                ),
                onMapCreated: (controller) {
                  _controller = controller;
                },

                // onTap: (coordinate) async {
                //   _controller.animateCamera(CameraUpdate.newLatLng(coordinate));
                //   setState(() {
                //     latitude = coordinate.latitude;
                //     longitude = coordinate.longitude;
                //   });
                //   print(latitude);
                //   print(longitude);
                //   final cordinate =
                //       Coordinates(coordinate.latitude, coordinate.longitude);
                //   address = await Geocoder.local
                //       .findAddressesFromCoordinates(cordinate);
                //   setState(() {
                //     address1 = address.first.featureName;
                //     address2 = address.first.addressLine;
                //   });
                //   print(address2);

                //   Marker marker = Marker(
                //       markerId: MarkerId('1'),
                //       position: coordinate,
                //       draggable: true,
                //       infoWindow: InfoWindow(title: address2));
                //   setState(() {
                //     markers.add(marker);
                //   });
                // },
              ),
              widget.completed == "yes"
                  ? Dismissible(
                      key: Key(uuid.v1()),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            height: size.height * 0.1,
                            color: Colors.white,
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Peole For animals",
                                      style: TextStyle(fontSize: 12),
                                    ),
                                    SizedBox(
                                      height: 7,
                                    ),
                                    SizedBox(
                                      width: size.width * .65,
                                      child: Text(
                                        "${widget.name},Your Request has been Completed",
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(18),
                                  child: SizedBox(
                                      height: 30,
                                      width: size.width * .23,
                                      child: Expanded(
                                          child: RaisedButton(
                                              color: Colors.blue,
                                              child: Text(
                                                "Donate",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              onPressed: () {
                                                showDialog(
                                                    context: context,
                                                    builder: (ctx) =>
                                                        StatefulBuilder(builder:
                                                            (BuildContext
                                                                    context,
                                                                StateSetter
                                                                    setState) {
                                                          return AlertDialog(
                                                              content:
                                                                  Container(
                                                            height: 200,
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Text(
                                                                  "Make A Donation",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          18),
                                                                ),
                                                                SizedBox(
                                                                  height: 20,
                                                                ),
                                                                Text(
                                                                  "₹$amount:|A Perfect Amount to start Contributing",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      color: Colors
                                                                          .blue),
                                                                ),
                                                                SizedBox(
                                                                  height: 20,
                                                                ),
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    GestureDetector(
                                                                        onTap:
                                                                            () {
                                                                          setamount(
                                                                              100,
                                                                              setState,
                                                                              color);
                                                                        },
                                                                        child: Container(
                                                                            color:
                                                                                color,
                                                                            child:
                                                                                Text("100"))),
                                                                    GestureDetector(
                                                                        onTap:
                                                                            () {
                                                                          setamount(
                                                                              200,
                                                                              setState,
                                                                              color);
                                                                        },
                                                                        child: Container(
                                                                            color:
                                                                                color,
                                                                            child:
                                                                                Text("200"))),
                                                                    GestureDetector(
                                                                        onTap:
                                                                            () {
                                                                          setamount(
                                                                              400,
                                                                              setState,
                                                                              color);
                                                                        },
                                                                        child: Container(
                                                                            color:
                                                                                color,
                                                                            child:
                                                                                Text("400"))),
                                                                    GestureDetector(
                                                                        onTap:
                                                                            () {
                                                                          setamount(
                                                                              500,
                                                                              setState,
                                                                              color);
                                                                        },
                                                                        child: Container(
                                                                            color:
                                                                                color,
                                                                            child:
                                                                                Text("500"))),
                                                                  ],
                                                                ),
                                                                SizedBox(
                                                                  height: 30,
                                                                ),
                                                                ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              18),
                                                                  child: Container(
                                                                      height: 40,
                                                                      child: Expanded(
                                                                          child: RaisedButton(
                                                                              color: Colors.blue,
                                                                              child: Text(
                                                                                "Begin Payment",
                                                                                style: TextStyle(color: Colors.white),
                                                                              ),
                                                                              onPressed: () {
                                                                                openCheckout(amount);
                                                                              }))),
                                                                ),
                                                              ],
                                                            ),
                                                          ));
                                                        }));
                                              }))),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  : Container(),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // SizedBox(
                  //   height: 10,
                  // ),
                  // Container(
                  //   width: double.infinity,
                  //   height: 50,
                  //   child: Expanded(
                  //     child: Text(
                  //       address2,
                  //       style: TextStyle(backgroundColor: Colors.white,),
                  //     ),
                  //   ),
                  // // ),
                  // TextField(
                  //   decoration: InputDecoration(
                  //       labelText: address2,
                  //       fillColor: Colors.white,
                  //       filled: true),
                  //   readOnly: true,
                  // ),
                  Container(
                    width: double.infinity,
                    height: 40,
                    child: Expanded(
                      child: ElevatedButton(
                        onPressed: () =>
                            confirm(context, address2, latitude, longitude),
                        child: Text("Confirm Location"),
                      ),
                    ),
                  ),
                ],
              )
            ]),
    );
  }
}
