import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_firebase/global_widgets/custom_widget.dart';
import 'package:ecommerce_firebase/views/Authentication/LoginScreen/login_screen.dart';
import 'package:ecommerce_firebase/views/ProductsByCategory/pbc.dart';
import 'package:ecommerce_firebase/views/cart.dart';
import 'package:ecommerce_firebase/views/details/product_details.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../utils/colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> sliderImages = [
    'https://img.freepik.com/premium-vector/sale-banner-template-design_74379-121.jpg',
    'https://img.freepik.com/premium-vector/mega-sale-discount-banner-template-promotion_148524-1103.jpg',
    'https://img.freepik.com/premium-vector/modern-big-sale-banner_18622-513.jpg'
  ];

  List slider = [];

  Future getSliders() async {
    var data = await FirebaseFirestore.instance.collection('sliders').get();
    print(data.docs.length);
    setState(() {
      slider = data.docs;
    });
  }

  List<Map<String, String>> categories = [
    {
      'icon': 'assets/images/1.png',
    },
    {
      'icon': 'assets/images/2.png',
    },
    {
      'icon': 'assets/images/3.png',
    },
    {
      'icon': 'assets/images/4.png',
    },
    {
      'icon': 'assets/images/5.png',
    }
  ];

  List<Map<String, String>> products = [
    {
      'image':
          'https://i.ibb.co/8BntMyD/6-44mm-blu-889c7c8b-e883-41ab-856c-38c9dd970d12-1200x-removebg-preview-2.png',
      'price': '40',
    },
    {
      'image':
          'https://i.ibb.co/8BntMyD/6-44mm-blu-889c7c8b-e883-41ab-856c-38c9dd970d12-1200x-removebg-preview-2.png',
      'name': 'Apple Watch - 6',
    },
    {
      'image':
          'https://i.ibb.co/8BntMyD/6-44mm-blu-889c7c8b-e883-41ab-856c-38c9dd970d12-1200x-removebg-preview-2.png',
      'name': 'Casino Watch',
      'price': '80',
    },
    {
      'image':
          'https://i.ibb.co/8BntMyD/6-44mm-blu-889c7c8b-e883-41ab-856c-38c9dd970d12-1200x-removebg-preview-2.png',
      'name': 'Redmi Note 4',
      'price': '40',
    },
    {
      'image':
          'https://i.ibb.co/8BntMyD/6-44mm-blu-889c7c8b-e883-41ab-856c-38c9dd970d12-1200x-removebg-preview-2.png',
      'name': 'Apple Watch - 6',
      'price': '100',
    },
    {
      'image':
          'https://i.ibb.co/8BntMyD/6-44mm-blu-889c7c8b-e883-41ab-856c-38c9dd970d12-1200x-removebg-preview-2.png',
      'name': 'Casino Watch',
      'price': '80',
    },
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSliders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
          context: context,
          isLeading: const Icon(Icons.menu),
          action: [
            IconButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (route) => false,
                  );
                },
                icon: const Icon(Icons.logout))
          ]),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 15.0,
          vertical: 10,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Greetings
              const Text(
                'Hello Shirajul 👋',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
              ),
              Text(
                'Let’s start shopping!',
                style: TextStyle(color: Colors.black.withOpacity(.5)),
              ),
              Container(
                height: 150,
                margin: const EdgeInsets.only(top: 20, bottom: 15),
                width: double.infinity,
                child: CarouselSlider.builder(
                  itemCount: 2,
                  itemBuilder: (context, index, realIndex) {
                    return slider.isEmpty
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              image: DecorationImage(
                                image: NetworkImage(slider[index]['image']),
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                  },
                  options: CarouselOptions(
                    autoPlay: true,
                    autoPlayCurve: Curves.easeInOut,
                    enlargeCenterPage: true,
                  ),
                ),
              ),

              // Categories
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Top Categories',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'See All',
                      style: TextStyle(color: AppColors.primaryColor),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('categories')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return SizedBox(
                      height: 62,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        primary: false,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          final data = snapshot.data!.docs[index];
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => PBCScreen(
                                    data: data,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.only(right: 10),
                              width: 64,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: const Color(0xFFF2F2F2),
                                  border: Border.all(
                                      color: const Color(0xFFD8D3D3))),
                              child: Center(
                                child: Image.network(
                                  data['icon']!,
                                  width: 35,
                                  height: 35,
                                  color: Colors.black.withOpacity(.5),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }
                },
              ),

              // Recent Product
              const SizedBox(
                height: 15,
              ),
              const Text(
                'Recent Products',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
              ),
              const SizedBox(
                height: 15,
              ),
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('products')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 15,
                              mainAxisSpacing: 15,
                              childAspectRatio: .8),
                      itemCount: snapshot.data!.docs.length,
                      shrinkWrap: true,
                      primary: false,
                      itemBuilder: (context, index) {
                        final data = snapshot.data!.docs[index];
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => Details(data: data),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: const Color(0xFFF2F2F2),
                                borderRadius: BorderRadius.circular(15)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 120,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    image: DecorationImage(
                                      image: NetworkImage(data['image']!),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      IconButton(
                                        onPressed: () {},
                                        icon: Icon(
                                          Icons.favorite_border,
                                          color: Colors.black.withOpacity(.5),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        data['name'] ?? 'Default Title',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 15),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        '\$${data['price'] ?? '10'}',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
              Card(
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const Cart(),
                      ),
                    );
                  },
                  child: const Text('Cart'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
