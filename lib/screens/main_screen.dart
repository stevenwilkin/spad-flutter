import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../db/entry_queries.dart';
import '../models/entry.dart';

const _monthNames = [
  '',
  'JANUARY', 'FEBRUARY', 'MARCH', 'APRIL', 'MAY', 'JUNE',
  'JULY', 'AUGUST', 'SEPTEMBER', 'OCTOBER', 'NOVEMBER', 'DECEMBER',
];

String _formatDate(int month, int day) => '$day ${_monthNames[month]}';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with WidgetsBindingObserver {
  Entry? entry;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkState();
    }
  }

  Future<void> _checkState() async {
    final now = DateTime.now();
    final fetched = await getEntry(month: now.month, day: now.day);
    if (fetched?.id != entry?.id) {
      setState(() => entry = fetched);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (entry == null) {
      return const Scaffold(backgroundColor: Color(0xFFFAF8F5));
    }

    final e = entry!;

    return Scaffold(
      backgroundColor: const Color(0xFFFAF8F5),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(28, 40, 28, 60),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                _formatDate(e.month, e.day),
                textAlign: TextAlign.center,
                style: GoogleFonts.lora(
                  fontSize: 11,
                  letterSpacing: 2.5,
                  color: const Color(0xFF888888),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                e.title!,
                textAlign: TextAlign.center,
                style: GoogleFonts.lora(
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                  height: 1.3,
                  color: const Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height: 28),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  e.quote!,
                  style: GoogleFonts.lora(
                    fontSize: 15,
                    fontStyle: FontStyle.italic,
                    height: 1.65,
                    color: const Color(0xFF2E2E2E),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Text(
                  '\u2013 ${e.quoteSource!}',
                  style: GoogleFonts.lora(
                    fontSize: 14,
                    height: 1.5,
                    color: const Color(0xFF555555),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ...e.body!.split('\n').map(
                (para) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    para,
                    style: GoogleFonts.lora(
                      fontSize: 16,
                      height: 1.75,
                      color: const Color(0xFF1A1A1A),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Text(
                e.closing!,
                textAlign: TextAlign.center,
                style: GoogleFonts.lora(
                  fontSize: 15,
                  fontStyle: FontStyle.italic,
                  height: 1.65,
                  color: const Color(0xFF444444),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
