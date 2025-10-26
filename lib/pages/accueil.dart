import 'package:flutter/material.dart';
//import 'package:projet1/widgets/navbarside.dart';
//import 'package:projet1/widgets/redacteur.dart';
import 'package:projet1/widgets/ajouteurRedacteurpage.dart';
//import 'package:projet1/widgets/navbarside.dart';

/// ---- PAGE CONTENEUR (Scaffold + AppBar + Drawer + BottomNavigationBar) ----
class PageAccueil extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onIndexChanged;
  const PageAccueil({
    super.key,
    required this.currentIndex,
    required this.onIndexChanged,
  });

  @override
  Widget build(BuildContext context) {
    final pages = const [_HomeTab(), _MagazineTab(), _ProfilTab()];
    //var image = Image.asset("assets/images/redacteur0.jpeg");
    //var _currentIndex;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: const Text("Magazine Infos"),
        centerTitle: true,
        elevation: 4.0,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            tooltip: "Rechercher",
            onPressed: () {
              print('Recherche lancee');
            },
          ),
        ],
      ),

      /// navbarside
      drawer: SizedBox(
        child: SizedBox(
          width: 280.0,
          child: Drawer(
            backgroundColor: const Color.fromARGB(255, 230, 56, 137),
            child: ListView(
              //tous les elements de notre men
              children: [
                UserAccountsDrawerHeader(
                  currentAccountPicture: CircleAvatar(
                    backgroundImage: AssetImage(
                      "assets/images/redacteur0.jpeg",
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 102, 14, 58),
                  ),
                  accountName: Text("Joseph ELEGBEDE"),
                  accountEmail: Text("joskindin2018@gmail.com"),
                ),

                ExpansionTile(
                  title: Text("Inscription/Connexion"),
                  leading: Icon(Icons.person),
                  children: [
                    ListTile(
                      title: Text("Connexion"),
                      leading: Icon(Icons.login),
                    ),
                    ListTile(
                      title: Text("Modifier mot de passe"),
                      leading: Icon(Icons.password),
                    ),
                    //ListTile(title: Text("Connexion"), leading: Icon(Icons.login)),
                    ListTile(
                      title: Text("Inscription"),
                      leading: Icon(Icons.person_add),
                    ),
                    ListTile(
                      title: Text("Profil"),
                      leading: Icon(Icons.person),
                    ),
                    ListTile(
                      title: Text("Déconnexion"),
                      leading: Icon(Icons.logout),
                    ),
                  ],
                ),
                Divider(),
                ListTile(
                  title: Text("Accueil"),
                  leading: Icon(Icons.home),
                  onTap: () {
                    onIndexChanged(0);
                    Navigator.pop(context);
                  },
                ),
                Divider(),
                ListTile(
                  title: Text("Gérer les rédacteurs"),
                  leading: Icon(Icons.group),
                  onTap: () {
                    //onIndexChanged(0);
                    //Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AjoutRedacteurPage(),
                      ), //route vers accueil
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),

      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        //currentIndex: _currentIndex,
        //onTap: (index) => setCurrentindex(index),
        selectedItemColor: const Color.fromARGB(255, 251, 4, 111),
        unselectedItemColor: Colors.pink,
        iconSize: 32,
        elevation: 15,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Accueil",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.newspaper),
            label: "Magazine",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profil"),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AjoutRedacteurPage()),
          );
        },
        tooltip: "Click",
        backgroundColor: Colors.deepOrange,
        //child: const Text('+'),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

///accueil
class _HomeTab extends StatelessWidget {
  const _HomeTab();

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Column(
        children: [
          Image(image: AssetImage('assets/images/magazinei.jpg')),
          PartieTitre(),
          PartieTexte(),
          PartieIcone(),
          PartieRubrique(),
          //RedacteurInterface(),
          //PartieButton(),
        ],
      ),
    );
  }
}

//Magazine
class _MagazineTab extends StatelessWidget {
  const _MagazineTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Page Magazine", style: TextStyle(fontSize: 22.0)),
    );
  }
}

//Profil
class _ProfilTab extends StatelessWidget {
  const _ProfilTab();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Page Profil", style: TextStyle(fontSize: 22.0)),
    );
  }
}

class PartieTitre extends StatelessWidget {
  const PartieTitre({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Bienvenue au Magazine Infos",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800),
          ),
          Text(
            "Votre magazine numerique, votre source d"
            '" inspiration',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

class PartieTexte extends StatelessWidget {
  const PartieTexte({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: const Text(
        "Magazine Infos est bien plus qu'un simple magazine d'informations...", //C'est votre passerelle vers le monde, une source inestimble de connaissances et d'actualites soigneusement selectionnees pour vous eclairer sur les enjeux mondiaux, la culture, la culture, la science,  voir meme le divertissement(jeux
      ),
    );
  }
}

class PartieIcone extends StatelessWidget {
  const PartieIcone({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Icon(Icons.phone, color: Colors.pink),
                const SizedBox(height: 5),
                Text(
                  "Tel".toUpperCase(),
                  style: const TextStyle(color: Colors.pink),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Icon(Icons.mail, color: Colors.pink),
                const SizedBox(height: 5),
                Text(
                  "Mail".toUpperCase(),
                  style: const TextStyle(color: Colors.pink),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Icon(Icons.share, color: Colors.pink),
                const SizedBox(height: 5),
                Text(
                  "Partage".toLowerCase(),
                  style: const TextStyle(color: Colors.pink),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PartieRubrique extends StatelessWidget {
  const PartieRubrique({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: const Image(
              image: AssetImage('assets/images/1.jpeg'),
              width: 100.0,
              height: 80.0,
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: const Image(
              image: AssetImage('assets/images/imgangeli.jpeg'),
              width: 100.0,
              height: 80.0,
            ),
          ),
        ],
      ),
    );
  }
}

// class RedacteurInterface extends StatefulWidget {
//   const RedacteurInterface({super.key});

//   @override
//   State<RedacteurInterface> createState() => _RedacteurInterfaceState();
// }

// class _RedacteurInterfaceState extends State<RedacteurInterface> {
//   final _formKey = GlobalKey<FormState>();
//   //controlleurs
//   final TextEditingController _nomController = TextEditingController();
//   final TextEditingController _prenomController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Ajouter un rédacteur'),
//         centerTitle: true,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(20.0),
//         child: Center(
//           child: Container(
//             padding: EdgeInsets.only(top: 25, left: 20.0, right: 20.0),
//             child: Form(
//               key: _formKey,
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     "Ajouter un Redacteur",
//                     style: TextStyle(
//                       fontSize: 22.0,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   Input(
//                     label: "Nom",
//                     hint: "Veuillez saisir le nom",
//                     controller: _nomController,
//                   ),
//                   SizedBox(height: 10),
//                   SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton(
//                       onPressed: () {},
//                       child: Text("Ajouter un rédacteur"),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
