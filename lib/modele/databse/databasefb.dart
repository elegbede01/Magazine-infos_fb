import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projet1/modele/redacteurfb.dart';

class FirestoreService {
  // Ajouter un document à la collection "redacteurs"
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String collectionName = 'redacteurs';

  // Stream pour obtenir tous les rédacteurs en temps réel
  Stream<List<Redacteur>> streamRedacteurs() {
    return _db.collection(collectionName).orderBy('nom').snapshots().map((
      snapshot,
    ) {
      return snapshot.docs
          .map((doc) => Redacteur.fromMap(doc.data(), doc.id))
          .toList();
    });
  }

  // Ajouter un rédacteur
  Future<void> ajouterRedacteur(Redacteur redacteur) async {
    await _db.collection(collectionName).add(redacteur.toMap());
  }

  // Mettre à jour ou modifier les infos du redacteurs
  Future<void> modifierRedacteur(Redacteur redacteur) async {
    if (redacteur.id == null) throw Exception("ID du rédacteur manquant");
    await _db.collection(collectionName).doc(redacteur.id).update({
      'nom': redacteur.nom,
      'specialite': redacteur.specialite,
      'email': redacteur.email,
    });
  }

  // Supprimer les infos
  Future<void> deleteRedacteur(String id) async {
    await _db.collection(collectionName).doc(id).delete();
  }
}
