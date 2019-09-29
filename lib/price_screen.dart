import 'dart:io' show Platform;

import 'package:bitcoin_ticker/coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = currenciesList[0];
  Map<String, String> lastPriceMap =
      Map.fromIterable(cryptoList, key: (v) => v, value: (v) => '?');

  void fetchAllCoinData() {
    for (String coin in cryptoList) {
      fetchCoinData(coin);
    }
  }

  void fetchCoinData(String coin) async {
    try {
      double latestPrice =
          await CoinData().getLastCoinPrice(coin, selectedCurrency);
      setState(() {
        lastPriceMap[coin] = latestPrice.toString();
      });
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    fetchAllCoinData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: Card(
              color: Colors.lightBlueAccent,
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                children: cryptoList
                    .map((coin) => Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 15.0, horizontal: 28.0),
                          child: Text(
                            '1 $coin = ${lastPriceMap[coin]} $selectedCurrency',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.white,
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS
                ? getCurrencyPicker()
                : getCurrencyDropdownButton(),
          ),
        ],
      ),
    );
  }

  DropdownButton<String> getCurrencyDropdownButton() {
    return DropdownButton<String>(
      value: selectedCurrency,
      items: currenciesList
          .map((currency) => DropdownMenuItem(
                child: Text(currency),
                value: currency,
              ))
          .toList(),
      onChanged: (value) {
        setState(() {
          selectedCurrency = value;
        });
        fetchAllCoinData();
      },
    );
  }

  CupertinoPicker getCurrencyPicker() {
    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      children: currenciesList.map((item) => Text(item)).toList(),
      onSelectedItemChanged: (pos) {
        setState(() {
          selectedCurrency = currenciesList[pos];
        });
        fetchAllCoinData();
      },
    );
  }
}
