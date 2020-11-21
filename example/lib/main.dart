import 'package:ars_progress_dialog/custom_progress_dialog.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  CustomProgressDialog _customProgressDialog;

  @override
  Widget build(BuildContext context) {
    _customProgressDialog = CustomProgressDialog(context, blur: 2);

    return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              MaterialButton(
                onPressed: () {
                  _customProgressDialog.show();
                },
                child: Text("show dialog"),
              ),
            ],
          ),
        ));
  }
}
