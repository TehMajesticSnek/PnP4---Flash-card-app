import 'package:flutter/material.dart' hide Card;
import 'package:flashes/card_sets.dart';
import 'package:flashes/card_screen.dart';
import 'package:flashes/card_creator.dart';
import 'package:flashes/database_handler.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class CardManageScreen extends StatefulWidget {
  final CardSet? cardSet;
  const CardManageScreen({super.key, this.cardSet});

  @override
  State<CardManageScreen> createState() => _CardManageScreenState();
}

class _CardManageScreenState extends State<CardManageScreen> {
  //card list
  List<Card> cards = [];
  late final TextEditingController setNameController = TextEditingController(
    text: widget.cardSet!.name,
  );
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

  List<Card> getSelectedCards() {
    List<Card> selectedCards = [];

    for (Card card in cards) {
      if (card.isSelected) {
        selectedCards.add(card);
      }
    }

    return selectedCards;
  }

  void queueEdit() {
    List<Card> selectedCards = getSelectedCards();

    if (selectedCards.isEmpty) {
      return;
    }
    // Iterate through list, navigate to new page for each
    for (int i = selectedCards.length; i > 0; i--) {
      Navigator.of(context)
          .push(
            MaterialPageRoute(
              builder: (context) => CardCreation(
                cardSet: widget.cardSet!.setID,
                card: selectedCards[i - 1],
              ),
            ),
          )
          .then((_) => reloadPage());
    }
  }

  void flipCard(Card card) {
    // unsure whether to allow flips here or not. Maybe as a button in the corner of a card *****
    String temp = card.fText;

    card.fText = card.bText;
    card.bText = temp;
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

    KeyboardVisibilityController keyVis = KeyboardVisibilityController();
    keyVis.onChange.listen((bool visible) {
      if (!visible) {
        FocusManager.instance.primaryFocus?.unfocus();
      }
    });
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
          title: TextFormField(
            controller: setNameController,
            onTapOutside: (PointerDownEvent event) {
              FocusManager.instance.primaryFocus?.unfocus();
            },
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
            onChanged: (value) {
              // Update the studyset title
              widget.cardSet?.setName(value);
              db.updateSet(true, widget.cardSet!.setID, value);
            },
          ),
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
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: IconButton(
                icon: const Icon(
                  Icons.delete_forever,
                ), // ***** consider folder delete
                onPressed: () {
                  showDialog<bool>(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Delete card set'),
                        content: Text(
                          'Are you sure you would like to delete this card set? This cannot be undone.',
                        ),
                        actionsAlignment: MainAxisAlignment.spaceBetween,
                        actions: [
                          TextButton(
                            child: const Text('Cancel'),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                          TextButton(
                            child: const Text(
                              'Delete',
                              style: TextStyle(color: Colors.red),
                            ),
                            onPressed: () async {
                              await db.deleteSet(widget.cardSet!.setID);
                              int count = 0;
                              Navigator.of(
                                context,
                              ).popUntil((_) => count++ >= 3);
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 6.0),
              Expanded(
                child: ListView.builder(
                  itemCount: cards.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return AspectRatio(
                        aspectRatio: 5 / 3,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 8),
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
                                      builder: (context) => CardCreation(
                                        cardSet: widget.cardSet!.setID,
                                      ),
                                    ),
                                  )
                                  .then((value) => reloadPage());
                            },
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 7),
                              backgroundColor: Colors.white,
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
                              'Add Card\n+',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      );
                    }
                    final card = cards[index - 1];
                    return InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () {
                        setState(() {
                          cards[index - 1].isSelected =
                              !cards[index - 1].isSelected;
                        });
                      },
                      child: Stack(
                        children: [
                          AspectRatio(
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
                                      card.fText,
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
                          Positioned(
                            top: 8,
                            right: 0,
                            child: IgnorePointer(
                              ignoring: true,
                              child: Checkbox(
                                value: cards[index - 1].isSelected,
                                onChanged: (bool? value) {},
                              ),
                            ),
                          ),
                        ],
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.delete_sweep),
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
                  iconSize: 36,
                  minimumSize: Size(
                    MediaQuery.of(context).size.width * 0.25,
                    MediaQuery.of(context).size.height * 0.10,
                  ),
                ),
                onPressed: () {
                  if (getSelectedCards().isEmpty) {
                    return;
                  }
                  showDialog<bool>(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Delete cards'),
                        content: Text(
                          'Are you sure you would like to delete these cards? This cannot be undone.',
                        ),
                        actionsAlignment: MainAxisAlignment.spaceBetween,
                        actions: [
                          TextButton(
                            child: const Text('Cancel'),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                          TextButton(
                            child: const Text(
                              'Delete',
                              style: TextStyle(color: Colors.red),
                            ),
                            onPressed: () async {
                              await db.deleteCards(getSelectedCards());
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  ).then((_) => reloadPage());
                },
              ),

              ElevatedButton(
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
                  'Edit Cards',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  // queue edit for all selected cards
                  queueEdit();
                },
              ),
            ],
          ),
        ),
      );
    }
  }
}
