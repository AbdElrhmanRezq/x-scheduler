import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../algorithms/fcfs.dart';
import '../algorithms/non_p_priority.dart';
import '../algorithms/rr.dart';
import '../algorithms/sjf.dart';
import '../models/process.dart';
import '../provider/process_provider.dart';

class DisplayFCFS extends StatefulWidget {
  static const String id = 'display-fcfs';

  @override
  State<DisplayFCFS> createState() => _DisplayFCFSState();
}

class _DisplayFCFSState extends State<DisplayFCFS> {
  List<int> getDisplayedList(List<Process> processList, String algo) {
    List<int> displayedList = [];
    if (algo == "FCFS") {
      FCFS fcfs = FCFS(processList.length);
      fcfs.getData(processList);
      fcfs.fcfsCalculations();
      fcfs.fcfsLiveCalculation();
      displayedList.addAll(fcfs.timeLine);
    } else if (algo == "RR") {
      RRAlgorithm rrAlgorithm = RRAlgorithm(processList.length, 1);
      rrAlgorithm.setInitialData(processList);
      rrAlgorithm.nonLiveRR();
      displayedList.addAll(rrAlgorithm.ganttProcesses);
    } else if (algo == "Priority Non Preemptive") {
      NonPreemptive_Priority nonPreePriority =
          NonPreemptive_Priority(processList.length);
      nonPreePriority.getData(processList);
      displayedList
          .addAll(nonPreePriority.getTimeLine(nonPreePriority.processes));
    } else if (algo == "SJF Preemptive") {
      SJF sjf = SJF(processList.length);
      sjf.getData(processList);
      sjf.execute();
      displayedList.addAll(sjf.timeline);
    }
    return displayedList;
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    dynamic provider = Provider.of<ProcessProvider>(context);
    List<Process> processList = provider.processList;
    String algo = provider.algorithm;
    List<int> displayList = getDisplayedList(processList, algo);
    // SJF sjf = SJF(processList.length);
    // sjf.getData(processList);
    // sjf.nonLiveSJF();

    return Scaffold(
      appBar: AppBar(
        title: Text("Let's Go"),
        backgroundColor: Colors.green,
        leading: IconButton(
            onPressed: () {
              provider.clearProcesses();
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back_ios_new)),
      ),
      body: Center(
        child: Container(
          height: height * 0.1,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: displayList.length,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.all(1.0),
              child: Container(
                width: width * 0.03,
                color: Colors.green,
                child: Text(
                  displayList[index].toString() == '0'
                      ? "IDLE"
                      : displayList[index].toString(),
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
