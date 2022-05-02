import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  _callNumber(String mobile) async {
    await FlutterPhoneDirectCaller.callNumber("+" + mobile);
  }

  void _pickFile() async {
    // opens storage to pick files and the picked file or files
    // are assigned into result and if no file is chosen result is null.
    // you can also toggle "allowMultiple" true or false depending on your need
    final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowMultiple: false,
        allowedExtensions: ['csv', 'vcf']);
    // if no file is picked
    if (result == null) return;
    // we will log the name, size and path of the
    // first picked file (if multiple are selected)
    // print(result.files.first.name);
    // print(result.files.first.size);
    // print(result.files.first.path);
    // we get the file from result object
    final file = result.files.first;
    openFile(file.path);
  }

  //late List<List<dynamic>> employeeData;
  List<List<dynamic>> employeeData = [[]];

  openFile(filepath) async {
    File f = new File(filepath);
    print("CSV to List");
    final input = f.openRead();
    final fields = await input
        .transform(utf8.decoder)
        .transform(new CsvToListConverter())
        .toList();
    print(fields);

    // List<dynamic> KK = fields[0];

    employeeData.clear();
    setState(() {
      employeeData = fields;
      //names = fields.removeAt(0).toList();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //employeeData = List<List<dynamic>>.empty(growable: true);
  }

  @override
  Widget build(BuildContext context) {
    double sWidth = MediaQuery.of(context).size.width;
    double sPad = sWidth * 0.03;
    int contactCount = 20;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        actions: [
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: sPad, vertical: 5),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(30)),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        left: sWidth * 0.05, right: sWidth * 0.02),
                    child: Text(
                      "Total Contacts:",
                      style: TextStyle(
                          color:
                              Theme.of(context).appBarTheme.iconTheme!.color),
                    ),
                  ),
                  Text(
                    employeeData[0].length.toString(),
                    style: const TextStyle(color: Colors.green),
                  ),
                  Expanded(child: Container()),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        employeeData = [[]];
                      });
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        backgroundColor: Colors.green,
                        child: Icon(
                          Icons.delete_forever,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
      body: SafeArea(
          child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(
                top: sPad, bottom: sPad, left: sPad, right: sPad),
            margin: const EdgeInsets.only(bottom: 5),
            decoration: const BoxDecoration(
                border:
                    Border(bottom: BorderSide(width: 2, color: Colors.green))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Btn(
                    sWidth: sWidth,
                    title: "Export Verified",
                    action: () {},
                    symbol: Icons.download),
                Btn(
                  sWidth: sWidth,
                  action: () {
                    print(employeeData[0]);
                  },
                  title: "Verify Contact",
                  symbol: Icons.check_outlined,
                  primary: false,
                ),
              ],
            ),
          ),
          Expanded(
              child: ListView.builder(
                  itemCount: employeeData[0].length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (_, index) {
                    //return Container();
                    return ContactCard(
                      action: () =>
                          _callNumber(employeeData[0][index].toString()),
                      sWidth: sWidth,
                      sPad: sPad,
                      employeeData: employeeData,
                      index: index,
                    );
                  }))
        ],
      )),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () {
          print("wow");
          //_openFileExplorer();
          _pickFile();
          print("tapped");
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class ContactCard extends StatelessWidget {
  const ContactCard(
      {Key? key,
      required this.sWidth,
      required this.sPad,
      required this.employeeData,
      required this.action,
      required this.index})
      : super(key: key);

  final double sWidth;
  final double sPad;
  final List<List> employeeData;
  final int index;
  final Function() action;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: action,
      child: Container(
        width: sWidth,
        margin: EdgeInsets.only(bottom: 10, left: sPad, right: sPad),
        padding: EdgeInsets.only(left: sPad, top: sWidth * 0.01),
        height: 50,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(employeeData[0][index].toString(),
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    )),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class Btn extends StatelessWidget {
  const Btn({
    Key? key,
    required this.sWidth,
    this.primary = true,
    required this.title,
    required this.action,
    required this.symbol,
  }) : super(key: key);

  final double sWidth;
  final bool primary;
  final String title;
  final Function() action;
  final IconData symbol;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: action,
      child: Container(
        child: Row(
          children: [
            Text(title),
            const SizedBox(
              width: 10,
            ),
            CircleAvatar(
              radius: 8,
              backgroundColor: primary ? Colors.white : Colors.green,
              child: Icon(
                symbol,
                color: primary ? Colors.green : Colors.white,
                size: 10,
              ),
            )
          ],
        ),
        padding: EdgeInsets.symmetric(vertical: 7, horizontal: sWidth * 0.03),
        decoration: BoxDecoration(
            color: primary ? Colors.green : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(width: 2, color: Colors.green)),
      ),
    );
  }
}
