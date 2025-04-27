import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_app/note/add.dart';
import 'package:notes_app/note/edit.dart';

class Noteview extends StatefulWidget {
  final String categoryid;
  const Noteview({super.key, required this.categoryid});

  @override
  State<Noteview> createState() => _NoteviewState();
}

class _NoteviewState extends State<Noteview> {
  List<QueryDocumentSnapshot> data = [];

  bool isloading = true;
  getdata() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("categories")
        .doc(widget.categoryid)
        .collection("Note")
        .get();

    await Future.delayed(Duration(seconds: 1));
    data.addAll(querySnapshot.docs);
    isloading = false;
    setState(() {});
  }

  @override
  void initState() {
    getdata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
            backgroundColor: Color.fromARGB(255, 0, 174, 255),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => AddNote(docid: widget.categoryid)));
            },
            child: Icon(Icons.add)),
        appBar: AppBar(
            title: Center(child: Text("Noteview".tr)), 
            actions: []),
        body: WillPopScope(
            child: isloading == true
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : GridView.builder(
                    itemCount: data.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, mainAxisExtent: 200),
                    itemBuilder: (context, i) {
                      return InkWell(
                        onLongPress: () {
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.info,

                            animType: AnimType.rightSlide,
                            title: 'error'.tr,
                            titleTextStyle: TextStyle(
                              color: Color.fromARGB(255, 0, 174, 255),
                            ),
                            desc: 'are you sure about the deleting process?'.tr,
                            descTextStyle: TextStyle(
                              color: Color.fromARGB(255, 0, 174, 255),
                            ), 
                            btnCancelColor: Color.fromARGB(255, 0, 174, 255),
                            btnCancelText: 'cancel'.tr,
                            btnOkColor: Color.fromARGB(
                                255, 0, 174, 255),
                            btnOkText: 'ok'.tr, 
                            btnCancelOnPress: () async {},
                            btnOkOnPress: () async {
                              await FirebaseFirestore.instance
                                  .collection("categories")
                                  .doc(widget.categoryid)
                                  .collection("Note")
                                  .doc(data[i].id)
                                  .delete();

                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      Noteview(categoryid: widget.categoryid)));
                            },
                          ).show();
                        },
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => EditNote(
                                  notedocid: data[i].id,
                                  categorydocid: widget.categoryid,
                                  value: data[i]["Note"])));
                        },
                        child: Card(
                          child: Container(
                            padding: EdgeInsets.all(20),
                            child: Column(
                              children: [
                                Text(
                                  "${data[i]["Note"]}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 0, 174, 255),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
            onWillPop: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil("homebage", (route) => false);
              return Future.value(false);
            }));
  }
}
