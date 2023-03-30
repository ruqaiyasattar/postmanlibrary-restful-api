
import 'package:postman_app/features/books/data/book.dart';

abstract class BooksRepository {
  Future<Book> getBook(String id);
  Future<List<Book>> getBooks({String query = ''});
  Future<void> addBook(Book book);
  Future<void> removeBookFromCheckedOut(String bookId);
  Future<List<Book>> getCheckedOutBooks();
}