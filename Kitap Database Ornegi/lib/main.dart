import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Book Store',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ayşenur Kürklü Book Store'),
      ),
      body: Center(
        child: Container(
          margin: EdgeInsets.all(16),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: Color.fromARGB(255, 22, 22, 22)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: BookList(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddBookPage()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class BookList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('books').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        var books = snapshot.data?.docs;

        return ListView.builder(
          itemCount: books?.length,
          itemBuilder: (context, index) {
            var book = books![index];
            return BookListItem(book: book);
          },
        );
      },
    );
  }
}

class BookListItem extends StatelessWidget {
  final DocumentSnapshot book;

  BookListItem({required this.book});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.red),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        title: Text(
          book['title'],
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          'Yazar: ${book['author']}, Sayfa Sayısı: ${book['pageCount']}, Tür: ${book['genre']}',
          style: TextStyle(fontSize: 16),
        ),
        onTap: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text(book['title']),
                content: Text(
                    'Yazar: ${book['author']}\nSayfa Sayısı: ${book['pageCount']}\nTür: ${book['genre']}'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Kapat'),
                  ),
                ],
              );
            },
          );
        },
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UpdateBookPage(book: book),
                  ),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                showDeleteConfirmationDialog(context, book);
              },
            ),
          ],
        ),
      ),
    );
  }

  void showDeleteConfirmationDialog(
      BuildContext context, DocumentSnapshot book) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Kitap Silme'),
          content: Text('Kitabı silmek istediğinizden emin misiniz?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Vazgeç'),
            ),
            TextButton(
              onPressed: () async {
                await FirebaseFirestore.instance
                    .collection('books')
                    .doc(book.id)
                    .delete();
                Navigator.pop(context);
              },
              child: Text('Sil'),
            ),
          ],
        );
      },
    );
  }
}

void showDeleteConfirmationDialog(BuildContext context, DocumentSnapshot book) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Kitap Silme'),
        content: Text('Kitabı silmek istediğinizden emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Vazgeç'),
          ),
          TextButton(
            onPressed: () async {
              await FirebaseFirestore.instance
                  .collection('books')
                  .doc(book.id)
                  .delete();
              Navigator.pop(context);
            },
            child: Text('Sil'),
          ),
        ],
      );
    },
  );
}

class AddBookPage extends StatelessWidget {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController authorController = TextEditingController();
  final TextEditingController pageCountController = TextEditingController();
  String selectedGenre = 'Roman'; // Default genre

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kitap Ekle'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Kitap Adı'),
            TextField(controller: titleController),
            Text('Yazar'),
            TextField(controller: authorController),
            Text('Sayfa Sayısı'),
            TextField(
              controller: pageCountController,
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            Text('Tür'),
            DropdownButton<String>(
              value: selectedGenre,
              onChanged: (String? newValue) {
                selectedGenre = newValue!;
              },
              items: <String>['Roman', 'Hikaye', 'Şiir', 'Deneme']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                String title = titleController.text;
                String author = authorController.text;
                int pageCount = int.tryParse(pageCountController.text) ?? 0;
                if (title.isNotEmpty && author.isNotEmpty && pageCount > 0) {
                  await FirebaseFirestore.instance.collection('books').add({
                    'title': title,
                    'author': author,
                    'pageCount': pageCount,
                    'genre': selectedGenre,
                  });

                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Kitap Eklendi'),
                        content: Text('Kitap başarıyla eklendi!'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                            child: Text('Tamam'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: Text('Kitap Ekle'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Geri Dön'),
            ),
          ],
        ),
      ),
    );
  }
}

class UpdateBookPage extends StatefulWidget {
  final DocumentSnapshot book;

  UpdateBookPage({required this.book});

  @override
  _UpdateBookPageState createState() => _UpdateBookPageState();
}

class _UpdateBookPageState extends State<UpdateBookPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController authorController = TextEditingController();
  final TextEditingController pageCountController = TextEditingController();
  String selectedGenre = 'Roman'; // Default genre

  @override
  void initState() {
    super.initState();
    titleController.text = widget.book['title'];
    authorController.text = widget.book['author'];
    pageCountController.text = widget.book['pageCount'].toString();
    selectedGenre = widget.book['genre'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kitap Güncelle'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Kitap Adı'),
            TextField(controller: titleController),
            Text('Yazar'),
            TextField(controller: authorController),
            Text('Sayfa Sayısı'),
            TextField(
              controller: pageCountController,
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            Text('Tür'),
            DropdownButton<String>(
              value: selectedGenre,
              onChanged: (String? newValue) {
                setState(() {
                  selectedGenre = newValue!;
                });
              },
              items: <String>['Roman', 'Hikaye', 'Şiir', 'Deneme']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                String title = titleController.text;
                String author = authorController.text;
                int pageCount = int.tryParse(pageCountController.text) ?? 0;
                if (title.isNotEmpty && author.isNotEmpty && pageCount > 0) {
                  await FirebaseFirestore.instance
                      .collection('books')
                      .doc(widget.book.id)
                      .update({
                    'title': title,
                    'author': author,
                    'pageCount': pageCount,
                    'genre': selectedGenre,
                  });

                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Kitap Güncellendi'),
                        content: Text('Kitap başarıyla güncellendi!'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                            child: Text('Tamam'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: Text('Kitap Güncelle'),
            ),
          ],
        ),
      ),
    );
  }
}
