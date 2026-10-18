import 'package:flutter/material.dart';

void main() => runApp(const NovaCraftApp());

const Color bg = Color(0xFF0B1110);
const Color panel = Color(0xFF141E1B);
const Color green = Color(0xFF69E58B);
const Color muted = Color(0xFF9BAEA5);

class NovaCraftApp extends StatefulWidget {
  const NovaCraftApp({super.key});
  @override
  State<NovaCraftApp> createState() => _NovaCraftAppState();
}

class _NovaCraftAppState extends State<NovaCraftApp> {
  bool darkMode = true;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NovaCraft',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: darkMode ? Brightness.dark : Brightness.light,
        scaffoldBackgroundColor: darkMode ? bg : const Color(0xFFF3F7F4),
        colorScheme: ColorScheme.fromSeed(seedColor: green, brightness: darkMode ? Brightness.dark : Brightness.light),
        useMaterial3: true,
      ),
      home: LauncherHome(darkMode: darkMode, onThemeChanged: (v) => setState(() => darkMode = v)),
    );
  }
}

class LauncherHome extends StatefulWidget {
  final bool darkMode;
  final ValueChanged<bool> onThemeChanged;
  const LauncherHome({super.key, required this.darkMode, required this.onThemeChanged});
  @override
  State<LauncherHome> createState() => _LauncherHomeState();
}

class _LauncherHomeState extends State<LauncherHome> {
  int tab = 0;
  String version = '1.21.1';
  String loader = 'Vanilla';
  String resolution = '1280 × 720';
  double ram = 3;
  String accountName = '';
  final TextEditingController modController = TextEditingController();
  final List<String> mods = [];
  final List<String> versions = ['1.21.8', '1.21.4', '1.21.1', '1.20.4', '1.19.4', '1.16.5', '1.12.2'];
  final List<String> loaderOptions = ['Vanilla', 'Fabric', 'Forge', 'NeoForge'];

  @override
  void dispose() {
    modController.dispose();
    super.dispose();
  }

