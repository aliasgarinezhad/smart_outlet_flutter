// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ThirdPage extends StatefulWidget {
  const ThirdPage({Key? key}) : super(key: key);

  @override
  State<ThirdPage> createState() => _ThirdPageState();
}

class _ThirdPageState extends State<ThirdPage> {
  showAlertDialog(BuildContext context) {
    Widget okButton = TextButton(
      child: const Text("باشه"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    AlertDialog alert = AlertDialog(
      content: const Text(
          "لطفا پریز را به برق متصل نموده و به وای فای smart_switch با رمز 12345678 متصل شوید و به برنامه برگردید."),
      actions: [
        okButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () => showAlertDialog(context));

    String ssid = "";
    String password = "";

    void applyDeviceSetting() async {
      if (ssid == "") {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("لطفا نام وای فای خانگی را وارد کنید.")));
        return;
      } else if (password == "") {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("لطفا عبور وای فای خانگی را وارد کنید.")));
        return;
      } else if (password.length < 8) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("رمز وای فای خانگی باید بیشتر از هشت رقم باشد.")));
        return;
      }

      Map<String, String> body1 = {"turn_off": "true"};
      bool isDeviceConnected = false;
      Map<String, String> body = {
        "local_name": "smart_switch",
        "local_password": "12345678",
        "router_name": ssid,
        "router_password": password,
        "save": "true"
      };

      try {
        var response =
            await http.post(Uri.parse("http://192.168.4.1/"), body: body1);
        if (response.statusCode != 200) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text(
                  "به وای فای پریز متصل نیستید. لطفا پریز را به برق متصل نموده و به وای فای smart_switch با رمز 12345678 متصل شوید. ")));
          return;
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
                "به وای فای پریز متصل نیستید. لطفا پریز را به برق متصل نموده و به وای فای smart_switch با رمز 12345678 متصل شوید. ")));
        return;
      }

      try {
        await http.post(Uri.parse("http://192.168.4.1/"), body: body);
        Navigator.pushNamedAndRemoveUntil(context, "Main", (r) => false);
      } catch (e) {
        Navigator.pushNamedAndRemoveUntil(context, "Main", (r) => false);
      }
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text("تنظیمات دستگاه"),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: TextField(
                  onChanged: (it) {
                    ssid = it;
                  },
                  decoration: const InputDecoration(
                      labelText: "نام وای فای خانگی (مودم ثابت)",
                      contentPadding: EdgeInsets.all(16),
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(20))))),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: TextField(
                  onChanged: (it) {
                    password = it;
                  },
                  decoration: const InputDecoration(
                      labelText: "رمز وای فای خانگی",
                      contentPadding: EdgeInsets.all(16),
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(20))))),
            ),
            Container(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: ElevatedButton(
                  onPressed: () {
                    applyDeviceSetting();
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
