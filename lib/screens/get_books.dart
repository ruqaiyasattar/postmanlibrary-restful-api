import 'package:flutter/material.dart';
import 'package:postman_app/model/dataArgument.dart';
import 'package:postman_app/features/books/data/book.dart';
import 'package:postman_app/screens/addbook.dart';
import 'package:postman_app/services/apiservice/apiservice.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

late Future<List<Book>> _books;

void toast(String msg){
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.grey,
      textColor: Colors.white,
      fontSize: 16.0
  );

}

class GetBooks extends StatefulWidget {
  const GetBooks({Key? key}) : super(key: key);

  @override
  State<GetBooks> createState() => _GetBooksState();
}

class _GetBooksState extends State<GetBooks> {

  @override
  void initState() {
    // TODO: implement initState
    _books = ApiService.fetchBook();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text('Postmanlab Books')),
      body: FutureBuilder<List<Book>>(

        future: _books,

        builder: (context, snapshot) {

          if (snapshot.hasData) {

            final data = snapshot.data!;

            return ListView.builder(

              itemCount: data.length,

              itemBuilder: (context, index) {

                final item = data[index];

                return GestureDetector(
                  onTap: (){
                    Navigator.push(
                        context, MaterialPageRoute(
                        builder: (context) => const AddBookWidget(),
                        settings: RouteSettings(
                        arguments: data_Arguments(
                          bookName: item.title,
                          bookAuthor: item.author,
                          bookGenre: item.genre,
                          bookYear: item.yearPublished.toString(),
                        ),
                    )),
                    );
                  },
                  child: Dismissible(
                    key: UniqueKey(),
                    onDismissed: (direction) async {
                      Map<String, String> header = {
                        'api-key': 'postmanrulz',
                      };

                      final response = await http.delete(
                        Uri.parse('${baseURL}books/${item.id}'),
                        headers: header,
                      );

                      if (response.statusCode == 204) {
                        toast("book ${item.title} deleted successfully");
                      } else {
                        // Handle error
                        throw Exception('Failed to delete item.');
                      }
                      setState(() {
                        data.removeAt(index);
                      });
                    },
                    background: Container(
                        color: Colors.red,
                        child: const Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: 16),
                            child: Icon(Icons.delete, color: Colors.white),
                          ),
                        )
                    ),
                    direction: DismissDirection.startToEnd,
                    child: Card(
                      elevation: 2,
                      color: const Color(0xfff1ecec),
                      child: ListTile(
                        leading: Text(item.genre),
                        trailing: Text( (item.checkedOut) ? 'sold out' : 'available'),
                        title: Text("${item.title} \n"),
                        subtitle: Text("${item.author} \nPublished on: ${item.yearPublished.toString()}"),
                      ),
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {

            return Text('${snapshot.error}');

          } else {
            _books;
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton:  FloatingActionButton(
        onPressed: ()  {
           Navigator.push(
              context, MaterialPageRoute(builder: (context) => const AddBookWidget()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
