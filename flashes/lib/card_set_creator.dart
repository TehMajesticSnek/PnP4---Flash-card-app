import 'package:flutter/material.dart';
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
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 200, 200, 200),
      appBar: AppBar(
        title: const Text('Category Creation'),
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
                      const Text(
                        'Create a card set',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF280039),
                        ),
                      ),
                      const SizedBox(height: 30),
                      TextFormField(
                        controller: _categoryNameController,
                        onTapOutside: (PointerDownEvent event) {
                          FocusManager.instance.primaryFocus?.unfocus();
                        },
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white,
                          labelText: 'Set name',
                          hintText: 'Enter name',
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
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          addCategory();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey,
                          foregroundColor: Colors.black,
                        ),
                        child: const Text('Save'),
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
