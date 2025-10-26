import 'package:flutter/material.dart';
import 'package:projet1/widgets/input.dart';
import 'package:projet1/modele/redacteurfb.dart';
import 'package:projet1/modele/databse/databasefb.dart';
import 'package:projet1/pages/redacteurinfopage.dart';

class AjoutRedacteurPage extends StatefulWidget {
  const AjoutRedacteurPage({super.key});

  @override
  State<AjoutRedacteurPage> createState() => _AjoutRedacteurPageState();
}

class _AjoutRedacteurPageState extends State<AjoutRedacteurPage> {
  final _formKey = GlobalKey<FormState>();

  //controlleurs
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _specialiteController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final _service = FirestoreService();

  @override
  void dispose() {
    _nomController.dispose();
    _specialiteController.dispose();
    super.dispose();
  }

  void _ajouterRedacteur() async {
    if (!_formKey.currentState!.validate()) return;
    final Redacteur nouveau = Redacteur(
      id: '',
      nom: _nomController.text.trim(),
      specialite: _specialiteController.text.trim(),
      email: _emailController.text.trim(),
    );
    try {
      await _service.ajouterRedacteur(nouveau);
      // Vide les champ
      _nomController.clear();
      _specialiteController.clear();
      _emailController.clear();

      //_listeKey.currentState?.refresh();
      //Affiche le Snackbar si le formulaire est valide
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text("Rédacteur ajouté avec succès ✅")),
      // );
      await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Succès"),
          content: const Text("Rédacteur ajouté avec succès ✅"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        ),
      );
      Navigator.pop(context); // retourne à la page précédente
      setState(() {}); // Rafraichir la page
      //rafraichir directement
      //_formKey.currentState?.refresh();
    } catch (e) {
      print("Erreur insertion $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Erreur: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 230, 56, 137),
      appBar: AppBar(
        title: const Text('Gestion des rédacteurs /ajouter un rédacteur.'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: const Text(
                      "Ajouter un rédacteur",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  Input(
                    label: "Nom",
                    hint: "Veuillez saisir le nom",
                    controller: _nomController,
                    keyboardType: TextInputType.text,
                  ),
                  Input(
                    label: "Spécialité",
                    hint: "Veuillez saisir votre spécialité",
                    controller: _specialiteController,
                    keyboardType: TextInputType.text,
                  ),
                  Input(
                    label: "Email",
                    hint: "Veuillez saisir votre adresse email",
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _ajouterRedacteur,
                      icon: const Icon(Icons.add),
                      label: const Text("Ajuouter"),
                      style: ElevatedButton.styleFrom(
                        //fixedSize: Size(250, 60),
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 30, thickness: 1),
            SizedBox(
              height: 400, //appel direct de la classe Listedesredacters
              //child: ListeRedacteurs(key: _listeKey),
              child: RedacteurInfoPage(),
            ),
          ],
        ),
      ),
    );
  }
}
