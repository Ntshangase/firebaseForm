import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyCtnzvAqrIvqKl1j4nYOKIBP64dqHoMeZw",
        authDomain: "thebeginning-28e19.firebaseapp.com",
        appId: "1:405180516032:web:43883af699d552ded74f25",
        messagingSenderId: "405180516032",
        projectId: "thebeginning-28e19"),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FireBase App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.indigo,
        ).copyWith(secondary: Colors.indigo),
        textTheme: const TextTheme(
            bodyText2: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 26),
            headline6: TextStyle(
              fontStyle: FontStyle.italic,
            )),
        outlinedButtonTheme: OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.indigo)),
        textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.indigo,
        )),
        scaffoldBackgroundColor: Colors.blue,
      ),
      home: const MyHomePage(title: 'Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title),
      ),
      body: const Center(
        child: Text("Please Fill Form In Next Page:"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const Myself(),
              ))
        },
        child: const Icon(Icons.manage_accounts_rounded),
        hoverElevation: 80,
      ),
    );
  }
}

//ziyakhala ke manje!!

class Myself extends StatefulWidget {
  const Myself({Key? key}) : super(key: key);

  @override
  State<Myself> createState() => _MyselfState();
}

class _MyselfState extends State<Myself> {
  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController surnameController = TextEditingController();
    TextEditingController podcastController = TextEditingController();

    Future fillform() {
      final name = nameController.text;
      final surname = surnameController.text;
      final podcast = podcastController.text;

      final ref = FirebaseFirestore.instance.collection("forms").doc();

      return ref
          .set({
            "Name": name,
            "Surname": surname,
            "Favourite Podcast": podcast,
            "doc_id": ref.id
          })
          .then((value) => {
                nameController.text = "",
                surnameController.text = "",
                podcastController.text = ""
              })
          // ignore: invalid_return_type_for_catch_error
          .catchError((onError) => log(onError));
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Fill In Form")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: TextField(
                controller: nameController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                    hintText: "Enter Name"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: TextField(
                controller: surnameController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                    hintText: "Enter Surname"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: TextField(
                controller: podcastController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                    hintText: "Enter Your Favourite Podcast Name"),
              ),
            ),
            ElevatedButton(
                onPressed: () => {
                      fillform(),
                    },
                child: const Text("Add Participant")),
            const SelfList(),
          ],
        ),
      ),
    );
  }
}

class SelfList extends StatefulWidget {
  const SelfList({Key? key}) : super(key: key);

  @override
  State<SelfList> createState() => _SelfListState();
}

class _SelfListState extends State<SelfList> {
  final Stream<QuerySnapshot> myforms =
      FirebaseFirestore.instance.collection("forms").snapshots();

  @override
  Widget build(BuildContext context) {
    TextEditingController nameFieldCtrlr = TextEditingController();
    TextEditingController surnameFieldCtrlr = TextEditingController();
    TextEditingController podcastFieldCtrlr = TextEditingController();

    void delete(docid) {
      FirebaseFirestore.instance
          .collection("forms")
          .doc(docid)
          .delete()
          // ignore: avoid_print
          .then((value) => print("Record Deleted"));
    }

    void update(data) {
      var collection = FirebaseFirestore.instance.collection("forms");
      nameFieldCtrlr.text = data["Name"];
      surnameFieldCtrlr.text = data["Surname"];
      podcastFieldCtrlr.text = data["Favourite Podcast"];

      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                title: Container(
                  margin: const EdgeInsets.all(8.0),
                  padding: const EdgeInsets.all(8.0),
                  alignment: Alignment.center,
                  child: const Text("Edit"),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameFieldCtrlr,
                    ),
                    TextField(
                      controller: surnameFieldCtrlr,
                    ),
                    TextField(
                      controller: podcastFieldCtrlr,
                    ),
                    TextButton(
                      onPressed: () {
                        collection.doc(data["doc_id"]).update({
                          "Name": nameFieldCtrlr.text,
                          "Surname": surnameFieldCtrlr.text,
                          "Favourite Podcast": podcastFieldCtrlr.text,
                        });
                        Navigator.pop(context);
                      },
                      child: const Text("Update Button"),
                    ),
                  ],
                ),
              ));
    }

    return StreamBuilder(
      stream: myforms,
      builder: (BuildContext context,
          AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
        if (snapshot.hasError) {
          return const Text("Something Went Wrong");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        if (snapshot.hasData) {
          return Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: (MediaQuery.of(context).size.height),
                  width: MediaQuery.of(context).size.width,
                  child: ListView(
                    children: snapshot.data!.docs
                        .map((DocumentSnapshot documentSnapshot) {
                      Map<String, dynamic> data =
                          documentSnapshot.data()! as Map<String, dynamic>;
                      return Column(
                        children: [
                          ListTile(
                            title: Text(data["Name"]),
                            isThreeLine: true,
                            subtitle: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text(data["Surname"]),
                                Text(data["Favourite Podcast"]),
                              ],
                            ),
                          ),
                          ButtonTheme(
                              child: ButtonBar(
                            children: [
                              OutlinedButton.icon(
                                onPressed: () {
                                  update(data);
                                },
                                icon: const Icon(Icons.edit),
                                label: const Text("Edit"),
                              ),
                              OutlinedButton.icon(
                                onPressed: () {
                                  delete(data["doc_id"]);
                                },
                                icon: const Icon(Icons.remove),
                                label: const Text("Delete"),
                              )
                            ],
                          ))
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          );
        } else {
          return (const Text("No Data"));
        }
      },
    );
  }
}
