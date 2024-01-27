import 'package:flutter/material.dart';
import 'package:registration_app/pages/archive.dart';
import 'package:registration_app/pages/sign_up.dart';
import 'package:registration_app/services/db.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isChecked = false;
  DB db = DB();
  final _formKey = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();
  TextEditingController nationalNumber = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[400],
      body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(60),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  MaterialButton(
                    onPressed: () async {
                      await db.deleteMyDatabase();
                    },
                    child: const Text('delete db'),
                  ),
                  const Text(
                    'WELCOME BACK',
                    style: TextStyle(fontSize: 30.0),
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  TextFormField(
                    controller: name,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please fill the input';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      icon: Icon(
                        Icons.person,
                        size: 25.0,
                      ),
                      label: Text(
                        'Username',
                        style: TextStyle(
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    controller: nationalNumber,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please fill the input';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      icon: Icon(
                        Icons.key,
                        size: 25.0,
                      ),
                      label: Text(
                        'National Number',
                        style: TextStyle(
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                    textAlign: TextAlign.start,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 80.0, 0, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              List<Map> res =
                                  await db.login('''SELECT * FROM users WHERE 
                                name='${name.text}' 
                                AND national_number='${nationalNumber.text}' ''');
                              if (res.isEmpty) {
                                print(res);
                              } else {
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) => const Archive()));
                              }
                            }
                          },
                          child: const Text(
                            'SIGN IN',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            value: isChecked,
                            onChanged: (bool? value) {
                              setState(() {
                                isChecked = value!;
                              });
                            },
                          ),
                          const Text('Remember me'),
                        ],
                      ),
                      const Text('Forgot password?'),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      const Text(
                        "Don't have an account? ",
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const SignUp()));
                        },
                        child: const Text(
                          "Sign Up",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          )),
    );
  }
}
