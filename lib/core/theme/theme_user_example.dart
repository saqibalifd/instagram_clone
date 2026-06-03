// import 'package:flutter/material.dart';
// import 'app_theme.dart'; // your theme file

// void main() {
//   runApp(const MyApp());
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // 1. WIRE UP THE THEME — do this once, everything inherits automatically
// // ─────────────────────────────────────────────────────────────────────────────

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Instagram Clone',
//       theme: AppTheme.light, // light mode
//       darkTheme: AppTheme.dark, // dark mode
//       themeMode: ThemeMode.system, // follows device setting
//       // themeMode: ThemeMode.dark,   // force dark
//       // themeMode: ThemeMode.light,  // force light
//       home: const DemoScreen(),
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // 2. HOW TO ACCESS THEME IN ANY WIDGET
// // ─────────────────────────────────────────────────────────────────────────────

// class DemoScreen extends StatelessWidget {
//   const DemoScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // Always grab these two — they give you everything
//     final tt = Theme.of(context).textTheme; // text styles
//     final cs = Theme.of(context).colorScheme; // colors

//     return Scaffold(
//       // ── Scaffold background comes from theme automatically ──────────────
//       // No need to set backgroundColor here unless you want to override it
//       // e.g. Splash screen override: backgroundColor: IGColors.splashBg
//       appBar: AppBar(
//         title: const Text('Instagram'), // uses titleTextStyle from theme
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.add_box_outlined),
//             // icon color comes from appBarTheme.actionsIconTheme automatically
//             onPressed: () {},
//           ),
//         ],
//       ),

//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // ── TEXT STYLES ─────────────────────────────────────────────────
//             Text('Display Large — Profile Name', style: tt.displayLarge),
//             const SizedBox(height: 4),
//             Text('Headline Medium — Post Username', style: tt.headlineMedium),
//             const SizedBox(height: 4),
//             Text(
//               'Body Large — Caption or bio text goes here',
//               style: tt.bodyLarge,
//             ),
//             const SizedBox(height: 4),
//             Text('Body Small — 2 hours ago', style: tt.bodySmall),
//             const SizedBox(height: 4),
//             Text('Label Large — FOLLOW', style: tt.labelLarge),
//             const SizedBox(height: 24),

//             // ── COLORS FROM COLOR SCHEME ─────────────────────────────────────
//             // Use cs.* for adaptive light/dark colors
//             Container(
//               padding: const EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 color: cs.surfaceContainerHighest, // card background
//                 borderRadius: BorderRadius.circular(12),
//                 border: Border.all(color: cs.outline, width: 0.5),
//               ),
//               child: Text('Card surface color', style: tt.bodyMedium),
//             ),
//             const SizedBox(height: 12),

//             // Use IGColors.* for fixed brand colors (same in light & dark)
//             Container(
//               padding: const EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 color: IGColors.pink.withValues(alpha: 0.1),
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Text(
//                 'Brand pink tint',
//                 style: tt.bodyMedium?.copyWith(color: IGColors.pink),
//               ),
//             ),
//             const SizedBox(height: 24),

//             // ── BUTTONS ──────────────────────────────────────────────────────
//             // All button styles come from theme — no extra styling needed
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: () {},
//                 child: const Text('Follow'), // pink filled button
//               ),
//             ),
//             const SizedBox(height: 8),
//             SizedBox(
//               width: double.infinity,
//               child: OutlinedButton(
//                 onPressed: () {},
//                 child: const Text('Message'), // outlined button
//               ),
//             ),
//             const SizedBox(height: 8),
//             TextButton(
//               onPressed: () {},
//               child: const Text('Forgot password?'), // blue text button
//             ),
//             const SizedBox(height: 24),

//             // ── TEXT FIELD ───────────────────────────────────────────────────
//             const TextField(
//               decoration: InputDecoration(
//                 hintText: 'Search',
//                 prefixIcon: Icon(Icons.search),
//               ),
//             ),
//             const SizedBox(height: 8),
//             const TextField(
//               obscureText: true,
//               decoration: InputDecoration(
//                 hintText: 'Password',
//                 prefixIcon: Icon(Icons.lock_outline),
//               ),
//             ),
//             const SizedBox(height: 24),

//             // ── CARD ─────────────────────────────────────────────────────────
//             Card(
//               child: ListTile(
//                 leading: const CircleAvatar(
//                   backgroundImage: NetworkImage(
//                     'https://i.pravatar.cc/150?img=3',
//                   ),
//                 ),
//                 title: Text('username', style: tt.headlineSmall),
//                 subtitle: Text('Liked your photo', style: tt.bodySmall),
//                 trailing: TextButton(
//                   onPressed: () {},
//                   child: const Text('Follow'),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 24),

//             // ── STORY RING GRADIENT ──────────────────────────────────────────
//             Row(children: List.generate(4, (i) => _StoryAvatar(index: i))),
//             const SizedBox(height: 24),

//             // ── DIVIDER ──────────────────────────────────────────────────────
//             const Divider(), // thickness + color from theme automatically
//             const SizedBox(height: 24),

//             // ── LIKE BUTTON (semantic color) ─────────────────────────────────
//             Row(
//               children: [
//                 IconButton(
//                   icon: const Icon(Icons.favorite_border),
//                   color: cs.onSurface, // default: matches text
//                   onPressed: () {},
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.favorite),
//                   color: IGColors.like, // red when liked
//                   onPressed: () {},
//                 ),
//                 const Spacer(),
//                 IconButton(
//                   icon: const Icon(Icons.bookmark_border),
//                   color: cs.onSurface,
//                   onPressed: () {},
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),

