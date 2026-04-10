import 'package:flutter/material.dart' hide Card;
import 'package:flashes/card_screen.dart';
import 'package:flashes/database_handler.dart';

class CardCreation extends StatefulWidget {
  final int cardSet;
  final Card? card;
  const CardCreation({super.key, required this.cardSet, this.card});

  @override
  State<CardCreation> createState() => _CreateState();
}

class _CreateState extends State<CardCreation> {
  @override
  void initState() {
    super.initState();
    populateFields(); // keep placement in mind for debugging
  }

  final TextEditingController _fTextController = TextEditingController();
  final TextEditingController _bTextController = TextEditingController();
  final DatabaseHandler db = DatabaseHandler.databaseInstance!;
  late bool isEdit = false;
  String titleText = "Create card set";

  Future<void> addCard() async {
    String fText = _fTextController.text;
    String bText = _bTextController.text;

    await db.updateCard(
      isEdit,
      widget.card?.cardID,
      widget.cardSet,
      fText,
      bText,
    );
    Navigator.of(context).pop();
  }

  void populateFields() {
    if (widget.card != null) {
      _fTextController.text = widget.card!.fText;
      _bTextController.text = widget.card!.bText;
      isEdit = true;
      titleText = "Edit card";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 200, 200, 200),
      appBar: AppBar(
        title: const Text(''),
        centerTitle: true,
        backgroundColor: const Color(0xFF280039),
        foregroundColor: Colors.white,
        elevation: 40,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          tooltip: 'Back Icon',
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: CustomScrollView(
        physics: ClampingScrollPhysics(),
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Container(
                width: 300,
                height: 500,
                decoration: BoxDecoration(
                  color: const Color(0xFFFF9B71),
                  border: Border.all(color: const Color(0xFF280039), width: 3),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      Text(
                        titleText,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF280039),
                        ),
                      ),
                      const SizedBox(height: 30),
                      TextFormField(
                        controller: _fTextController,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white,
                          labelText: 'Front Text',
                          hintText: 'Enter text',
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color(0xFF3B0054),
                              width: 3,
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color.fromARGB(255, 117, 20, 158),
                              width: 3,
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      TextFormField(
                        controller: _bTextController,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white,
                          labelText: 'Back Text',
                          hintText: 'Enter text',
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color(0xFF3B0054),
                              width: 3,
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color.fromARGB(255, 117, 20, 158),
                              width: 3,
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                      const SizedBox(height: 100),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            width: 100,
                            child: ElevatedButton(
                              onPressed: () {
                                // pop until on edit page
                                Navigator.of(context).popUntil(
                                  ModalRoute.withName('/setManageScreen'),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.black,
                              ),
                              child: const Text('Cancel'),
                            ),
                          ),
                          SizedBox(
                            width: 100,
                            child: ElevatedButton(
                              onPressed: () {
                                addCard();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromARGB(
                                  255,
                                  171,
                                  255,
                                  209,
                                ),
                                foregroundColor: Colors.black,
                              ),
                              child: const Text('Save'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
