import 'package:flutter/material.dart';

import 'category_landing_screen.dart';
import 'delete_account_screen.dart';
import 'forgot_password_screen.dart';
import 'home_screen.dart';
import 'login_screen.dart';
import 'onboarding_belong_screen.dart';
import 'onboarding_discover_screen.dart';
import 'onboarding_experience_screen.dart';
import 'product_reviews_screen.dart';
import 'product_detail_screen.dart';
import 'product_listing_screen.dart';
import 'profile_screen.dart';
import 'register_screen.dart';
import 'reset_password_screen.dart';
import 'search_discovery_screen.dart';
import 'shopping_bag_screen.dart';
import 'size_guide_screen.dart';
import 'splash_screen.dart';
import 'wishlist_screen.dart';
import 'checkout_delivery_screen.dart';
import 'checkout_payment_screen.dart';
import 'checkout_review_screen.dart';
import '../data/models/product.dart';

class ScreensHubScreen extends StatelessWidget {
  const ScreensHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = <_HubItem>[
      _HubItem('01 Splash', const SplashScreen()),
      _HubItem('03 Login', const LoginScreen()),
      _HubItem('02 Register', const RegisterScreen()),
      _HubItem('04 Forgot Password', const ForgotPasswordScreen()),
      _HubItem('05 Reset Password', const ResetPasswordScreen()),
      _HubItem('08 Home', const HomeScreen()),
      _HubItem('09 Search & Discovery', const SearchDiscoveryScreen()),
      _HubItem('11 Category Landing (Men)', const CategoryLandingScreen(departmentId: 'men')),
      _HubItem('11b Category Landing (Women)', const CategoryLandingScreen(departmentId: 'women')),
      _HubItem('12 Product Listing', const ProductListingScreen()),
      _HubItem(
        '13 Product Detail',
        ProductDetailScreen(
          product: const Product(
            id: 'preview',
            name: 'Preview Product',
            brand: 'ATELIER',
            categoryId: '',
            price: 0,
            currency: '',
            imageUrls: <String>[],
            description: '',
            isFeatured: false,
          ),
        ),
      ),
      _HubItem('14 Size Guide', const SizeGuideScreen()),
      _HubItem('15 Product Reviews', const ProductReviewsScreen()),
      _HubItem('16 Shopping Bag', const ShoppingBagScreen()),
      _HubItem('17 Checkout Step 1 - Delivery', const CheckoutDeliveryScreen()),
      _HubItem('17b Checkout Step 2 - Payment', const CheckoutPaymentScreen()),
      _HubItem('17c Checkout Step 3 - Review', const CheckoutReviewScreen()),
      _HubItem('18 Wishlist', const WishlistScreen()),
      _HubItem('26 Profile', const ProfileScreen()),
      _HubItem('07 Delete Account', const DeleteAccountScreen()),
      _HubItem('10a Onboarding Discover', const OnboardingDiscoverScreen()),
      _HubItem('10b Onboarding Experience', const OnboardingExperienceScreen()),
      _HubItem('10c Onboarding Belong', const OnboardingBelongScreen()),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Screens'),
      ),
      body: ListView.separated(
        itemCount: items.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final item = items[index];
          return ListTile(
            title: Text(item.title),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => item.screen));
            },
          );
        },
      ),
    );
  }
}

class _HubItem {
  _HubItem(this.title, this.screen);
  final String title;
  final Widget screen;
}

