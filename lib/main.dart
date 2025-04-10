import 'package:flutter/material.dart';
import 'package:reading_csv/patient_data_streamer.dart';
import 'package:reading_csv/status_card.dart';
import 'heart_rate_stream.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: HeartRateScreen());
  }
}

class HeartRateScreen extends StatefulWidget {
  const HeartRateScreen({super.key});

  @override
  createState() => _HeartRateScreenState();
}

class _HeartRateScreenState extends State<HeartRateScreen> {
  // final HeartRateStream _streamer = HeartRateStream();
  // late Stream<int> _heartRateStream;
  final PatientDataStreamer _patientDataStreamer = PatientDataStreamer();
  late Stream<Vitals> _patientDataStream;

  @override
  void initState() {
    super.initState();
    _patientDataStream = _patientDataStreamer.combinedVitalsStream();
    // _heartRateStream = _streamer.startStreaming();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Heart Rate Stream")),
      body: StreamBuilder<Vitals>(
        stream: _patientDataStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: Text("Waiting..."));
          } else if (snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Today",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      children:  [
                        StatusCard(
                          title: "Heart Rate",
                          value: snapshot.data!.heartRate.toString(),
                          unit: "bpm",
                          color: Color(0xFFFED7E2),
                          textColor: Colors.redAccent,
                          icon: Icons.favorite_border,
                        ),
                        StatusCard(
                          title: "syntolic",
                          value: snapshot.data!.systolic.toString(),
                          unit: "mmHg",
                          color: Color(0xFFD6E4FF),
                          textColor: Colors.blue,
                          icon: Icons.bloodtype,
                        ),
                        StatusCard(
                          title: "dyastolic",
                          value: snapshot.data!.diastolic.toString(),
                      
                          unit: "mmHg",
                          color: Color(0xFFD3F9F5),
                          textColor: Colors.teal,
                          icon: Icons.bloodtype_sharp,
                        ),
                        StatusCard(
                          title: "time",
                          value: snapshot.data!.count.toString(),
                          unit: "s",
                          color: Color(0xFFEADCF9),
                          textColor: Colors.purple,
                          icon: Icons.access_time,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
            // return Center(
            //   child: Column(
            //     mainAxisAlignment: MainAxisAlignment.spaceAround,
            //     crossAxisAlignment: CrossAxisAlignment.center,
            //     children: [
            //       Container(
            //         padding: const EdgeInsets.all(16),
            //         width: 150,
            //         height: 150,
            //         color: Colors.blueAccent,
            //         child: Center(
            //           child: Text(
            //             "Heart Rate:\n ${snapshot.data!.heartRate} bpm",
            //             style: const TextStyle(fontSize: 28),
            //           ),
            //         ),
            //       ),
            //     Container(
            //         padding: const EdgeInsets.all(16),
            //         width: 150,
            //         height: 150,
            //         color: Colors.blueAccent,
            //         child: Center(
            //           child: Text(
            //            "Systolic: ${snapshot.data!.systolic} mmHg",
            //             style: const TextStyle(fontSize: 28),
            //           ),
            //         ),
            //       ),
            //         Container(
            //         padding: const EdgeInsets.all(16),
            //         width: 150,
            //         height: 150,
            //         color: Colors.blueAccent,
            //         child: Center(
            //           child: Text(
            //             "Diastolic: ${snapshot.data!.diastolic} mmHg",
            //             style: const TextStyle(fontSize: 28),
            //           ),
            //         ),
            //       ),

            //     ],
            //   ),
            // );
          } else {
            return const Center(child: Text("Done reading all values."));
          }
        },
      ),
    );
  }
}
