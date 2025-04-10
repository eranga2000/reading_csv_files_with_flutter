import 'package:flutter/material.dart';
import 'heart_rate_stream.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HeartRateScreen(),
    );
  }
}

class HeartRateScreen extends StatefulWidget {
  const HeartRateScreen({super.key});

  @override
 createState() => _HeartRateScreenState();
}

class _HeartRateScreenState extends State<HeartRateScreen> {
  final HeartRateStream _streamer = HeartRateStream();
  late Stream<int> _heartRateStream;

  @override
  void initState() {
    super.initState();
    _heartRateStream = _streamer.startStreaming();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Heart Rate Stream")),
      body: StreamBuilder<int>(
        stream: _heartRateStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: Text("Waiting..."));
          } else if (snapshot.hasData) {
            return Center(
              child: Text(
                "Heart Rate: ${snapshot.data} bpm",
                style: const TextStyle(fontSize: 28),
              ),
            );
          } else {
            return const Center(child: Text("Done reading all values."));
          }
        },
      ),
    );
  }
}
