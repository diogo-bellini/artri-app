import 'package:artriapp/utils/enums/index.dart';

class Myth {
  String question = '';
  String description = '';
  AnswerType answerType = AnswerType.myth;

  Myth({
    required this.question,
    required this.description,
    required this.answerType,
  });
}