  void message(String text) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text), behavior: SnackBarBehavior.floating));

  @override
  Widget build(BuildContext context) {
    final pages = [homePage(), versionsPage(), modsPage(), filesPage(), settingsPage(), accountPage()];
    return Scaffold(
      body: SafeArea(child: Column(children: [topBar(), Expanded(child: IndexedStack(index: tab, children: pages)), bottomNav()])),
    );
  }

  Widget topBar() => Padding(
    padding: const EdgeInsets.fromLTRB(18, 14, 18, 10),
    child: Row(children: [
      Container(width: 46, height: 46, decoration: BoxDecoration(color: green.withOpacity(.13), borderRadius: BorderRadius.circular(15), border: Border.all(color: green.withOpacity(.35))), child: const Icon(Icons.videogame_asset, color: green, size: 27)),
      const SizedBox(width: 12),
      const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('NovaCraft', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)), Text('MINECRAFT JAVA LAUNCHER', style: TextStyle(fontSize: 9, letterSpacing: 1.5, color: muted))])),
      IconButton(onPressed: () => setState(() => tab = 4), icon: const Icon(Icons.settings_outlined, color: muted), tooltip: 'تنظیمات'),
    ]),
  );

  Widget homePage() => ListView(padding: const EdgeInsets.fromLTRB(18, 8, 18, 22), children: [
    Container(height: 176, padding: const EdgeInsets.all(20), decoration: BoxDecoration(borderRadius: BorderRadius.circular(24), gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF214A35), Color(0xFF14251E), Color(0xFF111816)]), border: Border.all(color: green.withOpacity(.25))), child: Stack(children: [
      Positioned(right: -4, bottom: -20, child: Icon(Icons.grid_4x4, size: 132, color: Colors.white.withOpacity(.05))),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5), decoration: BoxDecoration(color: green.withOpacity(.15), borderRadius: BorderRadius.circular(30)), child: const Text('لانچر اندروید', style: TextStyle(color: green, fontSize: 11, fontWeight: FontWeight.w700))), const Spacer(), const Text('ماجراجویی شروع می‌شود', style: TextStyle(fontSize: 21, fontWeight: FontWeight.w800)), const SizedBox(height: 6), const Text('نسخه و تنظیماتت را آماده کن.', style: TextStyle(color: muted, fontSize: 12))]),
    ])),
    const SizedBox(height: 20), const SectionTitle('نسخهٔ بازی'), const SizedBox(height: 10), versionCard(), const SizedBox(height: 12),
    Container(padding: const EdgeInsets.all(15), decoration: BoxDecoration(color: panel, borderRadius: BorderRadius.circular(16)), child: Row(children: [const Icon(Icons.memory, color: green), const SizedBox(width: 12), const Expanded(child: Text('حافظهٔ اختصاص‌یافته', style: TextStyle(fontWeight: FontWeight.w700))), Text('${ram.toStringAsFixed(1)} GB', style: const TextStyle(color: green, fontWeight: FontWeight.bold))])),
    const SizedBox(height: 18), SizedBox(height: 58, child: FilledButton.icon(onPressed: () => message('موتور اجرای Minecraft هنوز متصل نیست؛ این دکمه فعلاً بازی را اجرا نمی‌کند.'), icon: const Icon(Icons.play_arrow_rounded, size: 30), label: const Text('اجرای بازی', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800)), style: FilledButton.styleFrom(backgroundColor: green, foregroundColor: const Color(0xFF082012), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18))))),
    const SizedBox(height: 12), const InfoTile(icon: Icons.info_outline, title: 'وضعیت پروژه', description: 'رابط کاربری و تنظیمات این نسخه فعال‌اند؛ اجرای واقعی بازی به موتور سازگار Minecraft Java نیاز دارد.'),
    const SizedBox(height: 18), const SectionTitle('میانبرها'), const SizedBox(height: 10), Row(children: [Expanded(child: Shortcut(icon: Icons.layers_outlined, label: 'نسخه‌ها', onTap: () => setState(() => tab = 1))), const SizedBox(width: 8), Expanded(child: Shortcut(icon: Icons.extension_outlined, label: 'مودها', onTap: () => setState(() => tab = 2))), const SizedBox(width: 8), Expanded(child: Shortcut(icon: Icons.folder_outlined, label: 'فایل‌ها', onTap: () => setState(() => tab = 3)))]),
  ]);

  Widget versionCard() => Container(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4), decoration: BoxDecoration(color: panel, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.white.withOpacity(.07))), child: Row(children: [Container(width: 40, height: 40, decoration: BoxDecoration(color: green.withOpacity(.12), borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.view_in_ar_outlined, color: green)), const SizedBox(width: 12), const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Minecraft Java', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)), SizedBox(height: 3), Text('نسخهٔ انتخاب‌شده', style: TextStyle(color: muted, fontSize: 11))])), DropdownButtonHideUnderline(child: DropdownButton<String>(value: version, dropdownColor: panel, items: versions.map((v) => DropdownMenuItem(value: v, child: Text(v, style: const TextStyle(fontSize: 12)))).toList(), onChanged: (v) { if (v != null) setState(() => version = v); }))]));

  Widget versionsPage() => ListView(padding: const EdgeInsets.all(18), children: [const PageHeading(icon: Icons.layers_outlined, title: 'نسخه‌ها', subtitle: 'نسخهٔ موردنظرت را برای پیکربندی انتخاب کن.'), const SizedBox(height: 18), ...versions.map((v) => Card(color: panel, child: ListTile(leading: Icon(version == v ? Icons.check_circle : Icons.circle_outlined, color: version == v ? green : muted), title: Text('Minecraft Java $v'), subtitle: Text(version == v ? 'انتخاب‌شده' : 'در این رابط انتخاب‌پذیر است؛ هنوز دانلود نشده'), trailing: version == v ? const Icon(Icons.check, color: green) : null, onTap: () => setState(() => version = v)))), const SizedBox(height: 10), const InfoTile(icon: Icons.cloud_download_outlined, title: 'دانلود نسخه‌ها', description: 'دریافت فایل‌های رسمی بازی هنوز به موتور لانچر متصل نشده است.')]);

  Widget modsPage() => ListView(padding: const EdgeInsets.all(18), children: [const PageHeading(icon: Icons.extension_outlined, title: 'مودها و مودپک‌ها', subtitle: 'نام مودها را در این فهرست محلی مدیریت کن.'), const SizedBox(height: 18), TextField(controller: modController, decoration: InputDecoration(hintText: 'نام مود یا مودپک', filled: true, fillColor: panel, border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none), prefixIcon: const Icon(Icons.extension), suffixIcon: IconButton(icon: const Icon(Icons.add_circle, color: green), onPressed: addMod)), onSubmitted: (_) => addMod()), const SizedBox(height: 12), if (mods.isEmpty) const InfoTile(icon: Icons.inventory_2_outlined, title: 'فهرست خالی است', description: 'نام یک مود را وارد و روی + بزن. این فهرست فعلاً محلی است و فایل مود نصب نمی‌کند.') else ...mods.asMap().entries.map((e) => Card(color: panel, child: ListTile(leading: const Icon(Icons.extension, color: green), title: Text(e.value), subtitle: Text('هدف نسخه: $version · $loader'), trailing: IconButton(icon: const Icon(Icons.delete_outline), onPressed: () => setState(() => mods.removeAt(e.key))))), const SizedBox(height: 16), const InfoTile(icon: Icons.warning_amber_outlined, title: 'سازگاری', description: 'مودها باید با نسخهٔ بازی و مودلودر سازگار باشند. نصب و اعتبارسنجی واقعی هنوز پیاده‌سازی نشده است.')]);

  void addMod() { final value = modController.text.trim(); if (value.isEmpty) return; setState(() { mods.add(value); modController.clear(); }); }

  Widget filesPage() => ListView(padding: const EdgeInsets.all(18), children: [const PageHeading(icon: Icons.folder_outlined, title: 'فایل‌ها و دنیاها', subtitle: 'مدیریت فایل‌های بازی در نسخه‌های بعدی به موتور اجرا متصل می‌شود.'), const SizedBox(height: 18), const InfoTile(icon: Icons.public, title: 'دنیاهای ذخیره‌شده', description: 'دسترسی به پوشهٔ saves هنوز فعال نشده است.'), const SizedBox(height: 10), const InfoTile(icon: Icons.image_outlined, title: 'بسته‌های منابع', description: 'مدیریت resource pack و shader هنوز فعال نشده است.'), const SizedBox(height: 10), const InfoTile(icon: Icons.folder_zip_outlined, title: 'فایل‌های نصب', description: 'انتخاب فایل‌های محلی و نصب خودکار هنوز پیاده‌سازی نشده است.')]);

  Widget settingsPage() => ListView(padding: const EdgeInsets.all(18), children: [const PageHeading(icon: Icons.settings_outlined, title: 'تنظیمات', subtitle: 'تنظیمات رابط و گزینه‌های پیشنهادی اجرای بازی.'), const SizedBox(height: 16), Card(color: panel, child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('حافظهٔ رم', style: TextStyle(fontWeight: FontWeight.w800)), Text('${ram.toStringAsFixed(1)} GB', style: const TextStyle(color: green)), Slider(value: ram, min: 1, max: 8, divisions: 14, label: '${ram.toStringAsFixed(1)} GB', onChanged: (v) => setState(() => ram = v)), const Text('مقدار واقعی قابل استفاده به حافظهٔ دستگاه بستگی دارد.', style: TextStyle(color: muted, fontSize: 11))]))), const SizedBox(height: 10), Card(color: panel, child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('مودلودر', style: TextStyle(fontWeight: FontWeight.w800)), const SizedBox(height: 8), DropdownButtonFormField<String>(value: loader, decoration: const InputDecoration(border: OutlineInputBorder()), items: loaderOptions.map((x) => DropdownMenuItem(value: x, child: Text(x))).toList(), onChanged: (v) { if (v != null) setState(() => loader = v); })]))), const SizedBox(height: 10), Card(color: panel, child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('وضوح تصویر', style: TextStyle(fontWeight: FontWeight.w800)), const SizedBox(height: 8), DropdownButtonFormField<String>(value: resolution, decoration: const InputDecoration(border: OutlineInputBorder()), items: ['854 × 480', '1280 × 720', '1600 × 900', '1920 × 1080'].map((x) => DropdownMenuItem(value: x, child: Text(x))).toList(), onChanged: (v) { if (v != null) setState(() => resolution = v); })]))), const SizedBox(height: 10), SwitchListTile(value: widget.darkMode, onChanged: widget.onThemeChanged, tileColor: panel, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)), secondary: const Icon(Icons.dark_mode_outlined, color: green), title: const Text('پوستهٔ تیره'), subtitle: const Text('ظاهر برنامه', style: TextStyle(color: muted)))]);

  Widget accountPage() => ListView(padding: const EdgeInsets.all(18), children: [const PageHeading(icon: Icons.account_circle_outlined, title: 'حساب کاربری', subtitle: 'ورود امن باید از مسیر رسمی و سازگار اضافه شود.'), const SizedBox(height: 18), TextField(decoration: const InputDecoration(labelText: 'نام نمایشی (محلی)', prefixIcon: Icon(Icons.person_outline), border: OutlineInputBorder()), onChanged: (v) => setState(() => accountName = v)), const SizedBox(height: 12), Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: panel, borderRadius: BorderRadius.circular(16)), child: Row(children: [const CircleAvatar(backgroundColor: Color(0xFF244C35), child: Icon(Icons.person, color: green)), const SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(accountName.isEmpty ? 'بازیکن مهمان' : accountName, style: const TextStyle(fontWeight: FontWeight.w800)), const Text('حساب محلی؛ ورود Minecraft انجام نشده', style: TextStyle(color: muted, fontSize: 11))]))])), const SizedBox(height: 12), const InfoTile(icon: Icons.verified_user_outlined, title: 'ورود رسمی', description: 'ورود Microsoft و بررسی مالکیت بازی هنوز متصل نشده است. رمز عبور را داخل این نسخه وارد نکن.')]);

  Widget bottomNav() { final items = [(Icons.home_rounded, 'خانه'), (Icons.layers_outlined, 'نسخه‌ها'), (Icons.extension_outlined, 'مودها'), (Icons.folder_outlined, 'فایل‌ها'), (Icons.settings_outlined, 'تنظیمات'), (Icons.person_outline, 'حساب')]; return Container(padding: const EdgeInsets.fromLTRB(4, 7, 4, 7), decoration: BoxDecoration(color: const Color(0xFF101715), border: Border(top: BorderSide(color: Colors.white.withOpacity(.06))),), child: Row(children: List.generate(items.length, (i) { final active = tab == i; return Expanded(child: InkWell(borderRadius: BorderRadius.circular(12), onTap: () => setState(() => tab = i), child: Padding(padding: const EdgeInsets.symmetric(vertical: 6), child: Column(mainAxisSize: MainAxisSize.min, children: [Icon(items[i].$1, color: active ? green : muted, size: 20), const SizedBox(height: 4), Text(items[i].$2, style: TextStyle(fontSize: 9, color: active ? green : muted, fontWeight: active ? FontWeight.w700 : FontWeight.w400))])))); }))); }
}

