import 'package:flutter_traning_app_1/data/get_adv_id_and_tz.dart';
import 'package:flutter_traning_app_1/data/get_url.dart';
import 'package:flutter_traning_app_1/data/shared_preferences.dart';
import 'package:flutter_traning_app_1/pages/home_page.dart';
import 'package:flutter_traning_app_1/pages/home_page_app.dart';
import 'package:flutter_traning_app_1/pages/home_page_web.dart';
import 'package:flutter_traning_app_1/riverpod/riverpod.dart';
import 'package:flutter_traning_app_1/utils/library.dart';

import 'package:flutter_traning_app_1/pages/exercise_page.dart';
import 'package:flutter_user_agentx/flutter_user_agent.dart';
import 'data/exercises.dart';

final container = ProviderContainer();
String url = '';
String? advertisingId = '';
String timezone = 'Unknown';
int homePageIndex = 2;
String userAgent = 'unknown';

void main() async {
  /// Check initialization
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterUserAgent.init();
  var webViewUserAgent = FlutterUserAgent.webViewUserAgent;
  userAgent = webViewUserAgent!;
  print(userAgent);
  /// Load url
  url = await LocalData().getUrl();
  if(url != ''){homePageIndex = 1;}
  container.read(homePageProvider.notifier).update((state) => 1);
  print('${container.read(homePageProvider)}');
  print('LOAD URL: $url');
  /// Get url from server
  if (url == '') {
    await GetAdvIdAndTZ().initPlatformState();
    await GetAdvIdAndTZ().initTimeZone();
    url = (await GetUrl().getHttp(advertisingId: advertisingId!, timezone: timezone))!;
    await LocalData().setUrl(url);
    if(url != ''){homePageIndex = 1;}else {homePageIndex = 0;}
  }

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,

        /// ThemeData
        theme: ThemeData(
          // useMaterial3: true,
          primarySwatch: Colors.blue,
        ),
        home: const HomePage(),
        routes: {
          '/homePage': (context) => const HomePage(),
          '/homePageApp': (context) => const HomePageApp(),
          '/homePageWeb': (context) => const HomePageWeb(),
          '/exercisePage': (context) => ExercisePage(
                /// Delete and check
                exercises: Exercises().listOfDayExercises[0],
              ),
        });
  }
}
