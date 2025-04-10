import 'dart:async';
import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';

class HeartRateStream {
  List<int> _heartRateList = [];

  Future<void> loadCSV() async {
    final rawData = await rootBundle.loadString('assets/data/abc.csv');
    List<List<dynamic>> csvTable = const CsvToListConverter().convert(rawData);

    // Skip header and store only the first column (heart_rate)
    _heartRateList = csvTable.skip(1).map((row) => row[0] as int).toList();
  }

  Stream<int> startStreaming() async* {
    if (_heartRateList.isEmpty) {
      await loadCSV();
    }

    for (final heartRate in _heartRateList) {
      yield heartRate;
      await Future.delayed(const Duration(seconds: 1));
    }
  }
}