class PageHeading extends StatelessWidget { final IconData icon; final String title; final String subtitle; const PageHeading({super.key, required this.icon, required this.title, required this.subtitle}); @override Widget build(BuildContext context) => Column(children: [Icon(icon, size: 42, color: green), const SizedBox(height: 10), Text(title, style: const TextStyle(fontSize: 23, fontWeight: FontWeight.w800)), const SizedBox(height: 6), Text(subtitle, textAlign: TextAlign.center, style: const TextStyle(color: muted, fontSize: 12))]); }
class SectionTitle extends StatelessWidget { final String text; const SectionTitle(this.text, {super.key}); @override Widget build(BuildContext context) => Text(text, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800)); }
class InfoTile extends StatelessWidget { final IconData icon; final String title; final String description; const InfoTile({super.key, required this.icon, required this.title, required this.description}); @override Widget build(BuildContext context) => Container(padding: const EdgeInsets.all(15), decoration: BoxDecoration(color: panel, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.white.withOpacity(.06))), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Icon(icon, color: green), const SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)), const SizedBox(height: 4), Text(description, style: const TextStyle(color: muted, fontSize: 11, height: 1.45))]))])); }
class Shortcut extends StatelessWidget { final IconData icon; final String label; final VoidCallback onTap; const Shortcut({super.key, required this.icon, required this.label, required this.onTap}); @override Widget build(BuildContext context) => InkWell(onTap: onTap, borderRadius: BorderRadius.circular(16), child: Container(padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 6), decoration: BoxDecoration(color: panel, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.white.withOpacity(.06))), child: Column(children: [Icon(icon, color: green, size: 23), const SizedBox(height: 8), Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700))]))); }
