import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:miria/model/account.dart';
import 'package:miria/providers.dart';
import 'package:miria/router/app_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/view/common/error_dialog_handler.dart';
import 'package:miria/view/settings_page/tab_settings_page/channel_select_dialog.dart';
import 'package:misskey_dart/misskey_dart.dart';

import 'local_only_icon.dart';

class RenoteModalSheet extends ConsumerStatefulWidget {
  final Note note;
  final Account account;

  const RenoteModalSheet({
    super.key,
    required this.note,
    required this.account,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      RenoteModalSheetState();
}

class RenoteModalSheetState extends ConsumerState<RenoteModalSheet> {
  bool isLocalOnly = false;
  var visibility = NoteVisibility.public;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final accountSettings =
        ref.read(accountSettingsRepositoryProvider).fromAccount(widget.account);
    isLocalOnly = accountSettings.defaultIsLocalOnly;
    visibility =
        accountSettings.defaultNoteVisibility == NoteVisibility.specified
            ? NoteVisibility.followers
            : accountSettings.defaultNoteVisibility;
  }

  @override
  Widget build(BuildContext context) {
    final channel = widget.note.channel;
    return ListView(
      children: [
        if (channel != null) ...[
          ListTile(
            onTap: () async {
              final scaffoldMessenger = ScaffoldMessenger.of(context);
              final navigator = Navigator.of(context);
              await ref
                  .read(misskeyProvider(widget.account))
                  .notes
                  .create(NotesCreateRequest(
                    renoteId: widget.note.id,
                    localOnly: true,
                    channelId: channel.id,
                  ));
              scaffoldMessenger
                  .showSnackBar(const SnackBar(content: Text("Renoteしました。"), behavior: SnackBarBehavior.floating, margin: EdgeInsetsDirectional.symmetric(vertical: 80)));
              navigator.pop();
            }.expectFailure(context),
            title: Padding(
              padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
              child: Text("${channel.name}内にRenote"),
            ),
          ),
          ListTile(
            onTap: () async {
              final navigator = Navigator.of(context);
              final channelsShowData = await ref
                  .read(misskeyProvider(widget.account))
                  .channels
                  .show(ChannelsShowRequest(channelId: channel.id));
              if (!mounted) return;
              navigator.pop();
              context.pushRoute(NoteCreateRoute(
                  renote: widget.note,
                  channel: channelsShowData,
                  initialAccount: widget.account));
            }.expectFailure(context),
            title: Padding(
              padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
              child: Text("${channel.name}内に引用Renote"),
            ),
          ),
        ],
        if (widget.note.channel?.allowRenoteToExternal != false) ...[
          ListTile(
            onTap: () async {
              final scaffoldMessenger = ScaffoldMessenger.of(context);
              final navigator = Navigator.of(context);
              await ref
                  .read(misskeyProvider(widget.account))
                  .notes
                  .create(NotesCreateRequest(
                    renoteId: widget.note.id,
                    localOnly: isLocalOnly,
                    visibility: visibility,
                  ));
              scaffoldMessenger
                  .showSnackBar(const SnackBar(content: Text("Renoteしました。"), behavior: SnackBarBehavior.floating, margin: EdgeInsetsDirectional.symmetric(vertical: 80)));
              navigator.pop();
            }.expectFailure(context),
            title: const Padding(
              padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
              child: Text("Renote"),
            ),
            subtitle: Row(children: [
              Expanded(
                child: DropdownButton(
                  isExpanded: true,
                  items: [
                    for (final element in NoteVisibility.values.where(
                        (element) => element != NoteVisibility.specified))
                      DropdownMenuItem(
                          value: element, child: Text(element.displayName))
                  ],
                  value: visibility,
                  onChanged: (value) => setState(() {
                    visibility = value ?? NoteVisibility.public;
                  }),
                ),
              ),
              IconButton(
                  onPressed: () => setState(() {
                        isLocalOnly = !isLocalOnly;
                      }),
                  icon: isLocalOnly
                      ? const LocalOnlyIcon()
                      : const Icon(Icons.rocket)),
            ]),
          ),
          ListTile(
              onTap: () {
                final navigator = Navigator.of(context);
                context.pushRoute(NoteCreateRoute(
                    renote: widget.note, initialAccount: widget.account));
                navigator.pop();
              },
              title: const Text("引用Renote")),
          ListTile(
              onTap: () async {
                final scaffoldMessenger = ScaffoldMessenger.of(context);
                final navigator = Navigator.of(context);
                final selected = await showDialog<CommunityChannel?>(
                    context: context,
                    builder: (context) =>
                        ChannelSelectDialog(account: widget.account));
                if (selected != null) {
                  await ref
                      .read(misskeyProvider(widget.account))
                      .notes
                      .create(NotesCreateRequest(
                        renoteId: widget.note.id,
                        channelId: selected.id,
                        localOnly: true,
                      ));

                  scaffoldMessenger.showSnackBar(
                      const SnackBar(content: Text("Renoteしました。"), behavior: SnackBarBehavior.floating, margin: EdgeInsetsDirectional.symmetric(vertical: 80)));
                  navigator.pop();
                }
              }.expectFailure(context),
              title: Text(
                  "${widget.note.channel != null ? "ほかの" : ""}チャンネルへRenote")),
          ListTile(
              onTap: () async {
                final navigator = Navigator.of(context);
                final selected = await showDialog<CommunityChannel?>(
                    context: context,
                    builder: (context) =>
                        ChannelSelectDialog(account: widget.account));
                if (!mounted) return;
                if (selected != null) {
                  context.pushRoute(NoteCreateRoute(
                      renote: widget.note,
                      initialAccount: widget.account,
                      channel: selected));
                  navigator.pop();
                }
              },
              title: Text(
                  "${widget.note.channel != null ? "ほかの" : ""}チャンネルへ引用Renote")),
        ]
      ],
    );
  }
}
