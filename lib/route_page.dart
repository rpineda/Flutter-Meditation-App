import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:happy_pass/widgets/establishment_form.dart';
// import 'package:happy_pass/widgets/fire_map.dart';
import 'package:happy_pass/widgets/fire_route_map.dart';
// import 'package:happy_pass/widgets/payment_boxes.dart';
// import 'package:happy_pass/widgets/payment_form.dart';
// import 'package:happy_pass/widgets/svg_asset.dart';

// import 'icons.dart';

class RoutePage extends StatefulWidget {
  const RoutePage({
    Key? key,
  }) : super(key: key);

  @override
  State<RoutePage> createState() => _RoutePageState();
}

class _RoutePageState extends State<RoutePage> {
  late BitmapDescriptor pinLocationIcon;

  @override
  void initState() {
    super.initState();

    // setCustomMapPin();
  }

  // setCustomMapPin() async {
  //   pinLocationIcon = await BitmapDescriptor.fromAssetImage(
  //       ImageConfiguration(devicePixelRatio: 2.5),
  //       'assets/icons/iconViolet.png');
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff121421),
      body: FireRouteMap(),
    );
  }
}
