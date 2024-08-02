import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DeciderListScreen extends StatelessWidget {
  const DeciderListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/decider_history_screen');
            },
            icon: const Icon(Icons.history),
            iconSize: 30.w,
            padding: EdgeInsets.only(right: 15.w),
          ),
        ],
        title:
            SvgPicture.asset("assets/svg/d.svg", width: 120.w, height: 120.h),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: Center(
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 2,
              crossAxisSpacing: 10.w,
              mainAxisExtent: 200.h,
            ),
            itemCount: _deciderList.length,
            itemBuilder: (context, index) {
              return Card(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _deciderList[index]['name'],
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 100.h,
                      width: 100.w,
                      child: Image.asset(
                        _deciderList[index]['image'],
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: 120.w,
                      height: 25.h,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 7, 63, 109),
                        ),
                        onPressed: _deciderList[index]['isActivated'] == !false
                            ? () {
                                Navigator.pushNamed(
                                    context, '/option_list_screen',
                                    arguments: _deciderList[index]);
                              }
                            : null,
                        child: Text(
                          'Karar Ver',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

final List<Map<String, dynamic>> _deciderList = [
  {
    'isActivated': true,
    'name': 'Çark',
    'image': 'assets/png/cark.png',
    'maxItem': 8,
    'onPressed': 'fortune',
  },
  {
    'isActivated': true,
    'name': 'Kart',
    'image': 'assets/png/card_flip.jpg',
    'maxItem': 9,
    'onPressed': 'card',
  },
  {
    'isActivated': false,
    'name': 'Zar',
    'image': 'assets/png/dice.png',
    'maxItem': 6,
    'onPressed': 'dice',
  },
];
