import 'package:flutter/material.dart';
import 'package:registration_app/pages/archive.dart';
import 'package:registration_app/pages/login.dart';
import 'package:registration_app/services/db.dart';
import 'package:intl/intl.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  DB db = DB();

  signUp(String table, Map<String, String> user) async {
    int response = await db.insert(table, user);
    if (response > 0) {
      print(user);
    }
  }

  TextEditingController nameController = TextEditingController();
  TextEditingController nationalNumberController = TextEditingController();
  TextEditingController dateOfBirthController = TextEditingController();
  TextEditingController titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[400],
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Form(
            child: SingleChildScrollView(
          child: Column(
            // mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'SIGN UP',
                style: TextStyle(
                  fontSize: 30.0,
                ),
              ),
              const SizedBox(
                height: 30.0,
              ),
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
                controller: nationalNumberController,
                decoration: const InputDecoration(
                  label: Text(
                    'National Number',
                    style: TextStyle(fontSize: 20.0),
                  ),
                ),
              ),
              TextFormField(
                onChanged: (value) {},
                controller: dateOfBirthController,
                decoration: const InputDecoration(
                  label: Text(
                    'Data of birth',
                    style: TextStyle(fontSize: 20.0),
                  ),
                ),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                      context: context,
                      firstDate: DateTime(1950),
                      lastDate: DateTime(2100));
                  if (pickedDate != null) {
                    String formattedDate =
                        DateFormat.yMMMd().format(pickedDate);
                    setState(() {
                      dateOfBirthController.text = formattedDate;
                    });
                  }
                },
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
                        "national_number": nationalNumberController.text,
                        "date_of_birth": dateOfBirthController.text,
                        "title": titleController.text
                      };
                      await signUp('users', user);
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => const Archive()));
                    },
                    child: const Text('SIGN UP'),
                  ),
                ],
              ),
              const SizedBox(
                height: 120.0,
              ),
              Row(
                children: <Widget>[
                  const Text(
                    "You you an account? ",
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => const Login()));
                    },
                    child: const Text(
                      "Sign In",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        )),
      ),
    );
  }
}
