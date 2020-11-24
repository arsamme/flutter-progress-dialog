import 'package:ars_progress_dialog/ars_progress_dialog.dart';
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
  ArsProgressDialog _progressDialog;

  @override
  Widget build(BuildContext context) {
    _progressDialog = ArsProgressDialog(context,
        blur: 2,
        backgroundColor: Color(0x33000000),
        animationDuration: Duration(milliseconds: 500));

    ArsProgressDialog customProgressDialog = ArsProgressDialog(context,
        blur: 2,
        backgroundColor: Color(0x33000000),
        loadingWidget: Container(
          width: 150,
          height: 150,
          color: Colors.red,
          child: CircularProgressIndicator(),
        ));

    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            height: 200,
            child: Text(
              'Example of progress dialog',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            ),
          ),
          MaterialButton(
            onPressed: () {
              _progressDialog.show();
            },
            child: Text("show dialog"),
          ),
        ],
      ),
    ));
  }
}
