import 'package:flutter/material.dart';
import 'package:os_project/provider/process_provider.dart';
import 'package:provider/provider.dart';
import '../models/process.dart';

class AltHomePage extends StatefulWidget {
  static const String id = 'alt-homepage';
  int index = 0;
  @override
  State<AltHomePage> createState() => _AltHomePageState();
}

class _AltHomePageState extends State<AltHomePage> {
  List<int> extractIntegers(String input) {
    List<String> values = input.split(' ');
    List<int> integers = [];

    for (String value in values) {
      integers.add(int.parse(value));
    }

    return integers;
  }

  void initProvider(String arrivalTimes, String burstTimes, String priorities) {
    List<Process> processList = [];
    List<int> arrivalList = extractIntegers(arrivalTimes);
    List<int> burstList = extractIntegers(burstTimes);
    if (priorities != "") {
      List<int> priorityList = extractIntegers(priorities);
      for (int i = 0; i < arrivalList.length; i++) {
        processList.add(Process(
            arrivalTime: arrivalList[i],
            duration: burstList[i],
            priority: priorityList[i]));
      }
    } else {
      for (int i = 0; i < arrivalList.length; i++) {
        processList
            .add(Process(arrivalTime: arrivalList[i], duration: burstList[i]));
      }
    }
    Provider.of<ProcessProvider>(context, listen: false)
        .processList
        .addAll(processList);
    if (Provider.of<ProcessProvider>(context, listen: false).live) {
      Navigator.of(context).pushNamed('timer-page');
    } else {
      Navigator.of(context).pushNamed('display-fcfs');
    }
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController durationController = TextEditingController();
    TextEditingController arrivalTimeController = TextEditingController();
    TextEditingController priorityController = TextEditingController();
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    bool priorityCheck = (Provider.of<ProcessProvider>(context).algorithm ==
            "Proirity Preemptive" ||
        Provider.of<ProcessProvider>(context).algorithm ==
            "Priority Non Preemptive");

    List<String> algos = [
      "FCFS",
      "SJF Preemptive",
      "SJF Non Preemptive",
      "Proirity Preemptive",
      "Priority Non Preemptive",
      "RR"
    ];
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/background.png"),
          fit: BoxFit.fill,
        ),
      ),
      child: Scaffold(
        backgroundColor:
            Colors.transparent, // Make scaffold background transparent
        body: Padding(
          padding: EdgeInsets.symmetric(
              vertical: height * 0.09, horizontal: width * 0.03),
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  height: height * .1,
                  width: width * 0.7,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: algos.length,
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: Container(
                        width: width * 0.7 / algos.length,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: index == widget.index
                                ? Colors.grey
                                : Colors.white,
                          ),
                          child: TextButton(
                            onPressed: () {
                              Provider.of<ProcessProvider>(context,
                                      listen: false)
                                  .changeAlgo(algos[index]);
                              widget.index = index;
                            },
                            child: Text(algos[index]),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                    width: width * 0.1,
                    height: height * 0.1,
                    child: TextField(
                      controller: arrivalTimeController,
                      decoration:
                          const InputDecoration(hintText: "Arrival Times"),
                    )),
                SizedBox(
                    width: width * 0.1,
                    height: height * 0.1,
                    child: TextField(
                      controller: durationController,
                      decoration:
                          const InputDecoration(hintText: "Burst Times"),
                    )),
                priorityCheck
                    ? SizedBox(
                        width: width * 0.1,
                        height: height * 0.1,
                        child: TextField(
                          controller: priorityController,
                          decoration:
                              const InputDecoration(hintText: "Priorities"),
                        ))
                    : const SizedBox(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Live execution?"),
                    Consumer<ProcessProvider>(
                      builder: (context, provider, child) => Checkbox(
                        value: provider.live,
                        onChanged: (value) {
                          Provider.of<ProcessProvider>(context, listen: false)
                              .changeState(value as bool);
                        },
                      ),
                    ),
                  ],
                ),
                TextButton(
                    onPressed: () {
                      initProvider(
                        arrivalTimeController.text.trim(),
                        durationController.text.trim(),
                        priorityCheck ? priorityController.text.trim() : "",
                      );
                    },
                    child: const Text("Start execution"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
