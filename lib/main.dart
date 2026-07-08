import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await addMedicineToFirestore();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: FirebaseAuth.instance.currentUser == null ? '/splash' : '/home',
      theme: ThemeData(
        primaryColor: Colors.teal,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.teal[800],
          foregroundColor: Colors.white,
          elevation: 0,
          titleTextStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal[700],
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 14, horizontal: 24),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 8,
            textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        textTheme: TextTheme(
          bodyMedium: TextStyle(fontSize: 16, color: Colors.grey[800]),
          headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.teal[900]),
        ),
        cardTheme: CardTheme(
          elevation: 5,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
      ),
      routes: {
        '/splash': (context) => SplashScreen(),
        '/welcome': (context) => WelcomeScreen(),
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignupScreen(),
        '/home': (context) => HomeScreen(),
        '/cart': (context) => CartScreen(),
        '/payment': (context) => PaymentScreen(),
        '/profile': (context) => ProfileScreen(),
        '/history': (context) => HistoryScreen(),
        '/orders': (context) => OrderScreen(),
      },
    );
  }
}

// Splash Screen
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(seconds: 3))..repeat();
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
    _offsetAnimation = Tween<Offset>(begin: Offset(0, 0), end: Offset(0, 0.2)).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    Timer(Duration(seconds: 4), () => Navigator.pushReplacementNamed(context, '/welcome'));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.teal[900]!, Colors.teal[300]!],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.0, _controller.value],
                  ),
                ),
              );
            },
          ),
          Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _offsetAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/logo.png', width: 180),
                    SizedBox(height: 20),
                    Text("Your Health, Our Care", style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold)),
                    SizedBox(height: 20),
                    CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.white)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Welcome Screen
class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(seconds: 1))..forward();
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal[50]!, Colors.teal[200]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Welcome to Medicine App", style: Theme.of(context).textTheme.headlineSmall),
                SizedBox(height: 40),
                ElevatedButton.icon(
                  icon: Icon(Icons.login),
                  label: Text("Login"),
                  onPressed: () => Navigator.pushNamed(context, '/login'),
                ),
                SizedBox(height: 20),
                ElevatedButton.icon(
                  icon: Icon(Icons.person_add),
                  label: Text("Sign Up"),
                  onPressed: () => Navigator.pushNamed(context, '/signup'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Login Screen
class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  late AnimationController _controller;
  late Animation<double> _buttonAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _buttonAnimation = Tween<double>(begin: 0.9, end: 1).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
    _controller.forward();
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Login failed: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal[700]!, Colors.teal[200]!],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 60),
              FadeTransition(
                opacity: _fadeAnimation,
                child: Text("Login", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                  labelStyle: TextStyle(color: Colors.white70),
                  prefixIcon: Icon(Icons.email, color: Colors.white70),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.2),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                ),
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: "Password",
                  labelStyle: TextStyle(color: Colors.white70),
                  prefixIcon: Icon(Icons.lock, color: Colors.white70),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.2),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                ),
                obscureText: true,
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 40),
              Center(
                child: ScaleTransition(
                  scale: _buttonAnimation,
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.login),
                    label: Text("Login"),
                    onPressed: _login,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Signup Screen
class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(seconds: 1))..forward();
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _signup() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      String userName = _emailController.text.split('@')[0];
      await FirebaseAuth.instance.currentUser!.updateDisplayName(userName);
      await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).set({
        'name': userName,
        'purchases': [],
        'transactions': [],
        'address': '',
        'email': _emailController.text.trim(),
        'phone': '',
        'age': '',
        'gender': '',
        'emergencyContact': '',
        'medicalConditions': '',
      });
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Signup failed: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sign Up")),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Create Account", style: Theme.of(context).textTheme.headlineSmall),
              SizedBox(height: 20),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: "Password",
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
                obscureText: true,
              ),
              SizedBox(height: 30),
              Center(
                child: ElevatedButton.icon(
                  icon: Icon(Icons.person_add),
                  label: Text("Sign Up"),
                  onPressed: _signup,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Home Screen
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  List<Map<String, dynamic>> cart = [];
  String _searchQuery = '';
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(seconds: 1))..forward();
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _addToCart(Map<String, dynamic> medicine) {
    setState(() {
      cart.add(medicine);
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${medicine['name']} added to cart")));
  }

  void _logout() {
    FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, '/welcome');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Medicines"),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () => Navigator.pushNamed(context, '/cart', arguments: cart),
          ),
          IconButton(
            icon: Icon(Icons.history),
            onPressed: () => Navigator.pushNamed(context, '/history'),
          ),
          IconButton(
            icon: Icon(Icons.local_shipping),
            onPressed: () => Navigator.pushNamed(context, '/orders'),
          ),
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () => Navigator.pushNamed(context, '/profile'),
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Quick Help Coming Soon!"))),
        child: Icon(Icons.help),
        backgroundColor: Colors.teal[700],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 200,
                padding: EdgeInsets.symmetric(vertical: 10),
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance.collection('medicines').limit(5).snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        var med = snapshot.data!.docs[index].data() as Map<String, dynamic>;
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Card(
                            elevation: 5,
                            child: Container(
                              width: 150,
                              child: Column(
                                children: [
                                  Image.asset(med['imageUrl'] ?? 'assets/images/m2.png', height: 100, fit: BoxFit.cover),
                                  SizedBox(height: 8),
                                  Text(med['name'] ?? 'Unknown', style: TextStyle(fontWeight: FontWeight.bold)),
                                  Text('₹${med['price']}', style: TextStyle(color: Colors.teal)),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Search health issue (e.g., fever, pain)",
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.search, color: Colors.teal),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value.toLowerCase();
                        });
                      },
                    ),
                  ),
                ),
              ),
              StreamBuilder(
                stream: FirebaseFirestore.instance.collection('medicines').snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) return Center(child: CircularProgressIndicator(color: Colors.teal));
                  if (snapshot.hasError) return Center(child: Text("Error: ${snapshot.error}"));
                  if (snapshot.data!.docs.isEmpty) return Center(child: Text("No medicines available"));

                  var filteredMedicines = snapshot.data!.docs.where((doc) {
                    var med = doc.data() as Map<String, dynamic>;
                    String name = (med['name'] ?? '').toString().toLowerCase();
                    String usage = (med['usage'] ?? '').toString().toLowerCase();
                    String purpose = (med['purpose'] ?? '').toString().toLowerCase();
                    return name.contains(_searchQuery) || usage.contains(_searchQuery) || purpose.contains(_searchQuery);
                  }).toList();

                  if (filteredMedicines.isEmpty) {
                    return Center(child: Text("No medicines found for '$_searchQuery'"));
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.all(16),
                    itemCount: filteredMedicines.length,
                    itemBuilder: (context, index) {
                      var med = filteredMedicines[index].data() as Map<String, dynamic>;
                      return AnimatedMedicineCard(
                        medicine: med,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MedicineDetailsScreen(
                                medicine: med,
                                onAddToCart: _addToCart,
                              ),
                            ),
                          );
                        },
                        onAddToCart: _addToCart,
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Animated Medicine Card Widget
class AnimatedMedicineCard extends StatelessWidget {
  final Map<String, dynamic> medicine;
  final VoidCallback onTap;
  final Function(Map<String, dynamic>) onAddToCart;

