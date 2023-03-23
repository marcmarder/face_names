import 'package:face_names/list_persons_site.dart';
import 'package:flutter/material.dart';

class EntrySite extends StatefulWidget {
  const EntrySite({Key? key}) : super(key: key);

  @override
  State<EntrySite> createState() => _EntrySiteState();
}

class _EntrySiteState extends State<EntrySite> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // textbox to enter number of people
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                child: SizedBox(
                  width: 400,
                  child: TextField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'How many Faces?',
                      hintText: 'A number between 1 and 20',
                    ),
                    keyboardType: TextInputType.number,
                    controller: _controller,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              // button to generate people
              ElevatedButton(
                onPressed: () {
                  // get number from textbox
                  final number = int.parse(_controller.text);
                  if (number < 1 || number > 20) {
                    return;
                  }

                  // navigate to play site
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ListPersonsSite(number)));
                },
                child: const Text('Go'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
