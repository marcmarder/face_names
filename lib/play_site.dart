import 'dart:async';

import 'package:face_names/People_Service.dart';
import 'package:face_names/person.dart';
import 'package:face_names/result_site.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class PlaySide extends StatefulWidget {
  const PlaySide({super.key});

  @override
  State<PlaySide> createState() => _PlaySideState();
}

enum Answer { correct, wrong, none, contains }

class _PlaySideState extends State<PlaySide> {
  _PlaySideState();

  BehaviorSubject<Person?> currentPersonx = BehaviorSubject<Person?>();

  BehaviorSubject<int> timeSinceStart = BehaviorSubject<int>.seeded(0);

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
  void initState() {
    startTimer();
    chooseNextPerson();
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void chooseNextPerson() {
    PeopleService().shufflePeople();
    Person? currentPerson;

    if (currentPersonx.hasValue) {
      currentPerson = currentPersonx.value;
    } else {
      currentPerson = PeopleService()
          .people
          .firstWhere((element) => element.answer == Answer.none);
    }
    if (currentPerson == null) {
      throw Exception('currentPerson is null');
    }

    for (var person in PeopleService().people) {
      if (person == currentPerson) {
        continue;
      }
      if (person.answer != Answer.none) {
        continue;
      }
      currentPersonx.add(person);
      return;
    }
  }

  TextEditingController nameController = TextEditingController();
  FocusNode nameFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.all(20),
        child: Column(
          children: [
            SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      PeopleService().reset();
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: const Text('Reset'),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ResultSite(),
                          ),
                        );
                      },
                      child: const Text("Done"))
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                StreamBuilder<int>(
                    stream: timeSinceStart,
                    initialData: 0,
                    builder: (context, snapshot) {
                      int time = snapshot.data!;
                      if (time < 90) {
                        return Text('TIME: ${snapshot.data} / 90');
                      }
                      return const Text(
                        "TIME IS UP",
                        style: TextStyle(color: Colors.red),
                      );
                    }),
              ],
            ),
            Expanded(
              child: ListView(children: [
                GridView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  itemCount: PeopleService().people.length,
                  itemBuilder: (BuildContext context, int index) {
                    final cardPerson = PeopleService().people[index];
                    return StreamBuilder<Person?>(
                        stream: currentPersonx,
                        builder: (context, snapshot) {
                          final currentPerson = snapshot.data;
                          return StreamBuilder(
                              stream: cardPerson.subject,
                              builder: (context, snapshot) {
                                return Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: GestureDetector(
                                    onTap: () {
                                      currentPersonx.add(cardPerson);
                                      nameController.text =
                                          cardPerson.nameAnswer ?? '';
                                      nameController.selection =
                                          TextSelection.fromPosition(
                                              TextPosition(
                                                  offset: nameController
                                                      .text.length));
                                      nameFocusNode.requestFocus();
                                    },
                                    child: Container(
                                      color: currentPerson == cardPerson
                                          ? Colors.grey
                                          : Colors.white,
                                      padding: const EdgeInsets.all(8),
                                      child: Column(
                                        children: [
                                          SizedBox(
                                              height: 120,
                                              width: 120,
                                              child: Image.network(
                                                  cardPerson.url)),
                                          if (cardPerson.nameAnswer != null)
                                            Text(cardPerson.nameAnswer!),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              });
                        });
                  },
                ),
              ]),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                StreamBuilder(
                  stream: currentPersonx,
                  initialData: null,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    Person? currentPerson = snapshot.data;
                    if (currentPerson == null) {
                      return const CircularProgressIndicator();
                    }
                    return Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 20),
                          child: TextField(
                            focusNode: nameFocusNode,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Who is this?',
                            ),
                            keyboardType: TextInputType.text,
                            controller: nameController,
                            onChanged: (value) {
                              currentPerson.nameAnswer = value;
                            },
                            onSubmitted: (value) {
                              currentPerson.nameAnswer = nameController.text;
                              nameFocusNode.unfocus();
                            },
                          ),
                        ),
                      ],
                    );
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
