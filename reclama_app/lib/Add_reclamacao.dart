import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


class CreateProblemScreen extends StatefulWidget {
  const CreateProblemScreen({super.key});

  @override
  _CreateProblemScreenState createState() => _CreateProblemScreenState();
}

class _CreateProblemScreenState extends State<CreateProblemScreen> {
  TextEditingController authorController = TextEditingController();
  TextEditingController problemNameController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController attachmentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastre Sua Reclamação Aqui:'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildTextFieldContainer(
              child: TextField(
                controller: authorController,
                decoration: const InputDecoration(labelText: 'Autor da Reclamação'),
              ),
            ),
            const SizedBox(height: 16),
            _buildTextFieldContainer(
              child: TextField(
                controller: problemNameController,
                decoration: const InputDecoration(labelText: 'Nome da Reclamação'),
              ),
            ),
            const SizedBox(height: 16),
            _buildTextFieldContainer(
              child: TextField(
                controller: dateController,
                decoration: const InputDecoration(labelText: 'Data da Reclamação'),
              ),
            ),
            const SizedBox(height: 16),
            _buildTextFieldContainer(
              child: TextField(
                controller: descriptionController,
                decoration:
                    const InputDecoration(labelText: 'Descrição da Reclamação'),
              ),
            ),
            const SizedBox(height: 16),
            _buildTextFieldContainer(
              child: TextField(
                controller: locationController,
                decoration:
                    const InputDecoration(labelText: 'Localização da Reclamação'),
              ),
            ),
            const SizedBox(height: 16),
            _buildTextFieldContainer(
              child: TextField(
                controller: attachmentController,
                decoration: const InputDecoration(labelText: 'Anexo da Reclamação'),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                Complaint newComplaint = Complaint(
                  id: 0,
                  author: authorController.text,
                  problemName: problemNameController.text,
                  date: dateController.text,
                  description: descriptionController.text,
                  location: locationController.text,
                  attachment: attachmentController.text,
                );

                int result =
                    await DatabaseHelper().insertComplaint(newComplaint);

                if (result != 0) {
                  print('Reclamação cadastrada com sucesso!');
                } else {
                  print('Erro ao cadastrar a reclamação.');
                }
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: const Color.fromARGB(255, 5, 96, 156),
              ),
              child: const Text('Cadastrar Reclamação'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextFieldContainer({required Widget child}) {
    return Container(
      width: 300,
      height: 80,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromARGB(255, 123, 123, 123)),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: child,
    );
  }
}

class Complaint {
  int id;
  String author;
  String problemName;
  String date;
  String description;
  String location;
  String attachment;

  Complaint({
    required this.id,
    required this.author,
    required this.problemName,
    required this.date,
    required this.description,
    required this.location,
    required this.attachment,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'author': author,
      'problemName': problemName,
      'date': date,
      'description': description,
      'location': location,
      'attachment': attachment,
    };
  }

  factory Complaint.fromMap(Map<String, dynamic> map) {
    return Complaint(
      id: map['id'],
      author: map['author'],
      problemName: map['problemName'],
      date: map['date'],
      description: map['description'],
      location: map['location'],
      attachment: map['attachment'],
    );
  }
}

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;

  static late Database _db;

  DatabaseHelper.internal();

  Future<Database> get db async {
    return _db;
      _db = await initDb();
    return _db;
  }

  Future<Database> initDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'complaints.db');

    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  void _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE Complaints (
        id INTEGER PRIMARY KEY,
        author TEXT,
        problemName TEXT,
        date TEXT,
        description TEXT,
        location TEXT,
        attachment TEXT
      )
    ''');
    Future<Database> initDb() async {
      String databasesPath = await getDatabasesPath();
      String path = join(databasesPath, 'complaints.db');

      var db = await openDatabase(path, version: 1, onCreate: _onCreate);
      print('Banco de dados aberto com sucesso no caminho: $path');
      return db;
    }
  }

  Future<int> insertComplaint(Complaint complaint) async {
    var dbClient = await db;
    int res = await dbClient.insert('Complaints', complaint.toMap());
    return res;
  }

  Future<List<Complaint>> getComplaints() async {
    var dbClient = await db;
    List<Map<String, dynamic>> maps = await dbClient.query('Complaints');
    List<Complaint> complaints = [];
    for (var map in maps) {
      complaints.add(Complaint.fromMap(map));
    }
    return complaints;
  }
}

void main() {
  runApp(
    const MaterialApp(
      home: CreateProblemScreen(),
    ),
  );
}
