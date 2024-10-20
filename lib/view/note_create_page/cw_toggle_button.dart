import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/state_notifier/note_create_page/note_create_state_notifier.dart";

class CwToggleButton extends ConsumerWidget {
  const CwToggleButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cw = ref.watch(
      noteCreateNotifierProvider.select((value) => value.isCw),
    );
    return IconButton(
      onPressed: () => ref.read(noteCreateNotifierProvider.notifier).toggleCw(),
      icon: Icon(cw ? Icons.visibility_off : Icons.remove_red_eye),
      tooltip: S.of(context).contentWarning,
    );
  }
}
