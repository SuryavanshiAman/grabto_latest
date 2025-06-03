import 'dart:async';
import 'dart:io';
import 'package:app_links/app_links.dart';
import 'package:grabto/generated/assets.dart';
import 'package:grabto/helper/user_provider.dart';
import 'package:grabto/theme/theme.dart';
import 'package:grabto/ui/coupon_fullview_screen.dart';
import 'package:grabto/ui/signup_screen.dart';
import 'package:grabto/ui/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:grabto/view_model/add_flick_view_model.dart';
import 'package:grabto/view_model/add_heighlight_view_model.dart';
import 'package:grabto/view_model/add_post_view_model.dart';
import 'package:grabto/view_model/add_rivew_view_model.dart';
import 'package:grabto/view_model/different_location_view_model.dart';
import 'package:grabto/view_model/explore_view_model.dart';
import 'package:grabto/view_model/filter_view_model.dart';
import 'package:grabto/view_model/flicks_view_model.dart';
import 'package:grabto/view_model/follow_view_model.dart';
import 'package:grabto/view_model/get_all_user_highlight_view_model.dart';
import 'package:grabto/view_model/get_flick_view_model.dart';
import 'package:grabto/view_model/get_highlight_view_model.dart';
import 'package:grabto/view_model/get_post_view_model.dart';
import 'package:grabto/view_model/get_review_view_model.dart';
import 'package:grabto/view_model/get_wallet_view_model.dart';
import 'package:grabto/view_model/grabto_grab_view_model.dart';
import 'package:grabto/view_model/like_view_model.dart';
import 'package:grabto/view_model/menu_data_view_model.dart';
import 'package:grabto/view_model/menu_type_view_model.dart';
import 'package:grabto/view_model/my_followers_view_model.dart';
import 'package:grabto/view_model/my_following_view_model.dart';
import 'package:grabto/view_model/my_saved_flick_view_model.dart';
import 'package:grabto/view_model/near_me_image_view_model.dart';
import 'package:grabto/view_model/profile_view_model.dart';
import 'package:grabto/view_model/recommended_view_model.dart';
import 'package:grabto/view_model/restaurants_flicks_view_model.dart';
import 'package:grabto/view_model/save_flick_view_model.dart';
import 'package:grabto/view_model/similar_restro_view_model.dart';
import 'package:grabto/view_model/un_follow_view_model.dart';
import 'package:grabto/view_model/un_like_view_model.dart';
import 'package:grabto/view_model/un_save_flick_view_model.dart';
import 'package:grabto/view_model/update_cover_image_view_model.dart';
import 'package:grabto/view_model/update_profile_view_model.dart';
import 'package:grabto/view_model/user_post_like_view_model.dart';
import 'package:grabto/view_model/user_post_un_like_view_model.dart';
import 'package:grabto/view_model/vibe_view_model.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:rxdart/rxdart.dart';

import 'helper/location_provider.dart';
final _messageStreamController = BehaviorSubject<RemoteMessage>();

// TODO: Define the background message handler
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  if (kDebugMode) {
    print("Handling a background message: ${message.messageId}");
    print('Message data: ${message.data}');
    print('Message notification: ${message.notification?.title}');
    print('Message notification: ${message.notification?.body}');
  }
}

//For network resolution
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();


  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final messaging = FirebaseMessaging.instance;

  final settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  if (kDebugMode) {
    print('Permission granted: ${settings.authorizationStatus}');
  }

  // It requests a registration token for sending messages to users from your App server or other trusted server environment.
  String? token = await messaging.getToken();

  if (kDebugMode) {
    print('Registration Token= $token');
  }

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    if (kDebugMode) {
      print('Handling a foreground message: ${message.messageId}');
      print('Message data: ${message.data}');
      print('Message notification: ${message.notification?.title}');
      print('Message notification: ${message.notification?.body}');
    }

    _messageStreamController.sink.add(message);
  });

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(MyApp(token));
}

class MyApp extends StatefulWidget {
  final String? token;
  static bool hasHandledDeepLink = false;

