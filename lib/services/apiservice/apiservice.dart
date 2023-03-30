import 'dart:convert';
import 'package:postman_app/features/books/data/book.dart';
import 'package:http/http.dart' as http;

class ApiService{

  static const baseURL = 'https://library-api.postmanlabs.com/';

  static var headers = {
    'api-key': 'postmanrulz'
  };

  static Future<List<Book>> fetchBook() async {

    final response = await http.get(
        Uri.parse(
            '${baseURL}books'
        ));

    response.headers.addAll(headers);

    if (response.statusCode == 200) {

      final jsonData = jsonDecode(response.body);
      List<Book> books = [];
      for (var bookJson in jsonData) {
        books.add(Book.fromJson(bookJson));
      }

      return List<Book>.from(jsonData.map((data) => Book.fromJson(data)));

    } else {

      throw Exception('Failed to load data');
    }}

  static Future<void> deleteBookById(String id) async {

    Map<String, String> header = {
      'api-key': 'postmanrulz',
      'Authorization' :'postmanrulz',
      "Content-Type": "application/json"// add the authorization header
    };
    final response = await http.delete(
      Uri.parse('${baseURL}/books:$id'),
      headers: header,
    );

    if (response.statusCode == 204) {
      print("deleted succesfully");
      // Item deleted successfully
      // Remove the item from your data source
      /*setState(() {
        book.removeWhere((item) => item.id == id);
      });*/
    } else {
      // Handle error
      throw Exception('Failed to delete item.');
    }
  }

}