import 'package:flutter/material.dart';
import 'package:os_project/models/process.dart';
import 'package:os_project/provider/process_provider.dart';
import 'package:provider/provider.dart';

import '../algorithms/rr.dart';

class DisplayPage extends StatefulWidget {
  static const String id = 'display-page';

  @override
  State<DisplayPage> createState() => _DisplayPageState();
}

class _DisplayPageState extends State<DisplayPage> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    List<Process> processList =
        Provider.of<ProcessProvider>(context).processList;
    RRAlgorithm rrAlgorithm = RRAlgorithm(processList.length, 1);
    rrAlgorithm.setInitialData(processList);
    rrAlgorithm.nonLiveRR();
    return Scaffold(
      appBar: AppBar(
        title: Text("Let's Go"),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Container(
          height: height * 0.1,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: rrAlgorithm.ganttProcesses.length,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.all(1.0),
              child: Container(
                width: width * 0.03,
                color: Colors.green,
                child: Text(
                  rrAlgorithm.ganttProcesses[index].toString(),
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
