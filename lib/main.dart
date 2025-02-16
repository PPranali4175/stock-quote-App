import 'package:flutter/material.dart';
import 'stock_provider.dart';
import 'stock_home_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const StockQuoteApp());
}

class StockQuoteApp extends StatelessWidget {
  const StockQuoteApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => StockProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Stock Quote App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: StockHomeScreen(),
      ),
    );
  }
}
