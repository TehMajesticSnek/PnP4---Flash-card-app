import 'package:flashes/main.dart';
import 'package:flashes/database_handler.dart';
import 'package:flashes/card_sets.dart';
import 'package:flashes/card_manager.dart';
import 'package:flashes/study_view.dart';
import 'package:flashes/quiz_screen.dart';
import 'package:flashes/learn_screen.dart';


class Card {
  int cardID;
  int setID;
  String fText;
  String bText;
  bool isSelected = false;

  Card({
    required this.cardID,
    required this.setID,
    required this.fText,
    required this.bText,
  });
}

class CardScreen extends StatefulWidget {
  final CardSet? cardSet;
  const CardScreen({super.key, this.cardSet});

  @override
  State<CardScreen> createState() => _CardScreenState();
}

class _CardScreenState extends State<CardScreen> {
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
      //for each in card, make an object with the data
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
      return Container(
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage('assets/ComplicatedPattern2.jpg'),
          alignment: AlignmentGeometry.topLeft,
          fit: BoxFit.cover
          ),
        ),
        child: Scaffold(
          backgroundColor: const Color(0x40280039),
          appBar: AppBar(
            title: const Text('Cards'),
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
          image: DecorationImage(image: AssetImage('assets/ComplicatedPattern2.jpg'),
          alignment: AlignmentGeometry.topLeft,
          fit: BoxFit.cover
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
                Navigator.of(context).pop();
              },
            ),
            actions: [
              IconButton.filled(
                icon: const Icon(Icons.edit),
                style: IconButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.white
                ),
                onPressed: () {
                  Navigator.of(context)
                    .push(
                      MaterialPageRoute(
                        settings: const RouteSettings(name: '/setManageScreen'),
                        builder: (context) => CardManageScreen(
                          cardSet: widget.cardSet,
                        ),
                      ),
                    )
                    .then((value) => reloadPage()
                  );
                },
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cards.length,
                    itemBuilder: (context, index) {
                      final card = cards[index];
                      return InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () async {
                          flipCard(card);
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
                                  child: AutoSizeText(
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
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: BottomAppBar(
            padding: EdgeInsets.all(12),
            color: Color(0xbf259086),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      MediaQuery.of(context).size.width * 0.25,
                      MediaQuery.of(context).size.height * 0.10,
                    ),
                  ),
                  child: const Text(
                    'Study',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    if (cards.isEmpty) {
                      return;
                    }
                    Navigator.of(context)
                      .push(
                        MaterialPageRoute(
                          builder: (context) =>
                              StudyView(cardSet: widget.cardSet!),
                        ),
                      )
                      .then((value) => reloadPage()
                    );
                  },
                ),
                ElevatedButton(
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
                  child: const Text(
                    'Quiz',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    if (cards.isEmpty) {
                      return;
                    }
                    Navigator.of(context)
                      .push(
                        MaterialPageRoute(
                          builder: (context) =>
                              QuizScreen(cardSet: widget.cardSet!),
                        ),
                      )
                      .then((value) => reloadPage()
                    );
                  },
                ),
                ElevatedButton(
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
                  child: const Text(
                    'Learn',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    if (cards.isEmpty) {
                      return;
                    }
                    Navigator.of(context)
                      .push(
                        MaterialPageRoute(
                          builder: (context) =>
                              LearnScreen(cardSet: widget.cardSet!),
                        ),
                      )
                      .then((value) => reloadPage()
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}
