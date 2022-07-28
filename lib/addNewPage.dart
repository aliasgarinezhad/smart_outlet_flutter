import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Device.dart';
import 'main.dart';

String serialNumber = "";
String password = "";
String name = "";
String status = "";

void saveToMemory() async {

  SharedPreferences memory = await SharedPreferences.getInstance();
  List<String> uiListStringArray = List.empty(growable: true);
  for (var element in uiList) {
    Map<String, dynamic> elementMap = {
      'serialNumber': element.serialNumber,
      'password': element.password,
      'name': element.name,
      'status': element.status
    };
    uiListStringArray.add(jsonEncode(elementMap));
  }
  await memory.setStringList('uiList', uiListStringArray);
}

void addNewDevice() {
  uiList.add(Device(serialNumber, password, name, false));
  saveToMemory();
}

class SecondPage extends StatefulWidget {
  const SecondPage({Key? key}) : super(key: key);

  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("اضافه کردن دستگاه جدید"),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: TextField(
                  onChanged: (text) {
                    serialNumber = text;
                  },
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      labelText: "شماره سریال پریز را وارد کنید",
                      contentPadding: EdgeInsets.all(16),
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(20))))),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: TextField(
                  onChanged: (text) {
                    password = text;
                  },
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      labelText: "رمز عبور پریز را وارد کنید",
                      contentPadding: EdgeInsets.all(16),
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(20))))),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: TextField(
                  onChanged: (text) {
                    name = text;
                  },
                  decoration: const InputDecoration(
                      labelText: "نام دستگاه را وارد کنید (مانند کولر)",
                      contentPadding: EdgeInsets.all(16),
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(20))))),
            ),
            Container(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: ElevatedButton(
                  onPressed: () {
                    if (serialNumber == "") {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content:
                              Text("لطفا شماره سریال دستگاه را وارد کنید.")));
                      return;
                    } else if (password == "") {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content:
                          Text("لطفا رمز عبور دستگاه را وارد کنید.")));
                      return;
                    } else if (name == "") {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content:
                          Text("لطفا نام دستگاه را وارد کنید.")));
                      return;
                    }
                    addNewDevice();
                    Navigator.pushNamed(context, "DeviceSetting");
                  },
                  style: ElevatedButton.styleFrom(
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)))),
                  child: const Text("افزودن"),
                ))
          ],
        ));
  }
}
