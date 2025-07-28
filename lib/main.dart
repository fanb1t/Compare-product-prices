import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: compare_pd
    );
  }
}
// เริ่มระบบ Widget ระบบwidgetหลัก โดยเราจะเขียนแยกคลาสเป็น ส่วนของ state คลาสของฟอร์ม คลาสของการแจ้งเตือน

class compare_pd extends StatefulWidget { 
  const compare_pd({super.key});

  @override
  State<compare_pd> createState() => _compare_pdState();
  
}

// สร้างคลาสหลักของ widget เป็นclass รับค่าstateก่อน
class _compare_pdState extends State<compare_pd> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
