// Create a Form widget.
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PaymentForm extends StatefulWidget {
  const PaymentForm({Key? key}) : super(key: key);

  @override
  PaymentFormState createState() {
    return PaymentFormState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class PaymentFormState extends State<PaymentForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<PaymentFormState>.
  final _formKey = GlobalKey<FormState>();

  final ccNumber = TextEditingController();
  final ccName = TextEditingController();
  final ccExp = TextEditingController();
  final ccCvv = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    ccNumber.dispose();
    ccName.dispose();
    ccExp.dispose();
    ccCvv.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            decoration: InputDecoration(
              // hintText: "Numero de tarjeta",
              // hintStyle: TextStyle(color: Colors.white38),
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              labelText: 'Número de tarjeta',
              labelStyle: TextStyle(color: Colors.white70),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white70),
              ),
              fillColor: Colors.white,
            ),
            controller: ccNumber,
          ),
          TextField(
            decoration: InputDecoration(
              // hintText: "Nombre en tarjeta",
              // hintStyle: TextStyle(color: Colors.white38),
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              labelText: 'Nombre en tarjeta',
              labelStyle: TextStyle(color: Colors.white70),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white70),
              ),
              fillColor: Colors.white,
            ),
            controller: ccName,
          ),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  // height: 46.h,
                  width: 140.w,
                  child: TextField(
                    decoration: InputDecoration(
                      // hintText: "Nombre en tarjeta",
                      // hintStyle: TextStyle(color: Colors.white38),
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      labelText: 'MM/YY',
                      labelStyle: TextStyle(color: Colors.white70),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white70),
                      ),
                      fillColor: Colors.white,
                    ),
                    controller: ccExp,
                  ),
                ),
                SizedBox(
                  // height: 46.h,
                  width: 140.w,
                  child: TextField(
                    decoration: InputDecoration(
                      // hintText: "Nombre en tarjeta",
                      // hintStyle: TextStyle(color: Colors.white38),
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      labelText: 'CVV',
                      labelStyle: TextStyle(color: Colors.white70),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white70),
                      ),
                      fillColor: Colors.white,
                    ),
                    controller: ccCvv,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 16.h,
          ),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // SizedBox(
                //   // height: 46.h,
                //   width: 140.w,
                //   child: Padding(
                //     padding: const EdgeInsets.symmetric(vertical: 16.0),
                //     child: ElevatedButton(
                //       onPressed: () {
                //         // Validate returns true if the form is valid, or false otherwise.
                //         if (_formKey.currentState!.validate()) {
                //           // If the form is valid, display a snackbar. In the real world,
                //           // you'd often call a server or save the information in a database.
                //           ScaffoldMessenger.of(context).showSnackBar(
                //             const SnackBar(content: Text('Escaneando tarjeta')),
                //           );
                //         }
                //       },
                //       child: const Text('Escanear'),
                //     ),
                //   ),
                // ),
                SizedBox(
                  width: 140.w,
                  child: Container(),
                ),
                SizedBox(
                  // height: 46.h,
                  width: 140.w,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: ElevatedButton(
                      onPressed: () {
                        // Validate returns true if the form is valid, or false otherwise.
                        if (_formKey.currentState!.validate()) {
                          // If the form is valid, display a snackbar. In the real world,
                          // you'd often call a server or save the information in a database.
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Processing Data')),
                          );
                        }
                      },
                      child: const Text('Pagar'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
