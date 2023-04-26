import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class UploadButton extends StatelessWidget {
  final String label;
  const UploadButton({required this.label, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: Theme.of(context).primaryColor)),
        child: Row(children: [
          SvgPicture.asset('images/pdf.svg',
              height: 18, width: 18, semanticsLabel: 'PDF'),
          const SizedBox(width: 6),
          Text(label)
        ]));
  }
}
