import 'package:flutter/material.dart';
//import 'package:projet1/modele/Redacteur.dart';
//import 'package:projet1/modele/databse/databaseManager.dart';
import 'package:projet1/modele/databse/databasefb.dart';
import 'package:projet1/modele/redacteurfb.dart';
import 'package:projet1/widgets/ajouteurRedacteurpage.dart';

class RedacteurInfoPage extends StatefulWidget {
  const RedacteurInfoPage({super.key});

  @override
  State<RedacteurInfoPage> createState() => _RedacteurInfoPageState();
}

class _RedacteurInfoPageState extends State<RedacteurInfoPage> {
  // Service Firestore : utilisé pour lire et manipuler les données
  final FirestoreService _service =
      FirestoreService(); //l'instqnce peut etre cree

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Liste des Rédacteurs"),
        backgroundColor: const Color.fromARGB(255, 230, 56, 137),
        actions: [
          // Bouton pour accéder à la page d'ajout de rédacteur
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AjoutRedacteurPage()),
              );
              // Permet de relancer le StreamBuilder à la sortie
              setState(() {});
            },
          ),
        ],
      ),
      //StreamBuilder : écoute les changements en temps réel depuis Firestore
      // 🔸 StreamBuilder : écoute les changements en temps réel depuis Firestore
      body: StreamBuilder<List<Redacteur>>(
        stream: _service.streamRedacteurs(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Erreur : ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final redacteurs = snapshot.data ?? [];

          if (redacteurs.isEmpty) {
            return const Center(child: Text('Aucun rédacteur trouvé.'));
          }

          // ✅ Liste dynamique de rédacteurs
          return ListView.builder(
            itemCount: redacteurs.length,
            itemBuilder: (context, index) {
              final r = redacteurs[index];

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                elevation: 3,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.amber.shade700,
                    child: Text(
                      r.nom.isNotEmpty
                          ? r.nom.substring(0, 1).toUpperCase()
                          : '?',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text(
                    r.nom,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(r.specialite),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // ✏️ Bouton modifier
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        tooltip: "Modifier",
                        onPressed: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ModifierRedacteurPage(
                                redacteurId: r.id!,
                                redacteurData: r,
                              ),
                            ),
                          );
                          setState(() {}); // 🔁 rafraîchit la vue
                        },
                      ),

                      // 🗑️ Bouton supprimer
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        tooltip: "Supprimer",
                        onPressed: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => SupprimerRedacteurPage(
                                redacteurId: r.id!,
                                redacteurNom: r.nom,
                              ),
                            ),
                          );
                          setState(() {}); // 🔁 rafraîchit après suppression
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// quelques classes
//Affiche boite de dialogue pour conifirmation avant suppression
class SupprimerRedacteurPage extends StatelessWidget {
  final String redacteurId;
  final String redacteurNom;

  const SupprimerRedacteurPage({
    super.key,
    required this.redacteurId,
    required this.redacteurNom,
  });

