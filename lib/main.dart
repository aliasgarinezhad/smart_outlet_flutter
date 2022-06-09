import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'Device.dart';

var uiList = <Device>{};

void main() {
  loadMemory();
  runApp(const App());
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
              child: const TextField(
                  decoration: InputDecoration(
                      labelText: "شماره سریال پریز را وارد کنید",
                      contentPadding: EdgeInsets.all(16),
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(20))))),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: const TextField(
                  decoration: InputDecoration(
                      labelText: "رمز عبور پریز را وارد کنید",
                      contentPadding: EdgeInsets.all(16),
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(20))))),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: const TextField(
                  decoration: InputDecoration(
                      labelText: "نام دستگاه را وارد کنید (مانند کولر)",
                      contentPadding: EdgeInsets.all(16),
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(20))))),
            ),
            Container(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20)))),
                  child: const Text("افزودن"),
                ))
          ],
        ));
  }
}

class FirstPage extends StatefulWidget {
  const FirstPage({Key? key}) : super(key: key);

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("لیست دستگاه ها"),
        centerTitle: true,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SecondPage()),
          );
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
                            uiList.elementAt(i).status = status;
                            setState(() {});
                          })
                    ]),
              ))
      ]),
    );
  }
}

void loadMemory() {
  uiList.add(Device("23458534", "9756", "کولر", false));
  uiList.add(Device("23458534", "9756", "کولر", false));
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
      title: 'Flutter Demo',
      theme: ThemeData(
          primaryColor: const Color(0xFF4aa3df),
          backgroundColor: const Color(0xFFecf5fb),
          scaffoldBackgroundColor: const Color(0xFFecf5fb),
          fontFamily: 'sans'),
      home: const FirstPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
