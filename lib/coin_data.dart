import 'dart:convert';

import 'package:http/http.dart' as http;

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

const String bitCoinAverageUrl =
    'https://apiv2.bitcoinaverage.com/indices/global/ticker';

class CoinData {
  Future<dynamic> getLastCoinPrice(String coin, String currency) async {
    http.Response response =
        await http.get('$bitCoinAverageUrl/$coin$currency');

    if (response.statusCode == 200) {
      print(response.body);
      return jsonDecode(response.body)['last'];
    } else {
      throw '${response.statusCode}-Something went wrong with the request.';
    }
  }
}
