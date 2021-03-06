import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  const Header(this.heading, {Key? key}) : super(key: key);
  final String heading;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          heading,
          style: const TextStyle(fontSize: 24),
        ),
      );
}

class Paragraph extends StatelessWidget {
  const Paragraph(this.content, {Key? key}) : super(key: key);
  final String content;
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Text(
          content,
          style: const TextStyle(fontSize: 18),
        ),
      );
}

class IconAndDetail extends StatelessWidget {
  const IconAndDetail(this.icon, this.detail, {Key? key}) : super(key: key);
  final IconData icon;
  final String detail;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Icon(icon),
            const SizedBox(width: 8),
            Text(
              detail,
              style: const TextStyle(fontSize: 18),
            )
          ],
        ),
      );
}

class StyledButton2 extends StatelessWidget {
  const StyledButton2({Key? key, required this.txt, required this.onPressed}) : super(key: key);
  final String txt;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) => OutlinedButton(
        style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Colors.red)),
        onPressed: onPressed,
        child: Text(txt, style: const TextStyle(color: Colors.red)),
      );
}

class StyledButton extends StatelessWidget {
  const StyledButton({Key? key, required this.txt, required this.onPressed}) : super(key: key);
  final String txt;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) => OutlinedButton(
    style: OutlinedButton.styleFrom(
        backgroundColor: Colors.red,
        side: const BorderSide(color: Colors.white)),
    onPressed: onPressed,
    child: Text(txt, style: const TextStyle(color: Colors.white),),
  );
}