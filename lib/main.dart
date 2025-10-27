import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF121212),
        primaryColor: Colors.red,
      ),
      home: const MovieHomePage(),
    );
  }
}

class MovieHomePage extends StatefulWidget {
  const MovieHomePage({super.key});

  @override
  State<MovieHomePage> createState() => _MovieHomePageState();
}

class _MovieHomePageState extends State<MovieHomePage> {
  final PageController _pageController = PageController(
    viewportFraction: 0.75, // Lebih kecil untuk efek center yang lebih baik
    initialPage: 0,
  );

  int _currentCarouselIndex = 0;

  int _selectedIndex = 0;

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_pageController.hasClients) {
        int nextPage = _currentCarouselIndex + 1;
        if (nextPage >= nowPlayingMovies.length) {
          nextPage = 0;
        }
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  ///dummy
  final List<Map<String, String>> nowPlayingMovies = [
    {
      'title': 'Deadpool & Wolverine',
      'image': 'https://picsum.photos/400/600?random=1',
      'description': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
    },
    {
      'title': 'The Avengers',
      'image': 'https://picsum.photos/400/600?random=2',
      'description': 'Earth\'s mightiest heroes must come together.',
    },
    {
      'title': 'Spider-Man',
      'image': 'https://picsum.photos/400/600?random=3',
      'description': 'With great power comes great responsibility.',
    },
  ];

  final List<Map<String, String>> trendingMovies = [
    {'title': 'RED', 'image': 'https://picsum.photos/150/225?random=4'},
    {'title': 'Superman', 'image': 'https://picsum.photos/150/225?random=5'},
    {'title': 'Joker', 'image': 'https://picsum.photos/150/225?random=6'},
    {'title': 'Batman', 'image': 'https://picsum.photos/150/225?random=7'},
  ];

  final List<Map<String, String>> popularMovies = [
    {'title': 'Drama', 'image': 'https://picsum.photos/150/225?random=8'},
    {'title': 'Fallout', 'image': 'https://picsum.photos/150/225?random=9'},
    {'title': 'Ocean', 'image': 'https://picsum.photos/150/225?random=10'},
    {'title': 'Action', 'image': 'https://picsum.photos/150/225?random=11'},
  ];

  final List<Map<String, String>> topRatedMovies = [
    {'title': 'Classic', 'image': 'https://picsum.photos/150/225?random=12'},
    {'title': 'Thriller', 'image': 'https://picsum.photos/150/225?random=13'},
    {
      'title': 'Perfect Game',
      'image': 'https://picsum.photos/150/225?random=14',
    },
    {'title': 'Mystery', 'image': 'https://picsum.photos/150/225?random=15'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),

              _buildNowPlayingSection(),

              const SizedBox(height: 24),

              _buildMovieSection(title: 'Trending', movies: trendingMovies),

              const SizedBox(height: 24),

              _buildMovieSection(title: 'Popular', movies: popularMovies),

              const SizedBox(height: 24),

              _buildMovieSection(title: 'Top Rated', movies: topRatedMovies),

              const SizedBox(height: 80), // Extra space untuk bottom nav
            ],
          ),
        ),
      ),
      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF1E1E1E),
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.category), label: 'Genres'),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorite',
          ),
        ],
      ),
    );
  }

  Widget _buildNowPlayingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Center(
            child: Text(
              'Now Playing',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),

        SizedBox(
          height: 500,
          child: PageView.builder(
            controller: _pageController,
            itemCount: nowPlayingMovies.length,
            onPageChanged: (index) {
              setState(() {
                _currentCarouselIndex = index;
              });
            },
            itemBuilder: (context, index) {
              final movie = nowPlayingMovies[index];
              return _buildNowPlayingCard(movie);
            },
          ),
        ),

        const SizedBox(height: 12),
        Center(
          child: SmoothPageIndicator(
            controller: _pageController,
            count: nowPlayingMovies.length,
            effect: ExpandingDotsEffect(
              activeDotColor: Colors.red,
              dotColor: Colors.grey,
              dotHeight: 8,
              dotWidth: 8,
              expansionFactor: 3,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNowPlayingCard(Map<String, String> movie) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.6),
            blurRadius: 15,
            offset: const Offset(0, 8),
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            Image.network(
              movie['image']!,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  color: Colors.grey[900],
                  child: Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                          : null,
                      color: Colors.red,
                    ),
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[800],
                  child: const Center(
                    child: Icon(Icons.movie, size: 80, color: Colors.grey),
                  ),
                );
              },
            ),

            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Colors.black.withOpacity(0.9), Colors.transparent],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie['title']!,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      movie['description']!,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMovieSection({
    required String title,
    required List<Map<String, String>> movies,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  'More',
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        SizedBox(
          height: 225,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: movies.length,
            itemBuilder: (context, index) {
              return _buildMovieCard(movies[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMovieCard(Map<String, String> movie) {
    return Container(
      width: 150,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  movie['image']!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      color: Colors.grey[900],
                      child: Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                              : null,
                          color: Colors.red,
                          strokeWidth: 2,
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[800],
                      child: const Center(
                        child: Icon(Icons.movie, size: 50, color: Colors.grey),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
