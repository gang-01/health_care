import 'package:flutter/material.dart';
import 'package:excel/excel.dart';
import 'dart:io';

import 'package:flutter/services.dart' show ByteData, rootBundle;

class DiseaseInputScreen extends StatefulWidget {
  @override
  _DiseaseInputScreenState createState() => _DiseaseInputScreenState();
}

class _DiseaseInputScreenState extends State<DiseaseInputScreen> {
  final _controller = TextEditingController();
  String _result = '';
  Map<String, List<String>> _medicineMap = {};

  @override
  void initState() {
    super.initState();
    _loadExcelData();
  }

  Future<void> _loadExcelData() async {
    ByteData data= await rootBundle.load('assets/medicine.xlsx');
    final bytes= data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    final excel= Excel.decodeBytes(bytes);


    for (var table in excel.tables.keys) {
      var sheet = excel.tables[table];
      for (var row in sheet!.rows) {
        String? disease = row[0]?.value.toString();
        String? medicine = row[1]?.value.toString();

        if (_medicineMap.containsKey(disease)) {
          _medicineMap[disease]!.add(medicine!);
        } else {
          _medicineMap[disease!] = [medicine!];
        }
        print("added $medicine for disease $disease");
      }
    }
  }

  void _searchMedicine() {
    final disease = _controller.text;
    final medicines = _medicineMap[disease] ?? ['추천 약을 찾을 수 없습니다'];

    setState(() {
      _result = medicines.join(', ');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            Text('추천 약: $_result'),
          ],
        ),
      ),
    );
  }
}
