import'package:flutter/material.dart';
Future<bool> TwoOptionsDialog(BuildContext context,String title, String content, String option1, String option2)
{
  return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(onPressed: () {
              Navigator.of(context).pop(true);
            }, child:
            Text(option1)),

            TextButton(onPressed: () {
              Navigator.of(context).pop(false);
            }, child:
            Text(option2)),
          ],
        );
      }
  ).then((value)=>value??false);
}