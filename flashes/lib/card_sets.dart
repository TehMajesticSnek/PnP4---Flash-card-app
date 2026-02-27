import 'package:flutter/material.dart';
import 'package:flashes/card_set_creator.dart';
import 'package:flashes/database_handler.dart';
import 'package:flashes/card_screen.dart';

class CardSet {
  int setID;
  String name;

  CardSet({required this.setID, required this.name});
}

class SetsScreen extends StatefulWidget {
  const SetsScreen({super.key});

  @override
  State<SetsScreen> createState() => _SetsScreenState();
}

class _SetsScreenState extends State<SetsScreen> {
  //Card set list
  List<CardSet> sets = [];
  final DatabaseHandler db = DatabaseHandler.databaseInstance!;
  bool _loading = true;

  Future<void> getSetList() async {
    List<Map<String, Object?>> userSets = await db.getCardSets();

    sets = [];
    for (int i = 0; i < userSets.length; i++) {
      //for each in sets, make an object with the data
      sets.add(createSetObject(userSets[i]));
    }
    setState(() {
      _loading = false;
    });
  }

  CardSet createSetObject(Map<String, Object?> cardSet) {
    //object with given data
    CardSet newSet = CardSet(setID: cardSet['setID'] as int, name: cardSet['setName'] as String);
    return newSet;
  }

  void reloadPage() {
    setState(() {
      _loading = true;
    });
    getSetList();
  }

  @override
  void initState() {
    super.initState();
    getSetList();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        backgroundColor: const Color(0xFF280039),
        appBar: AppBar(
          title: const Text('Card Sets'),
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
                            builder: (context) => CardSetCreation(),
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
                    'Create Card Set',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              const SizedBox(height: 20.0),
              Center(child: CircularProgressIndicator()),
            ],
          ),
        ),
      );
    } else {
      return Scaffold(
        backgroundColor: const Color(0xFF280039),
        appBar: AppBar(
          title: const Text('Card Sets'),
          centerTitle: true,
          backgroundColor: const Color(0xFF280039),
          foregroundColor: Colors.white,
          elevation: 40,
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
                            builder: (context) => CardSetCreation(),
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
                    'Create Card Set',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 20.0),

              Expanded(
                child: ListView.builder(
                  itemCount: sets.length,
                  itemBuilder: (context, index) {
                    final cardSet = sets[index];
                    return InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () async {
                        await Navigator.of(context)
                            .push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    CardScreen(cardSet: cardSet),
                              ),
                            )
                            .then((value) => reloadPage());
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              cardSet.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
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