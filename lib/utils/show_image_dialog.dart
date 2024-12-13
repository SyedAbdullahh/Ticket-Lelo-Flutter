import 'package:flutter/material.dart';
Future<void> showImageDialog(BuildContext context,String imageURL)
{
  return showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Error "),
          content: Image.network(imageURL),
          actions: [
            TextButton(onPressed: () {
              Navigator.of(context).pop();
            }, child:
            const Text("Close")),

          ],
        );
      }
  );
}
