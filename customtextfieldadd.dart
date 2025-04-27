import 'package:flutter/material.dart';

class customtextformadd extends StatelessWidget {
  final String hinttext;
  final TextEditingController mycontroller;
  final String? Function(String?)? validator;
  const customtextformadd(
      {super.key,
      required this.hinttext,
      required this.mycontroller,
      required TextEditingController mycotroller,
      required this.validator});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      controller: mycontroller,
      decoration: InputDecoration(
          hintText: hinttext,
          hintStyle: TextStyle(
            fontSize: 15,
            color: Color.fromARGB(255, 0, 174, 255),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 2, horizontal: 20),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(50)),
          filled: true,
          fillColor: const Color.fromARGB(0, 0, 0, 0)),
    );
  }
}
