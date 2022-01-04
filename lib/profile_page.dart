import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:happy_pass/widgets/establishment_form.dart';
// import 'package:happy_pass/widgets/payment_boxes.dart';
// import 'package:happy_pass/widgets/payment_form.dart';
// import 'package:happy_pass/widgets/svg_asset.dart';

// import 'icons.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({
    Key? key,
  }) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff121421),
      body: SafeArea(
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            Padding(
                padding: EdgeInsets.only(left: 28.w, right: 18.w, top: 36.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Registro",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 34.w,
                            fontWeight: FontWeight.bold)),
                  ],
                )),
            Container(
              height: 120.h,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 16.h),
                child: Text(
                  "El registro del establecimiento es gratuito, sin embargo la activación depende de la aprobación de Happy Pass",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 28.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Información del establecimiento",
                    style: TextStyle(
                        color: Color(0xff515979),
                        fontWeight: FontWeight.w500,
                        fontSize: 14.w),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 16.h,
            ),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 28.w),
                child: EstablishmentForm())
          ],
        ),
      ),
    );
  }
}
