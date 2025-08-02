import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Unit Price Comparison App',
      theme: AppTheme.darkTheme,
      home: const CompareBody(),
    );
  }
}

// คลาสจัดการธีมสีและสไตล์ทั้งหมด
class AppTheme {
  // สีของการ์ดแต่ละแบบ
  static const Color cardColor1 = Color(0xFFE91E63); // สีชมพูสำหรับการ์ดที่ 1
  static const Color cardColor2 = Color(0xFF9C27B0); // สีม่วงสำหรับการ์ดที่ 2
  static const Color cardBackgroundDark = Color(0xFF1B263B); // พื้นหลังการ์ดสีมืด
  
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF0D1B2A), // สีเข้มหลัก
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFFFF6B6B), // สีแดงส้มสำหรับปุ่ม
      secondary: Color(0xFFE91E63), // สีชมพู
      surface: Color.fromARGB(255, 43, 33, 73), // สีพื้นผิว
      background: Color.fromARGB(255, 19, 15, 78), // สีพื้นหลัง
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: cardBackgroundDark.withOpacity(0.7),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),
      labelStyle: const TextStyle(color: Colors.white70),
      hintStyle: const TextStyle(color: Colors.white54),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFFF6B6B), // สีแดงส้ม
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
      ),
    ),
  );
}

// คลาสข้อมูลสินค้าสำหรับเก็บรายละเอียดแต่ละสินค้า
class ProductData {
  final String name; // ชื่อสินค้า
  final double volume; // ปริมาตร (มล.)
  final double price; // ราคา (บาท)
  final String unit; // หน่วย (มล., ลิตร, กรัม, กิโลกรัม)

  ProductData({
    required this.name,
    required this.volume,
    required this.price,
    required this.unit,
  });

  // คำนวณราคาต่อหน่วย (บาท/มล.)
  double get pricePerUnit {
    return price / volume;
  }

  // แปลงหน่วยเป็นมิลลิลิตรสำหรับการเปรียบเทียบ
  double get volumeInML {
    switch (unit.toLowerCase()) {
      case 'ลิตร':
      case 'l':
        return volume * 1000;
      case 'มล.':
      case 'ml':
        return volume;
      case 'กก.':
      case 'kg':
        return volume * 1000; // สมมติ 1 กก. = 1000 มล.
      case 'กรัม':
      case 'g':
        return volume;
      default:
        return volume;
    }
  }

  // ราคาต่อ 100 มล. สำหรับเปรียบเทียบ
  double get pricePer100ML {
    return (price / volumeInML) * 100;
  }
}

// คลาสคำนวณและเปรียบเทียบราคา
class PriceCalculator {
  // เปรียบเทียบสินค้า 2 ชิ้นและส่งคืนผลลัพธ์
  static ComparisonResult compareProducts(ProductData product1, ProductData product2) {
    double price1 = product1.pricePer100ML;
    double price2 = product2.pricePer100ML;
    
    String betterChoice;
    double savings;
    String emoji;
    
    if (price1 < price2) {
      betterChoice = product1.name;
      savings = price2 - price1;
      emoji = '🎉';
    } else if (price2 < price1) {
      betterChoice = product2.name;
      savings = price1 - price2;
      emoji = '✨';
    } else {
      betterChoice = 'ราคาเท่ากัน';
      savings = 0;
      emoji = '⚖️';
    }
    
    return ComparisonResult(
      betterChoice: betterChoice,
      savings: savings,
      emoji: emoji,
      product1PricePer100ML: price1,
      product2PricePer100ML: price2,
    );
  }
}

// คลาสเก็บผลลัพธ์การเปรียบเทียบ
class ComparisonResult {
  final String betterChoice; // สินค้าที่คุ้มค่ากว่า
  final double savings; // จำนวนเงินที่ประหยัดได้ต่อ 100 มล.
  final String emoji; // อิโมจิแสดงผล
  final double product1PricePer100ML; // ราคาสินค้าที่ 1 ต่อ 100 มล.
  final double product2PricePer100ML; // ราคาสินค้าที่ 2 ต่อ 100 มล.

  ComparisonResult({
    required this.betterChoice,
    required this.savings,
    required this.emoji,
    required this.product1PricePer100ML,
    required this.product2PricePer100ML,
  });
}

// คลาสหลักจัดการ State ของแอป
class CompareBody extends StatefulWidget {
  const CompareBody({super.key});

  @override
  State<CompareBody> createState() => _CompareBodyState();
}

class _CompareBodyState extends State<CompareBody> {
  // Controllers สำหรับ TextField ของสินค้าแรก
  final TextEditingController _product1NameController = TextEditingController();
  final TextEditingController _product1VolumeController = TextEditingController();
  final TextEditingController _product1PriceController = TextEditingController();
  
