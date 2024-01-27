import 'package:flutter/material.dart';
import 'package:registration_app/pages/updateUser.dart';
import 'package:registration_app/services/db.dart';

class Archive extends StatefulWidget {
  const Archive({super.key});

  @override
  State<Archive> createState() => _ArchiveState();
}

class _ArchiveState extends State<Archive> {
  DB db = DB();
  List users = [];
  TextEditingController keyWordConroller = TextEditingController();
  @override
  void initState() {
    super.initState();
    getUsers('users');
  }

  getUsers(String table) async {
    List<Map> response = await db.read(table);
    if (keyWordConroller.text == '') {
      users.addAll(response);
      setState(() {});
    }
  }

  filter(String value) {
    setState(() {
      Iterable filterdUsers = users.where(
          (element) => element['name'] == value || element['title'] == value);
      users.replaceRange(0, users.length, filterdUsers.toList());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Archive'),
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: SizedBox(
                height: 40,
                child: Form(
                    child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: keyWordConroller,
                        decoration: const InputDecoration(
                          hintText: 'Search by title | name',
                        ),
                        onChanged: (value) async {
                          if (value == '') {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => const Archive()));
                          }
                        },
                      ),
                    ),
                    TextButton(
                      child: const Text('search'),
                      onPressed: () async {
                        FocusScope.of(context).unfocus();
                        await filter(keyWordConroller.text);
                      },
                    ),
                  ],
                )),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(5),
                    child: Card(
                      child: ListTile(
                        title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text("Name: ${users[index]['name']}"),
                              Text(
                                  "National NO.: ${users[index]['national_number']}"),
                              Text("Title: ${users[index]['title']}"),
                            ]),
                        subtitle: Text(
                            "Birth of date: ${users[index]['date_of_birth']}"),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            IconButton(
                              onPressed: () async {
                                int response = await db.delete(
                                    'users', 'id=${users[index]['id']}');
                                if (response > 0) {
                                  users.removeWhere((element) =>
                                      element!['id'] == users[index]['id']);
                                }
                                if (mounted) {
                                  setState(() {});
                                }
                              },
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                            ),
                            IconButton(
                              onPressed: () async {
                                Navigator.of(context)
                                    .pushReplacement(MaterialPageRoute(
                                        builder: (context) => UpdateUser(
                                              id: users[index]['id'],
                                              name: users[index]['name'],
                                              title: users[index]['title'],
                                              dateOfBirth: users[index]
                                                  ['date_of_birth'],
                                              nationalNumber: users[index]
                                                  ['national_number'],
                                            )));
                              },
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.green,
                              ),
                            )
                          ],
                        ),
                        isThreeLine: true,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
