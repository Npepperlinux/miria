import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:miria/model/account.dart';
import 'package:miria/providers.dart';
import 'package:miria/router/app_router.dart';
import 'package:miria/view/common/avatar_icon.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CommonDrawer extends ConsumerWidget {
  final Account initialOpenAccount;

  const CommonDrawer({super.key, required this.initialOpenAccount});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: ListView(
          children: [
            for (final account in ref.read(accountRepository).account) ...[
              ExpansionTile(
                  leading: AvatarIcon.fromIResponse(account.i),
                  initiallyExpanded:
                      account.userId == initialOpenAccount.userId &&
                          account.host == initialOpenAccount.host,
                  title: Text(account.i.name ?? account.i.username,
                      style: Theme.of(context).textTheme.titleMedium),
                  subtitle: Text(
                    "@${account.userId}@${account.host}",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  children: [
                    ListTile(
                        leading: const Icon(Icons.notifications),
                        title: const Text("通知"),
                        onTap: () {
                          Navigator.of(context).pop();
                          context
                              .pushRoute(NotificationRoute(account: account));
                        }),
                    ListTile(
                      leading: const Icon(Icons.star),
                      title: const Text("お気に入り"),
                      onTap: () {
                        Navigator.of(context).pop();
                        context.pushRoute(FavoritedNoteRoute(account: account));
                      },
                    ),
                    ListTile(
                        leading: const Icon(Icons.list),
                        title: const Text("リスト"),
                        onTap: () {
                          Navigator.of(context).pop();
                          context.pushRoute(UsersListRoute(account: account));
                        }),
                    ListTile(
                        leading: const Icon(Icons.settings_input_antenna),
                        title: Text("アンテナ"),
                        onTap: () {
                          Navigator.of(context).pop();
                          context.pushRoute(AntennaRoute(account: account));
                        }),
                    ListTile(
                        leading: const Icon(Icons.attach_file),
                        title: const Text("クリップ"),
                        onTap: () {
                          Navigator.of(context).pop();
                          context.pushRoute(ClipListRoute(account: account));
                        }),
                    ListTile(
                        leading: const Icon(Icons.tv),
                        title: const Text("チャンネル"),
                        onTap: () {
                          Navigator.of(context).pop();
                          context.pushRoute(ChannelsRoute(account: account));
                        }),
                    ListTile(
                        leading: const Icon(Icons.search),
                        title: const Text("検索"),
                        onTap: () {
                          Navigator.of(context).pop();
                          context.pushRoute(NoteSearchRoute(account: account));
                        })
                  ])
            ],
            ListTile(
                leading: const Icon(Icons.settings),
                title: const Text("設定"),
                onTap: () {
                  Navigator.of(context).pop();
                  context.pushRoute(const SettingsRoute());
                }),
          ],
        ),
      ),
    );
  }
}