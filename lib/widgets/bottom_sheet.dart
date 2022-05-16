import 'package:flutter/material.dart';

Future showbottomsheet(
  BuildContext context,
  TextEditingController _titleController,
  TextEditingController _descriptionController,
  Widget name,
  VoidCallback press,
) {
  return showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    elevation: 5,
    isScrollControlled: true,
    builder: (_) => Container(
      padding: EdgeInsets.only(
        top: 35,
        left: 15,
        right: 15,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // title
          titleField(_titleController),
          const SizedBox(height: 20),

          //description
          descriptionField(_descriptionController),
          const SizedBox(height: 30),

          //create btn
          createBtn(press, name),
        ],
      ),
    ),
  );
}

//create btn
ElevatedButton createBtn(VoidCallback press, Widget name) {
  return ElevatedButton(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all(Colors.black),
    ),
    onPressed: press,
    child: name,
  );
}

// title field
TextField titleField(TextEditingController _titleController) {
  return TextField(
    controller: _titleController,
    decoration: const InputDecoration(hintText: 'Title'),
  );
}

//description field
TextField descriptionField(TextEditingController _descriptionController) {
  return TextField(
    controller: _descriptionController,
    decoration: const InputDecoration(hintText: 'Description'),
  );
}