//       // ── BOTTOM NAV ────────────────────────────────────────────────────────
//       bottomNavigationBar: NavigationBar(
//         destinations: const [
//           NavigationDestination(
//             icon: Icon(Icons.home_outlined),
//             selectedIcon: Icon(Icons.home),
//             label: 'Home',
//           ),
//           NavigationDestination(
//             icon: Icon(Icons.search),
//             selectedIcon: Icon(Icons.search),
//             label: 'Search',
//           ),
//           NavigationDestination(
//             icon: Icon(Icons.add_box_outlined),
//             selectedIcon: Icon(Icons.add_box),
//             label: 'Post',
//           ),
//           NavigationDestination(
//             icon: Icon(Icons.favorite_outline),
//             selectedIcon: Icon(Icons.favorite),
//             label: 'Activity',
//           ),
//           NavigationDestination(
//             icon: Icon(Icons.person_outline),
//             selectedIcon: Icon(Icons.person),
//             label: 'Profile',
//           ),
//         ],
//         selectedIndex: 0,
//         onDestinationSelected: (_) {},
//         // backgroundColor, height, label behavior — all from theme
//       ),

//       floatingActionButton: FloatingActionButton(
//         onPressed: () {},
//         child: const Icon(Icons.camera_alt_outlined),
//         // color comes from theme automatically
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // 3. STORY RING — using IGColors.storyRing gradient
// // ─────────────────────────────────────────────────────────────────────────────

// class _StoryAvatar extends StatelessWidget {
//   final int index;
//   const _StoryAvatar({required this.index});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(right: 12),
//       child: Container(
//         padding: const EdgeInsets.all(2.5), // gap between ring and avatar
//         decoration: const BoxDecoration(
//           gradient: IGColors.storyRing,
//           shape: BoxShape.circle,
//         ),
//         child: Container(
//           padding: const EdgeInsets.all(2), // white border
//           decoration: BoxDecoration(
//             color: Theme.of(context).colorScheme.surface,
//             shape: BoxShape.circle,
//           ),
//           child: CircleAvatar(
//             radius: 28,
//             backgroundImage: NetworkImage(
//               'https://i.pravatar.cc/150?img=$index',
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // 4. SPLASH SCREEN — black background override
// // ─────────────────────────────────────────────────────────────────────────────

// class SplashView extends StatelessWidget {
//   const SplashView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: IGColors.splashBg, // always black, ignores theme
//       body: Center(
//         child: Image.asset('assets/icons/instaCloneAppLogo.png', height: 100),
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // 5. QUICK REFERENCE — copy-paste snippets
// // ─────────────────────────────────────────────────────────────────────────────
// //
// // Get theme in any widget:
// //   final tt = Theme.of(context).textTheme;
// //   final cs = Theme.of(context).colorScheme;
// //
// // Text styles:
// //   tt.displayLarge      → big profile name
// //   tt.headlineMedium    → post username
// //   tt.bodyLarge         → caption / bio
// //   tt.bodySmall         → timestamp / meta
// //   tt.labelLarge        → button text
// //
// // Adaptive colors (change with light/dark mode):
// //   cs.surface                    → scaffold / screen background
// //   cs.surfaceContainerHighest    → card / input background
// //   cs.onSurface                  → primary text color
// //   cs.onSurfaceVariant           → muted / secondary text
// //   cs.outline                    → dividers, borders
// //   cs.primary                    → pink accent
// //   cs.secondary                  → blue (links, verified)
// //   cs.error                      → red (errors, like)
// //
// // Fixed brand colors (never change):
// //   IGColors.pink         → #E1306C
// //   IGColors.blue         → #0095F6
// //   IGColors.like         → #ED4956
// //   IGColors.splashBg     → #000000
// //   IGColors.storyRing    → gradient
