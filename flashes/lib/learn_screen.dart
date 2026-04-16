import 'package:flutter/material.dart' hide Card;
import 'package:flashes/card_sets.dart';
import 'package:flashes/card_screen.dart';
import 'package:flashes/database_handler.dart';

class LearnScreen extends StatefulWidget {
  final CardSet? cardSet;
  const LearnScreen({super.key, this.cardSet});

  @override
  State<LearnScreen> createState() => _LearnScreenState();
}

class _LearnScreenState extends State<LearnScreen> {
  //card list
  List<Card> cards = [];
  int cardIndex = 0;
  final DatabaseHandler db = DatabaseHandler.databaseInstance!;
  bool _loading = true;
  bool checkState = false; // false is show card, true shows answer
  final TextEditingController learnController = TextEditingController();

  Future<void> getCardList() async {
    List<Map<String, Object?>> userCards = await db.getCards(
      widget.cardSet!.setID,
    );

    cards = [];
    for (int i = 0; i < userCards.length; i++) {
      //for each in cards, make an object with the data
      cards.add(createCardObject(userCards[i]));
    }
    cards.shuffle();
    setState(() {
      _loading = false;
    });
  }

  Card createCardObject(Map<String, Object?> card) {
    //object with given data
    Card newCard = Card(
      cardID: card['cardID'] as int,
      setID: card['cardSet'] as int,
      fText: card['frontText'] as String,
      bText: card['backText'] as String,
    );
    return newCard;
  }

  void check(Card card) {
    setState(() {
      checkState = true;
    });
  }

  void nextCard() {
    if (cardIndex < cards.length - 1) {
      cardIndex++;
    } else {
      cardIndex = 0;
    }
    checkState = false;
    setState(() {});
  }

  void reloadPage() {
    setState(() {
      _loading = true;
    });
    getCardList();
  }

  @override
  void initState() {
    super.initState();
    getCardList();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        backgroundColor: const Color(0xFF280039),
        appBar: AppBar(
          title: const Text('Learn'),
          centerTitle: true,
          backgroundColor: const Color(0xFF280039),
          foregroundColor: Colors.white,
          elevation: 40,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
      );
    } else if (!checkState) {
      return Scaffold(
        backgroundColor: const Color(0xFF280039),
        appBar: AppBar(
          title: Text(widget.cardSet!.name),
          centerTitle: true,
          backgroundColor: const Color(0xFF280039),
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
                          child: Text(
                            cards[cardIndex].fText,
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
              SizedBox(height: 30),
              TextFormField(
                controller: learnController,
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 255, 255, 255),
                      width: 3,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 255, 255, 255),
                      width: 3,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          padding: EdgeInsets.all(12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () async {
                  check(cards[cardIndex]);
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 7),
                  backgroundColor: const Color.fromARGB(255, 197, 197, 197),
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: const BorderSide(
                      color: Color.fromARGB(255, 0, 0, 0),
                      width: 3,
                    ),
                  ),
                  minimumSize: Size(
                    MediaQuery.of(context).size.width * 0.45,
                    MediaQuery.of(context).size.height * 0.10,
                  ),
                ),
                child: const Text(
                  'Check',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  nextCard();
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 7),
                  backgroundColor: const Color.fromARGB(255, 197, 197, 197),
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: const BorderSide(
                      color: Color.fromARGB(255, 0, 0, 0),
                      width: 3,
                    ),
                  ),
                  minimumSize: Size(
                    MediaQuery.of(context).size.width * 0.25,
                    MediaQuery.of(context).size.height * 0.10,
                  ),
                ),
                child: const Text(
                  'Skip',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      // Check screen *****
      return Scaffold();
    }
  }
}
