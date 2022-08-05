// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Device.dart';
import 'main.dart';
import 'package:http/http.dart' as http;

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

class SecondPage extends StatefulWidget {
  const SecondPage({Key? key}) : super(key: key);

  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  @override
  Widget build(BuildContext context) {

    showAlertDialog(BuildContext context) {

      // set up the buttons
      Widget cancelButton = TextButton(
        child: const Text("خیر، ورود به تنظیمات دستگاه"),
        onPressed:  () {
          Navigator.pushNamed(context, "DeviceSetting");
        },
      );
      Widget continueButton = TextButton(
        child: const Text("بله"),
        onPressed:  () {
          Navigator.pushNamedAndRemoveUntil(
              context, "Main", (r) => false);
          },
      );

      // set up the AlertDialog
      AlertDialog alert = AlertDialog(
        content: const Text("آیا قبلا پریز را به اینترنت متصل کرده اید؟ در غیر این صورت وارد صفحه تنظیمات دستگاه شوید و نام و رمز عبور مودم خانگی تان را برای دستگاه تعریف کنید."),
        actions: [
          continueButton,
          cancelButton,
        ],
      );

      // show the dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }

    void addNewDevice(String serialNumber, String password, String name) async {

      Map<String, String> body = {
        'serialNumber': serialNumber,
        'password': password,
      };

      try {
        var response = await http.post(
          Uri.parse("http://mamatirnoavar.ir/switchs/checkSerialNumberPassword.php"),
          body: body,
        );

        if(response.body.contains("1000")) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("شماره سریال یا رمز عبور اشتباه است.")));
        } else if(response.body.contains("2000")) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("با موفقیت اضافه شد.")));
          uiList.add(Device(serialNumber, password, name, false));
          saveToMemory();
          showAlertDialog(context);
        } else if(response.body.contains("3000")) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("مشکلی در سرور پیش آمده است. لطفا دوباره امتحان کنید.")));
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("اینترنت قطع است. لطفا اینترنت سیم کارت یا شبکه وای فای را فعال کنید.")));
      }


    }

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
                    addNewDevice(serialNumber, password, name);
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
