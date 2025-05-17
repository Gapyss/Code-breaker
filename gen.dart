import 'dart:io';

void main() async {
  // อ่านไฟล์ต้นฉบับ
  final inputFile = File('word.txt');
  final outputFile = File('wording.txt');

  // ตรวจสอบว่าไฟล์ต้นฉบับมีอยู่หรือไม่
  if (await inputFile.exists()) {
    // อ่านเนื้อหาไฟล์
    final content = await inputFile.readAsString();
    
    // แยกคำจากบรรทัด และรวมคำทั้งหมดให้เป็นคำเดี่ยวในบรรทัดใหม่
    final words = content.split(RegExp(r'\s+')).where((word) => word.isNotEmpty).join('\n');

    // เขียนผลลัพธ์ไปที่ไฟล์ใหม่
    await outputFile.writeAsString(words);
    print('ไฟล์ถูกแปลงสำเร็จ! ผลลัพธ์อยู่ใน output.txt');
  } else {
    print('ไม่พบไฟล์ input.txt');
  }
}