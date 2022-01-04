import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:rxdart/rxdart.dart';
import 'dart:async';
// import 'package:firebase_core/firebase_core.dart';

class FireMap extends StatefulWidget {
  // final BitmapDescriptor pinLocationIcon;
  // const FireMap(this.pinLocationIcon);

  @override
  State createState() => FireMapState();
}

class FireMapState extends State<FireMap> {
  late GoogleMapController mapController;
  Location location = new Location();

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Geoflutterfire geo = Geoflutterfire();

  CollectionReference _collectionRef =
      FirebaseFirestore.instance.collection('establishment');

  final Map<String, Marker> _markers = {};

  late BitmapDescriptor myIcon;
  late LatLng newMarkerPosition;

  @override
  void initState() {
    BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(48, 48)),
            'assets/icons/iconViolet.png')
        .then((onValue) {
      myIcon = onValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xff121421),
        appBar: AppBar(
          title: Text('Registro'),
          backgroundColor: Color(0xff121421),
        ),
        body: Container(
          child: LayoutBuilder(
            builder: (context, cont) {
              return Column(
                children: <Widget>[
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height - 136,
                    child: GoogleMap(
                      initialCameraPosition: CameraPosition(
                          target: LatLng(14.628434, -90.522713), zoom: 13),
                      onMapCreated: _onMapCreated,
                      myLocationEnabled: true,
                      mapType: MapType.normal,
                      compassEnabled: true,
                      markers: _markers.values.toSet(),
                      // trackCameraPosition: true,
                    ),
                  ),
                ],
              );
            },
          ),
        ));
  }

  build2(context) {
    return Stack(children: [
      GoogleMap(
        initialCameraPosition:
            CameraPosition(target: LatLng(14.628434, -90.522713), zoom: 13),
        onMapCreated: _onMapCreated,
        myLocationEnabled: true,
        mapType: MapType.normal,
        compassEnabled: true,
        markers: _markers.values.toSet(),
        // trackCameraPosition: true,
      ),
      Positioned(
          bottom: 100,
          right: 10,
          child: TextButton(
              child: Icon(Icons.update, size: 40.0),
              // color: Colors.green,
              onPressed: () async {
                // await _addGeoPoint(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Processing Data')),
                );

                setState(() {});
              })),
    ]);
  }

  Future<List<QueryDocumentSnapshot<Object?>>> getData() async {
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await _collectionRef.get();

    // Get data from docs and convert map to List
    // final allData = querySnapshot.docs.map((doc) => doc.data()).toList();

    return querySnapshot.docs;
  }

  _animateToUser(currLatLng) {
    // var pos = await location.getLocation();
    mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: currLatLng,
      zoom: 13,
    )));

    // Current Position Marker
    var name = "Está aquí";

    var marker = Marker(
      draggable: true,
      // onDragEnd: (LatLng) async {
      //   await _addGeoPoint(context);
      // },
      onDragEnd: ((newPosition) async {
        newMarkerPosition = newPosition;

        await _addGeoPoint(context);
        print(newPosition.latitude);
        print(newPosition.longitude);
      }),
      onTap: () async {
        // await _addGeoPoint(context);
      },
      zIndex: 9999,
      // icon: widget.pinLocationIcon,
      icon: myIcon,
      visible: true,
      markerId: MarkerId(name),
      position: currLatLng,
      infoWindow: InfoWindow(
        title: name,
        snippet: "Puede arrastrar y soltar el marcador",
      ),
    );

    _markers[name] = marker;
  }

  // Map Created Lifecycle Hook
  _onMapCreated(GoogleMapController controller) async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Processing Data')),
    );

    // await setCustomMapPin();

    var curr_pos = await location.getLocation();
    // GeoFirePoint current_point = geo.point(
    //     latitude: curr_pos.latitude as double,
    //     longitude: curr_pos.longitude as double);
    LatLng currLatLng =
        new LatLng(curr_pos.latitude as double, curr_pos.longitude as double);

    print('****************************');
    var places = await getData();

    mapController = controller;

    setState(() {
      _markers.clear();

      _animateToUser(currLatLng);

      places.forEach((element) {
        var name = element.get("name");
        var address = element.get("address");

        var pos = element.get('position')['geopoint'];
        LatLng latLng = new LatLng(pos.latitude, pos.longitude);

        var marker = Marker(
          markerId: MarkerId(name),
          position: latLng,
          infoWindow: InfoWindow(
            title: name,
            snippet: address,
          ),
        );

        _markers[name] = marker;
      });
    });
  }

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Set GeoLocation Data
  Future<void> _addGeoPoint(BuildContext context) async {
    return await showDialog(
        context: context,
        builder: (context) {
          final TextEditingController _establishment_name =
              TextEditingController();
          final TextEditingController _establishment_address =
              TextEditingController();
          final TextEditingController _establishment_phone =
              TextEditingController();
          final TextEditingController _establishment_email =
              TextEditingController();

          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: Text("Nuevo Establecimiento"),
              content: SingleChildScrollView(
                child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          controller: _establishment_name,
                          validator: (value) {
                            if (value != null) {
                              return value.isNotEmpty
                                  ? null
                                  : "Establecimiento invalido";
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(hintText: "Nombre"),
                        ),
                        TextFormField(
                          controller: _establishment_address,
                          validator: (value) {
                            if (value != null) {
                              return value.isNotEmpty
                                  ? null
                                  : "Dirección invalida";
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(hintText: "Dirección"),
                        ),
                        TextFormField(
                          controller: _establishment_phone,
                          validator: (value) {
                            if (value != null) {
                              return value.isNotEmpty
                                  ? null
                                  : "Teléfono invalido";
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(hintText: "Teléfono"),
                        ),
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          controller: _establishment_email,
                          validator: (value) {
                            if (value != null) {
                              return value.isNotEmpty ? null : "Email invalido";
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(hintText: "Email"),
                        )
                      ],
                    )),
              ),
              actions: [
                TextButton(
                    onPressed: () async {
                      if (_formKey.currentState == null) return null;

                      if (_formKey.currentState!.validate()) {
                        //Save to firestore
                        // var pos = await location.getLocation();
                        var pos = newMarkerPosition;
                        GeoFirePoint point = geo.point(
                            latitude: pos.latitude, longitude: pos.longitude);

                        setState(() {
                          // _markers.clear();
                          // for (final office in googleOffices.offices) {
                          final marker = Marker(
                            markerId: MarkerId(_establishment_name.text),
                            position: LatLng(pos.latitude, pos.longitude),
                            infoWindow: InfoWindow(
                              title: _establishment_name.text,
                              snippet: _establishment_address.text,
                            ),
                          );
                          _markers[_establishment_name.text] = marker;
                          // }
                        });

                        firestore.collection('establishment').add({
                          'position': point.data,
                          'name': _establishment_name.text,
                          'address': _establishment_address.text,
                          'phone': _establishment_phone.text,
                          'email': _establishment_email.text
                        });

                        Navigator.of(context).pop();
                      }
                    },
                    child: Text('Grabar'))
              ],
            );
          });
        });
    //
    // return firestore.collection('establishment').add({
    //   'position': point.data,
    //   'name': 'Happy Pass Point'
    // });
  }

  // void _updateMarkers(List<DocumentSnapshot> documentList) {
  //   print(documentList);
  //   // mapController.clearMarkers();
  //
  //   documentList.forEach((DocumentSnapshot document) {
  //     // GeoPoint pos = document.data.position.geopoint;
  //     // double distance = document.data['distance'];
  //     // var marker = MarkerOptions(
  //     //     position: LatLng(pos.latitude, pos.longitude),
  //     //     icon: BitmapDescriptor.defaultMarker,
  //     //     infoWindowText: InfoWindowText('Magic Marker', '$distance kilometers from query center')
  //     // );
  //     //
  //     //
  //     // mapController.addMarker(marker);
  //
  //     print(document);
  //   });
  // }

  @override
  dispose() {
    // subscription.cancel();
    super.dispose();
  }
}
