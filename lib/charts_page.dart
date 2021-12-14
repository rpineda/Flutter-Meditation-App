import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:happy_pass/widgets/payment_boxes.dart';
import 'package:happy_pass/widgets/payment_form.dart';
import 'package:happy_pass/widgets/svg_asset.dart';

import 'icons.dart';


class ChartsPage extends StatefulWidget {
  const ChartsPage({
    Key? key,
  }) : super(key: key);

  @override
  State<ChartsPage> createState() => _ChartsPageState();
}

class _ChartsPageState extends State<ChartsPage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff121421),
      body: SafeArea(
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            Padding(
                padding: EdgeInsets.only(
                  left: 28.w,
                  right: 18.w,
                  top: 36.h
                ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Billetera",
                  style: TextStyle(
                   color: Colors.white,
                   fontSize: 34.w,
                   fontWeight: FontWeight.bold)),
                  InkWell(
                    borderRadius: BorderRadius.circular(360),
                    onTap: null,
                    child: Container(
                      height: 35.w,
                      width: 35.w,
                      child: Center(
                        child: SvgAsset(
                          assetName: AssetName.creditCardPayment,
                          height: 24.w,
                          width: 24.w,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ),
            Container(
              height: 120.h,
              child: ListView(
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                children: [
                  SizedBox(
                    width: 45.w,
                  ),
                  PaymentBoxes(
                    text: "USD 25",
                    onPressed: (value) => print(value),
                  ),
                  PaymentBoxes(
                    text: "USD 50",
                    onPressed: (value) => print(value),
                  ),
                  PaymentBoxes(
                    text: "USD 100",
                    onPressed: (value) => print(value),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 28.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Saldo actual",
                    style: TextStyle(
                        color: Color(0xff515979),
                        fontWeight: FontWeight.w500,
                        fontSize: 14.w),
                  ),
                  Text(
                    "USD 150.00",
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
              child: PaymentForm()
            )
          ],
        ),
      ),
    );
  }
}
