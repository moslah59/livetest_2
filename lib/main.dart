import 'package:flutter/material.dart';

void main() {
  runApp(const ContactListApp());
}

class ContactListApp extends StatelessWidget {
  const ContactListApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contact List',
      theme: ThemeData(primarySwatch: Colors.blueGrey),
      home: const ContactListScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Contact {
  final String name;
  final String number;

  Contact(this.name, this.number);
}

class ContactListScreen extends StatefulWidget {
  const ContactListScreen({Key? key}) : super(key: key);

  @override
  State<ContactListScreen> createState() => _ContactListScreenState();
}

class _ContactListScreenState extends State<ContactListScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final List<Contact> _contacts = [];

  void _addContact() {
    String name = _nameController.text.trim();
    String number = _numberController.text.trim();

    if (name.isNotEmpty && number.isNotEmpty) {
      setState(() {
        _contacts.add(Contact(name, number));
        _nameController.clear();
        _numberController.clear();
      });
    }
  }

  void _deleteContact(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirmation"),
          content: const Text("Are you sure for Delete?"),
          actions: [
            IconButton(
              icon: const Icon(Icons.cancel),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                setState(() {
                  _contacts.removeAt(index);
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildContactTile(Contact contact, int index) {
    return GestureDetector(
      onLongPress: () => _deleteContact(index),
      child: ListTile(
        leading: const Icon(Icons.person),
        title: Text(
          contact.name,
          style: const TextStyle(color: Colors.red),
        ),
        subtitle: Text(contact.number),
        trailing: const Icon(Icons.call, color: Colors.blue),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contact List"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                hintText: "Name",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _numberController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                hintText: "Number",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _addContact,
                child: const Text("Add"),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: _contacts.isEmpty
                  ? const Center(child: Text("No contacts added yet."))
                  : ListView.builder(
                itemCount: _contacts.length,
                itemBuilder: (context, index) {
                  return _buildContactTile(_contacts[index], index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
