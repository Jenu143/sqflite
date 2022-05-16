import 'package:flutter/material.dart';
import 'package:sqflite_text/sqflite/sqf_lite_helper.dart';
import 'package:sqflite_text/widgets/bottom_sheet.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> _journals = [];

  bool _isLoading = true;
  void _refreshJournals() async {
    final data = await SQLHelper.getItems();
    setState(() {
      _journals = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshJournals();
  }

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  //^ show form
  void _showForm(int? id) async {
    if (id != null) {
      // id == null -> create new item
      // id != null -> update an existing item
      final existingJournal =
          _journals.firstWhere((element) => element['id'] == id);

      _titleController.text = existingJournal['title'];

      _descriptionController.text = existingJournal['description'];
    }

    //^ add data
    Future<void> _addItem() async {
      await SQLHelper.createItem(
        _titleController.text,
        _descriptionController.text,
      );
      _refreshJournals();
    }

    //^ update data
    Future<void> _updateItem(int id) async {
      await SQLHelper.updateItem(
          id, _titleController.text, _descriptionController.text);
      _refreshJournals();
    }

    //^ bottom sheet
    showbottomsheet(
      context,
      _titleController,
      _descriptionController,
      Text(id == null ? 'Create New' : 'Update'),
      () async {
        // Save new journal
        if (id == null) {
          await _addItem();
        }
        if (id != null) {
          await _updateItem(id);
        }
        // Clear the text fields
        _titleController.text = '';
        _descriptionController.text = '';
        // Close the bottom sheet
        Navigator.of(context).pop();
      },
    );
  }

  //^ delet data
  void _deleteItem(int id) async {
    await SQLHelper.deleteItem(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Successfully deleted a journal!'),
    ));
    _refreshJournals();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : dataList(),
      floatingActionButton: createFABbutton(),
    );
  }

  ListView dataList() {
    return ListView.builder(
      itemCount: _journals.length,
      itemBuilder: (context, index) => Card(
        color: Colors.grey[200],
        margin: const EdgeInsets.all(15),
        child: ListTile(
          title: Text(
            _journals[index]['title'],
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(_journals[index]['description']),
          trailing: SizedBox(
            width: 100,
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.edit,
                    color: Colors.green.shade700,
                  ),
                  onPressed: () => _showForm(_journals[index]['id']),
                ),
                IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: Colors.red.shade700,
                  ),
                  onPressed: () => _deleteItem(
                    _journals[index]['id'],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  FloatingActionButton createFABbutton() {
    return FloatingActionButton(
      backgroundColor: Colors.black,
      child: const Icon(Icons.add),
      onPressed: () => _showForm(null),
    );
  }
}
