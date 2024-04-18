import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:os_project/provider/process_provider.dart';
import 'package:provider/provider.dart';

import '../models/process.dart';

class ProcessListPage extends StatefulWidget {
  static const String id = "process-list-page";

  @override
  State<ProcessListPage> createState() => _ProcessListPageState();
}

class _ProcessListPageState extends State<ProcessListPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController durationController = TextEditingController();
  TextEditingController arrivalTimeController = TextEditingController();
  TextEditingController priorityController = TextEditingController();

  void addProcess(String algorithm) {
    bool priorityCheck = (algorithm == "Proirity Preemptive" ||
        algorithm == "Priority Non Preemptive");
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Enter Process Info"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(hintText: "Process Name"),
              ),
              TextField(
                controller: durationController,
                decoration: const InputDecoration(hintText: "Process duration"),
              ),
              TextField(
                controller: arrivalTimeController,
                decoration: const InputDecoration(hintText: "Arrival Time"),
              ),
              priorityCheck
                  ? TextField(
                      controller: priorityController,
                      decoration:
                          const InputDecoration(hintText: "Process priority"),
                    )
                  : const SizedBox(
                      height: 0,
                    ),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () {
                  setState(() {
                    String name = nameController.text;
                    int duration = int.parse(durationController.text.trim());
                    int arrivalTime =
                        int.parse(arrivalTimeController.text.trim());
                    if (priorityCheck) {
                      int priority = int.parse(priorityController.text.trim());
                      processList.add(Process(
                          duration: duration,
                          priority: priority,
                          arrivalTime: arrivalTime));
                    } else {
                      processList.add(Process(
                          duration: duration, arrivalTime: arrivalTime));
                    }
                    nameController.clear();
                    durationController.clear();
                    arrivalTimeController.clear();
                    priorityController.clear();
                    Navigator.of(context).pop();
                  });
                },
                child: const Text("Add"))
          ],
        );
      },
    );
  }

  List<Process> processList = [];
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    String algorithm = Provider.of<ProcessProvider>(context).algorithm;
    bool priorityCheck = (algorithm == "Proirity Preemptive" ||
        algorithm == "Priority Non Preemptive");
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addProcess(algorithm);
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Text(algorithm),
        actions: [
          IconButton(
              onPressed: () {
                if (processList.length > 0) {
                  Provider.of<ProcessProvider>(context, listen: false)
                      .processList
                      .addAll(processList);
                  Navigator.of(context).pushReplacementNamed('timer-page');
                }
              },
              icon: const Icon(Icons.check))
        ],
      ),
      body: Center(
        child: processList.length == 0
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.tag_faces_rounded,
                    size: height * 0.2,
                  ),
                  Text(
                    "Enter some processes",
                    style: TextStyle(fontSize: height * 0.1),
                  )
                ],
              )
            : ListView.builder(
                itemCount: processList.length,
                itemBuilder: (context, index) => ListTile(
                  title: Text("Process ${index + 1}:"),
                  subtitle: Row(
                    children: [
                      Text("Duration: ${processList[index].duration}"),
                      priorityCheck
                          ? Text(", Priority: ${processList[index].priority}")
                          : const SizedBox(),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
