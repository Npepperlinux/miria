import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:miria/repository/account_settings_repository.dart';
import 'package:miria/repository/emoji_repository.dart';
import 'package:miria/repository/general_settings_repository.dart';
import 'package:miria/repository/tab_settings_repository.dart';
import 'package:misskey_dart/misskey_dart.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

@GenerateNiceMocks([
  // レポジトリ
  MockSpec<TabSettingsRepository>(),
  MockSpec<AccountSettingsRepository>(),
  MockSpec<EmojiRepository>(),
  MockSpec<GeneralSettingsRepository>(),

  // API
  MockSpec<Misskey>(),
  MockSpec<MisskeyAntenna>(),
  MockSpec<MisskeyAp>(),
  MockSpec<MisskeyBlocking>(),
  MockSpec<MisskeyChannels>(),
  MockSpec<MisskeyClips>(),
  MockSpec<MisskeyDrive>(),
  MockSpec<MisskeyDriveFolders>(),
  MockSpec<MisskeyDriveFiles>(),
  MockSpec<MisskeyFederation>(),
  MockSpec<MisskeyFollowing>(),
  MockSpec<MisskeyHashtags>(),
  MockSpec<MisskeyI>(),
  MockSpec<MisskeyNotes>(),
  MockSpec<MisskeyNotesFavorites>(),
  MockSpec<MisskeyNotesPolls>(),
  MockSpec<MisskeyRenoteMute>(),
  MockSpec<MisskeyRoles>(),
  MockSpec<MisskeyUsers>(),

  // プラグインとか
  MockSpec<Dio>(),
  MockSpec<HttpClient>(),
  MockSpec<FakeFilePickerPlatform>(as: #MockFilePickerPlatform)
])
// ignore: unused_import
import 'mock.mocks.dart';

class FakeFilePickerPlatform extends Mock
    with MockPlatformInterfaceMixin
    implements FilePicker {}
