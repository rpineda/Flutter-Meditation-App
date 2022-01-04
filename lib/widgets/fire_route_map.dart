import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_map_polyline_new/google_map_polyline_new.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:rxdart/rxdart.dart';
import 'dart:async';
// import 'package:firebase_core/firebase_core.dart';

class FireRouteMap extends StatefulWidget {
  // final BitmapDescriptor pinLocationIcon;
  // const FireRouteMap(this.pinLocationIcon);

  @override
  State createState() => FireRouteMapState();
}

class FireRouteMapState extends State<FireRouteMap> {
  Location location = new Location();
  late GoogleMapController mapController;

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Geoflutterfire geo = Geoflutterfire();

  CollectionReference _collectionRef =
      FirebaseFirestore.instance.collection('establishment');

  final Map<String, Marker> _markers = {};

  int _polylineCount = 1;
  Map<PolylineId, Polyline> _polylines = <PolylineId, Polyline>{};

  GoogleMapPolyline _googleMapPolyline =
      new GoogleMapPolyline(apiKey: "AIzaSyCBcVq_cG1OgdvWABZ070ITGcyqVE9WmEA");

  //Polyline patterns
  List<List<PatternItem>> patterns = <List<PatternItem>>[
    <PatternItem>[], //line
    <PatternItem>[PatternItem.dash(30.0), PatternItem.gap(20.0)], //dash
    <PatternItem>[PatternItem.dot, PatternItem.gap(10.0)], //dot
    <PatternItem>[
      //dash-dot
      PatternItem.dash(30.0),
      PatternItem.gap(20.0),
      PatternItem.dot,
      PatternItem.gap(20.0)
    ],
  ];

  LatLng _mapInitLocation = LatLng(14.628434, -90.522713);

  LatLng _originLocation = LatLng(14.5986, -90.5601);
  LatLng _destinationLocation = LatLng(14.5745, -90.5471);

  bool _loading = false;

  _onMapCreated(GoogleMapController controller) async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Processing Data')),
    );

    var curr_pos = await location.getLocation();
    // GeoFirePoint current_point = geo.point(
    //     latitude: curr_pos.latitude as double,
    //     longitude: curr_pos.longitude as double);
    LatLng currLatLng =
        new LatLng(curr_pos.latitude as double, curr_pos.longitude as double);

    var places = await getData();

    setState(() {
      mapController = controller;

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
          onTap: () async {
            setState(() {
              _originLocation = currLatLng;
              _destinationLocation = latLng;
            });

            await _getPolylinesWithLocation();

            // await _addGeoPoint(context);
          },
          infoWindow: InfoWindow(
            title: name,
            snippet: address,
          ),
        );

        _markers[name] = marker;
      });
    });
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
      draggable: false,
      // onDragEnd: (LatLng) async {
      //   await _addGeoPoint(context);
      // },
      // onDragEnd: ((newPosition) async {
      //   newMarkerPosition = newPosition;

      //   await _addGeoPoint(context);
      //   print(newPosition.latitude);
      //   print(newPosition.longitude);
      // }),
      // onTap: () async {
      //   // await _addGeoPoint(context);
      // },
      zIndex: 9999,
      // icon: widget.pinLocationIcon,
      icon: myIcon,
      visible: true,
      markerId: MarkerId(name),
      position: currLatLng,
      infoWindow: InfoWindow(
        title: name,
        snippet: "De click en destino para trazar ruta",
      ),
    );

    _markers[name] = marker;
  }

  Future<List<QueryDocumentSnapshot<Object?>>> getData() async {
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await _collectionRef.get();

    // Get data from docs and convert map to List
    // final allData = querySnapshot.docs.map((doc) => doc.data()).toList();

    return querySnapshot.docs;
  }

  //Get polyline with Location (latitude and longitude)
  _getPolylinesWithLocation() async {
    _setLoadingMenu(true);
    List<LatLng>? _coordinates =
        await _googleMapPolyline.getCoordinatesWithLocation(
            origin: _originLocation,
            destination: _destinationLocation,
            mode: RouteMode.driving);

    setState(() {
      _polylines.clear();
    });
    _addPolyline(_coordinates);
    _setLoadingMenu(false);
  }

  //Get polyline with Address
  _getPolylinesWithAddress() async {
    _setLoadingMenu(true);
    List<LatLng>? _coordinates =
        await _googleMapPolyline.getPolylineCoordinatesWithAddress(
            origin: '55 Kingston Ave, Brooklyn, NY 11213, USA',
            destination: '8007 Cypress Ave, Glendale, NY 11385, USA',
            mode: RouteMode.driving);

    setState(() {
      _polylines.clear();
    });
    _addPolyline(_coordinates);
    _setLoadingMenu(false);
  }

  _addPolyline(List<LatLng>? _coordinates) {
    PolylineId id = PolylineId("poly$_polylineCount");
    Polyline polyline = Polyline(
        polylineId: id,
        patterns: patterns[0],
        color: Colors.blueAccent,
        points: _coordinates!,
        width: 10,
        onTap: () {});

    setState(() {
      _polylines[id] = polyline;
      _polylineCount++;
    });
  }

  _setLoadingMenu(bool _status) {
    setState(() {
      _loading = _status;
    });
  }

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
        title: Text('Como llegar'),
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
                    onMapCreated: _onMapCreated,
                    polylines: Set<Polyline>.of(_polylines.values),
                    initialCameraPosition: CameraPosition(
                      target: _mapInitLocation,
                      zoom: 15,
                    ),
                    markers: _markers.values.toSet(),
                  ),
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _loading
          ? Container(
              color: Colors.black.withOpacity(0.75),
              child: Center(
                child: Text(
                  'Cargando...',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            )
          : Container(),
    );
  }
}
