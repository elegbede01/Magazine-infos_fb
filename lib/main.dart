import 'package:flutter/material.dart';
//imports indispensables pour inclure les bibliothèques d
//pour initialiser Firebase et utiliser les services Firebase dans l'application.
import 'package:firebase_core/firebase_core.dart';
//permet d'accéder à la base de données Cloud Firestore de Firebase pour stocker et récupérer des données dans l'application
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projet1/pages/accueil.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MonApp());
}

class MonApp extends StatefulWidget {
  const MonApp({super.key});

  @override
  State<MonApp> createState() => _MonAppState();
}

class _MonAppState extends State<MonApp> {
  int _currentIndex = 0;
  setCurrentIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Magazine',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.red,
        visualDensity: VisualDensity
            .adaptivePlatformDensity, //Ajustement suivqnt la plateforme
      ),
      //oN PASSE l'index et le callback à PageAccueil
      home: PageAccueil(
        currentIndex: _currentIndex,
        onIndexChanged: setCurrentIndex,
      ),
    );
  }
}