  const MyApp(this.token, {super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  StreamSubscription? _sub;
  late final AppLinks _appLinks;
  bool _hasHandledDeepLink = false;
  @override
  void initState() {
    super.initState();
    initDeepLinks();
    // checkForUpdate();
  }

  bool hasHandledDeepLink = false;
  Future<void> initDeepLinks() async {
    _appLinks = AppLinks();

    try {
      final Uri? initialUri = await _appLinks.getInitialLink();
      handleIncomingLink(initialUri?.toString());
    } catch (e) {
      print('Error getting initial link: $e');
    }

    // Listen for background/foreground links
    _appLinks.uriLinkStream.listen((Uri? uri) {
      handleIncomingLink(uri?.toString());
    });
  }


  void handleIncomingLink(String? link) {
    if (link != null && !_hasHandledDeepLink) {
      _hasHandledDeepLink = true; // Prevent multiple navigations
      final uri = Uri.parse(link);
      final segments = uri.pathSegments;

      if (segments.isNotEmpty) {
        if (segments.first == 'restaurants' && segments.length > 1) {
          final restaurantId = segments[1];
          navigatorKey.currentState?.pushReplacement(
            MaterialPageRoute(
              builder: (_) => CouponFullViewScreen(restaurantId),
            ),
          );
          return;
        }

        final referralCode = segments.first;
        navigatorKey.currentState?.pushReplacement(
          MaterialPageRoute(
            builder: (_) => SignupScreen(referralCode: referralCode, mobile: '', type:"1"),
          ),
        );
      }
    }
  }
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  void showUpdatePopup() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
          alignment: Alignment.center,
          backgroundColor: MyColors.redBG,
          content: Container(
            padding: const EdgeInsets.all(15),
            height: heights*0.27,
            child: Column(
              children: [
                const Text("Update your app!",style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: MyColors.whiteBG),),
                Image.asset(Assets.imagesGrabtoLogoWithText,height: heights*0.13,),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      height: heights*0.05,
                      width: widths*0.25,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: MyColors.whiteBG,
                      ),
                      child:  const Text("Later",style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: MyColors.blackBG),),),

                    InkWell(
                        onTap: (){
                          Navigator.of(context).pop();
                          // startImmediateUpdate();
                        },
                        child: Container(
                            alignment: Alignment.center,
                            height: heights*0.05,
                            width: widths*0.25,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: MyColors.whiteBG,
                            ),

                            child: const Text("Update",style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: MyColors.blackBG),)))
                  ],
                )
              ],
            ),
          )
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    heights=MediaQuery.of(context).size.height;
    widths=MediaQuery.of(context).size.width;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => Address()),
        ChangeNotifierProvider(create: (_) => FilterViewModel()),
        ChangeNotifierProvider(create: (_) => DifferentLocationViewModel()),
        ChangeNotifierProvider(create: (_) => GrabtoGrabViewModel()),
        ChangeNotifierProvider(create: (_) => SimilarRestroViewModel()),
        ChangeNotifierProvider(create: (_) => RecommendedViewModel()),
        ChangeNotifierProvider(create: (_) => VibeViewModel()),
        ChangeNotifierProvider(create: (_) => RestaurantsFlicksViewModel()),
        ChangeNotifierProvider(create: (_) => MenuDataViewModel()),
        ChangeNotifierProvider(create: (_) => MenuTypeViewModel()),
        ChangeNotifierProvider(create: (_) => GetWalletViewModel()),
        ChangeNotifierProvider(create: (_) => NearMeImageViewModel()),
        ChangeNotifierProvider(create: (_) => FlicksViewModel()),
        ChangeNotifierProvider(create: (_) => AddPostViewModel()),
        ChangeNotifierProvider(create: (_) => GetPostViewModel()),
        ChangeNotifierProvider(create: (_) => AddFlickViewModel()),
        ChangeNotifierProvider(create: (_) => AddHighlightViewModel()),
        ChangeNotifierProvider(create: (_) => AddReviewViewModel()),
        ChangeNotifierProvider(create: (_) => GetFlickViewModel()),
        ChangeNotifierProvider(create: (_) => GetHighlightViewModel()),
        ChangeNotifierProvider(create: (_) => GetReviewViewModel()),
        ChangeNotifierProvider(create: (_) => ProfileViewModel()),
        ChangeNotifierProvider(create: (_) => UpdateCoverImageViewModel()),
        ChangeNotifierProvider(create: (_) => UpdateProfileViewModel()),
        ChangeNotifierProvider(create: (_) => SaveFlickViewModel()),
        ChangeNotifierProvider(create: (_) => UnSaveFlickViewModel()),
        ChangeNotifierProvider(create: (_) => MySavedFlickViewModel()),
        ChangeNotifierProvider(create: (_) => MyFollowersViewModel()),
        ChangeNotifierProvider(create: (_) => MyFollowingViewModel()),
        ChangeNotifierProvider(create: (_) => FollowViewModel()),
        ChangeNotifierProvider(create: (_) => UnFollowViewModel()),
        ChangeNotifierProvider(create: (_) => LikeViewModel()),
        ChangeNotifierProvider(create: (_) => UnLikeViewModel()),
        ChangeNotifierProvider(create: (_) => ExploreViewModel()),
        ChangeNotifierProvider(create: (_) => UserPostLikeViewModel()),
        ChangeNotifierProvider(create: (_) => UserPostUnLikeViewModel()),
        ChangeNotifierProvider(create: (_) => GetAllUserHighlightViewModel()),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        title: 'Grabto',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          fontFamily: 'ubuntu',
          useMaterial3: true,
        ),
        home: SplashScreen(
          token: widget.token,
        ),
      ),
    );
  }
}
double heights=0.0;
double widths=0.0;