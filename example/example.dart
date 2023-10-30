import 'package:esc_pos_utils_la/esc_pos_utils_la.dart';
import 'package:image/image.dart';
import 'package:flutter/services.dart';

Future<void> main() async {
  final profile = await CapabilityProfile.load();
  final generator = Generator(PaperSize.mm80, profile);
  List<int> bytes = [];
  bytes += generator.text(
      'Regular: aA bB cC dD eE fF gG hH iI jJ kK lL mM nN oO pP qQ rR sS tT uU vV wW xX yY zZ');
  bytes += generator.text('Special 1: àÀ èÈ éÉ ûÛ üÜ çÇ ôÔ',
      styles: const PosStyles(codeTable: 'CP1252'));
  bytes += generator.text('Special 2: blåbærgrød',
      styles: const PosStyles(codeTable: 'CP1252'));

  bytes += generator.text('Bold text', styles: const PosStyles(bold: true));
  bytes +=
      generator.text('Reverse text', styles: const PosStyles(reverse: true));
  bytes += generator.text('Underlined text',
      styles: const PosStyles(underline: true), linesAfter: 1);
  bytes += generator.text('Align left',
      styles: const PosStyles(align: PosAlign.left));
  bytes += generator.text('Align center',
      styles: const PosStyles(align: PosAlign.center));
  bytes += generator.text('Align right',
      styles: const PosStyles(align: PosAlign.right), linesAfter: 1);

  bytes += generator.row([
    PosColumn(
      text: 'col3',
      width: 3,
      styles: const PosStyles(align: PosAlign.center, underline: true),
    ),
    PosColumn(
      text: 'col6',
      width: 6,
      styles: const PosStyles(align: PosAlign.center, underline: true),
    ),
    PosColumn(
      text: 'col3',
      width: 3,
      styles: const PosStyles(align: PosAlign.center, underline: true),
    ),
  ]);

  bytes += generator.text('Text size 200%',
      styles: const PosStyles(
        height: PosTextSize.size2,
        width: PosTextSize.size2,
      ));

  // Print image:
  final ByteData data = await rootBundle.load('assets/logo.png');
  final Uint8List imgBytes = data.buffer.asUint8List();
  final Image image = decodeImage(imgBytes)!;
  bytes += generator.image(image);
  // Print image using an alternative (obsolette) command
  // bytes += generator.imageRaster(image);

  // Print barcode
  final List<int> barData = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 4];
  bytes += generator.barcode(Barcode.upcA(barData));

  // Print mixed (chinese + latin) text. Only for printers supporting Kanji mode
  // ticket.text(
  //   'hello ! 中文字 # world @ éphémère &',
  //   styles: PosStyles(codeTable: PosCodeTable.westEur),
  //   containsChinese: true,
  // );

  bytes += generator.feed(2);
  bytes += generator.cut();
}
