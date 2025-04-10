import 'dart:async';
import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';

class PatientDataStreamer {
 final List<int> _heartRates = [];
  final List<int> _systolic = [];
 final  List<int> _diastolic = [];
  bool _loaded = false;
 int count=0;

  Future<void> _loadCSV() async {
    if (_loaded) return; // Avoid reloading

    final rawData = await rootBundle.loadString('assets/data/abc.csv');
    final csvTable = const CsvToListConverter().convert(rawData);

    // Skip header row
    final dataRows = csvTable.skip(1);

    for (final row in dataRows) {
      _heartRates.add(row[0] as int);
      _systolic.add(row[1] as int);
      _diastolic.add(row[2] as int);
  
    }

    _loaded = true;
  }

  // Stream<int> heartRateStream() async* {
  //   await _loadCSV();
  //   for (final hr in _heartRates) {
  //     yield hr;
  //     await Future.delayed(const Duration(seconds: 1));
  //   }
  // }

  // Stream<int> systolicStream() async* {
  //   await _loadCSV();
  //   for (final sys in _systolic) {
  //     yield sys;
  //     await Future.delayed(const Duration(seconds: 1));
  //   }
  // }

  // Stream<int> diastolicStream() async* {
  //   await _loadCSV();
  //   for (final dia in _diastolic) {
  //     yield dia;
  //     await Future.delayed(const Duration(seconds: 1));
  //   }
  // }


  

Stream<Vitals> combinedVitalsStream() async* {
  await _loadCSV();
  for (int i = 0; i < _heartRates.length; i++) {
    yield Vitals(_heartRates[i], _systolic[i], _diastolic[i], count++);
    await Future.delayed(const Duration(seconds: 1));
  }
}
}
class Vitals {
  final int heartRate;
  final int systolic;
  final int diastolic;
  final int count;

  Vitals(this.heartRate, this.systolic, this.diastolic, this.count);
}