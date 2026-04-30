import 'package:flashes/main.dart';
import 'package:flashes/quiz_screen.dart';
import 'package:confetti/confetti.dart';
import 'dart:math';

class QuizScore extends StatefulWidget {
  final List<Question> questions;

  const QuizScore({super.key, required this.questions});

  @override
  State<QuizScore> createState() => _QuizScoreState();
}

class _QuizScoreState extends State<QuizScore> {
  int correctAnswers = 0;
  List<Question> incorrectQuestions = [];
  ConfettiController confetti = ConfettiController();

  void countCorrect() {
    correctAnswers = 0;
    for (Question question in widget.questions) {
      if (question.isCorrect) {
        correctAnswers++;
      }
    }
  }

  void setWrongAnswers() {
    incorrectQuestions = [];
    for (Question question in widget.questions) {
      if (!question.isCorrect) {
        incorrectQuestions.add(question);
      }
    }
  }

  void reloadPage() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    countCorrect();
    setWrongAnswers();

    if (correctAnswers.toDouble() / widget.questions.length >= 0.75) {
      confetti.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/ComplicatedPattern2.jpg'),
          alignment: AlignmentGeometry.topLeft,
          fit: BoxFit.cover,
        ),
      ),
      child: Stack( 
        children: [
          Positioned(
            top: 300,
            child: ConfettiWidget(
              confettiController: confetti,
              blastDirection: 1.6 * pi,
              emissionFrequency: 0,
              numberOfParticles: 100,
              maxBlastForce: 40,
              minBlastForce: 5,
              maximumSize: Size(30,15),
              minimumSize: Size(5,5),
              shouldLoop: false,
            ),
          ),
          Positioned(
            right: 0,
            top: 300,
            child: ConfettiWidget(
              confettiController: confetti,
              blastDirection: 1.4 * pi,
              emissionFrequency: 0,
              numberOfParticles: 100,
              maxBlastForce: 40,
              minBlastForce: 5,
              maximumSize: Size(30,15),
              minimumSize: Size(5,5),
              shouldLoop: false,
            ),
          ),
          Scaffold(
            backgroundColor: const Color(0x40280039),
            appBar: AppBar(
              title: Text("Quiz Score"),
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
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 40.0),
                  Text(
                    'Quiz complete. You scored\n$correctAnswers / ${widget.questions.length}',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40.0),
                  Expanded(
                    child: ListView.builder(
                      itemCount: incorrectQuestions.length,
                      itemBuilder: (context, index) {
                        final Question question = incorrectQuestions[index];
                        String chosenAnswer = '';
                        for (int i = 0; i < question.choices.length; i++) {
                          if (question.choices[i].$2) {
                            chosenAnswer = 'You chose: ${question.choices[i].$1}';
                          }
                        }
                        if (chosenAnswer == '') {
                          chosenAnswer = 'You didn\'t select an answer.';
                        }
                        return InkWell(
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 255, 150, 173),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'Question ${question.questionNumber}:\n${question.questionBody}\n\n$chosenAnswer\nCorrect answer: ${question.cAnswer}',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        );
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
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
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
                    child: const Text(
                      'Continue',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
