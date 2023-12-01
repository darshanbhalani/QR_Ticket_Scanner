import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

bool? isNull;
String? cityName;
String? stationName;
String? gateName;
List metroData = [];
List<DropDownValueModel> metroStationsList = [];

Color c1 = const Color.fromARGB(255, 26,67,77);
Color c2 = const Color.fromARGB(255, 251,242,237);

FirebaseFirestore fire = FirebaseFirestore.instance;
FirebaseDatabase ref = FirebaseDatabase.instance;

snackBar(context,Color color,String msg){
  final snackbar = SnackBar(
    content: Text(msg),
    duration: const Duration(seconds: 2),
    backgroundColor: color,
  );
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(snackbar);
}

List<DropDownValueModel> citiesList = [
  const DropDownValueModel(name: "Ahmedabad", value: "Ahmedabad"),
  const DropDownValueModel(name: "Agra", value: "Agra"),
  const DropDownValueModel(name: "Bengaluru", value: "Bengaluru"),
  const DropDownValueModel(name: "Bhopal", value: "Bhopal"),
  const DropDownValueModel(name: "Chennai", value: "Chennai"),
  const DropDownValueModel(name: "Delhi", value: "Delhi"),
];

List<DropDownValueModel> gateList = [
  const DropDownValueModel(name: "Entry", value: "Entry"),
  const DropDownValueModel(name: "Exit", value: "Exit"),
];

loading(context,bool flag) {
  return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async{
            if(!flag){
              snackBar(context, Colors.black87, "Please wait until process completed.");
            }
            return flag;
          },
          child: (
              Center(
                  child: SizedBox(
                      height: 40,
                      width: 40,
                      child:  CircularProgressIndicator(color: c1)
                  )
              )),
        );
      });
}


Future buildDataBase(String city) async {
  metroStationsList = [];
  metroData = [];
  List list = [];
  final snapshot = await ref.ref("Cities/$city").orderByKey().get();
  Map<dynamic, dynamic> values = snapshot.value as Map;
  values.forEach((key, value) {
    list.add(value);
  });
  for (int i = 0; i < list.length; i++) {
    Map temp = list[i];
    List temp1 = [];
    temp1.add(temp["Name"]);
    metroData.add(temp1);
  }
  print("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
  for (int i = 0; i < metroData.length; i++) {
    metroData.sort((a, b) => a[0].compareTo(b[0]));
  }
  for (int i = 0; i < metroData.length; i++) {
    metroStationsList
        .add(DropDownValueModel(name: metroData[i][0], value: metroData[i][0]));
  }
}