  // Controllers สำหรับ TextField ของสินค้าที่สอง
  final TextEditingController _product2NameController = TextEditingController();
  final TextEditingController _product2VolumeController = TextEditingController();
  final TextEditingController _product2PriceController = TextEditingController();
  
  // ตัวแปรเก็บหน่วยที่เลือก
  String _product1Unit = 'มล.';
  String _product2Unit = 'มล.';
  
  // ตัวแปรเก็บผลลัพธ์การเปรียบเทียบ
  ComparisonResult? _comparisonResult;
  
  // รายการหน่วยที่ใช้ได้
  final List<String> _units = ['มล.', 'ลิตร', 'กรัม', 'กก.'];

  @override
  void dispose() {
    // ลบ controllers เมื่อไม่ใช้แล้วเพื่อป้องกัน memory leak
    _product1NameController.dispose();
    _product1VolumeController.dispose();
    _product1PriceController.dispose();
    _product2NameController.dispose();
    _product2VolumeController.dispose();
    _product2PriceController.dispose();
    super.dispose();
  }

  // ฟังก์ชันเปรียบเทียบราคา
  void _compareProducts() {
    // ตรวจสอบว่ากรอกข้อมูลครบหรือไม่
    if (_product1NameController.text.isEmpty ||
        _product1VolumeController.text.isEmpty ||
        _product1PriceController.text.isEmpty ||
        _product2NameController.text.isEmpty ||
        _product2VolumeController.text.isEmpty ||
        _product2PriceController.text.isEmpty) {
      _showErrorDialog('กรุณากรอกข้อมูลให้ครบทุกช่อง 📝');
      return;
    }

    try {
      // สร้างข้อมูลสินค้าจากที่ผู้ใช้กรอก
      ProductData product1 = ProductData(
        name: _product1NameController.text,
        volume: double.parse(_product1VolumeController.text),
        price: double.parse(_product1PriceController.text),
        unit: _product1Unit,
      );

      ProductData product2 = ProductData(
        name: _product2NameController.text,
        volume: double.parse(_product2VolumeController.text),
        price: double.parse(_product2PriceController.text),
        unit: _product2Unit,
      );

      // เปรียบเทียบและอัปเดต State
      setState(() {
        _comparisonResult = PriceCalculator.compareProducts(product1, product2);
      });
    } catch (e) {
      _showErrorDialog('กรุณากรอกตัวเลขที่ถูกต้อง 🔢');
    }
  }

