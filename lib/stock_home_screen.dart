import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'stock_provider.dart';

class StockHomeScreen extends StatelessWidget {
  final TextEditingController _searchController = TextEditingController();

  StockHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ) {
    final provider = Provider.of<StockProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Stock Quote App',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.blue, Colors.lightBlueAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Enter stock symbol',
                  hintStyle: const TextStyle(color: Colors.white70),
                  prefixIcon: const Icon(Icons.search, color: Colors.white),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                ),
                style: const TextStyle(color: Colors.white),
                onSubmitted: (value) {
                  if (value.isNotEmpty) {
                    provider.fetchStockData(value.toUpperCase(),context);
                    //provider.fetchHistoricalData(value.toUpperCase());
                  }
                },
              ),
            ),
            const SizedBox(height: 16),
            
            if (provider.isLoading)
              const CircularProgressIndicator()
            else if (provider.errorMessage.isNotEmpty)
              Text(
                provider.errorMessage,
                style: const TextStyle(color: Colors.red),
              )
            
               
            else if (provider.selectedStock != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.shade800, width: 1.5),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(2, 4),
                        ),
                      ],
                    ),
                    
                    child: ListTile(
                      title: Text(
                        provider.selectedStock?['symbol'] ?? 'No Data',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (provider.selectedStock!.containsKey('companyName'))
                            Text(
                              'Company: ${provider.selectedStock!['companyName']}',
                              style: const TextStyle(color: Colors.grey),
                            ),
                          Text('Price: \$${provider.selectedStock!['price']}'),
                          Text(
                            'Change: ${provider.selectedStock!['change']} (${provider.selectedStock!['percentChange']})',
                            style: TextStyle(
                              color: provider.selectedStock!['change'].startsWith('-')
                                  ? Colors.red
                                  : Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (provider.selectedStock!.containsKey('marketCap'))
                            Text('Market Cap: ${provider.selectedStock!['marketCap']}'),
                          if (provider.selectedStock!.containsKey('peRatio'))
                            Text('P/E Ratio: ${provider.selectedStock!['peRatio']}'),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.add, color: Colors.blueAccent),
                        onPressed: () {
                          provider.addToWatchlist(provider.selectedStock!);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 16),
            const Text(
              'Watchlist',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: provider.watchlist.length,
                itemBuilder: (context, index) {
                  final stock = provider.watchlist[index];
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.shade800, width: 1.5),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(2, 4),
                        ),
                      ],
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(
                        stock['symbol'],
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (stock.containsKey('companyName'))
                            Text(
                              'Company: ${stock['companyName']}',
                              style: const TextStyle(color: Colors.grey),
                            ),
                          Text('Price: \$${stock['price']}'),
                          Text(
                            'Change: ${stock['change']} (${stock['percentChange']})',
                            style: TextStyle(
                              color: stock['change'].startsWith('-') ? Colors.red : Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (stock.containsKey('marketCap'))
                            Text('Market Cap: ${stock['marketCap']}'),
                          if (stock.containsKey('peRatio'))
                            Text('P/E Ratio: ${stock['peRatio']}'),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () {
                          provider.removeFromWatchlist(stock['symbol']);
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
