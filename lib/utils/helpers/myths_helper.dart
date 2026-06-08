import 'dart:math';
import 'package:artriapp/models/index.dart';
import 'package:artriapp/utils/consts/all_myths.dart';
import 'package:artriapp/utils/enums/index.dart';

class MythsHelper {
  int _currentIndex = 0;
  final int _currentMaxIndex = AllMyths.myths.length - 1;

  bool isMythCorrect(Myth myth, AnswerType userAnswer) {
    return myth.answerType == userAnswer;
  }

  Myth getRandomMyth() {
    _currentIndex = Random().nextInt(AllMyths.myths.length);

    return AllMyths.myths[_currentIndex];
  }

  Myth getNextMyth() {
    _currentIndex = (_currentIndex + 1) % (_currentMaxIndex + 1);

    return AllMyths.myths[_currentIndex];
  }
}
