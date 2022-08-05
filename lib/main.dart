// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'Device.dart';
import 'addNewPage.dart';
import 'deviceSettingPage.dart';

var uiList = <Device>{};

void main() {
  runApp(const App());
}

class FirstPage extends StatefulWidget {
  const FirstPage({Key? key}) : super(key: key);

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  void loadMemory() async {
    SharedPreferences memory = await SharedPreferences.getInstance();
    uiList.clear();
    var uiListString = memory.getStringList('uiList');
    if (uiListString != null) {
      setState(() {
        for (var element in uiListString) {
          var deviceJson = jsonDecode(element);
          uiList.add(Device(deviceJson['serialNumber'], deviceJson['password'],
              deviceJson['name'], deviceJson['status']));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    loadMemory();

    void turnOnOff(int i, bool status) async {

      String statusString;

      if(status) {
        statusString = '1';
      } else {
        statusString = '0';
      }
      Map<String, String> body = {
        'serialNumber': uiList.elementAt(i).serialNumber,
        'password': uiList.elementAt(i).password,
        'status': statusString
      };

      var response = await http.post(
        Uri.parse("http://mamatirnoavar.ir/switchs/setDeviceParameters.php"),
        body: body,
      );

      if(response.body.contains("1000")) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("شماره سریال یا رمز عبور دستگاه اشتباه است.")));
      } else if(response.body.contains("2000")) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("فرمان با موفقیت ارسال شد.")));
        uiList.elementAt(i).status = status;
        saveToMemory();
        setState(() {});
      } else if(response.body.contains("3000")) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("مشکلی در سرور پیش آمده است. لطفا دوباره امتحان کنید.")));
      }
    }
    
    return Scaffold(
      appBar: AppBar(
        title: const Text("لیست دستگاه ها"),
        centerTitle: true,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, "AddNewDevice");
        },
        label: const Text("اضافه کردن دستگاه جدید",
            style: TextStyle(letterSpacing: 0)),
        icon: const Icon(Icons.add),
      ),
      body: Column(children: [
        for (int i = 0; i < uiList.length; i++)
          Container(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Container(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("نام: ${uiList.elementAt(i).name}"),
                      Text("وضعیت: ${uiList.elementAt(i).getStatusString()}"),
                      Switch(
                          value: uiList.elementAt(i).status,
                          onChanged: (status) {
                            turnOnOff(i, status);
                          })
                    ]),
              ))
      ]),
    );
  }
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale("fa", "IR"),
      ],
      title: 'Smart outlet',
      theme: ThemeData(
          primaryColor: const Color(0xFF4aa3df),
          backgroundColor: const Color(0xFFecf5fb),
          scaffoldBackgroundColor: const Color(0xFFecf5fb),
          fontFamily: 'sans'),
      home: const FirstPage(),
      debugShowCheckedModeBanner: false,
      routes: {
        'Main': (context) => const FirstPage(),
        'AddNewDevice': (context) => const SecondPage(),
        'DeviceSetting': (context) => const ThirdPage(),
      },
    );
  }
}
