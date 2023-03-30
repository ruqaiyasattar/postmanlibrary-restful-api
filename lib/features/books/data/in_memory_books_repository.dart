import 'package:postman_app/features/books/data/book.dart';
import 'package:postman_app/features/books/data/books_repository.dart';

class InMemoryBooksRepository implements BooksRepository {
  final List<Book> _books = [
    Book(
      id: 'NODES6H1GJoC',
      title: 'Marina',
      author: 'Carlos Ruiz Zafon',
      genre: 'Fiction',
      yearPublished: 1940,
      checkedOut: false,
    )
  ];

  @override
  Future<void> addBookToCheckedOut(Book book) {
    // TODO: implement addBookToCheckedOut
    throw UnimplementedError();
  }

  @override
  Future<Book> getBook(String id) async {
    // TODO: implement getBook
    return _books.firstWhere((book) => book.id == id);
  }

  @override
  Future<List<Book>> getBooks({String query = ''}) async{
    // TODO: implement getBooks
    return _books;
  }

  @override
  Future<List<Book>> getCheckedOutBooks() {
    // TODO: implement getCheckedOutBooks
    throw UnimplementedError();
  }

  @override
  Future<void> removeBookFromCheckedOut(String bookId) {
    // TODO: implement removeBookFromCheckedOut
    throw UnimplementedError();
  }

  @override
  Future<void> addBook(Book book) {
    // TODO: implement addBook
    throw UnimplementedError();
  }

}