  Future<void> _supprimer(BuildContext context) async {
    final service = FirestoreService();
    try {
      await service.deleteRedacteur(redacteurId);
      // Afficher succès et revenir
      await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          //backgroundColor: Colors.blue,
          title: const Text('Supprimé'),
          content: const Text('Le rédacteur a été supprimé.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
        //title: Text("Confirmation!"),
      );
      Navigator.pop(context); // fermer la page de confirmation
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erreur: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Card(
        color: Colors.white,
        child: Column(
          children: [
            Text('Voulez-vous vraiment supprimer "$redacteurNom" ?'),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Annuler'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      side: const BorderSide(
                        color: Colors.grey,
                      ), // bordure grise
                      //                 shape: RoundedRectangleBorder(
                      //                   borderRadius: BorderRadius.circular(10),
                    ),
                    onPressed: () => _supprimer(context),
                    child: const Text('Supprimer'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// void _supprimerNote(int id) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           backgroundColor: Colors.blue,
//           title: Text("Confirmation!"),
//           content: Text("Voulez-vous vraiment supprimer cette note?"),
//           actions: [
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.white, // ✅ fond blanc
//                 foregroundColor: Colors.black, // texte noir
//                 side: const BorderSide(color: Colors.grey), // bordure grise
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//               onPressed: () => Navigator.pop(context),
//               child: const Text("Annuler"),
//             ),
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.red,
//                 foregroundColor: Colors.black,
//                 side: const BorderSide(color: Colors.grey),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//               onPressed: () async {
//                 await DatabaseManager.deleteNote(id);
//                 Navigator.pop(context); //ferme la boite
//                 _rafraichirListe(); // rafraichir la liste

//                 ScaffoldMessenger.of(
//                   context,
//                 ).showSnackBar(SnackBar(content: Text("Note supprimée!🗑️")));
//               },
//               child: Text("Supprimer"),
//             ),
//           ],
//         );
//       },
//     );

// void _supprimerRedacteur(int id) {
//   showDialog(
//     context: context,
//     builder: (context) {
//       return AlertDialog(
//         title: Text("Confirmation!"),
//         content: Text("Voulez-vous vraiment supprimer ce rédacteur?"),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context), //Fermer sans supprimer
//             child: Text("Annuler"),
//           ),
//           ElevatedButton(
//             style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//             onPressed: () async {
//               await DatabaseManager.deleteRedacteur(id);
//               Navigator.pop(context); //ferme la boite
//               _rafraichirListe(); // rafraichir la liste

//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(content: Text("Rédacteur supprimé!🗑️")),
//               );
//             },
//             child: Text("Supprimer"),
//           ),
//         ],
//       );
//     },
//   );
// }

// Affiche la boîte de dialogue pour modification

class ModifierRedacteurPage extends StatefulWidget {
  final String redacteurId;
  final Redacteur redacteurData;

  const ModifierRedacteurPage({
    super.key,
    required this.redacteurId,
    required this.redacteurData,
  });

  @override
  State<ModifierRedacteurPage> createState() => _ModifierRedacteurPageState();
}

class _ModifierRedacteurPageState extends State<ModifierRedacteurPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nomController;
  late TextEditingController _specialiteController;
  late TextEditingController _emailController;
  final _service = FirestoreService();

  @override
  void initState() {
    super.initState();
    _nomController = TextEditingController(text: widget.redacteurData.nom);
    _specialiteController = TextEditingController(
      text: widget.redacteurData.specialite,
    );
    _emailController = TextEditingController(text: widget.redacteurData.email);
  }

  @override
  void dispose() {
    _nomController.dispose();
    _specialiteController.dispose();
    super.dispose();
  }

  Future<void> _enregistrerModifications() async {
    if (!_formKey.currentState!.validate()) return;
    final updated = Redacteur(
      id: widget.redacteurId,
      nom: _nomController.text.trim(),
      specialite: _specialiteController.text.trim(),
      email: _emailController.text.trim(),
    );
    try {
      await _service.modifierRedacteur(updated);
      await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Succès'),
          content: const Text('Rédacteur mis à jour.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      Navigator.pop(context); // retour
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erreur: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Modifier rédacteur')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nomController,
                decoration: const InputDecoration(labelText: 'Nom'),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Nom requis' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _specialiteController,
                decoration: const InputDecoration(labelText: 'Spécialité'),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Spécialité requise'
                    : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _enregistrerModifications,
                icon: const Icon(Icons.save),
                label: const Text('Enregistrer'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

  // void _modifierRedacteur(Redacteur redacteur) {
  //   final _formKey = GlobalKey<FormState>();
  //   String nom = redacteur.nom;
  //   String prenom = redacteur.prenom;
  //   String email = redacteur.email;

  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         title: Text("Modifier le rédacteur"),
  //         content: Form(
  //           key: _formKey,
  //           child: SingleChildScrollView(
  //             child: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               children: [
  //                 TextFormField(
  //                   initialValue: nom,
  //                   decoration: InputDecoration(labelText: "Nom"),
  //                   validator: (value) {
  //                     if (value == null || value.isEmpty) return "Nom requis";
  //                     return null;
  //                   },
  //                   onChanged: (value) => nom = value,
  //                 ),
  //                 TextFormField(
  //                   initialValue: prenom,
  //                   decoration: InputDecoration(labelText: "Prénom"),
  //                   validator: (value) {
  //                     if (value == null || value.isEmpty) {
  //                       return "Prénom requis";
  //                     }
  //                     return null;
  //                   },
  //                   onChanged: (value) => prenom = value,
  //                 ),
  //                 TextFormField(
  //                   initialValue: email,
  //                   decoration: InputDecoration(labelText: "Email"),
  //                   validator: (value) {
  //                     if (value == null || value.isEmpty) return "Email requis";
  //                     if (!value.contains('@')) return "Email invalide";
  //                     return null;
  //                   },
  //                   onChanged: (value) => email = value,
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () => Navigator.pop(context),
  //             child: Text("Annuler"),
  //           ),
  //           ElevatedButton(
  //             onPressed: () async {
  //               if (_formKey.currentState!.validate()) {
  //                 redacteur.nom = nom;
  //                 redacteur.prenom = prenom;
  //                 redacteur.email = email;
  //                 await DatabaseManager.updateRedacteur(redacteur);
  //                 Navigator.pop(context);
  //                 _rafraichirListe();
  //                 ScaffoldMessenger.of(context).showSnackBar(
  //                   SnackBar(content: Text("Rédacteur modifié! ✏️")),
  //                 );
  //               }
  //             },
  //             child: Text("Enregistrer"),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }