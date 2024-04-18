import 'package:flutter/material.dart';
import 'package:os_project/provider/process_provider.dart';
import 'package:provider/provider.dart';

class Homepage extends StatelessWidget {
  static const String id = "homepage";

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    List<String> algos = [
      "FCFS",
      "SJF Preemptive",
      "SJF Non Preemptive",
      "Proirity Preemptive",
      "Priority Non Preemptive",
      "RR"
    ];
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Row(
        children: [
          Container(
            width: width * 0.3,
            color: Colors.white,
            child: Column(
              children: [
                Container(
                    height: height * 0.4,
                    child: Image.asset("assets/images/dino.png")),
                Text(
                  "Choose an algorithm",
                  style: TextStyle(fontSize: height * 0.05),
                )
              ],
            ),
          ),
          Center(
            child: Container(
              color: const Color.fromARGB(255, 76, 175, 139),
              width: width * 0.7,
              height: height,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, childAspectRatio: 1.1),
                itemCount: algos.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    child: FloatingActionButton(
                        backgroundColor: Colors.white,
                        heroTag: algos[index],
                        onPressed: () {
                          Provider.of<ProcessProvider>(context, listen: false)
                              .algorithm = algos[index];
                          Navigator.of(context).pushNamed("process-list-page");
                        },
                        child: Text(algos[index])),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
