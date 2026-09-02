import 'package:ketabto_test/core/models/book_model.dart';

// ─── Abstract contract ────────────────────────────────────────────────────────

abstract class BookRemoteDataSource {
  Future<List<BookModel>> getBooks();
}

// ─── Mock implementation ──────────────────────────────────────────────────────
// Replace this class with a real HTTP/Firestore implementation once the API
// is ready. No other file needs to change — just swap the registration in DI.

class BookRemoteDataSourceMock implements BookRemoteDataSource {
  @override
  Future<List<BookModel>> getBooks() async {
    // Simulates a network delay
    await Future.delayed(const Duration(milliseconds: 800));

    // TODO: replace with real API call e.g.
    // final response = await dio.get('/books');
    // return (response.data as List).map((e) => BookModel.fromJson(e)).toList();

    final rawList = _mockJson();
    return rawList.map((json) => BookModel.fromJson(json)).toList();
  }

  List<Map<String, dynamic>> _mockJson() => [
    {
      'id': '1',
      'name': 'The Alchemist',
      'writerName': 'Paulo Coelho',
      'category': 'novel',
      'price': 12.99,
      'pages': 209,
      'description':
          'A novel about a young Andalusian shepherd who travels to Egypt after having a recurring dream of finding a treasure there.',
      'imageUrl': 'https://i.ibb.co/MyWNS4Zw/617lxve-Uj-YL-SL1500.jpg',
      'ownerId': 'user_001',
      'ownerName': 'Ali Rezaei',
    },
    {
      'id': '2',
      'name': 'Atomic Habits',
      'writerName': 'James Clear',
      'category': 'psychology',
      'price': 15.49,
      'pages': 320,
      'description':
          'A guide to building good habits and breaking bad ones through tiny changes that yield remarkable results.',
      'imageUrl': 'https://i.ibb.co/Y7ZRqk0J/8106l-PWf-Xp-L-AC-UF1000-1000-QL80.jpg',
      'ownerId': 'user_002',
      'ownerName': 'Sara Mohammadi',
    },
    {
      'id': '3',
      'name': 'Clean Code',
      'writerName': 'Robert C. Martin',
      'category': 'technology',
      'price': 29.99,
      'pages': 464,
      'description':
          'A handbook of agile software craftsmanship that teaches you how to write clean, readable, and maintainable code.',
      'imageUrl': 'https://i.ibb.co/35L8pbY1/71nj3-JM-ig-L.jpg',
      'ownerId': 'user_003',
      'ownerName': 'Reza Karimi',
    },
    {
      'id': '4',
      'name': 'One Hundred Years of Solitude',
      'writerName': 'Gabriel García Márquez',
      'category': 'literature',
      'price': 17.00,
      'pages': 417,
      'description':
          'One Hundred Years of Solitude tells the story of the Buendía family across seven generations in the fictional town of Macondo. Blending the ordinary with the extraordinary, the novel explores themes of solitude, memory, time, fate, love, violence, and the cyclical nature of history. Through the rise and fall of Macondo, Gabriel García Márquez creates a multigenerational story that reflects both the personal and political history of Latin America.',
      'imageUrl': 'https://i.ibb.co/rRS7rLS2/81o-AEEwx-BWL.jpg',
      'ownerId': 'user_001',
      'ownerName': 'Ali Rezaei',
    },
    {
      'id': '5',
      'name': 'The Midnight Library',
      'writerName': 'Matt Haig',
      'category': 'psychology',
      'price': 18.99,
      'pages': 304,
      'description':
          'Between life and death there is a library, and within that library, the shelves go on forever. Each book offers a chance to try another life, to see how things might have turned out differently. The Midnight Library follows Nora Seed as she explores the lives she could have lived and discovers what truly makes a life worth living.',
      'imageUrl': 'https://i.ibb.co/99MxFFp1/71ls-I6-A5-KL.jpg',
      'ownerId': 'user_004',
      'ownerName': 'Mina Hosseini',
    },
    {
      'id': '6',
      'name': 'Cosmos',
      'writerName': 'Carl Sagan',
      'category': 'science',
      'price': 18.99,
      'pages': 384,
      'description':
          'Cosmos explores the universe, its origins, evolution, and the place of humanity within it. Carl Sagan combines astronomy, physics, history, and philosophy to explain the wonders of the cosmos and our ongoing quest to understand the universe.',
      'imageUrl': 'https://i.ibb.co/g0gF5wN/12044809.jpg',
      'ownerId': 'user_004',
      'ownerName': 'Mina Hosseini',
    },
    {
      'id': '7',
      'name': 'SPQR',
      'writerName': 'Mary Beard',
      'category': 'history',
      'price': 18.99,
      'pages': 608,
      'description':
          'SPQR offers a sweeping history of ancient Rome, from its legendary foundation through the transformation of the Roman world under the emperors. Mary Beard explores Roman politics, society, culture, warfare, religion, and everyday life while challenging many traditional ideas about Rome and its legacy.',
      'imageUrl': 'https://i.ibb.co/nN7Q8wwP/Ip3z3-Jl-Uvad-Po-Ijy-Pc-R1ai-EHQ0-Zwz0-q-MQb-HI931fq56-Ol-IAAYfjgo3hrh1tnikbf-KZui-e-W65nw4-ORXAQp-FMVyi.jpg',
      'ownerId': 'user_004',
      'ownerName': 'Mina Hosseini',
    },
  ];
}
