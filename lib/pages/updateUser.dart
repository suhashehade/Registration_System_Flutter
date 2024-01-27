import 'package:flutter/material.dart';
import 'package:registration_app/pages/archive.dart';
import 'package:registration_app/services/db.dart';

class UpdateUser extends StatefulWidget {
  final int id;
  final String name;
  final String title;
  final String dateOfBirth;
  final String nationalNumber;

  const UpdateUser(
      {super.key,
      required this.id,
      required this.name,
      required this.title,
      required this.dateOfBirth,
      required this.nationalNumber});

  @override
  State<UpdateUser> createState() => _UpdateUserState();
}

class _UpdateUserState extends State<UpdateUser> {
  DB db = DB();

  TextEditingController nameController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController dateOfBirthController = TextEditingController();
  TextEditingController nationalNumberController = TextEditingController();

  @override
  void initState() {
    nameController.text = widget.name;
    titleController.text = widget.title;
    dateOfBirthController.text = widget.dateOfBirth;
    nationalNumberController.text = widget.nationalNumber;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const Archive()));
            },
          ),
        ],
        title: const Text('UPDATE USER'),
        centerTitle: true,
      ),
      backgroundColor: Colors.grey[400],
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Form(
            child: SingleChildScrollView(
          child: Column(
            // mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  label: Text(
                    'Username',
                    style: TextStyle(fontSize: 20.0),
                  ),
                ),
              ),
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(
                  label: Text(
                    'Title',
                    style: TextStyle(fontSize: 20.0),
                  ),
                ),
              ),
              TextFormField(
                controller: dateOfBirthController,
                decoration: const InputDecoration(
                  label: Text(
                    'date of birth',
                    style: TextStyle(fontSize: 20.0),
                  ),
                ),
              ),
              TextFormField(
                controller: nationalNumberController,
                decoration: const InputDecoration(
                  label: Text(
                    'national number',
                    style: TextStyle(fontSize: 20.0),
                  ),
                ),
              ),
              const SizedBox(
                height: 120.0,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      Map<String, String> user = {
                        "name": nameController.text,
                        "title": titleController.text,
                        "date_of_birth": dateOfBirthController.text,
                        "national_number": nameController.text
                      };
                      await db.update('users', user, "id=${widget.id}");
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => const Archive()));
                    },
                    child: const Text('UPDATE'),
                  ),
                ],
              ),
            ],
          ),
        )),
      ),
    );
  }
}
