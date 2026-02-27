import 'package:flutter/material.dart' hide Card;
import 'package:flashes/card_sets.dart';
import 'package:flashes/card_screen.dart';
import 'package:flashes/card_creator.dart';
import 'package:flashes/database_handler.dart';

class CardManageScreen extends StatefulWidget {
  final CardSet? cardSet;
  const CardManageScreen({super.key, this.cardSet});

  @override
  State<CardManageScreen> createState() => _CardManageScreenState();
}

class _CardManageScreenState extends State<CardManageScreen> {
  //card list
  List<Card> cards = [];
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
    reloadPageFlip();
  }

  void reloadPage() {
    setState(() {
      _loading = true;
    });
    getCardList();
  }

  void reloadPageFlip() {
    setState(() {});
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
              Container(
                //spending section outer border
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 3),
                  borderRadius: BorderRadius.circular(23),
                  shape: BoxShape.rectangle,
                ),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context)
                        .push(
                          MaterialPageRoute(
                            builder: (context) =>
                                CardCreation(cardSet: widget.cardSet!.setID),
                          ),
                        )
                        .then((value) => reloadPage());
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 7),
                    backgroundColor: const Color(0xFFFF9B71),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: const BorderSide(
                        color: Color(0xFF3B0054),
                        width: 3,
                      ),
                    ),
                    minimumSize: Size(
                      MediaQuery.of(context).size.width * 0.9,
                      MediaQuery.of(context).size.height * 0.05,
                    ),
                  ),
                  child: const Text(
                    'Create Card',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 20.0),

              Expanded(
                child: ListView.builder(
                  itemCount: cards.length,
                  itemBuilder: (context, index) {
                    final card = cards[index];
                    return InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () {
                        Navigator.of(context)
                        .push(
                          MaterialPageRoute(
                            builder: (context) =>
                                CardCreation(cardSet: widget.cardSet!.setID, card: card),
                          ),
                        )
                        .then((value) => reloadPage());
                      },
                      child: AspectRatio (
                        aspectRatio: 5/3,
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
                                  card.fText,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  softWrap: true,
                                  textAlign: TextAlign.center,
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}