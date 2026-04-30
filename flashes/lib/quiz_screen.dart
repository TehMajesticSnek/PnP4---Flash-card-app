import 'package:flashes/main.dart';
import 'package:flashes/card_sets.dart';
import 'package:flashes/database_handler.dart';
import 'package:flashes/quiz_score.dart';
import 'dart:math';

class Question {
  late int questionNumber;
  String questionBody;
  String cAnswer;
  List<(String, bool)> choices = [];
  bool isCorrect = false;

  Question({required this.questionBody, required this.cAnswer});
}

class QuizScreen extends StatefulWidget {
  final CardSet? cardSet;
  final int numQs;
  const QuizScreen({super.key, this.cardSet, this.numQs = 15});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  /* 
    How to quiz maybe --> Start with a list of all cards. Shuffle them all, then pick the first n cards for the quiz.
    Consistent data, question object maybe. Save card term as correct and 3 random others as incorrect.
    Functionally display similar to study view. Switch to next/prev in list index on submit/back.
    
    pick random index of 0-3 for correct answer, choose random from terms for others. No dupes.

    display in corner for current question out of n questions

    last button redirects to score screen eventually

    confirm modal for leaving quiz and final answer submission
  */

  //question list
  List<Question> questions = [];
  int questionIndex = 0;
  final DatabaseHandler db = DatabaseHandler.databaseInstance!;
  bool _loading = true;

  Future<void> getQuestionList() async {
    List<Map<String, Object?>> userQuestions = await db.getCards(
      widget.cardSet!.setID,
    );

    questions = [];
    // list every question in set
    for (int i = 0; i < userQuestions.length; i++) {
      //for each in questions, make an object with the data
      questions.add(createQuestionObject(userQuestions[i]));
    }

    // populate answer choices using other correct answers -- seems wasteful, look into alternatives eventually
    int numChoices = 3;
    if (userQuestions.length < 4) {
      // fewer choices if normal 3 is impossible
      numChoices = userQuestions.length - 1;
    }
    for (int i = 0; i < userQuestions.length; i++) {
      List<int> chosenIndexes = [i];
      for (int j = 0; j < numChoices; j++) {
        int choiceIndex = Random().nextInt(userQuestions.length);
        if (chosenIndexes.contains(choiceIndex)) {
          // if random answer was already chosen
          j--;
          continue;
        }
        chosenIndexes.add(choiceIndex);
        questions[i].choices.add((questions[choiceIndex].cAnswer, false));
      }
      // add correct answer to choice list
      questions[i].choices.insert(Random().nextInt(numChoices + 1), (
        questions[i].cAnswer,
        false,
      ));
    }
    // shuffle then trim the question list
    questions.shuffle();
    if (questions.length > widget.numQs) {
      // trim end if longer than selected question amount
      questions.removeRange(widget.numQs, userQuestions.length);
    }

    setState(() {
      _loading = false;
    });
  }

  Question createQuestionObject(Map<String, Object?> question) {
    //object with given data
    return Question(
      questionBody: question['backText'] as String,
      cAnswer: question['frontText'] as String,
    );
  }

  void nextQuestion() {
    if (questionIndex < questions.length - 1) {
      questionIndex++;
    } else {
      finishConfirm(context);
    }
    setState(() {});
  }

  void prevQuestion() {
    if (questionIndex > 0) {
      questionIndex--;
    } else {
      quitConfirm(context);
    }
    setState(() {});
  }

  void reloadPage() {
    setState(() {
      _loading = true;
    });
    //getCardList();
  }

  @override
  void initState() {
    super.initState();
    getQuestionList();
  }

  Future<void> quitConfirm(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Confirm quit',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Color(0xff938ead),
          content: const Text(
            'Are you sure you want to leave the quiz? You won\'t be able to continue',
            style: TextStyle(color: Colors.white),
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(backgroundColor: Color(0xe5ffd61f)),
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(backgroundColor: Color(0xe5ffd61f)),
              child: const Text('Quit'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> finishConfirm(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Confirm submission',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Color(0xff938ead),
          content: const Text(
            'Are you sure you want to submit your answers?',
            style: TextStyle(color: Colors.white),
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(backgroundColor: Color(0xe5ffd61f)),
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(backgroundColor: Color(0xe5ffd61f)),
              child: const Text('Submit'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => QuizScore(questions: questions),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/ComplicatedPattern2.jpg'),
            alignment: AlignmentGeometry.topLeft,
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          backgroundColor: const Color(0x40280039),
          appBar: AppBar(
            title: const Text('Quiz'),
            centerTitle: true,
            backgroundColor: const Color(0xbf000000),
            foregroundColor: Colors.white,
            elevation: 40,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ),
      );
    } else {
      return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/ComplicatedPattern2.jpg'),
            alignment: AlignmentGeometry.topLeft,
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          backgroundColor: const Color(0x40280039),
          appBar: AppBar(
            title: Text(widget.cardSet!.name),
            centerTitle: true,
            backgroundColor: const Color(0xbf000000),
            foregroundColor: Colors.white,
            elevation: 40,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                quitConfirm(context);
              },
            ),
            actions: [
              Text("${questionIndex + 1} / ${questions.length}"),
              SizedBox(width: 20),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const SizedBox(height: 70.0),
                InkWell(
                  borderRadius: BorderRadius.circular(20),
                  child: AspectRatio(
                    aspectRatio: 5 / 3,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: AutoSizeText(
                              questions[questionIndex].questionBody,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              softWrap: true,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30.0),
                Expanded(
                  child: ListView.separated(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: questions[questionIndex].choices.length,
                    itemBuilder: (context, index) {
                      final question = questions[questionIndex];
                      question.questionNumber = questionIndex + 1;
                      return InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () async {
                          // validates if Q is correct
                          question.isCorrect =
                              (question.choices[index].$1 == question.cAnswer);

                          // deselects all choices
                          for (int i = 0; i < question.choices.length; i++) {
                            question.choices[i] = (
                              question.choices[i].$1,
                              false,
                            );
                          }
                          // selects chosen choice
                          question.choices[index] = (
                            question.choices[index].$1,
                            true,
                          );
                          // refresh
                          setState(() {});
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xef938ead),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              IgnorePointer(
                                ignoring: true,
                                child: Checkbox(
                                  checkColor: Colors.black,
                                  activeColor: Color(0xe5ffd61f),
                                  side: const BorderSide(
                                    color: Colors.black,
                                    width: 2,
                                  ),
                                  value: question.choices[index].$2,
                                  onChanged: (_) {},
                                ),
                              ),
                              Expanded(
                                child:Text(
                                  question.choices[index].$1,
                                  style: TextStyle(color: Colors.white),
                                  overflow: TextOverflow.ellipsis
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return SizedBox(height: 3);
                    },
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: BottomAppBar(
            padding: EdgeInsets.all(12),
            color: const Color(0xbf259086),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    prevQuestion();
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 7),
                    backgroundColor: const Color(0xff028ac1),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    minimumSize: Size(
                      MediaQuery.of(context).size.width * 0.25,
                      MediaQuery.of(context).size.height * 0.10,
                    ),
                  ),
                ),
                FilledButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 7),
                    backgroundColor: const Color(0xff028ac1),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    minimumSize: Size(
                      MediaQuery.of(context).size.width * 0.45,
                      MediaQuery.of(context).size.height * 0.10,
                    ),
                  ),
                  onPressed: () {
                    nextQuestion();
                  },
                  child: Text(
                    "Continue",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}
