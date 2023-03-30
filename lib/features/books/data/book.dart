class Book {
  final String id;
  final String title;
  final String author;
  final String genre;
  final int yearPublished;
  final bool checkedOut;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.genre,
    required this.yearPublished,
    required this.checkedOut,
    });

  factory Book.fromJson(Map<String, dynamic> json){
    return Book(
        id: json['id'] as String,
        title: json['title'] as String,
        author: json['author'] as String,
        genre: json['genre'] as String,
        yearPublished: json['yearPublished'] as int,
        checkedOut: json['checkedOut'] as bool,
    );
  }

  Map<String, dynamic> toJson(){
    return {
      'id': id,
      'title': title,
      'author': author,
      'genre': genre,
      'yearPublished': yearPublished,
      'checkedOut': checkedOut,
    };
  }
}