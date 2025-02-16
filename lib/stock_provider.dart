import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class StockProvider extends ChangeNotifier {
  bool isLoading = false;
  String errorMessage = '';
  Map<String, dynamic>? selectedStock;
  List<Map<String, dynamic>> watchlist = [];
  List<Map<String, dynamic>> historicalData = [];

  
  Future<void> fetchStockData(String symbol) async {
    isLoading = true;
    errorMessage = '';
    notifyListeners();

    final url = 'https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=$symbol&apikey=LPDZGT82KITWOFBE';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final stockData = data['Global Quote'];

        if (stockData != null) {
         
          selectedStock = {
            'symbol': stockData['01. symbol'],
'price': stockData['05. price'],
'change': stockData['09. change'],
'percentChange': stockData['10. change percent'],
'companyName': stockData['companyName'] ?? 'Unknown', 
'marketCap': stockData['marketCap'] ?? 'N/A', 
'peRatio': stockData['peRatio'] ?? 'N/A', 
 
          };
        } else {
          errorMessage = 'Stock not found.';
        }
      } else {
        errorMessage = 'Failed to fetch stock data.';
      }
    } catch (e) {
      errorMessage = 'Error: $e';
    }

    isLoading = false;
    notifyListeners();
  }

  
  Future<void> fetchHistoricalData(String symbol) async {
    final url = 'https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=$symbol&apikey=LPDZGT82KITWOFBE';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final timeSeries = data['Time Series (Daily)'];

        if (timeSeries != null) {
          historicalData = timeSeries.entries.map((entry) {
            return {
              'date': DateTime.parse(entry.key),
              'close': double.tryParse(entry.value['4. close']) ?? 0.0,
            };
          }).toList();

          
          print('Historical Data: $historicalData');
        } else {
          print('No data found for $symbol');
        }
      } else {
        print('Failed to fetch historical data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching historical data: $e');
    }
    notifyListeners();
  }

  
  void addToWatchlist(Map<String, dynamic> stock) {
    if (!watchlist.any((item) => item['symbol'] == stock['symbol'])) {
      watchlist.add(stock);
      notifyListeners();
    }
  }

  
  void removeFromWatchlist(String symbol) {
    watchlist.removeWhere((stock) => stock['symbol'] == symbol);
    notifyListeners();
  }
}



