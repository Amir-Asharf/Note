import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart'; // تأكد من استيراد GetX
import 'package:notes_app/components/customtextfieldadd.dart';

class EditCategory extends StatefulWidget {
  final String docid;
  final String oldname;
  const EditCategory({super.key, required this.docid, required this.oldname});

  @override
  State<EditCategory> createState() => _EditCategoryState();
}

class _EditCategoryState extends State<EditCategory> {
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();
  CollectionReference categories =
      FirebaseFirestore.instance.collection('categories');
  bool isloading = false;

  editCategory() async {
    if (formstate.currentState!.validate()) {
      try {
        isloading = true;
        setState(() {});
        await categories.doc(widget.docid).update({"name": name.text});

        Navigator.of(context).pushReplacementNamed("homebage");
      } catch (e) {
        isloading = false;
        setState(() {});
        print("Error $e");
      }
    }
  }

  @override
  void initState() {
    name.text = widget.oldname;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Category".tr), // الترجمة هنا
      ),
      body: Form(
          key: formstate,
          child: isloading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  children: [
                    Container(
                      height: 20,
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 25),
                      child: customtextformadd(
                        hinttext: "Enter Category Name".tr, // الترجمة هنا
                        mycontroller: name,
                        validator: (val) {
                          if (val == "") {
                            return "can’t be Embty".tr; // الترجمة هنا
                          }
                        },
                        mycotroller: name,
                      ),
                    ),
                    MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      height: 40,
                      textColor: Colors.white,
                      color: Color.fromARGB(255, 0, 174, 255),
                      onPressed: () {
                        editCategory();
                      },
                      child: Text("Save".tr), // الترجمة هنا
                    ),
                  ],
                )),
    );
  }
}