  // แสดง Error Dialog
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1B263B),
        title: const Text('⚠️ ข้อผิดพลาด', style: TextStyle(color: Colors.white)),
        content: Text(message, style: const TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ตกลง', style: TextStyle(color: Color(0xFFFF6B6B))),
          ),
        ],
      ),
    );
  }

  // ล้างข้อมูลทั้งหมด
  void _clearAll() {
    setState(() {
      _product1NameController.clear();
      _product1VolumeController.clear();
      _product1PriceController.clear();
      _product2NameController.clear();
      _product2VolumeController.clear();
      _product2PriceController.clear();
      _product1Unit = 'มล.';
      _product2Unit = 'มล.';
      _comparisonResult = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      // Body หลักของแอป
      body: Container(
        // พื้นหลังไล่สีพร้อมเอฟเฟคเบลอ
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFF0D1B2A), // สีเข้มหลัก
              const Color(0xFF1B263B), // สีเข้มรอง
              const Color(0xFFE91E63).withOpacity(0.1), // สีชมพูเบลอ
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 60, 20, 20), // เพิ่ม padding ด้านบนแทน AppBar
          child: Column(
            children: [
              // หัวข้อแอป
              const Text(
                '🪙 Unit Price Comparison',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                ),
              ),
              const SizedBox(height: 30),
              // การ์ดสินค้าแรก
              _buildProductCard(
                title: 'Product 1',
                nameController: _product1NameController,
                volumeController: _product1VolumeController,
                priceController: _product1PriceController,
                selectedUnit: _product1Unit,
                onUnitChanged: (value) => setState(() => _product1Unit = value!),
                cardColor: const Color(0xFF4ECDC4).withOpacity(0.2), // สีฟ้าเขียวโปร่งใส
              ),
              
              const SizedBox(height: 20),
              
              // เส้นแบ่งสวยงามแทน VS
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: Divider(color: const Color(0xFFE91E63).withOpacity(0.6), thickness: 2)),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 15),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1B263B),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0xFFE91E63).withOpacity(0.5), width: 1.5),
                        ),
                        child: const Text(
                          'Product Price Comparator 🔄 ',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Expanded(child: Divider(color: const Color(0xFFE91E63).withOpacity(0.6), thickness: 2)),
                    ],
                  ),
                ],
              ),
              
              const SizedBox(height: 20),
              
              // การ์ดสินค้าที่สอง
              _buildProductCard(
                title: 'Product 2',
                nameController: _product2NameController,
                volumeController: _product2VolumeController,
                priceController: _product2PriceController,
                selectedUnit: _product2Unit,
                onUnitChanged: (value) => setState(() => _product2Unit = value!),
                cardColor: const Color(0xFFFFD93D).withOpacity(0.2), // สีเหลืองโปร่งใส
              ),
              
              const SizedBox(height: 30),
              
              // ปุ่มเปรียบเทียบและล้างข้อมูล
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _compareProducts,
                      label: const Text(
                        'Compare Products',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  ElevatedButton(
                    onPressed: _clearAll,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6C5CE7),
                      padding: const EdgeInsets.all(15),
                    ),
                    child: 
                    const Icon
                    (Icons.clear, size: 24),
                  ),
                ],
              ),
              
              const SizedBox(height: 30),
              
              // แสดงผลลัพธ์การเปรียบเทียบ
              if (_comparisonResult != null) _buildResultCard(),
            ],
          ),
        ),
      ),
    );
  }

  // Widget การ์ดสำหรับกรอกข้อมูลสินค้า - โทนมืดเรียบ
  Widget _buildProductCard({
    required String title,
    required TextEditingController nameController,
    required TextEditingController volumeController,
    required TextEditingController priceController,
    required String selectedUnit,
    required ValueChanged<String?> onUnitChanged,
    required Color cardColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1B263B), // สีมืดเรียบไม่มีเบลอ
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF415A77).withOpacity(0.5), // เส้นขอบโทนมืด
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // หัวข้อการ์ด
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 15),
          
          // ช่องกรอกชื่อสินค้า
          TextField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: '📦 ชื่อสินค้า',
              hintText: 'เช่น น้ำผลไม้แอปเปิ้ล',
            ),
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 15),
          
          // แถวปริมาตรและหน่วย
          Row(
            children: [
              // ช่องกรอกปริมาตร
              Expanded(
                flex: 2,
                child: TextField(
                  controller: volumeController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: '📏 ปริมาตร/น้ำหนัก',
                    hintText: 'เช่น 250',
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(width: 10),
              
              // Dropdown เลือกหน่วย
              Expanded(
                flex: 1,
                child: DropdownButtonFormField<String>(
                  value: selectedUnit,
                  decoration: const InputDecoration(
                    labelText: '📐 หน่วย',
                  ),
                  dropdownColor: const Color(0xFF1B263B),
                  style: const TextStyle(color: Colors.white),
                  items: _units.map((unit) => DropdownMenuItem(
                    value: unit,
                    child: Text(unit, style: const TextStyle(color: Colors.white)),
                  )).toList(),
                  onChanged: onUnitChanged,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          
          // ช่องกรอกราคา
          TextField(
            controller: priceController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: '💰 ราคา (บาท)',
              hintText: 'เช่น 25',
              prefixText: '฿ ',
            ),
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }

  // Widget แสดงผลลัพธ์การเปรียบเทียบ
  Widget _buildResultCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF00F260).withOpacity(0.2), // สีเขียวโปร่งใส
            const Color(0xFF0575E6).withOpacity(0.2), // สีน้ำเงินโปร่งใส
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF00F260).withOpacity(0.5),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00F260).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // หัวข้อผลลัพธ์
          Text(
            '${_comparisonResult!.emoji} ผลการเปรียบเทียบ ${_comparisonResult!.emoji}',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          
          // แสดงราคาต่อ 100 มล. ของแต่ละสินค้า
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: const Color(0xFF1B263B).withOpacity(0.7),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                Text(
                  '💵 ราคาต่อ 100 มล./กรัม',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        const Text('Product 1', style: TextStyle(color: Colors.white70)),
                        Text(
                          '฿${_comparisonResult!.product1PricePer100ML.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4ECDC4),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        const Text('Product 2', style: TextStyle(color: Colors.white70)),
                        Text(
                          '฿${_comparisonResult!.product2PricePer100ML.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFFD93D),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 20),
          
          // ผลลัพธ์หลัก
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFFFF6B6B).withOpacity(0.8),
                  const Color(0xFFE91E63).withOpacity(0.8),
                ],
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                Text(
                  '🏆 สินค้าที่คุ้มค่าที่สุด',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  _comparisonResult!.betterChoice,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                if (_comparisonResult!.savings > 0) ...[
                  const SizedBox(height: 10),
                  Text(
                    '💰 ประหยัดได้ ฿${_comparisonResult!.savings.toStringAsFixed(2)} ต่อ 100 มล./กรัม',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}