  const AnimatedMedicineCard({required this.medicine, required this.onTap, required this.onAddToCart});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: EdgeInsets.only(bottom: 8),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    medicine['imageUrl'] ?? 'assets/images/m2.png',
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Icon(Icons.broken_image),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(medicine['name'] ?? 'Unknown', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      Text('Price: ₹${medicine['price']} | ${medicine['usage']}', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add_circle, color: Colors.teal, size: 30),
                  onPressed: () => onAddToCart(medicine),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Medicine Details Screen
class MedicineDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> medicine;
  final Function(Map<String, dynamic>) onAddToCart;

  const MedicineDetailsScreen({required this.medicine, required this.onAddToCart});

  @override
  _MedicineDetailsScreenState createState() => _MedicineDetailsScreenState();
}

class _MedicineDetailsScreenState extends State<MedicineDetailsScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  final _reviewController = TextEditingController();
  bool _showReviewForm = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(seconds: 1))..forward();
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    _reviewController.dispose();
    super.dispose();
  }

  Future<void> _submitReview() async {
    if (_reviewController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please enter a review")));
      return;
    }
    String userId = FirebaseAuth.instance.currentUser!.uid;
    String userName = FirebaseAuth.instance.currentUser!.displayName ?? 'Anonymous';
    String medicineName = widget.medicine['name'];

    await FirebaseFirestore.instance.collection('medicines').where('name', isEqualTo: medicineName).get().then((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        var docId = snapshot.docs.first.id;
        FirebaseFirestore.instance.collection('medicines').doc(docId).update({
          'reviews': FieldValue.arrayUnion([
            {
              'userId': userId,
              'userName': userName,
              'review': _reviewController.text,
              'timestamp': DateTime.now().toIso8601String(),
            }
          ]),
        });
      }
    });

    _reviewController.clear();
    setState(() => _showReviewForm = false);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Review submitted!")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.medicine['name'] ?? 'Medicine Details')),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      widget.medicine['imageUrl'] ?? 'assets/images/m2.png',
                      width: 220,
                      height: 220,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Icon(Icons.broken_image, size: 100),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(widget.medicine['name'] ?? 'Unknown', style: Theme.of(context).textTheme.headlineSmall),
                SizedBox(height: 10),
                Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Price: ₹${widget.medicine['price'] ?? 'N/A'}", style: TextStyle(fontSize: 18)),
                        SizedBox(height: 10),
                        Text("Dosage: ${widget.medicine['dosage'] ?? 'Not specified'}", style: TextStyle(fontSize: 18)),
                        SizedBox(height: 10),
                        Text("Purpose: ${widget.medicine['purpose'] ?? 'Not specified'}", style: TextStyle(fontSize: 18)),
                        SizedBox(height: 10),
                        Text("Usage: ${widget.medicine['usage'] ?? 'Not specified'}", style: TextStyle(fontSize: 18)),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      icon: Icon(Icons.add_shopping_cart),
                      label: Text("Add to Cart"),
                      onPressed: () {
                        widget.onAddToCart(widget.medicine);
                        Navigator.pop(context);
                      },
                    ),
                    ElevatedButton.icon(
                      icon: Icon(Icons.payment),
                      label: Text("Pay Now"),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UserInfoFormScreen(
                              cart: [widget.medicine],
                              onPayment: (cart) => Navigator.pushNamed(context, '/payment', arguments: {'cart': cart}),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                SizedBox(height: 20),
                ElevatedButton.icon(
                  icon: Icon(Icons.rate_review),
                  label: Text("Write a Review"),
                  onPressed: () => setState(() => _showReviewForm = !_showReviewForm),
                ),
                if (_showReviewForm) ...[
                  SizedBox(height: 20),
                  TextField(
                    controller: _reviewController,
                    decoration: InputDecoration(
                      labelText: "Your Review",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    maxLines: 3,
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _submitReview,
                    child: Text("Submit Review"),
                  ),
                ],
                SizedBox(height: 20),
                Text("Reviews", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                StreamBuilder(
                  stream: FirebaseFirestore.instance.collection('medicines').where('name', isEqualTo: widget.medicine['name']).snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
                    var reviews = snapshot.data!.docs.first['reviews'] ?? [];
                    if (reviews.isEmpty) return Text("No reviews yet.");
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: reviews.length,
                      itemBuilder: (context, index) {
                        var review = reviews[index];
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 5),
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(review['userName'], style: TextStyle(fontWeight: FontWeight.bold)),
                                SizedBox(height: 5),
                                Text(review['review']),
                                SizedBox(height: 5),
                                Text(review['timestamp'].substring(0, 10), style: TextStyle(color: Colors.grey)),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Cart Screen (Updated to Call Expanded UserInfoFormScreen)
class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(seconds: 1))..forward();
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> cart = ModalRoute.of(context)!.settings.arguments as List<Map<String, dynamic>>;

    return Scaffold(
      appBar: AppBar(title: Text("Cart")),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: cart.isEmpty
            ? Center(child: Text("Your cart is empty", style: Theme.of(context).textTheme.headlineSmall))
            : ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: cart.length,
          itemBuilder: (context, index) {
            var item = cart[index];
            return AnimatedMedicineCard(
              medicine: item,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MedicineDetailsScreen(
                      medicine: item,
                      onAddToCart: (medicine) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${medicine['name']} already in cart")));
                      },
                    ),
                  ),
                );
              },
              onAddToCart: (medicine) {},
            );
          },
        ),
      ),
      bottomNavigationBar: cart.isEmpty
          ? null
          : Padding(
        padding: EdgeInsets.all(16),
        child: ElevatedButton.icon(
          icon: Icon(Icons.payment),
          label: Text("Proceed to Payment"),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UserInfoFormScreen(
                  cart: cart,
                  onPayment: (cart) => Navigator.pushNamed(context, '/payment', arguments: {'cart': cart}),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// User Info Form Screen (Expanded with More Fields)
class UserInfoFormScreen extends StatefulWidget {
  final List<Map<String, dynamic>> cart;
  final Function(List<Map<String, dynamic>>) onPayment;

  const UserInfoFormScreen({required this.cart, required this.onPayment});

  @override
  _UserInfoFormScreenState createState() => _UserInfoFormScreenState();
}

class _UserInfoFormScreenState extends State<UserInfoFormScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _ageController = TextEditingController();
  final _genderController = TextEditingController();
  final _emailController = TextEditingController();
  final _emergencyContactController = TextEditingController();
  final _medicalConditionsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    User? user = FirebaseAuth.instance.currentUser;
    _nameController.text = user?.displayName ?? '';
    _emailController.text = user?.email ?? '';
    _loadUserData();
  }

  void _loadUserData() async {
    var doc = await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get();
    if (doc.exists && doc.data() != null) {
      setState(() {
        _phoneController.text = doc.data()!['phone'] ?? '';
        _addressController.text = doc.data()!['address'] ?? '';
        _ageController.text = doc.data()!['age'] ?? '';
        _genderController.text = doc.data()!['gender'] ?? '';
        _emergencyContactController.text = doc.data()!['emergencyContact'] ?? '';
        _medicalConditionsController.text = doc.data()!['medicalConditions'] ?? '';
      });
    }
  }

  void _submitForm() {
    if (_nameController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _addressController.text.isEmpty ||
        _emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please fill all required fields (Name, Phone, Address, Email)")));
      return;
    }
    Navigator.pushNamed(
      context,
      '/payment',
      arguments: {
        'cart': widget.cart,
        'name': _nameController.text,
        'phone': _phoneController.text,
        'address': _addressController.text,
        'age': _ageController.text,
        'gender': _genderController.text,
        'email': _emailController.text,
        'emergencyContact': _emergencyContactController.text,
        'medicalConditions': _medicalConditionsController.text,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Enter Your Details")),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Please provide your details for the order", style: TextStyle(fontSize: 18, color: Colors.teal[900])),
              SizedBox(height: 20),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: "Name *",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: "Phone *",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 16),
              TextField(
                controller: _addressController,
                decoration: InputDecoration(
                  labelText: "Address *",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
                maxLines: 3,
              ),
              SizedBox(height: 16),
              TextField(
                controller: _ageController,
                decoration: InputDecoration(
                  labelText: "Age",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16),
              TextField(
                controller: _genderController,
                decoration: InputDecoration(
                  labelText: "Gender",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: "Email *",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 16),
              TextField(
                controller: _emergencyContactController,
                decoration: InputDecoration(
                  labelText: "Emergency Contact",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 16),
              TextField(
                controller: _medicalConditionsController,
                decoration: InputDecoration(
                  labelText: "Medical Conditions",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
                maxLines: 2,
              ),
              SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: _submitForm,
                  child: Text("Proceed to Payment"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Payment Screen (Updated to Handle Expanded Data)
class PaymentScreen extends StatefulWidget {
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> with SingleTickerProviderStateMixin {
  bool _isProcessing = false;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(seconds: 1));
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _processPayment(Map<String, dynamic> args) async {
    setState(() => _isProcessing = true);
    _controller.forward();
    await Future.delayed(Duration(seconds: 2));
    String userId = FirebaseAuth.instance.currentUser!.uid;
    List<Map<String, dynamic>> cart = args['cart'] as List<Map<String, dynamic>>;
    List<String> purchasedItems = cart.map((item) => item['name'] as String).toList();
    double total = cart.fold(0, (sum, item) => sum + (item['price'] as num).toDouble());
    String timestamp = DateTime.now().toIso8601String();

    await FirebaseFirestore.instance.collection('users').doc(userId).set({
      'name': args['name'],
      'phone': args['phone'],
      'address': args['address'],
      'age': args['age'],
      'gender': args['gender'],
      'email': args['email'],
      'emergencyContact': args['emergencyContact'],
      'medicalConditions': args['medicalConditions'],
      'purchases': FieldValue.arrayUnion(purchasedItems),
      'transactions': FieldValue.arrayUnion([
        {
          'items': purchasedItems,
          'total': total,
          'timestamp': timestamp,
          'name': args['name'],
          'phone': args['phone'],
          'address': args['address'],
          'age': args['age'],
          'gender': args['gender'],
          'email': args['email'],
          'emergencyContact': args['emergencyContact'],
          'medicalConditions': args['medicalConditions'],
        }
      ]),
    }, SetOptions(merge: true));

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Payment Successful via UPI!")));
    Navigator.popUntil(context, ModalRoute.withName('/home'));
    setState(() => _isProcessing = false);
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final List<Map<String, dynamic>> cart = args['cart'] as List<Map<String, dynamic>>;
    double total = cart.fold(0, (sum, item) => sum + (item['price'] as num).toDouble());

    return Scaffold(
      appBar: AppBar(title: Text("Payment")),
      body: Center(
        child: _isProcessing
            ? FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: Colors.teal),
              SizedBox(height: 20),
              Text("Processing UPI Transaction...", style: TextStyle(fontSize: 18, color: Colors.teal)),
            ],
          ),
        )
            : Card(
          elevation: 10,
          margin: EdgeInsets.all(20),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("UPI Payment", style: Theme.of(context).textTheme.headlineSmall),
                  SizedBox(height: 20),
                  Text("Total: ₹$total", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.teal[900])),
                  SizedBox(height: 10),
                  Text("Name: ${args['name']}", style: TextStyle(fontSize: 16)),
                  SizedBox(height: 10),
                  Text("Phone: ${args['phone']}", style: TextStyle(fontSize: 16)),
                  SizedBox(height: 10),
                  Text("Address: ${args['address']}", style: TextStyle(fontSize: 16)),
                  SizedBox(height: 10),
                  Text("Age: ${args['age'].isEmpty ? 'Not set' : args['age']}", style: TextStyle(fontSize: 16)),
                  SizedBox(height: 10),
                  Text("Gender: ${args['gender'].isEmpty ? 'Not set' : args['gender']}", style: TextStyle(fontSize: 16)),
                  SizedBox(height: 10),
                  Text("Email: ${args['email']}", style: TextStyle(fontSize: 16)),
                  SizedBox(height: 10),
                  Text("Emergency Contact: ${args['emergencyContact'].isEmpty ? 'Not set' : args['emergencyContact']}", style: TextStyle(fontSize: 16)),
                  SizedBox(height: 10),
                  Text("Medical Conditions: ${args['medicalConditions'].isEmpty ? 'Not set' : args['medicalConditions']}", style: TextStyle(fontSize: 16)),
                  SizedBox(height: 20),
                  Icon(Icons.account_balance_wallet, size: 50, color: Colors.teal),
                  SizedBox(height: 20),
                  ElevatedButton.icon(
                    icon: Icon(Icons.send),
                    label: Text("Pay via UPI"),
                    onPressed: () => _processPayment(args),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Profile Screen
class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _ageController;
  late TextEditingController _genderController;
  late TextEditingController _emailController;
  late TextEditingController _emergencyContactController;
  late TextEditingController _medicalConditionsController;
  bool _isEditing = false;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: FirebaseAuth.instance.currentUser!.displayName ?? 'User');
    _phoneController = TextEditingController();
    _addressController = TextEditingController();
    _ageController = TextEditingController();
    _genderController = TextEditingController();
    _emailController = TextEditingController(text: FirebaseAuth.instance.currentUser!.email ?? '');
    _emergencyContactController = TextEditingController();
    _medicalConditionsController = TextEditingController();
    _controller = AnimationController(vsync: this, duration: Duration(seconds: 1))..forward();
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(_controller);
    _loadUserData();
  }

  void _loadUserData() async {
    var doc = await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get();
    if (doc.exists && doc.data() != null) {
      setState(() {
        _phoneController.text = doc.data()!['phone'] ?? '';
        _addressController.text = doc.data()!['address'] ?? '';
        _ageController.text = doc.data()!['age'] ?? '';
        _genderController.text = doc.data()!['gender'] ?? '';
        _emergencyContactController.text = doc.data()!['emergencyContact'] ?? '';
        _medicalConditionsController.text = doc.data()!['medicalConditions'] ?? '';
      });
    }
  }

  void _saveProfile() async {
    String newName = _nameController.text.trim();
    String newPhone = _phoneController.text.trim();
    String newAddress = _addressController.text.trim();
    String newAge = _ageController.text.trim();
    String newGender = _genderController.text.trim();
    String newEmail = _emailController.text.trim();
    String newEmergencyContact = _emergencyContactController.text.trim();
    String newMedicalConditions = _medicalConditionsController.text.trim();

    if (newName.isNotEmpty && newPhone.isNotEmpty && newAddress.isNotEmpty && newEmail.isNotEmpty) {
      await FirebaseAuth.instance.currentUser!.updateDisplayName(newName);
      await FirebaseAuth.instance.currentUser!.updateEmail(newEmail);
      await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).set({
        'name': newName,
        'phone': newPhone,
        'address': newAddress,
        'age': newAge,
        'gender': newGender,
        'email': newEmail,
        'emergencyContact': newEmergencyContact,
        'medicalConditions': newMedicalConditions,
      }, SetOptions(merge: true));
      setState(() => _isEditing = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Profile updated!")));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please fill all required fields (Name, Phone, Address, Email)")));
    }
  }

  @override
  Widget build(BuildContext context) {
    String userId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.save : Icons.edit),
            onPressed: () {
              if (_isEditing) {
                _saveProfile();
              } else {
                setState(() => _isEditing = true);
              }
            },
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.teal[100],
                    child: Icon(Icons.person, size: 80, color: Colors.teal[800]),
                  ),
                ),
                SizedBox(height: 20),
                Text("Your Profile", style: Theme.of(context).textTheme.headlineSmall),
                SizedBox(height: 20),
                Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: _isEditing ? _buildEditForm() : _buildProfileView(),
                  ),
                ),
                SizedBox(height: 20),
                Text("Purchased Products", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance.collection('users').doc(userId).snapshots(),
                      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                        if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
                        if (snapshot.hasError) return Center(child: Text("Error: ${snapshot.error}"));
                        var userData = snapshot.data!.data() as Map<String, dynamic>?;
                        List<dynamic> purchases = userData?['purchases'] ?? [];

                        if (purchases.isEmpty) {
                          return Center(child: Text("No purchases yet"));
                        }

                        return ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: purchases.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(purchases[index]),
                              leading: Icon(Icons.medical_services, color: Colors.teal),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildProfileField("Name", _nameController.text),
        _buildProfileField("Phone", _phoneController.text),
        _buildProfileField("Address", _addressController.text),
        _buildProfileField("Age", _ageController.text.isEmpty ? "Not set" : _ageController.text),
        _buildProfileField("Gender", _genderController.text.isEmpty ? "Not set" : _genderController.text),
        _buildProfileField("Email", _emailController.text),
        _buildProfileField("Emergency Contact", _emergencyContactController.text.isEmpty ? "Not set" : _emergencyContactController.text),
        _buildProfileField("Medical Conditions", _medicalConditionsController.text.isEmpty ? "Not set" : _medicalConditionsController.text),
      ],
    );
  }

  Widget _buildProfileField(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text("$label: ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.teal[900])),
          Expanded(child: Text(value, style: TextStyle(fontSize: 16))),
        ],
      ),
    );
  }

  Widget _buildEditForm() {
    return Column(
      children: [
        TextField(
          controller: _nameController,
          decoration: InputDecoration(
            labelText: "Name *",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
        SizedBox(height: 16),
        TextField(
          controller: _phoneController,
          decoration: InputDecoration(
            labelText: "Phone *",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
          keyboardType: TextInputType.phone,
        ),
        SizedBox(height: 16),
        TextField(
          controller: _addressController,
          decoration: InputDecoration(
            labelText: "Address *",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
          maxLines: 3,
        ),
        SizedBox(height: 16),
        TextField(
          controller: _ageController,
          decoration: InputDecoration(
            labelText: "Age",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: 16),
        TextField(
          controller: _genderController,
          decoration: InputDecoration(
            labelText: "Gender",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
        SizedBox(height: 16),
        TextField(
          controller: _emailController,
          decoration: InputDecoration(
            labelText: "Email *",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
          keyboardType: TextInputType.emailAddress,
        ),
        SizedBox(height: 16),
        TextField(
          controller: _emergencyContactController,
          decoration: InputDecoration(
            labelText: "Emergency Contact",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
          keyboardType: TextInputType.phone,
        ),
        SizedBox(height: 16),
        TextField(
          controller: _medicalConditionsController,
          decoration: InputDecoration(
            labelText: "Medical Conditions",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
          maxLines: 2,
        ),
      ],
    );
  }
}

// History Screen
class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(seconds: 1))..forward();
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String userId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(title: Text("Transaction History")),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection('users').doc(userId).snapshots(),
              builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
                if (snapshot.hasError) return Center(child: Text("Error: ${snapshot.error}"));
                var userData = snapshot.data!.data() as Map<String, dynamic>?;
                List<dynamic> transactions = userData?['transactions'] ?? [];

                if (transactions.isEmpty) {
                  return Center(child: Text("No transactions yet", style: Theme.of(context).textTheme.headlineSmall));
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: transactions.length,
                  itemBuilder: (context, index) {
                    var transaction = transactions[index] as Map<String, dynamic>;
                    return Card(
                      elevation: 3,
                      margin: EdgeInsets.only(bottom: 10),
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Date: ${transaction['timestamp'].substring(0, 10)}", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            SizedBox(height: 8),
                            Text("Items: ${transaction['items'].join(', ')}", style: TextStyle(fontSize: 14)),
                            SizedBox(height: 8),
                            Text("Total: ₹${transaction['total']}", style: TextStyle(fontSize: 14, color: Colors.teal)),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

// Order Screen
class OrderScreen extends StatefulWidget {
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(seconds: 1))..forward();
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String userId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(title: Text("Orders")),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection('users').doc(userId).snapshots(),
              builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
                if (snapshot.hasError) return Center(child: Text("Error: ${snapshot.error}"));
                var userData = snapshot.data!.data() as Map<String, dynamic>?;
                List<dynamic> transactions = userData?['transactions'] ?? [];

                if (transactions.isEmpty) {
                  return Center(child: Text("No orders yet", style: Theme.of(context).textTheme.headlineSmall));
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: transactions.length,
                  itemBuilder: (context, index) {
                    var transaction = transactions[index] as Map<String, dynamic>;
                    return Card(
                      elevation: 3,
                      margin: EdgeInsets.only(bottom: 10),
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Order #${index + 1}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            SizedBox(height: 8),
                            Text("Date: ${transaction['timestamp'].substring(0, 10)}", style: TextStyle(fontSize: 16)),
                            SizedBox(height: 8),
                            Text("Items: ${transaction['items'].join(', ')}", style: TextStyle(fontSize: 14)),
                            SizedBox(height: 8),
                            Text("Total: ₹${transaction['total']}", style: TextStyle(fontSize: 14, color: Colors.teal)),
                            SizedBox(height: 8),
                            Text("Name: ${transaction['name']}", style: TextStyle(fontSize: 14)),
                            SizedBox(height: 8),
                            Text("Phone: ${transaction['phone']}", style: TextStyle(fontSize: 14)),
                            SizedBox(height: 8),
                            Text("Address: ${transaction['address']}", style: TextStyle(fontSize: 14)),
                            SizedBox(height: 8),
                            Text("Age: ${transaction['age']}", style: TextStyle(fontSize: 14)),
                            SizedBox(height: 8),
                            Text("Gender: ${transaction['gender']}", style: TextStyle(fontSize: 14)),
                            SizedBox(height: 8),
                            Text("Email: ${transaction['email']}", style: TextStyle(fontSize: 14)),
                            SizedBox(height: 8),
                            Text("Emergency Contact: ${transaction['emergencyContact']}", style: TextStyle(fontSize: 14)),
                            SizedBox(height: 8),
                            Text("Medical Conditions: ${transaction['medicalConditions']}", style: TextStyle(fontSize: 14)),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

// Add Medicines to Firestore
Future<void> addMedicineToFirestore() async {
  CollectionReference medicines = FirebaseFirestore.instance.collection('medicines');

  await medicines.add({
    'name': 'Paracetamol',
    'price': 20,
    'usage': 'Fever relief',
    'imageUrl': 'assets/para.jpeg',
    'dosage': '2 tablets per day',
    'purpose': 'Used to reduce fever and relieve mild to moderate pain such as headaches or muscle aches.',
    'reviews': [],
  });

  await medicines.add({
    'name': 'Ibuprofen',
    'price': 50,
    'usage': 'Pain relief',
    'imageUrl': 'assets/ibup.jpeg',
    'dosage': '1-2 tablets every 6 hours',
    'purpose': 'Used to relieve pain, reduce inflammation, and lower fever, especially for conditions like arthritis or injuries.',
    'reviews': [],
  });

  await medicines.add({
    'name': 'Aspirin',
    'price': 30,
    'usage': 'Pain and inflammation relief',
    'imageUrl': 'assets/asp.jpeg',
    'dosage': '1 tablet every 4-6 hours',
    'purpose': 'Used for pain relief, reducing inflammation, and preventing blood clots in conditions like heart disease.',
    'reviews': [],
  });

  await medicines.add({
    'name': 'Amoxicillin',
    'price': 100,
    'usage': 'Antibiotic for infections',
    'imageUrl': 'assets/amox.jpeg',
    'dosage': '1 tablet 3 times a day',
    'purpose': 'An antibiotic used to treat bacterial infections like ear infections, pneumonia, or urinary tract infections.',
    'reviews': [],
  });

  await medicines.add({
    'name': 'Cetirizine',
    'price': 25,
    'usage': 'Allergy relief',
    'imageUrl': 'assets/cet.jpeg',
    'dosage': '1 tablet per day',
    'purpose': 'Used to relieve allergy symptoms such as sneezing, runny nose, and itchy eyes.',
    'reviews': [],
  });

  await medicines.add({
    'name': 'Omeprazole',
    'price': 60,
    'usage': 'Acid reflux treatment',
    'imageUrl': 'assets/omep.jpeg',
    'dosage': '1 capsule per day',
    'purpose': 'Used to treat acid reflux, heartburn, and stomach ulcers by reducing stomach acid production.',
    'reviews': [],
  });

  await medicines.add({
    'name': 'Metformin',
    'price': 80,
    'usage': 'Diabetes management',
    'imageUrl': 'assets/melf.jpeg',
    'dosage': '1-2 tablets per day',
    'purpose': 'Used to control blood sugar levels in people with type 2 diabetes.',
    'reviews': [],
  });

  await medicines.add({
    'name': 'Loratadine',
    'price': 30,
    'usage': 'Seasonal allergy relief',
    'imageUrl': 'assets/lorat.jpeg',
    'dosage': '1 tablet per day',
    'purpose': 'Used to relieve symptoms of seasonal allergies like hay fever, including sneezing and itchy throat.',
    'reviews': [],
  });

  await medicines.add({
    'name': 'Dolo',
    'price': 25,
    'usage': 'Fever and pain relief',
    'imageUrl': 'assets/dolo.jpeg',
    'dosage': '1-2 tablets per day',
    'purpose': 'A paracetamol-based medicine used to reduce fever and relieve mild pain.',
    'reviews': [],
  });

  await medicines.add({
    'name': 'Vitamin C',
    'price': 15,
    'usage': 'Immune support',
    'imageUrl': 'assets/vc.jpeg',
    'dosage': '1 tablet per day',
    'purpose': 'Used to boost the immune system and prevent vitamin C deficiency.',
    'reviews': [],
  });

  await medicines.add({
    'name': 'Cough Syrup',
    'price': 50,
    'usage': 'Cough suppression',
    'imageUrl': 'assets/cough.jpeg',
    'dosage': '10 ml 2-3 times a day',
    'purpose': 'Used to suppress dry or productive coughs and soothe throat irritation.',
    'reviews': [],
  });

  await medicines.add({
    'name': 'Ranitidine',
    'price': 40,
    'usage': 'Heartburn relief',
    'imageUrl': 'assets/rani.jpeg',
    'dosage': '1 tablet twice a day',
    'purpose': 'Used to treat heartburn, indigestion, and ulcers by reducing stomach acid.',
    'reviews': [],
  });

  print("Medicines added to Firestore!");
}
/*
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await addHijabAccessoriesToFirestore();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: FirebaseAuth.instance.currentUser == null ? '/splash' : '/home',
      theme: ThemeData(
        primaryColor: Colors.pink,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.pink[800],
          foregroundColor: Colors.white,
          elevation: 0,
          titleTextStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.pink[700],
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 14, horizontal: 24),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 8,
            textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        textTheme: TextTheme(
          bodyMedium: TextStyle(fontSize: 16, color: Colors.grey[800]),
          headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.pink[900]),
        ),
        cardTheme: CardTheme(
          elevation: 5,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
      ),
      routes: {
        '/splash': (context) => SplashScreen(),
        '/welcome': (context) => WelcomeScreen(),
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignupScreen(),
        '/home': (context) => HomeScreen(),
        '/cart': (context) => CartScreen(),
        '/payment': (context) => PaymentScreen(),
        '/profile': (context) => ProfileScreen(),
        '/history': (context) => HistoryScreen(),
        '/orders': (context) => OrderScreen(),
      },
    );
  }
}

// Splash Screen
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(seconds: 3))..repeat();
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
    _offsetAnimation = Tween<Offset>(begin: Offset(0, 0), end: Offset(0, 0.2)).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    Timer(Duration(seconds: 4), () => Navigator.pushReplacementNamed(context, '/welcome'));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.pink[900]!, Colors.pink[300]!],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.0, _controller.value],
                  ),
                ),
              );
            },
          ),
          Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _offsetAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/logo.jpeg', width: 180),
                    SizedBox(height: 20),
                    Text("Elegance in Every Fold", style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold)),
                    SizedBox(height: 20),
                    CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.white)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Welcome Screen
class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(seconds: 1))..forward();
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.pink[50]!, Colors.pink[200]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Welcome to Hijab Boutique", style: Theme.of(context).textTheme.headlineSmall),
                SizedBox(height: 40),
                ElevatedButton.icon(
                  icon: Icon(Icons.login),
                  label: Text("Login"),
                  onPressed: () => Navigator.pushNamed(context, '/login'),
                ),
                SizedBox(height: 20),
                ElevatedButton.icon(
                  icon: Icon(Icons.person_add),
                  label: Text("Sign Up"),
                  onPressed: () => Navigator.pushNamed(context, '/signup'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Login Screen
class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  late AnimationController _controller;
  late Animation<double> _buttonAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _buttonAnimation = Tween<double>(begin: 0.9, end: 1).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
    _controller.forward();
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Login failed: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.pink[700]!, Colors.pink[200]!],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 60),
              FadeTransition(
                opacity: _fadeAnimation,
                child: Text("Login", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                  labelStyle: TextStyle(color: Colors.white70),
                  prefixIcon: Icon(Icons.email, color: Colors.white70),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.2),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                ),
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: "Password",
                  labelStyle: TextStyle(color: Colors.white70),
                  prefixIcon: Icon(Icons.lock, color: Colors.white70),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.2),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                ),
                obscureText: true,
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 40),
              Center(
                child: ScaleTransition(
                  scale: _buttonAnimation,
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.login),
                    label: Text("Login"),
                    onPressed: _login,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Signup Screen
class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(seconds: 1))..forward();
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _signup() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      String userName = _emailController.text.split('@')[0];
      await FirebaseAuth.instance.currentUser!.updateDisplayName(userName);
      await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).set({
        'name': userName,
        'purchases': [],
        'transactions': [],
        'address': '',
        'email': _emailController.text.trim(),
        'phone': '',
        'age': '',
        'gender': '',
        'emergencyContact': '',
        'preferences': '',
      });
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Signup failed: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sign Up")),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Create Account", style: Theme.of(context).textTheme.headlineSmall),
              SizedBox(height: 20),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: "Password",
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
                obscureText: true,
              ),
              SizedBox(height: 30),
              Center(
                child: ElevatedButton.icon(
                  icon: Icon(Icons.person_add),
                  label: Text("Sign Up"),
                  onPressed: _signup,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Home Screen
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  List<Map<String, dynamic>> cart = [];
  String _searchQuery = '';
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(seconds: 1))..forward();
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _addToCart(Map<String, dynamic> accessory) {
    setState(() {
      cart.add(accessory);
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${accessory['name']} added to cart")));
  }

  void _logout() {
    FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, '/welcome');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hijab Accessories"),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () => Navigator.pushNamed(context, '/cart', arguments: cart),
          ),
          IconButton(
            icon: Icon(Icons.history),
            onPressed: () => Navigator.pushNamed(context, '/history'),
          ),
          IconButton(
            icon: Icon(Icons.local_shipping),
            onPressed: () => Navigator.pushNamed(context, '/orders'),
          ),
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () => Navigator.pushNamed(context, '/profile'),
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Style Tips Coming Soon!"))),
        child: Icon(Icons.help),
        backgroundColor: Colors.pink[700],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 200,
                padding: EdgeInsets.symmetric(vertical: 10),
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance.collection('hijab_accessories').limit(5).snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        var acc = snapshot.data!.docs[index].data() as Map<String, dynamic>;
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Card(
                            elevation: 5,
                            child: Container(
                              width: 150,
                              child: Column(
                                children: [
                                  Image.asset(acc['imageUrl'] ?? 'assets/images/default_hijab.png', height: 100, fit: BoxFit.cover),
                                  SizedBox(height: 8),
                                  Text(acc['name'] ?? 'Unknown', style: TextStyle(fontWeight: FontWeight.bold)),
                                  Text('₹${acc['price']}', style: TextStyle(color: Colors.pink)),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Search accessories (e.g., hijab, pins)",
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.search, color: Colors.pink),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value.toLowerCase();
                        });
                      },
                    ),
                  ),
                ),
              ),
              StreamBuilder(
                stream: FirebaseFirestore.instance.collection('hijab_accessories').snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) return Center(child: CircularProgressIndicator(color: Colors.pink));
                  if (snapshot.hasError) return Center(child: Text("Error: ${snapshot.error}"));
                  if (snapshot.data!.docs.isEmpty) return Center(child: Text("No accessories available"));

                  var filteredAccessories = snapshot.data!.docs.where((doc) {
                    var acc = doc.data() as Map<String, dynamic>;
                    String name = (acc['name'] ?? '').toString().toLowerCase();
                    String usage = (acc['usage'] ?? '').toString().toLowerCase();
                    String description = (acc['description'] ?? '').toString().toLowerCase();
                    String category = (acc['category'] ?? '').toString().toLowerCase();
                    return name.contains(_searchQuery) || usage.contains(_searchQuery) || description.contains(_searchQuery) || category.contains(_searchQuery);
                  }).toList();

                  if (filteredAccessories.isEmpty) {
                    return Center(child: Text("No accessories found for '$_searchQuery'"));
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.all(16),
                    itemCount: filteredAccessories.length,
                    itemBuilder: (context, index) {
                      var acc = filteredAccessories[index].data() as Map<String, dynamic>;
                      return AnimatedAccessoryCard(
                        accessory: acc,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AccessoryDetailsScreen(
                                accessory: acc,
                                onAddToCart: _addToCart,
                              ),
                            ),
                          );
                        },
                        onAddToCart: _addToCart,
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Animated Accessory Card Widget
class AnimatedAccessoryCard extends StatelessWidget {
  final Map<String, dynamic> accessory;
  final VoidCallback onTap;
  final Function(Map<String, dynamic>) onAddToCart;

  const AnimatedAccessoryCard({required this.accessory, required this.onTap, required this.onAddToCart});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: EdgeInsets.only(bottom: 8),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    accessory['imageUrl'] ?? 'assets/images/default_hijab.png',
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Icon(Icons.broken_image),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(accessory['name'] ?? 'Unknown', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      Text('Price: ₹${accessory['price']} | ${accessory['usage']}', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add_circle, color: Colors.pink, size: 30),
                  onPressed: () => onAddToCart(accessory),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Accessory Details Screen
class AccessoryDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> accessory;
  final Function(Map<String, dynamic>) onAddToCart;

  const AccessoryDetailsScreen({required this.accessory, required this.onAddToCart});

  @override
  _AccessoryDetailsScreenState createState() => _AccessoryDetailsScreenState();
}

class _AccessoryDetailsScreenState extends State<AccessoryDetailsScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  final _reviewController = TextEditingController();
  bool _showReviewForm = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(seconds: 1))..forward();
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    _reviewController.dispose();
    super.dispose();
  }

  Future<void> _submitReview() async {
    if (_reviewController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please enter a review")));
      return;
    }
    String userId = FirebaseAuth.instance.currentUser!.uid;
    String userName = FirebaseAuth.instance.currentUser!.displayName ?? 'Anonymous';
    String accessoryName = widget.accessory['name'];

    await FirebaseFirestore.instance.collection('hijab_accessories').where('name', isEqualTo: accessoryName).get().then((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        var docId = snapshot.docs.first.id;
        FirebaseFirestore.instance.collection('hijab_accessories').doc(docId).update({
          'reviews': FieldValue.arrayUnion([
            {
              'userId': userId,
              'userName': userName,
              'review': _reviewController.text,
              'timestamp': DateTime.now().toIso8601String(),
            }
          ]),
        });
      }
    });

    _reviewController.clear();
    setState(() => _showReviewForm = false);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Review submitted!")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.accessory['name'] ?? 'Accessory Details')),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      widget.accessory['imageUrl'] ?? 'assets/images/default_hijab.png',
                      width: 220,
                      height: 220,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Icon(Icons.broken_image, size: 100),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(widget.accessory['name'] ?? 'Unknown', style: Theme.of(context).textTheme.headlineSmall),
                SizedBox(height: 10),
                Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Price: ₹${widget.accessory['price'] ?? 'N/A'}", style: TextStyle(fontSize: 18)),
                        SizedBox(height: 10),
                        Text("Category: ${widget.accessory['category'] ?? 'Not specified'}", style: TextStyle(fontSize: 18)),
                        SizedBox(height: 10),
                        Text("Description: ${widget.accessory['description'] ?? 'Not specified'}", style: TextStyle(fontSize: 18)),
                        SizedBox(height: 10),
                        Text("Usage: ${widget.accessory['usage'] ?? 'Not specified'}", style: TextStyle(fontSize: 18)),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      icon: Icon(Icons.add_shopping_cart),
                      label: Text("Add to Cart"),
                      onPressed: () {
                        widget.onAddToCart(widget.accessory);
                        Navigator.pop(context);
                      },
                    ),
                    ElevatedButton.icon(
                      icon: Icon(Icons.payment),
                      label: Text("Buy Now"),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UserInfoFormScreen(
                              cart: [widget.accessory],
                              onPayment: (cart) => Navigator.pushNamed(context, '/payment', arguments: {'cart': cart}),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                SizedBox(height: 20),
                ElevatedButton.icon(
                  icon: Icon(Icons.rate_review),
                  label: Text("Write a Review"),
                  onPressed: () => setState(() => _showReviewForm = !_showReviewForm),
                ),
                if (_showReviewForm) ...[
                  SizedBox(height: 20),
                  TextField(
                    controller: _reviewController,
                    decoration: InputDecoration(
                      labelText: "Your Review",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    maxLines: 3,
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _submitReview,
                    child: Text("Submit Review"),
                  ),
                ],
                SizedBox(height: 20),
                Text("Reviews", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                StreamBuilder(
                  stream: FirebaseFirestore.instance.collection('hijab_accessories').where('name', isEqualTo: widget.accessory['name']).snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
                    var reviews = snapshot.data!.docs.first['reviews'] ?? [];
                    if (reviews.isEmpty) return Text("No reviews yet.");
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: reviews.length,
                      itemBuilder: (context, index) {
                        var review = reviews[index];
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 5),
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(review['userName'], style: TextStyle(fontWeight: FontWeight.bold)),
                                SizedBox(height: 5),
                                Text(review['review']),
                                SizedBox(height: 5),
                                Text(review['timestamp'].substring(0, 10), style: TextStyle(color: Colors.grey)),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Cart Screen
class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(seconds: 1))..forward();
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> cart = ModalRoute.of(context)!.settings.arguments as List<Map<String, dynamic>>;

    return Scaffold(
      appBar: AppBar(title: Text("Cart")),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: cart.isEmpty
            ? Center(child: Text("Your cart is empty", style: Theme.of(context).textTheme.headlineSmall))
            : ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: cart.length,
          itemBuilder: (context, index) {
            var item = cart[index];
            return AnimatedAccessoryCard(
              accessory: item,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AccessoryDetailsScreen(
                      accessory: item,
                      onAddToCart: (accessory) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${accessory['name']} already in cart")));
                      },
                    ),
                  ),
                );
              },
              onAddToCart: (accessory) {},
            );
          },
        ),
      ),
      bottomNavigationBar: cart.isEmpty
          ? null
          : Padding(
        padding: EdgeInsets.all(16),
        child: ElevatedButton.icon(
          icon: Icon(Icons.payment),
          label: Text("Proceed to Payment"),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UserInfoFormScreen(
                  cart: cart,
                  onPayment: (cart) => Navigator.pushNamed(context, '/payment', arguments: {'cart': cart}),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// User Info Form Screen
class UserInfoFormScreen extends StatefulWidget {
  final List<Map<String, dynamic>> cart;
  final Function(List<Map<String, dynamic>>) onPayment;

  const UserInfoFormScreen({required this.cart, required this.onPayment});

  @override
  _UserInfoFormScreenState createState() => _UserInfoFormScreenState();
}

class _UserInfoFormScreenState extends State<UserInfoFormScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _ageController = TextEditingController();
  final _genderController = TextEditingController();
  final _emailController = TextEditingController();
  final _emergencyContactController = TextEditingController();
  final _preferencesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    User? user = FirebaseAuth.instance.currentUser;
    _nameController.text = user?.displayName ?? '';
    _emailController.text = user?.email ?? '';
    _loadUserData();
  }

  void _loadUserData() async {
    var doc = await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get();
    if (doc.exists && doc.data() != null) {
      setState(() {
        _phoneController.text = doc.data()!['phone'] ?? '';
        _addressController.text = doc.data()!['address'] ?? '';
        _ageController.text = doc.data()!['age'] ?? '';
        _genderController.text = doc.data()!['gender'] ?? '';
        _emergencyContactController.text = doc.data()!['emergencyContact'] ?? '';
        _preferencesController.text = doc.data()!['preferences'] ?? '';
      });
    }
  }

  void _submitForm() {
    if (_nameController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _addressController.text.isEmpty ||
        _emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please fill all required fields (Name, Phone, Address, Email)")));
      return;
    }
    Navigator.pushNamed(
      context,
      '/payment',
      arguments: {
        'cart': widget.cart,
        'name': _nameController.text,
        'phone': _phoneController.text,
        'address': _addressController.text,
        'age': _ageController.text,
        'gender': _genderController.text,
        'email': _emailController.text,
        'emergencyContact': _emergencyContactController.text,
        'preferences': _preferencesController.text,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Enter Your Details")),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Please provide your details for the order", style: TextStyle(fontSize: 18, color: Colors.pink[900])),
              SizedBox(height: 20),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: "Name *",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: "Phone *",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 16),
              TextField(
                controller: _addressController,
                decoration: InputDecoration(
                  labelText: "Address *",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
                maxLines: 3,
              ),
              SizedBox(height: 16),
              TextField(
                controller: _ageController,
                decoration: InputDecoration(
                  labelText: "Age",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16),
              TextField(
                controller: _genderController,
                decoration: InputDecoration(
                  labelText: "Gender",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: "Email *",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 16),
              TextField(
                controller: _emergencyContactController,
                decoration: InputDecoration(
                  labelText: "Emergency Contact",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 16),
              TextField(
                controller: _preferencesController,
                decoration: InputDecoration(
                  labelText: "Style Preferences",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
                maxLines: 2,
              ),
              SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: _submitForm,
                  child: Text("Proceed to Payment"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Payment Screen
class PaymentScreen extends StatefulWidget {
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> with SingleTickerProviderStateMixin {
  bool _isProcessing = false;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(seconds: 1));
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _processPayment(Map<String, dynamic> args) async {
    setState(() => _isProcessing = true);
    _controller.forward();
    await Future.delayed(Duration(seconds: 2));
    String userId = FirebaseAuth.instance.currentUser!.uid;
    List<Map<String, dynamic>> cart = args['cart'] as List<Map<String, dynamic>>;
    List<String> purchasedItems = cart.map((item) => item['name'] as String).toList();
    double total = cart.fold(0, (sum, item) => sum + (item['price'] as num).toDouble());
    String timestamp = DateTime.now().toIso8601String();

    await FirebaseFirestore.instance.collection('users').doc(userId).set({
      'name': args['name'],
      'phone': args['phone'],
      'address': args['address'],
      'age': args['age'],
      'gender': args['gender'],
      'email': args['email'],
      'emergencyContact': args['emergencyContact'],
      'preferences': args['preferences'],
      'purchases': FieldValue.arrayUnion(purchasedItems),
      'transactions': FieldValue.arrayUnion([
        {
          'items': purchasedItems,
          'total': total,
          'timestamp': timestamp,
          'name': args['name'],
          'phone': args['phone'],
          'address': args['address'],
          'age': args['age'],
          'gender': args['gender'],
          'email': args['email'],
          'emergencyContact': args['emergencyContact'],
          'preferences': args['preferences'],
        }
      ]),
    }, SetOptions(merge: true));

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Payment Successful via UPI!")));
    Navigator.popUntil(context, ModalRoute.withName('/home'));
    setState(() => _isProcessing = false);
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final List<Map<String, dynamic>> cart = args['cart'] as List<Map<String, dynamic>>;
    double total = cart.fold(0, (sum, item) => sum + (item['price'] as num).toDouble());

    return Scaffold(
      appBar: AppBar(title: Text("Payment")),
      body: Center(
        child: _isProcessing
            ? FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: Colors.pink),
              SizedBox(height: 20),
              Text("Processing UPI Transaction...", style: TextStyle(fontSize: 18, color: Colors.pink)),
            ],
          ),
        )
            : Card(
          elevation: 10,
          margin: EdgeInsets.all(20),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("UPI Payment", style: Theme.of(context).textTheme.headlineSmall),
                  SizedBox(height: 20),
                  Text("Total: ₹$total", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.pink[900])),
                  SizedBox(height: 10),
                  Text("Name: ${args['name']}", style: TextStyle(fontSize: 16)),
                  SizedBox(height: 10),
                  Text("Phone: ${args['phone']}", style: TextStyle(fontSize: 16)),
                  SizedBox(height: 10),
                  Text("Address: ${args['address']}", style: TextStyle(fontSize: 16)),
                  SizedBox(height: 10),
                  Text("Age: ${args['age'].isEmpty ? 'Not set' : args['age']}", style: TextStyle(fontSize: 16)),
                  SizedBox(height: 10),
                  Text("Gender: ${args['gender'].isEmpty ? 'Not set' : args['gender']}", style: TextStyle(fontSize: 16)),
                  SizedBox(height: 10),
                  Text("Email: ${args['email']}", style: TextStyle(fontSize: 16)),
                  SizedBox(height: 10),
                  Text("Emergency Contact: ${args['emergencyContact'].isEmpty ? 'Not set' : args['emergencyContact']}", style: TextStyle(fontSize: 16)),
                  SizedBox(height: 10),
                  Text("Preferences: ${args['preferences'].isEmpty ? 'Not set' : args['preferences']}", style: TextStyle(fontSize: 16)),
                  SizedBox(height: 20),
                  Icon(Icons.account_balance_wallet, size: 50, color: Colors.pink),
                  SizedBox(height: 20),
                  ElevatedButton.icon(
                    icon: Icon(Icons.send),
                    label: Text("Pay via UPI"),
                    onPressed: () => _processPayment(args),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Profile Screen
class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _ageController;
  late TextEditingController _genderController;
  late TextEditingController _emailController;
  late TextEditingController _emergencyContactController;
  late TextEditingController _preferencesController;
  bool _isEditing = false;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: FirebaseAuth.instance.currentUser!.displayName ?? 'User');
    _phoneController = TextEditingController();
    _addressController = TextEditingController();
    _ageController = TextEditingController();
    _genderController = TextEditingController();
    _emailController = TextEditingController(text: FirebaseAuth.instance.currentUser!.email ?? '');
    _emergencyContactController = TextEditingController();
    _preferencesController = TextEditingController();
    _controller = AnimationController(vsync: this, duration: Duration(seconds: 1))..forward();
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(_controller);
    _loadUserData();
  }

  void _loadUserData() async {
    var doc = await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get();
    if (doc.exists && doc.data() != null) {
      setState(() {
        _phoneController.text = doc.data()!['phone'] ?? '';
        _addressController.text = doc.data()!['address'] ?? '';
        _ageController.text = doc.data()!['age'] ?? '';
        _genderController.text = doc.data()!['gender'] ?? '';
        _emergencyContactController.text = doc.data()!['emergencyContact'] ?? '';
        _preferencesController.text = doc.data()!['preferences'] ?? '';
      });
    }
  }

  void _saveProfile() async {
    String newName = _nameController.text.trim();
    String newPhone = _phoneController.text.trim();
    String newAddress = _addressController.text.trim();
    String newAge = _ageController.text.trim();
    String newGender = _genderController.text.trim();
    String newEmail = _emailController.text.trim();
    String newEmergencyContact = _emergencyContactController.text.trim();
    String newPreferences = _preferencesController.text.trim();

    if (newName.isNotEmpty && newPhone.isNotEmpty && newAddress.isNotEmpty && newEmail.isNotEmpty) {
      await FirebaseAuth.instance.currentUser!.updateDisplayName(newName);
      await FirebaseAuth.instance.currentUser!.updateEmail(newEmail);
      await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).set({
        'name': newName,
        'phone': newPhone,
        'address': newAddress,
        'age': newAge,
        'gender': newGender,
        'email': newEmail,
        'emergencyContact': newEmergencyContact,
        'preferences': newPreferences,
      }, SetOptions(merge: true));
      setState(() => _isEditing = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Profile updated!")));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please fill all required fields (Name, Phone, Address, Email)")));
    }
  }

  @override
  Widget build(BuildContext context) {
    String userId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.save : Icons.edit),
            onPressed: () {
              if (_isEditing) {
                _saveProfile();
              } else {
                setState(() => _isEditing = true);
              }
            },
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.pink[100],
                    child: Icon(Icons.person, size: 80, color: Colors.pink[800]),
                  ),
                ),
                SizedBox(height: 20),
                Text("Your Profile", style: Theme.of(context).textTheme.headlineSmall),
                SizedBox(height: 20),
                Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: _isEditing ? _buildEditForm() : _buildProfileView(),
                  ),
                ),
                SizedBox(height: 20),
                Text("Purchased Accessories", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance.collection('users').doc(userId).snapshots(),
                      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                        if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
                        if (snapshot.hasError) return Center(child: Text("Error: ${snapshot.error}"));
                        var userData = snapshot.data!.data() as Map<String, dynamic>?;
                        List<dynamic> purchases = userData?['purchases'] ?? [];

                        if (purchases.isEmpty) {
                          return Center(child: Text("No purchases yet"));
                        }

                        return ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: purchases.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(purchases[index]),
                              leading: Icon(Icons.style, color: Colors.pink),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildProfileField("Name", _nameController.text),
        _buildProfileField("Phone", _phoneController.text),
        _buildProfileField("Address", _addressController.text),
        _buildProfileField("Age", _ageController.text.isEmpty ? "Not set" : _ageController.text),
        _buildProfileField("Gender", _genderController.text.isEmpty ? "Not set" : _genderController.text),
        _buildProfileField("Email", _emailController.text),
        _buildProfileField("Emergency Contact", _emergencyContactController.text.isEmpty ? "Not set" : _emergencyContactController.text),
        _buildProfileField("Preferences", _preferencesController.text.isEmpty ? "Not set" : _preferencesController.text),
      ],
    );
  }

  Widget _buildProfileField(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text("$label: ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.pink[900])),
          Expanded(child: Text(value, style: TextStyle(fontSize: 16))),
        ],
      ),
    );
  }

  Widget _buildEditForm() {
    return Column(
      children: [
        TextField(
          controller: _nameController,
          decoration: InputDecoration(
            labelText: "Name *",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
        SizedBox(height: 16),
        TextField(
          controller: _phoneController,
          decoration: InputDecoration(
            labelText: "Phone *",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
          keyboardType: TextInputType.phone,
        ),
        SizedBox(height: 16),
        TextField(
          controller: _addressController,
          decoration: InputDecoration(
            labelText: "Address *",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
          maxLines: 3,
        ),
        SizedBox(height: 16),
        TextField(
          controller: _ageController,
          decoration: InputDecoration(
            labelText: "Age",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: 16),
        TextField(
          controller: _genderController,
          decoration: InputDecoration(
            labelText: "Gender",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
        SizedBox(height: 16),
        TextField(
          controller: _emailController,
          decoration: InputDecoration(
            labelText: "Email *",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
          keyboardType: TextInputType.emailAddress,
        ),
        SizedBox(height: 16),
        TextField(
          controller: _emergencyContactController,
          decoration: InputDecoration(
            labelText: "Emergency Contact",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
          keyboardType: TextInputType.phone,
        ),
        SizedBox(height: 16),
        TextField(
          controller: _preferencesController,
          decoration: InputDecoration(
            labelText: "Style Preferences",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
          maxLines: 2,
        ),
      ],
    );
  }
}

// History Screen
class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(seconds: 1))..forward();
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String userId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(title: Text("Transaction History")),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection('users').doc(userId).snapshots(),
              builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
                if (snapshot.hasError) return Center(child: Text("Error: ${snapshot.error}"));
                var userData = snapshot.data!.data() as Map<String, dynamic>?;
                List<dynamic> transactions = userData?['transactions'] ?? [];

                if (transactions.isEmpty) {
                  return Center(child: Text("No transactions yet", style: Theme.of(context).textTheme.headlineSmall));
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: transactions.length,
                  itemBuilder: (context, index) {
                    var transaction = transactions[index] as Map<String, dynamic>;
                    return Card(
                      elevation: 3,
                      margin: EdgeInsets.only(bottom: 10),
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Date: ${transaction['timestamp'].substring(0, 10)}", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            SizedBox(height: 8),
                            Text("Items: ${transaction['items'].join(', ')}", style: TextStyle(fontSize: 14)),
                            SizedBox(height: 8),
                            Text("Total: ₹${transaction['total']}", style: TextStyle(fontSize: 14, color: Colors.pink)),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

// Order Screen
class OrderScreen extends StatefulWidget {
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(seconds: 1))..forward();
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String userId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(title: Text("Orders")),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection('users').doc(userId).snapshots(),
              builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
                if (snapshot.hasError) return Center(child: Text("Error: ${snapshot.error}"));
                var userData = snapshot.data!.data() as Map<String, dynamic>?;
                List<dynamic> transactions = userData?['transactions'] ?? [];

                if (transactions.isEmpty) {
                  return Center(child: Text("No orders yet", style: Theme.of(context).textTheme.headlineSmall));
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: transactions.length,
                  itemBuilder: (context, index) {
                    var transaction = transactions[index] as Map<String, dynamic>;
                    return Card(
                      elevation: 3,
                      margin: EdgeInsets.only(bottom: 10),
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Order #${index + 1}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            SizedBox(height: 8),
                            Text("Date: ${transaction['timestamp'].substring(0, 10)}", style: TextStyle(fontSize: 16)),
                            SizedBox(height: 8),
                            Text("Items: ${transaction['items'].join(', ')}", style: TextStyle(fontSize: 14)),
                            SizedBox(height: 8),
                            Text("Total: ₹${transaction['total']}", style: TextStyle(fontSize: 14, color: Colors.pink)),
                            SizedBox(height: 8),
                            Text("Name: ${transaction['name']}", style: TextStyle(fontSize: 14)),
                            SizedBox(height: 8),
                            Text("Phone: ${transaction['phone']}", style: TextStyle(fontSize: 14)),
                            SizedBox(height: 8),
                            Text("Address: ${transaction['address']}", style: TextStyle(fontSize: 14)),
                            SizedBox(height: 8),
                            Text("Age: ${transaction['age']}", style: TextStyle(fontSize: 14)),
                            SizedBox(height: 8),
                            Text("Gender: ${transaction['gender']}", style: TextStyle(fontSize: 14)),
                            SizedBox(height: 8),
                            Text("Email: ${transaction['email']}", style: TextStyle(fontSize: 14)),
                            SizedBox(height: 8),
                            Text("Emergency Contact: ${transaction['emergencyContact']}", style: TextStyle(fontSize: 14)),
                            SizedBox(height: 8),
                            Text("Preferences: ${transaction['preferences']}", style: TextStyle(fontSize: 14)),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

// Add Hijab Accessories to Firestore
Future<void> addHijabAccessoriesToFirestore() async {
  CollectionReference accessories = FirebaseFirestore.instance.collection('hijab_accessories');

  await accessories.add({
    'name': 'Silk Hijab',
    'price': 250,
    'usage': 'Daily wear',
    'imageUrl': 'assets/silk_hijab.jpeg',
    'description': 'A soft and elegant silk hijab suitable for everyday use.',
    'category': 'Hijabs',
    'reviews': [],
  });

  await accessories.add({
    'name': 'Chiffon Hijab',
    'price': 200,
    'usage': 'Special occasions',
    'imageUrl': 'assets/chiffon_hijab.jpeg',
    'description': 'Lightweight and flowy chiffon hijab for a graceful look.',
    'category': 'Hijabs',
    'reviews': [],
  });

  await accessories.add({
    'name': 'Cotton Hijab',
    'price': 150,
    'usage': 'Casual wear',
    'imageUrl': 'assets/cotton_hijab.jpeg',
    'description': 'Breathable cotton hijab perfect for hot weather.',
    'category': 'Hijabs',
    'reviews': [],
  });

  await accessories.add({
    'name': 'Hijab Pin Set',
    'price': 50,
    'usage': 'Securing hijab',
    'imageUrl': 'assets/hijab_pins.jpeg',
    'description': 'A set of decorative pins to secure your hijab in style.',
    'category': 'Accessories',
    'reviews': [],
  });

  await accessories.add({
    'name': 'Under Scarf Cap',
    'price': 100,
    'usage': 'Base layer',
    'imageUrl': 'assets/under_scarf.jpeg',
    'description': 'Comfortable cap to wear under your hijab for extra coverage.',
    'category': 'Accessories',
    'reviews': [],
  });

  await accessories.add({
    'name': 'Hijab Magnet',
    'price': 80,
    'usage': 'Securing hijab',
    'imageUrl': 'assets/hijab_magnet.jpeg',
    'description': 'Strong magnets for a pin-free hijab styling option.',
    'category': 'Accessories',
    'reviews': [],
  });

  await accessories.add({
    'name': 'Printed Hijab',
    'price': 180,
    'usage': 'Fashion wear',
    'imageUrl': 'assets/printed_hijab.jpeg',
    'description': 'Stylish hijab with vibrant prints for a trendy look.',
    'category': 'Hijabs',
    'reviews': [],
  });

  await accessories.add({
    'name': 'Lace Trim Hijab',
    'price': 300,
    'usage': 'Formal events',
    'imageUrl': 'assets/lace_hijab.jpeg',
    'description': 'Elegant hijab with lace trim for special occasions.',
    'category': 'Hijabs',
    'reviews': [],
  });

  await accessories.add({
    'name': 'Hijab Brooch',
    'price': 120,
    'usage': 'Decoration',
    'imageUrl': 'assets/hijab_brooch.jpeg',
    'description': 'A beautiful brooch to enhance your hijab style.',
    'category': 'Accessories',
    'reviews': [],
  });

  await accessories.add({
    'name': 'Jersey Hijab',
    'price': 170,
    'usage': 'Daily wear',
    'imageUrl': 'assets/jersey_hijab.jpeg',
    'description': 'Stretchy and comfortable jersey hijab for all-day wear.',
    'category': 'Hijabs',
    'reviews': [],
  });

  print("Hijab accessories added to Firestore!");
}*/
