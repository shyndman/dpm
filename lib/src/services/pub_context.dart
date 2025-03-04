import 'dart:io';

import 'package:console/console.dart';
import 'package:dpm/dpm.dart';
import 'package:dpm/src/services/settings.dart';
import 'package:pubspec/pubspec.dart';

class PubContext {
  PubContext.fromPubSpec(PubSpec pubspec)
      : isFlutter = pubspec.dependencies.containsKey('flutter');

  PubContext.fromPubLock(Publock publock)
      : isFlutter = publock.sdks.singleWhere(
                (sdk) => sdk.name.contains('flutter'),
                orElse: () => null) !=
            null;

  final bool isFlutter;

  Future<Process> start(List<String> arguments) async {
    final flutterSdkLocation = Settings().flutterSdkLocation;
    if (isFlutter && flutterSdkLocation.isEmpty) {
      Settings().flutterSdkLocation =
          await readInput('Please enter Flutter SDK location: ');
    }

    return Process.start(
      !isFlutter ? 'pub' : 'flutter packages',
      arguments,
      runInShell: true,
    );
  }
}
