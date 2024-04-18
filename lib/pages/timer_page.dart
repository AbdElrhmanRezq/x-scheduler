import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../algorithms/fcfs.dart';
import '../algorithms/non_p_priority.dart';
import '../algorithms/rr.dart';
import '../algorithms/sjf.dart';
import '../models/process.dart';
import '../provider/process_provider.dart';

class TimerPage extends StatefulWidget {
  static const String id = 'timer-page';

  @override
  State<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  Timer? _timer;
  List<String> incList = [];
  int counter = 0;
  late SJF sjf;
  //late RRAlgorithm rrAlgorithm;
  // late FCFS fcfs;
  // late NonPreemptive_Priority test1;
  List<int> here = [];
  @override
  void initState() {
    super.initState();
    List<Process> processList =
        Provider.of<ProcessProvider>(context, listen: false).processList;
    // fcfs = FCFS(processList.length);
    // fcfs.getData(processList);
    // fcfs.fcfsCalculations();
    // fcfs.fcfsLiveCalculation();
    // rrAlgorithm = RRAlgorithm(processList.length, 1);
    // rrAlgorithm.setInitialData(processList);
    // rrAlgorithm.queueInit();
    // test1 = NonPreemptive_Priority(processList.length);
    // test1.getData(processList);
    sjf = SJF(processList.length);
    sjf.getData(processList);
    sjf.execute();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        // here = test1.getTimeLine(test1.processes);
        //rrAlgorithm.calcStartTimeLive();
        incList.add(sjf.timeline[counter].toString());
        //fcfs.timeLine[counter].toString();
        //incList.add(here[counter].toString());

        counter++;
        print(incList);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    TextEditingController durationController = TextEditingController();
    TextEditingController arrivalTimeController = TextEditingController();

    void addProcess() {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: arrivalTimeController,
                decoration: InputDecoration(hintText: "Arrival Time"),
              ),
              TextField(
                controller: durationController,
                decoration: InputDecoration(hintText: "Burst Time"),
              )
            ],
          ),
          actions: [
            TextButton(
                onPressed: () {
                  // fcfs.addNewProcess(
                  //     int.parse(arrivalTimeController.text.trim()),
                  //     int.parse(durationController.text.trim()));
                  // test1.addNewProcess(
                  //     int.parse(arrivalTimeController.text.trim()),
                  //     int.parse(durationController.text.trim()),
                  //     2);
                  // rrAlgorithm.addProcess(
                  //     int.parse(arrivalTimeController.text.trim()),
                  //     int.parse(durationController.text.trim()));
                  sjf.addProcess(int.parse(arrivalTimeController.text.trim()),
                      int.parse(durationController.text.trim()));
                },
                child: Text("Add"))
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Let's Go"),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
              onPressed: () {
                addProcess();
              },
              icon: Icon(Icons.add))
        ],
      ),
      body: Center(
        child: Container(
          height: height * 0.1,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: incList.length,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.all(1.0),
              child: Container(
                width: width * 0.03,
                color: Colors.green,
                child: Text(
                  incList[index],
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
