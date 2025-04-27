import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_app/components/customtextfieldadd.dart';

class Addcategory extends StatefulWidget {
  const Addcategory({super.key});

  @override
  State<Addcategory> createState() => _AddcategoryState();
}

class _AddcategoryState extends State<Addcategory> {
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();

  final CollectionReference categories =
      FirebaseFirestore.instance.collection('categories');
  bool isloading = false;

  Future<void> addCategory() async {
    if (formstate.currentState!.validate()) {
      try {
        setState(() {
          isloading = true;
        });

        User? currentUser = FirebaseAuth.instance.currentUser;
        print("المستخدم الحالي: ${currentUser?.uid}");

        if (currentUser == null) {
          throw "الرجاء تسجيل الدخول أولاً";
        }

        // إضافة الفئة الجديدة
        await categories.add({
          "name": name.text,
          "id": currentUser.uid,
          "timestamp": FieldValue.serverTimestamp()
        }).then((value) {
          print("تم إضافة الفئة بنجاح! المعرف: ${value.id}");
          Navigator.of(context)
              .pushNamedAndRemoveUntil("homebage", (route) => false);
        }).catchError((error) {
          print("خطأ في إضافة الفئة: $error");
          throw error;
        });
      } catch (e) {
        print("خطأ: $e");
        setState(() {
          isloading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("حدث خطأ في إضافة الفئة: $e"),
          backgroundColor: Colors.red,
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Category".tr),
      ),
      body: Form(
          key: formstate,
          child: isloading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    Container(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 25),
                      child: customtextformadd(
                        hinttext: "Enter cover Name".tr,
                        mycontroller: name,
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return "لا يمكن أن يكون الاسم فارغاً";
                          }
                          return null;
                        },
                        mycotroller: name,
                      ),
                    ),
                    MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      height: 40,
                      textColor: Colors.white,
                      color: const Color.fromARGB(255, 0, 174, 255),
                      onPressed: addCategory,
                      child: Text("Add".tr),
                    ),
                  ],
                )),
    );
  }
}
