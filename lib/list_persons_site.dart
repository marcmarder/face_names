import 'dart:async';

import 'package:face_names/play_site.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import 'People_Service.dart';

class ListPersonsSite extends StatefulWidget {
  ListPersonsSite(this.peopleNumber, {super.key});
  late int peopleNumber;

  @override
  State<ListPersonsSite> createState() => _ListPersonsSiteState();
}

class _ListPersonsSiteState extends State<ListPersonsSite> {
  _ListPersonsSiteState();

  BehaviorSubject<int> timeSinceStart = BehaviorSubject<int>.seeded(0);

  @override
  void initState() {
    super.initState();
  }

  Timer? timer;
  void startTimer() {
    if (timer != null) {
      return;
    }
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      timeSinceStart.add(timeSinceStart.value + 1);
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: PeopleService().generatePeople(widget.peopleNumber),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          startTimer();
          return Column(
            children: [
              if (snapshot.hasError)
                ListTile(
                  leading: const Icon(Icons.info),
                  title: const Text("Error"),
                  subtitle: Text(
                      'There was an error loading the people. Only loaded ${PeopleService().people.length} people.'),
                  dense: true,
                ),
              SafeArea(
                child: StreamBuilder<int>(
                  stream: timeSinceStart,
                  initialData: 0,
                  builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                    int currentTime = snapshot.data!;
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        if (currentTime < 150)
                          Text('Time: $currentTime s / 150'),
                        if (currentTime >= 150)
                          const Text(
                            'Time is up!',
                            style: TextStyle(
                                color: Colors.red, fontWeight: FontWeight.bold),
                          ),
                        // continue button
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const PlaySide()),
                            );
                          },
                          child: const Text('Continue'),
                        ),
                      ],
                    );
                  },
                ),
              ),
              Expanded(
                child: ListView(children: [
                  GridView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                    itemCount: PeopleService().people.length,
                    itemBuilder: (BuildContext context, int index) {
                      final currentPerson = PeopleService().people[index];
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                  height: 120,
                                  width: 120,
                                  child: Image.network(currentPerson.url)),
                              Container(
                                height: 8,
                              ),
                              Text(currentPerson.name),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ]),
              ),
            ],
          );
        },
      ),
    );
  }
}
