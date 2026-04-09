import 'package:flutter/material.dart' hide Card;
import 'package:flashes/card_sets.dart';
import 'package:flashes/card_screen.dart';
import 'package:flashes/database_handler.dart';

class StudyView extends StatefulWidget {
  final CardSet? cardSet;
  const StudyView({super.key, this.cardSet});

  @override
  State<StudyView> createState() => _StudyViewState();
}

class _StudyViewState extends State<StudyView> {
  //card list
  List<Card> cards = [];
  int cardIndex = 0;
  final DatabaseHandler db = DatabaseHandler.databaseInstance!;
  bool _loading = true;

  Future<void> getCardList() async {
    List<Map<String, Object?>> userCards = await db.getCards(
      widget.cardSet!.setID,
    );

    cards = [];
    for (int i = 0; i < userCards.length; i++) {
      //for each in cards, make an object with the data
      cards.add(createCardObject(userCards[i]));
    }
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

  void flipCard(Card card) {
    String temp = card.fText;

    card.fText = card.bText;
    card.bText = temp;
    setState(() {});
  }

  void nextCard() {
    if (cardIndex < cards.length - 1) {
      cardIndex++;
    } else {
      cardIndex = 0;
    }
    setState(() {});
  }

  void prevCard() {
    if (cardIndex > 0) {
      cardIndex--;
    } else {
      cardIndex = cards.length - 1;
    }
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
          title: const Text('Cards'),
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
    } else {
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
              const SizedBox(height: 100.0),
              InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () {
                  flipCard(cards[cardIndex]);
                },
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
            ],
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          padding: EdgeInsets.all(12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  prevCard();
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
              ),
              ElevatedButton(
                onPressed: () async {
                  flipCard(cards[cardIndex]);
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
                  'Flip Card',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward),
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
              ),
            ],
          ),
        ),
      );
    }
  }
}
