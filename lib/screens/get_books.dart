import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:postman_app/model/dataArgument.dart';
import 'package:postman_app/features/books/data/book.dart';
import 'package:postman_app/provider/loginprovider.dart';
import 'package:postman_app/screens/addbook.dart';
import 'package:postman_app/screens/locationtrackerscreen.dart';
import 'package:postman_app/screens/login_screen.dart';
import 'package:postman_app/screens/ordertrackingpage.dart';
import 'package:postman_app/screens/tap_pay_widget.dart';
import 'package:postman_app/services/apiservice/apiservice.dart';
import 'package:http/http.dart' as http;
import 'package:postman_app/util/toast.dart';
import 'package:provider/provider.dart';

late Future<List<Book>> _books;

class GetBooks extends StatefulWidget {

  const GetBooks({
    Key? key,
  }) : super(key: key);

  @override
  State<GetBooks> createState() => _GetBooksState();
}

class _GetBooksState extends State<GetBooks> {

  @override
  void initState() {
    _books = ApiService.fetchBook();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final AuthProvider authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(

      appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('Books'),
          actions:  [
            GestureDetector(
              onTap:() async {
                await authProvider.logout();
                Navigator.push(
                  context, MaterialPageRoute(builder: (context) =>  LoginScreen()),
                );
                },
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.logout),
              )
          ),
            GestureDetector(
              onTap: (){
                Navigator.push(
                  context, MaterialPageRoute(builder: (context) =>  const OrderTrackingPage()),
                );
              },
              child: const Padding(
                padding:  EdgeInsets.all(8.0),
                child: Icon(Icons.location_searching),
              ),
            ),
            GestureDetector(
              onTap: (){
                Navigator.push(
                  context, MaterialPageRoute(builder: (context) =>  const PayTapWidget()),
                );
              },
              child: const Padding(
                padding:  EdgeInsets.all(8.0),
                child: Icon(Icons.payments),
              ),
            )
        ],
      ),

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
              context, MaterialPageRoute(builder: (context) => const AddBookWidget()),
           );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
