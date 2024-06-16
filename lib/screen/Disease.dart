import 'package:flutter/material.dart';
import 'package:excel/excel.dart';
import 'dart:io';

import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:get/get.dart';

class DiseaseInputScreen extends StatefulWidget {
  @override
  _DiseaseInputScreenState createState() => _DiseaseInputScreenState();
}

class _DiseaseInputScreenState extends State<DiseaseInputScreen> {
  final _controller = TextEditingController();
  String _result = '';
  String _result1='';
  String _result2='';
  String _result3='';

  Map<String, List<String>> _medicineMap = {};
  Map<String, List<String>> _medicineMap1 = {};
  Map<String, List<String>> _medicineMap2 = {};
  Map<String, List<String>> _medicineMap3 = {};

  @override
  void initState() {
    super.initState();
    _loadExcelData();
  }

  Future<void> _loadExcelData() async {
    final bytes = await rootBundle.load('assets/medicine.xlsx');
    final excel = Excel.decodeBytes(bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes));

    for (var table in excel.tables.keys) {
      var sheet = excel.tables[table];
      for (var row in sheet!.rows) {
        String? disease = row[0]?.value.toString();
        String? medicine = row[1]?.value.toString(); //약
        String? act = row[2]?.value.toString(); //증상
        String? age = row[3]?.value.toString(); //연령
        String? hospital=row[4]?.value.toString(); //병원

        if (_medicineMap.containsKey(disease)) {
          _medicineMap[disease]!.add(medicine!);
          _medicineMap1[disease]!.add(act!);
          _medicineMap2[disease]!.add(age!);
          _medicineMap3[disease]!.add(hospital!);
        } else {
          _medicineMap[disease!] = [medicine!];
          _medicineMap1[disease!]=[act!];
          _medicineMap2[disease!]=[age!];
          _medicineMap3[disease!]=[hospital!];
        }
      }
    }
  }

  void _searchMedicine() {
    final disease = _controller.text;
    final medicines = _medicineMap[disease] ?? ['추천 약을 찾을 수 없습니다'];
    final acts = _medicineMap1[disease] ??['없습니다.'];
    final ages = _medicineMap2[disease] ??[''];
    final hos = _medicineMap3[disease] ??[''];

    setState(() {
      _result = medicines.join(', ');
     _result1 = acts.join(',');
      _result2 = ages.join(',');
      _result3 = hos.join(',');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '약 추천',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.lightGreen, // Light green background color for AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: '질환명을 입력하세요',
              ),
              keyboardType: TextInputType.text,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _searchMedicine,
              child: Text('약 추천'),
            ),
            SizedBox(height: 20),
            //Text('추천 약: $_result'),
            Expanded(
              child: GridView.count(
              crossAxisCount: 2,
              children: [
                Center(
                  child: Container(
                      width: 150,
                      height: 100,
                      color: Colors.white10,
                      margin: EdgeInsets.all(5.0),
                      child: Text(
                        '일어날 수 있는 증상입니다 =>',
                        style: TextStyle(color: Colors.black,fontSize: 11,fontWeight: FontWeight.bold),
                      ),
                  ),
                ),
                Center(
                  child: Container(
                    width: 200,
                    height: 100,
                    color: Colors.greenAccent,
                    margin: EdgeInsets.all(5.0),
                    child: Text(
                      ':$_result',
                      style: TextStyle(color: Colors.black,fontStyle: FontStyle.italic,fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    width: 150,
                    height: 100,
                    color: Colors.white,
                    margin: EdgeInsets.all(5.0),
                    child: Text(
                      '걸릴 수 있는 연령입니다 =>',
                      style: TextStyle(color: Colors.black,fontSize: 11,fontStyle: FontStyle.italic,fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    width: 200,
                    height: 100,
                    color: Colors.greenAccent,
                    margin: EdgeInsets.all(5.0),
                    child: Text(
                      '$_result1',
                      style: TextStyle(color: Colors.black,fontStyle: FontStyle.italic,fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    width: 150,
                    height: 100,
                    color: Colors.white,
                    margin: EdgeInsets.all(5.0),
                    child: Text(
                      '추천 약입니다 꼭드세요! =>',
                      style: TextStyle(color: Colors.black,fontSize: 11,fontStyle: FontStyle.italic,fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    width: 200,
                    height: 100,
                    color: Colors.greenAccent,
                    margin: EdgeInsets.all(5.0),
                    child: Text(
                      '$_result2',
                      style: TextStyle(color: Colors.black,fontStyle: FontStyle.italic,fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    width: 150,
                    height: 100,
                    color: Colors.white,
                    margin: EdgeInsets.all(5.0),
                    child: Text(
                      '주의주의!! 예방하세요 =>',
                      style: TextStyle(color: Colors.black,fontSize: 11,fontStyle: FontStyle.italic,fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    width: 200,
                    height: 100,
                    color: Colors.greenAccent,
                    margin: EdgeInsets.all(5.0),
                    child: Text(
                      '$_result3',
                      style: TextStyle(color: Colors.black,fontStyle: FontStyle.italic,fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}