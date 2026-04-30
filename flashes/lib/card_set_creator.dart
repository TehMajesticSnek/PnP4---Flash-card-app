import 'package:flashes/main.dart';
import 'package:flashes/database_handler.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class CardSetCreation extends StatefulWidget {
  //allows for editing categories
  const CardSetCreation({super.key});

  @override
  State<CardSetCreation> createState() => _CreateSetState();
}

class _CreateSetState extends State<CardSetCreation> {
  @override
  void initState() {
    super.initState();

    KeyboardVisibilityController keyVis = KeyboardVisibilityController();
    keyVis.onChange.listen((bool visible) {
      if (!visible) {
        FocusManager.instance.primaryFocus?.unfocus();
      }
    });
  }

  final TextEditingController _categoryNameController = TextEditingController();
  final DatabaseHandler db = DatabaseHandler.databaseInstance!;

  Future<void> addCategory() async {
    String catName = _categoryNameController.text;

    await db.addSet(catName);
    Navigator.of(context).pop();
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
      child: Scaffold(
        backgroundColor: const Color(0x40280039),
        appBar: AppBar(
          title: const Text('Category Creation'),
          centerTitle: true,
          backgroundColor: const Color(0xbf000000),
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
                    color: const Color(0xef938ead),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        const Text(
                          'Create a card set',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 60),
                        TextFormField(
                          controller: _categoryNameController,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Set name',
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
                                Navigator.of(context).pop();
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
                                addCategory();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xff028ac1),
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
    );
  }
}
