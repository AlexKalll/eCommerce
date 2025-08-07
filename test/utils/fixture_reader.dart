import 'dart:io';

String fixture(String fileName) {
  return File('test/utils/fixtures/$fileName').readAsStringSync();
}
