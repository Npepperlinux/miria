import 'dart:ffi';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_misskey_app/providers.dart';
import 'package:flutter_misskey_app/repository/tab_settings_repository.dart';
import 'package:flutter_misskey_app/router/app_router.dart';
import 'package:flutter_misskey_app/view/login_page/api_key_login.dart';
import 'package:flutter_misskey_app/view/login_page/mi_auth_login.dart';
import 'package:flutter_misskey_app/view/login_page/password_login.dart';
import 'package:flutter_misskey_app/view/time_line_page/time_line_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()
class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => LoginPageState();
}

class LoginPageState extends ConsumerState<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          appBar: AppBar(
            title: const Text("ログイン"),
            bottom: const TabBar(isScrollable: true, tabs: [
              Tab(text: "MiAuthでログイン"),
              Tab(text: "APIキーでログイン"),
              Tab(text: "パスワードでログイン")
            ]),
          ),
          body: const TabBarView(
            children: [MiAuthLogin(), ApiKeyLogin(), PasswordLogin()],
          )),
    );
  }
}
