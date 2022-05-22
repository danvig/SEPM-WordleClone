/// [main.dart]
/// A list word generator program. Require a json file consists of
/// words. Outputs a Javascript file containing the list of words.
///
/// [Info]
/// - name: main.dart
/// - creator: Arvin
/// - organization/team: Team 10E Development Team
/// - created date: 16 May 2022
/// - last modified: 16 May 2022
///
/// [Todo]
/// TODO: Compile to exe or js file
/// TODO: Create CLI
/// TODO: Support online libraries

import 'dart:convert';
import 'dart:io';

const inPath = './assets/words.json';
const outPath = '../../js/words.js';

// Print event to terminal
void log(String event) {
  print('@ [${DateTime.now().toUtc()}] -- $event');
}

// Read and parse json, then to list
Future<List<String>?> readJson(String path) async {
  if (!path.endsWith('.json')) {
    path = '$path.json';
  }

  final file = File(path);
  if (file.existsSync()) {
    log('Reading File');
    final content = await file.readAsString();
    log('File Read');

    log('Decoding Json');
    final json = jsonDecode(content);
    log('Json Decoded');

    return List.castFrom<dynamic, String>(json['words']);
  } else {
    log('File Not Found');
  }
}

String generateFileContent(final List<String> words) {
  final content = "export const words = [\n '${words.join("',\n '")}'\n];";
  final headerComment = '''
// [words.js]
// This is a generated file. DO NOT MODIFY the code inside.
// Instead, re-run the generator file to update the content.
//
// Generator info:
// - name: main.dart
// - created date: 16 May 2022
// - last modified: 16 May 2022

$content
  ''';

  return headerComment;
}

// Create new file and export
Future<void> writeToJs(String path, List<String> words) async {
  if (!path.endsWith('.js')) {
    path = '$path.js';
  }

  final jsFile = File(path);

  log('Creating file');
  await jsFile.create();
  log('File Created');

  log('Writing File');
  await jsFile.writeAsString(generateFileContent(words));
  log('File Written');
}

Future<void> main(List<String> args) async {
  final words = await readJson(inPath);
  if (words != null) {
    // Clean up (Filter word with length of 5)
    words.removeWhere((e) => e.length != 5);

    await writeToJs(outPath, words);
    log('Success');
  }
}
