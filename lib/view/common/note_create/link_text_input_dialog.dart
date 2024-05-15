import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LinkTextInputDialog extends StatefulWidget {
  const LinkTextInputDialog({super.key});

  @override
  State<StatefulWidget> createState() => LinkTextInputDialogState();
}

class LinkTextInputDialogState extends State<LinkTextInputDialog> {
  bool _showLinkPreview = true;
  final _linkTextController = TextEditingController();
  final _linkUrlController = TextEditingController();
  String? linkTextAndUrl;

  @override
  void dispose() {
    _linkTextController.dispose();
    _linkUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("リンクの内容を入力"),
      content: Column(
        children: [
          TextField(
            controller: _linkTextController,
          ),
          TextField(
            controller: _linkUrlController,
          ),
          CheckboxListTile(
            value: _showLinkPreview,
            onChanged: (value) {
              setState(() {
                _showLinkPreview = value ?? true;
              });
            })
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            if (_showLinkPreview) {
              linkTextAndUrl = "[${_linkTextController.text}](${_linkUrlController.text})";
            } else {
              linkTextAndUrl = "?[${_linkTextController.text}](${_linkUrlController.text})";
            }
            Navigator.of(context).pop(linkTextAndUrl);
          },
          child: Text(S.of(context).done)
        )
      ],
    );
  }
}