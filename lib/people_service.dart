import 'dart:math';
import 'package:face_names/person.dart';
import 'lib.dart';

class PeopleService {
  // Singleton
  static final PeopleService _peopleService = PeopleService._internal();
  factory PeopleService() {
    return _peopleService;
  }
  PeopleService._internal();

  // Fields
  List<Person> _people = [];
  Future<List<Person>>? peopleRequest;

  late List<String> names;
  late List<String> surnames;

  // Getter
  List<Person> get people => _people;

  // Methods
  Future<List<String>> loadNames() async {
    return (await loadFile('assets/names.csv')).split(",");
  }

  Future<List<String>> loadSurnames() async {
    return (await loadFile('assets/surnames.csv')).split(",");
  }

  Future<Person> generatePerson() async {
    // get random pic url
    final url = await getRandomPicUrl();
    // get image from url
    final image = await getImageFromUrl(url);
    // get random person name
    final name =
        "${names[Random().nextInt(names.length)]} ${surnames[Random().nextInt(surnames.length)]}";

    print("Generated person: $name");

    return Person(name, url, image);
  }

  Future<List<Person>> generatePeople(int number) async {
    if (peopleRequest != null) {
      List<Person> people = await peopleRequest!;
      return people;
    }

    List<Future<Person>> futures = [];
    for (int i = 0; i < number; i++) {
      futures.add(generatePerson());
    }

    peopleRequest = Future.wait(futures);

    _people = (await peopleRequest)!;

    return people;
  }

  Future<void> init() async {
    names = await loadNames();
    surnames = await loadSurnames();
  }

  void reset() {
    _people = [];
    peopleRequest = null;
  }

  void shufflePeople() {
    _people.shuffle();
  }
}
