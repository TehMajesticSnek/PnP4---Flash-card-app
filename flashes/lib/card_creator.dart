import 'package:flutter/material.dart' hide Card;
import 'package:flashes/card_screen.dart';
import 'package:flashes/database_handler.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

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

    KeyboardVisibilityController keyVis = KeyboardVisibilityController();
    keyVis.onChange.listen((bool visible) {
      if (!visible) {
        FocusManager.instance.primaryFocus?.unfocus();
      }
    });
  }

  final TextEditingController _fTextController = TextEditingController();
  final TextEditingController _bTextController = TextEditingController();
  final DatabaseHandler db = DatabaseHandler.databaseInstance!;
  late bool isEdit = false;
  String titleText = "Create card";

  Future<void> addCard() async {
    String fText = _fTextController.text;
    String bText = _bTextController.text;

    if (fText == '' || bText == '') {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Enter both text fields')));
      return;
    }

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
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        ScaffoldMessenger.of(context).clearSnackBars();
        Navigator.of(context).popUntil(ModalRoute.withName('/setManageScreen'));
      },
      child: Container(
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
            centerTitle: true,
            backgroundColor: const Color(0xbf000000),
            foregroundColor: Colors.white,
            elevation: 40,
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              tooltip: 'Back Icon',
              onPressed: () {
                ScaffoldMessenger.of(context).removeCurrentSnackBar();
                ScaffoldMessenger.of(context).clearSnackBars();
                Navigator.of(context).popUntil(ModalRoute.withName('/setManageScreen'));
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
                      color: const Color(0xef938ead),
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
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 60),
                          TextFormField(
                            controller: _fTextController,
                            onTapOutside: (PointerDownEvent event) {
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              filled: true,
                              fillColor: Colors.white,
                              hintText: 'Front Text (term)',
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors.black,
                                  width: 3,
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors.black,
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
                              hintText: 'Back Text (definition)',
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors.black,
                                  width: 3,
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors.black,
                                  width: 3,
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                          ),
                          Expanded(child: Container()),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  // pop until on edit page
                                  Navigator.of(context).popUntil(
                                    ModalRoute.withName('/setManageScreen'),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xbf259086),
                                  foregroundColor: Colors.white,
                                  minimumSize: (Size(100, 40)),
                                ),
                                child: const Text(
                                  'Cancel',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  addCard();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xff028ac1),
                                  foregroundColor: Colors.white,
                                  minimumSize: (Size(100, 40)),
                                ),
                                child: const Text(
                                  'Save',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 50),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
