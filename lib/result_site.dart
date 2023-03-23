import 'package:face_names/entry_site.dart';
import 'package:face_names/play_site.dart';
import 'package:flutter/material.dart';

import 'People_Service.dart';

class ResultSite extends StatefulWidget {
  const ResultSite({Key? key}) : super(key: key);

  @override
  State<ResultSite> createState() => _ResultSiteState();
}

class _ResultSiteState extends State<ResultSite> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(children: [
        GridView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          itemCount: PeopleService().people.length,
          itemBuilder: (BuildContext context, int index) {
            final currentPerson = PeopleService().people[index];
            Color answerColor;
            switch (currentPerson.answer) {
              case Answer.correct:
                answerColor = Colors.green;
                break;
              case Answer.wrong:
                answerColor = Colors.red;
                break;
              case Answer.contains:
                answerColor = Colors.yellow;
                break;
              case Answer.none:
                answerColor = Colors.grey;
                break;
            }
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Container(
                padding: const EdgeInsets.all(8),
                height: 200,
                color: answerColor,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                        height: 100,
                        width: 100,
                        child: Image.network(currentPerson.url)),
                    Container(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.textsms_outlined),
                        if (currentPerson.nameAnswer != null)
                          Text(currentPerson.nameAnswer!),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.text_increase_outlined),
                        Text(currentPerson.name),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        ElevatedButton(
          onPressed: () {
            PeopleService().reset();
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const EntrySite()),
            );
          },
          child: const Text('Retry'),
        ),
      ]),
    );
  }
}
