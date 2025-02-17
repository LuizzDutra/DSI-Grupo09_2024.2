import 'package:app_gp9/custom_colors.dart';
import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget{
  final String text;
  final bool left;
  

  const ChatBubble({super.key, this.text='', this.left=false});

  @override
  Widget build(BuildContext context) {
    Alignment alignment = Alignment.centerRight;
    Color backgroundColor = Color.fromARGB(255, 124, 124, 124);
    if(left){
      alignment = Alignment.centerLeft;
      backgroundColor = customColors[7]!;
    }
    return Align(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Container(
          constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * 0.6),
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
              color: backgroundColor, borderRadius: BorderRadius.circular(10)),
          child: Text(
            text,
            style: TextStyle(color: Colors.white, fontSize: 16),
            softWrap: true,
          ),
        ),
      ),
    );
  }

}