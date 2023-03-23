import 'package:face_names/People_Service.dart';
import 'package:face_names/entry_site.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Builder(builder: (context) {
        return Scaffold(
          body: Center(
            child: FutureBuilder(
                future: PeopleService().init(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const CircularProgressIndicator();
                  }

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // navigate to play site
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const EntrySite()));
                        },
                        child: const Text('Start'),
                      ),
                    ],
                  );
                }),
          ),
        );
      }),
    );
  }
}
