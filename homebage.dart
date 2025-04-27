import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:notes_app/project/End_drawer.dart';

class homebage extends StatefulWidget {
  const homebage({super.key});

  @override
  State<homebage> createState() => _homebageState();
}

class _homebageState extends State<homebage> {

  List<QueryDocumentSnapshot> originalData = [];

  List<QueryDocumentSnapshot> displayedData = [];
  TextEditingController searchController = TextEditingController();
  bool isloading = true;

  @override
  void initState() {
    super.initState();
    getCategories();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  
  void filterCategories(String query) {
    setState(() {
      if (query.isEmpty) {

        displayedData = List.from(originalData);
      } else {
 
        displayedData = originalData.where((doc) {
          String name = doc['name'].toString().toLowerCase();
          return name.contains(query.toLowerCase());
        }).toList();
      }
    });
  }


  Future<void> getCategories() async {
    try {
      setState(() {
        isloading = true;
      });


      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        Navigator.of(context).pushReplacementNamed("login");
        return;
      }


      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("categories")
          .where("id", isEqualTo: currentUser.uid)
          .get();

      if (mounted) {
        setState(() {
  
          originalData = querySnapshot.docs;
          displayedData = List.from(originalData);
          isloading = false;
        });
      }
    } catch (e) {
      print("Error fetching data: $e");
      if (mounted) {
        setState(() {
          isloading = false;
          originalData = [];
          displayedData = [];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        foregroundColor: Colors.black,
        backgroundColor: Color.fromARGB(255, 0, 174, 255),
        onPressed: () async {
          await Navigator.of(context).pushNamed("Addcategory");
          getCategories(); 
        },
        child: Icon(Icons.note_alt_outlined),
      ),
      appBar: AppBar(
        title: Center(child: Text("Homebage".tr)),
        actions: [],
      ),
      endDrawer: CustomEnddrawer(),
      body: isloading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
       
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    children: [
                      Text(
                        "All Notes".tr,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 0, 174, 255),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: searchController,
                          decoration: InputDecoration(
                            hintText: "Search categories...".tr,
                            prefixIcon: Icon(Icons.search, color: Colors.blue),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(color: Colors.blue),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(color: Colors.blue),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(color: Colors.blue),
                            ),
                          ),
                          onChanged: filterCategories,
                        ),
                      ),
                    ],
                  ),
                ),
   
                Expanded(
                  child: displayedData.isEmpty
                      ? Center(
                          child: Text(
                            searchController.text.isEmpty
                                ? "No categories".tr
                                : "No results found".tr,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        )
                      : GridView.builder(
                          itemCount: displayedData.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2, mainAxisExtent: 200),
                          itemBuilder: (context, i) {
                            final category = displayedData[i];
                            return InkWell(
                              onTap: () async {
                                await Navigator.of(context).pushNamed(
                                  "Noteview",
                                  arguments: {"categoryid": category.id},
                                );
                                getCategories();
                              },
                              onLongPress: () {
                                AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.info,
                                  animType: AnimType.rightSlide,
                                  btnCancelColor: Colors.blue,
                                  btnOkColor: Colors.blue,
                                  desc: 'Choose what you want'.tr,
                                  descTextStyle: TextStyle(color: Colors.blue),
                                  btnCancelText: "Delete".tr,
                                  btnOkText: "Edit".tr,
                                  btnCancelOnPress: () async {
                                    await FirebaseFirestore.instance
                                        .collection("categories")
                                        .doc(category.id)
                                        .delete();
                                    getCategories();
                                  },
                                  btnOkOnPress: () async {
                                    await Navigator.of(context).pushNamed(
                                      "EditCategory",
                                      arguments: {
                                        "docid": category.id,
                                        "oldname": category['name']
                                      },
                                    );
                                    getCategories();
                                  },
                                ).show();
                              },
                              child: Card(
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  child: Column(
                                    children: [
                                      Image.asset(
                                        "images/icon.png",
                                        height: 100,
                                      ),
                                      Text(
                                        "${category['name']}",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color:
                                              Color.fromARGB(255, 0, 174, 255),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
