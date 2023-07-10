import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:postman_app/model/dataArgument.dart';
import 'package:postman_app/features/books/data/book.dart';
import 'package:postman_app/screens/get_books.dart';
import 'package:postman_app/services/apiservice/apiservice.dart';
import 'package:postman_app/util/toast.dart';

const baseURL = 'https://library-api.postmanlabs.com/';

Map<String, String> headers = {
  'api-key': 'postmanrulz',
  'Authorization' :'postmanrulz',
  "Content-Type": "application/json"// add the authorization header
};

class AddBookWidget extends HookWidget {
  const AddBookWidget({ Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

  final data_Arguments? item = ModalRoute.of(context)!.settings.arguments as data_Arguments?;

  final myObjectValue = useMemoized(() => item?.bookName ?? 'default');

  var nameTextController = useTextEditingController();
  var yearTextController = useTextEditingController();
  var authorTextController = useTextEditingController();
  var genreTextController = useTextEditingController();

  String name = nameTextController.text;
  String author = authorTextController.text;
  String genre = genreTextController.text;
  String year = yearTextController.text;

  var updatedTitle = useTextEditingController(
      text: myObjectValue == 'default' ? name :  item?.bookName);

  var updatedAuthor = useTextEditingController(
      text: myObjectValue == 'default' ? author : item?.bookAuthor );

  var updatedGenre = useTextEditingController(
      text: myObjectValue == 'default' ? genre : item?.bookGenre);

  var updatedYear = useTextEditingController(
      text: myObjectValue == 'default' ?  year: item?.bookYear
  );

  String nameU = updatedTitle.text;
  String authorU = updatedAuthor.text;
  String genreU = updatedGenre.text;
  String yearU = updatedYear.text;

  Future<void> postData() async {
    final url = Uri.parse('${baseURL}books');
     final book = Book(
       id: '',
       title: myObjectValue == 'default' ? name : nameU,
       author:  myObjectValue == 'default' ? author : authorU,
       genre:  myObjectValue == 'default' ? genre : genreU,
       yearPublished:  myObjectValue == 'default' ? int.parse(year) : int.parse(yearU),
       checkedOut: false,
     );

     var encodedbook = json.encode({
       'id': book.id,
        'title': book.title,
        'author': book.author,
        'genre': book.genre,
        'yearPublished': book.yearPublished,
        'checkedOut':book.checkedOut,
      });
      final response = await http.post(
        url,
        headers: headers,
        body: encodedbook,
      );

      ApiService.fetchBook().then(
            (value) => encodedbook,);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              const GetBooks(),
        ),
      );
      if (response.statusCode == 201) {
        toast("Updated");
      } else {
        toast("not Updated");
      }
    }

    return AlertDialog(
      title: const Text('Add New Book'),
      content: Wrap(
        children: [
          Column(
            children: [
              TextField(
                controller: myObjectValue == 'default' ?  nameTextController : updatedTitle,
                decoration: const InputDecoration(
                  hintText: 'Book title',
                ),
                autofocus: true,
                onChanged: (value) {
                  myObjectValue == 'default' ?  name = value: nameU = value;
                },
              ),
              TextField(
                controller:  myObjectValue == 'default' ? authorTextController : updatedAuthor,
                decoration: const InputDecoration(
                  hintText: 'Book Author',
                ),
                autofocus: true,
                onChanged: (value) {
                  myObjectValue == 'default' ?  author = value: authorU = value;
                },
              ),
              TextField(
                controller:  myObjectValue == 'default' ? genreTextController : updatedGenre,
                decoration: const InputDecoration(
                  hintText: 'Genre',
                ),
                autofocus: true,
                onChanged: (value) {
                  myObjectValue == 'default' ?  genre = value : genreU = value;
                },
              ),
              TextField(
                controller: myObjectValue == 'default' ?  yearTextController : updatedYear,
                decoration: const InputDecoration(
                  hintText: 'Publication date',
                ),
                autofocus: true,
                onChanged: (value) {
                  myObjectValue == 'default' ?  year = value: yearU = value;
                },
              ),
            ],
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: ()  {
            postData();
           },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
