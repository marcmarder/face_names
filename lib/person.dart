import 'package:face_names/play_site.dart';
import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';

class Person {
  final String _name;
  final String url;
  final Image image;
  String? _nameAnswer;
  final _subject = BehaviorSubject();

  Person(this._name, this.url, this.image);

  set nameAnswer(String? value) {
    _nameAnswer = value;
    _subject.add(null);
  }

  String? get nameAnswer => _nameAnswer;
  String get name => _name;
  Subject get subject => _subject;
  Answer get answer {
    if (nameAnswer == null) {
      return Answer.none;
    }
    if (nameAnswer == name) {
      return Answer.correct;
    }
    if (name.toLowerCase().contains(nameAnswer!.toLowerCase())) {
      return Answer.contains;
    }
    return Answer.wrong;
  }
}
