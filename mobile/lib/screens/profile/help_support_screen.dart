import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../utils/theme/colors.dart';
import '../../widget/app_top_bar.dart';
import '../../widget/section_header.dart';

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  final _searchCtrl = TextEditingController();
  String _query = '';
  Future<void>? _launched;
  int? _openIndex; // ← tracks which FAQ tile is open

  final _faqs = [
    _FAQ(
      q: 'How do I create a task?',
      a: 'Tap the + button on the Home screen or navigate to the Tasks tab '
          'and tap "Add Task". Fill in the title, description, due date and '
          'priority, then tap Create.',
    ),
    _FAQ(
      q: 'Can I edit a task after creating it?',
      a: 'Open any task by tapping its tile. From the Task Detail screen you '
          'can mark it complete or delete it.',
    ),
    _FAQ(
      q: 'What do the priority levels mean?',
      a: 'HIGH (red) = urgent, do today.\n'
          'MEDIUM (yellow) = normal priority.\n'
          'LOW (green) = nice-to-have, no rush.',
    ),
    _FAQ(
      q: 'Is my data synced to the cloud?',
      a: 'Yes — all tasks are synced to a REST API in real time. Your data is '
          'accessible on every device you sign in to.',
    ),
    _FAQ(
      q: 'How do I filter tasks?',
      a: 'On the Task List screen use the filter chips at the top to show All, '
          'Active, or Done. You can also search by task name.',
    ),
    _FAQ(
      q: 'How do I log out?',
      a: 'Go to Profile and scroll down to the second group. Tap "Log Out" '
          'and you will be returned to the login screen.',
    ),
  ];

  List<_FAQ> get _filtered => _query.isEmpty
      ? _faqs
      : _faqs
      .where((f) =>
  f.q.toLowerCase().contains(_query.toLowerCase()) ||
      f.a.toLowerCase().contains(_query.toLowerCase()))
      .toList();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _onFaqToggle(int index) {
    setState(() => _openIndex = _openIndex == index ? null : index);
  }

  Future<void> _launch(String url) async {
    final uri = Uri.parse(url);
    debugPrint('Trying to launch: $uri');
    debugPrint('Can launch: ${await canLaunchUrl(uri)}');
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;

    return Scaffold(
      backgroundColor: AppColors.topBar,
      body: Column(
        children: [
          const AppTopBar(
            title: 'Help & Support',
            subtitle: 'Get answers fast',
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: AppColors.base,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              clipBehavior: Clip.antiAlias,
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    TextField(
                      controller: _searchCtrl,
                      onChanged: (v) => setState(() {
                        _query = v;
                        _openIndex = null; // reset on search
                      }),
                      decoration: const InputDecoration(
                        hintText: 'Search help topics…',
                        prefixIcon: Icon(Icons.search_rounded,
                            color: AppColors.textDead, size: 18),
                      ),
                    ),

                    const SizedBox(height: 20),

                    const SectionHeader(title: 'FAQ'),
                    const SizedBox(height: 10),

                    if (filtered.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        child: Center(
                          child: Text(
                            'No results for "$_query"',
                            style: GoogleFonts.spaceGrotesk(
                                color: AppColors.textDim, fontSize: 13),
                          ),
                        ),
                      )
                    else
                      ...filtered.asMap().entries.map((e) => _FAQTile(
                        faq: e.value,
                        isOpen: _openIndex == e.key,
                        onToggle: () => _onFaqToggle(e.key),
                      )),

                    const SizedBox(height: 20),

                    const SectionHeader(title: 'Contact'),
                    const SizedBox(height: 10),
                    _ContactGroup(
                      items: [
                        _ContactItem(
                          icon: Icons.mail_outline_rounded,
                          label: 'Email',
                          subtitle: 'mr.nilesh.pr@gmail.com',
                          onTap: () => setState(() {
                            _launched = _launch('mailto:mr.nilesh.pr@gmail.com');
                          }),
                        ),
                        _ContactItem(
                          icon: Icons.code_rounded,
                          label: 'GitHub',
                          subtitle: 'Nilesh-Prajapat/sidlab-assignment',
                          onTap: () => setState(() {
                            _launched = _launch(
                                'https://github.com/Nilesh-Prajapat/sidlab-assignment');
                          }),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    FutureBuilder<void>(
                      future: _launched,
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Text(
                              'Could not open link',
                              style: GoogleFonts.spaceGrotesk(
                                  color: Colors.redAccent, fontSize: 12),
                              textAlign: TextAlign.center,
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),

                    Center(
                      child: Text(
                        'TaskFlow v1.0.0 · Built with Flutter',
                        style: GoogleFonts.spaceGrotesk(
                          color: AppColors.textDead,
                          fontSize: 10,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
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

class _FAQ {
  final String q;
  final String a;
  const _FAQ({required this.q, required this.a});
}

class _ContactItem {
  final IconData icon;
  final String label;
  final String subtitle;
  final VoidCallback onTap;
  const _ContactItem({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.onTap,
  });
}

// ← now stateless, driven by parent
class _FAQTile extends StatefulWidget {
  final _FAQ faq;
  final bool isOpen;
  final VoidCallback onToggle;
  const _FAQTile({
    required this.faq,
    required this.isOpen,
    required this.onToggle,
  });

  @override
  State<_FAQTile> createState() => _FAQTileState();
}

class _FAQTileState extends State<_FAQTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _expand;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
    _expand = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    if (widget.isOpen) _ctrl.value = 1.0;
  }

  @override
  void didUpdateWidget(_FAQTile old) {
    super.didUpdateWidget(old);
    widget.isOpen ? _ctrl.forward() : _ctrl.reverse();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.layer1,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.borderMuted),
      ),
      child: InkWell(
        onTap: widget.onToggle,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.faq.q,
                      style: GoogleFonts.spaceGrotesk(
                        color: AppColors.textMain,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  AnimatedRotation(
                    turns: widget.isOpen ? 0.25 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: const Icon(Icons.chevron_right_rounded,
                        size: 18, color: AppColors.textDead),
                  ),
                ],
              ),
              SizeTransition(
                sizeFactor: _expand,
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Text(
                      widget.faq.a,
                      style: GoogleFonts.spaceGrotesk(
                        color: AppColors.textMuted,
                        fontSize: 13,
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ContactGroup extends StatelessWidget {
  final List<_ContactItem> items;
  const _ContactGroup({required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.layer1,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.borderMuted),
      ),
      child: Column(
        children: items.asMap().entries.map((e) {
          final i = e.key;
          final item = e.value;
          return Column(
            children: [
              if (i > 0) const Divider(height: 1, indent: 48),
              InkWell(
                onTap: item.onTap,
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                  child: Row(
                    children: [
                      Icon(item.icon, size: 18, color: AppColors.textDim),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.label,
                                style: GoogleFonts.spaceGrotesk(
                                    color: AppColors.textMain, fontSize: 14)),
                            Text(item.subtitle,
                                style: GoogleFonts.spaceGrotesk(
                                    color: AppColors.textDim, fontSize: 11)),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right_rounded,
                          size: 18, color: AppColors.textDead),
                    ],
                  ),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}