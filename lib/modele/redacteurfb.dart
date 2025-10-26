// ignore: file_names
//import 'package:flutter/foundation.dart';

class Redacteur {
  String? id; //firestore
  String nom;
  String specialite;
  String email;

  Redacteur({
    required this.id,
    required this.nom,
    required this.specialite,
    required this.email,
  });

  Map<String, dynamic> toMap() {
    return {
      'nom': nom,
      'specialite': specialite,
      'email': email,
      'createdAt': DateTime.now().toIso8601String(),
    };
  }

  // METHODE fromMap
  factory Redacteur.fromMap(Map<String, dynamic> map, String docId) {
    return Redacteur(
      id: docId,
      nom: map['nom'] ?? '',
      specialite: map['specialite'] ?? '',
      email: map['email'],
    );
  }
}
