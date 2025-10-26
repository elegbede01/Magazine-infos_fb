import 'package:flutter/material.dart';
import 'package:projet1/modele/Redacteur.dart';
import 'package:projet1/modele/databse/databaseManager.dart';

class ListeRedacteurs extends StatefulWidget {
  const ListeRedacteurs({super.key});

  @override
  State<ListeRedacteurs> createState() => _ListeRedacteursState();
}

class _ListeRedacteursState extends State<ListeRedacteurs> {
  late Future<List<Redacteur>> _listeRedacteurs;
  @override
  void initState() {
    super.initState();
    _rafraichirListe();
  }

  void _rafraichirListe() {
    setState(() {
      _listeRedacteurs = DatabaseManager.getAllRedacteurs();
    });
  }

  void refresh() => _rafraichirListe();

  //Affiche boite de dialogue pour conifirmation avant suppression
  void _supprimerRedacteur(int id) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Confirmation!"),
          content: Text("Voulez-vous vraiment supprimer ce rédacteur?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), //Fermer sans supprimer
              child: Text("Annuler"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () async {
                await DatabaseManager.deleteRedacteur(id);
                Navigator.pop(context); //ferme la boite
                _rafraichirListe(); // rafraichir la liste

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Rédacteur supprimé!🗑️")),
                );
              },
              child: Text("Supprimer"),
            ),
          ],
        );
      },
    );
  }

  // Affiche la boîte de dialogue pour modification
  void _modifierRedacteur(Redacteur redacteur) {
    final _formKey = GlobalKey<FormState>();
    String nom = redacteur.nom;
    String prenom = redacteur.prenom;
    String email = redacteur.email;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Modifier le rédacteur"),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    initialValue: nom,
                    decoration: InputDecoration(labelText: "Nom"),
                    validator: (value) {
                      if (value == null || value.isEmpty) return "Nom requis";
                      return null;
                    },
                    onChanged: (value) => nom = value,
                  ),
                  TextFormField(
                    initialValue: prenom,
                    decoration: InputDecoration(labelText: "Prénom"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Prénom requis";
                      }
                      return null;
                    },
                    onChanged: (value) => prenom = value,
                  ),
                  TextFormField(
                    initialValue: email,
                    decoration: InputDecoration(labelText: "Email"),
                    validator: (value) {
                      if (value == null || value.isEmpty) return "Email requis";
                      if (!value.contains('@')) return "Email invalide";
                      return null;
                    },
                    onChanged: (value) => email = value,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Annuler"),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  redacteur.nom = nom;
                  redacteur.prenom = prenom;
                  redacteur.email = email;
                  await DatabaseManager.updateRedacteur(redacteur);
                  Navigator.pop(context);
                  _rafraichirListe();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Rédacteur modifié! ✏️")),
                  );
                }
              },
              child: Text("Enregistrer"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Redacteur>>(
      future: _listeRedacteurs, // les donnees
      builder: (context, snapshot) {
        //pendant le chargement
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final redacteurs = snapshot.data!;
        //si la table est vide
        if (redacteurs.isEmpty) {
          return Center(child: Text("Aucun rédacteur trouvé!"));
        }
        //sinon affiche la lite
        return ListView.builder(
          itemCount: redacteurs.length,
          itemBuilder: (context, index) {
            final r = redacteurs[index];
            return Column(
              children: [
                //Center(child: Text("Liste des rédacteurs")),
                Card(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    leading: CircleAvatar(child: Text(r.nom[0].toUpperCase())),
                    title: Text("${r.nom} ${r.prenom}"),
                    subtitle: Text(r.email),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _modifierRedacteur(r),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _supprimerRedacteur(r.id!),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
