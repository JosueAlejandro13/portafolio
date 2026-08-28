import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// ─── DESIGN TOKENS ───────────────────────────────────────────────────────────
class AppColors {
  static const bg = Color(0xFF0B0F19);
  static const bgCard = Color(0xFF131B2E);
  static const bgCardLight = Color(0xFF1B2640);
  static const primary = Color(0xFF00F0FF); // Cyber Cyan
  static const primaryLight = Color(0xFF70E0FF);
  static const accent = Color(0xFF6366F1); // Deep Tech Indigo/Violet
  static const accentLight = Color(0xFF818CF8);
  static const accentCyan = Color(0xFF06B6D4); // Pure Cyan
  static const accentGreen = Color(0xFF10B981); // Emerald Green
  static const textPrimary = Color(0xFFF8FAFC);
  static const textSecondary = Color(0xFF94A3B8);
  static const border = Color(0xFF1E293B);
  static const borderGlow = Color(0x4400F0FF);
}

void main() {
  runApp(const PortfolioWeb());
}

class PortfolioWeb extends StatelessWidget {
  const PortfolioWeb({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Alejandro Hernández — Dev',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true).copyWith(
        scaffoldBackgroundColor: AppColors.bg,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.primary,
          secondary: AppColors.accent,
          surface: AppColors.bgCard,
        ),
        textTheme:
            GoogleFonts.plusJakartaSansTextTheme(ThemeData.dark().textTheme),
      ),
      home: const PortfolioHomePage(),
    );
  }
}

// ─── HOME PAGE ────────────────────────────────────────────────────────────────
class PortfolioHomePage extends StatefulWidget {
  const PortfolioHomePage({super.key});

  @override
  State<PortfolioHomePage> createState() => _PortfolioHomePageState();
}

class _PortfolioHomePageState extends State<PortfolioHomePage> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _experienceKey = GlobalKey();
  final GlobalKey _techKey = GlobalKey();
  final GlobalKey _projectsKey = GlobalKey();
  final GlobalKey _contactKey = GlobalKey();

  void _scrollToTop() {
    _scrollController.animateTo(0,
        duration: const Duration(milliseconds: 800), curve: Curves.easeInOut);
  }

  void _scrollToSection(GlobalKey key) {
    if (key.currentContext != null) {
      Scrollable.ensureVisible(
        key.currentContext!,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
        alignment: 0.1,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 900;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: AppColors.bg,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(72),
        child: _GlassNavBar(
          isDesktop: isDesktop,
          onHome: _scrollToTop,
          onExperience: () => _scrollToSection(_experienceKey),
          onTech: () => _scrollToSection(_techKey),
          onProjects: () => _scrollToSection(_projectsKey),
          onContact: () => _scrollToSection(_contactKey),
        ),
      ),
      body: Stack(
        children: [
          // Animated grid background
          const Positioned.fill(child: _GridBackground()),
          // Glow orbs
          Positioned(
              top: -100,
              right: -150,
              child: _GlowOrb(color: AppColors.primary, size: 500)),
          Positioned(
              top: 400,
              left: -200,
              child: _GlowOrb(color: AppColors.accent, size: 400)),
          Positioned(
              top: 1200,
              right: -100,
              child: _GlowOrb(color: AppColors.accentCyan, size: 350)),
          // Main scroll content
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                _HeroSection(
                  isDesktop: isDesktop,
                  onProjectsTap: () => _scrollToSection(_projectsKey),
                ),
                _SectionDivider(),
                _SectionWrapper(
                  key: _experienceKey,
                  label: 'TRAYECTORIA',
                  title: 'Experiencia & Logros',
                  child: _ExperienceSection(isDesktop: isDesktop),
                ),
                _SectionDivider(),
                _SectionWrapper(
                  key: _techKey,
                  label: 'STACK TÉCNICO',
                  title: 'Tecnologías que Domino',
                  child: _TechnologiesSection(isDesktop: isDesktop),
                ),
                _SectionDivider(),
                _SectionWrapper(
                  key: _projectsKey,
                  label: 'PORTAFOLIO',
                  title: 'Proyectos Destacados',
                  child: _ProjectsSection(isDesktop: isDesktop),
                ),
                _SectionDivider(),
                _SectionWrapper(
                  key: _contactKey,
                  label: 'CONTACTO',
                  title: 'Hablemos',
                  child: _ContactSection(isDesktop: isDesktop),
                ),
                const SizedBox(height: 80),
                const _Footer(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── GLASS NAV BAR ────────────────────────────────────────────────────────────
class _GlassNavBar extends StatelessWidget {
  final bool isDesktop;
  final VoidCallback onHome, onExperience, onTech, onProjects, onContact;

  const _GlassNavBar({
    required this.isDesktop,
    required this.onHome,
    required this.onExperience,
    required this.onTech,
    required this.onProjects,
    required this.onContact,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bg.withValues(alpha: 0.75),
        border: const Border(
          bottom: BorderSide(color: AppColors.border, width: 1),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: isDesktop ? 60 : 20),
        child: Row(
          children: [
            // Logo
            GestureDetector(
              onTap: onHome,
              child: Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.3)),
                    ),
                    child: Text(
                      '</>',
                      style: GoogleFonts.firaCode(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Alejandro.',
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ).animate().fade(duration: 600.ms).slideX(begin: -0.2),
            const Spacer(),
            if (isDesktop) ...[
              _NavItem('Inicio', onHome),
              _NavItem('Experiencia', onExperience),
              _NavItem('Tecnologías', onTech),
              _NavItem('Proyectos', onProjects),
              _NavItem('Contacto', onContact),
              const SizedBox(width: 16),
              // CTA button
              _GradientButton(
                label: 'Descargar CV',
                icon: Icons.download_rounded,
                onTap: () async {
                  const url =
                      'https://drive.google.com/file/d/11q1RIElbN9IzIITODxjgntz3cA7zrjlu/view?usp=sharing';
                  final uri = Uri.parse(url);
                  if (await canLaunchUrl(uri)) await launchUrl(uri);
                },
              ),
            ] else
              IconButton(
                icon: const Icon(Icons.menu_rounded,
                    color: AppColors.textPrimary, size: 28),
                onPressed: () => _showMobileMenu(context),
              ),
          ],
        ),
      ),
    );
  }

  void _showMobileMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          decoration: BoxDecoration(
            color: AppColors.bgCard.withValues(alpha: 0.96),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            border: Border.all(color: AppColors.border),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.25),
                blurRadius: 30,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),
              _mobileItem(context, 'Inicio', Icons.home_rounded, onHome),
              _mobileItem(
                  context, 'Experiencia', Icons.timeline_rounded, onExperience),
              _mobileItem(context, 'Tecnologías', Icons.code_rounded, onTech),
              _mobileItem(context, 'Proyectos', Icons.folder_special_rounded,
                  onProjects),
              _mobileItem(context, 'Contacto', Icons.mail_rounded, onContact),
              const SizedBox(height: 20),
              _GradientButton(
                label: 'Descargar CV',
                icon: Icons.download_rounded,
                large: true,
                onTap: () async {
                  Navigator.pop(context);
                  const url =
                      'https://drive.google.com/file/d/11q1RIElbN9IzIITODxjgntz3cA7zrjlu/view?usp=sharing';
                  final uri = Uri.parse(url);
                  if (await canLaunchUrl(uri)) await launchUrl(uri);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _mobileItem(
      BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primaryLight),
      title: Text(
        title,
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
    );
  }
}

class _NavItem extends StatefulWidget {
  final String title;
  final VoidCallback onTap;
  const _NavItem(this.title, this.onTap);

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: AnimatedDefaultTextStyle(
            duration: 200.ms,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color:
                  _hovered ? AppColors.primaryLight : AppColors.textSecondary,
              fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
            ),
            child: Text(widget.title),
          ),
        ),
      ),
    );
  }
}

// ─── GRADIENT BUTTON ─────────────────────────────────────────────────────────
class _GradientButton extends StatefulWidget {
  final String label;
  final IconData? icon;
  final VoidCallback onTap;
  final bool large;

  const _GradientButton(
      {required this.label,
      required this.onTap,
      this.icon,
      this.large = false});

  @override
  State<_GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<_GradientButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: 200.ms,
          padding: EdgeInsets.symmetric(
            horizontal: widget.large ? 36 : 20,
            vertical: widget.large ? 18 : 12,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: _hovered
                  ? [AppColors.primaryLight, AppColors.accentLight]
                  : [AppColors.primary, AppColors.accent],
            ),
            borderRadius: BorderRadius.circular(widget.large ? 16 : 12),
            boxShadow: _hovered
                ? [
                    BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.5),
                        blurRadius: 20,
                        offset: const Offset(0, 8))
                  ]
                : [],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.icon != null) ...[
                Icon(widget.icon,
                    size: widget.large ? 20 : 16, color: Colors.white),
                SizedBox(width: widget.large ? 10 : 8),
              ],
              Text(
                widget.label,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: widget.large ? 16 : 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── BACKGROUND ELEMENTS ──────────────────────────────────────────────────────
class _GlowOrb extends StatelessWidget {
  final Color color;
  final double size;
  const _GlowOrb({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [color.withValues(alpha: 0.12), Colors.transparent],
        ),
      ),
    );
  }
}

class _GridBackground extends StatefulWidget {
  const _GridBackground();

  @override
  State<_GridBackground> createState() => _GridBackgroundState();
}

class _GridBackgroundState extends State<_GridBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl =
        AnimationController(vsync: this, duration: const Duration(seconds: 6))
          ..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) => CustomPaint(
        painter: _GridPainter(_ctrl.value),
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  final double t;
  _GridPainter(this.t);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF1E2236).withValues(alpha: 0.4)
      ..strokeWidth = 1;

    const cellSize = 60.0;
    // Vertical lines
    for (double x = 0; x < size.width; x += cellSize) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    // Horizontal lines
    for (double y = 0; y < size.height; y += cellSize) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    // Animated dots at intersections
    final dotPaint = Paint()..style = PaintingStyle.fill;
    final random = math.Random(42);
    int dotIndex = 0;
    for (double x = 0; x < size.width; x += cellSize) {
      for (double y = 0; y < size.height; y += cellSize) {
        dotIndex++;
        final phase = (random.nextDouble() + t) % 1.0;
        final alpha = (math.sin(phase * 2 * math.pi) * 0.5 + 0.5);
        if (alpha > 0.7) {
          dotPaint.color = AppColors.primary.withValues(alpha: alpha * 0.6);
          canvas.drawCircle(Offset(x, y), 2, dotPaint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(_GridPainter old) => old.t != t;
}

// ─── SECTION WRAPPER ──────────────────────────────────────────────────────────
class _SectionWrapper extends StatelessWidget {
  final String label;
  final String title;
  final Widget child;

  const _SectionWrapper(
      {super.key,
      required this.label,
      required this.title,
      required this.child});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 1200),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Label chip
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.25)),
              ),
              child: Text(
                label,
                style: GoogleFonts.firaCode(
                  color: AppColors.primaryLight,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 2,
                ),
              ),
            ).animate().fade(duration: 500.ms).slideY(begin: 0.3),
            const SizedBox(height: 16),
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [AppColors.textPrimary, AppColors.textSecondary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(bounds),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: MediaQuery.of(context).size.width > 600 ? 42 : 28,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  height: 1.1,
                ),
              ),
            )
                .animate()
                .fade(delay: 100.ms, duration: 600.ms)
                .slideY(begin: 0.2),
            const SizedBox(height: 12),
            Container(
              height: 3,
              width: 48,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.accent]),
                borderRadius: BorderRadius.circular(2),
              ),
            ).animate().scaleX(
                begin: 0,
                delay: 200.ms,
                duration: 600.ms,
                curve: Curves.easeOut),
            const SizedBox(height: 60),
            child,
          ],
        ),
      ),
    );
  }
}

class _SectionDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      margin: const EdgeInsets.symmetric(horizontal: 60),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            AppColors.border,
            Colors.transparent,
          ],
        ),
      ),
    );
  }
}

// ─── HERO SECTION ─────────────────────────────────────────────────────────────
class _HeroSection extends StatelessWidget {
  final bool isDesktop;
  final VoidCallback? onProjectsTap;
  const _HeroSection({required this.isDesktop, this.onProjectsTap});

  @override
  Widget build(BuildContext context) {
    final content = Column(
      crossAxisAlignment:
          isDesktop ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Status chip
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.accentGreen.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
            border:
                Border.all(color: AppColors.accentGreen.withValues(alpha: 0.3)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.accentGreen,
                  shape: BoxShape.circle,
                ),
              )
                  .animate(onPlay: (c) => c.repeat(reverse: true))
                  .scaleXY(begin: 0.8, end: 1.2, duration: 1.seconds),
              const SizedBox(width: 8),
              const Text(
                'Disponible para nuevos proyectos',
                style: TextStyle(
                    color: AppColors.accentGreen,
                    fontWeight: FontWeight.w600,
                    fontSize: 13),
              ),
            ],
          ),
        ).animate().fade(delay: 200.ms).slideY(begin: 0.3),
        const SizedBox(height: 28),

        // Name with gradient
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [AppColors.textPrimary, AppColors.primaryLight],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(bounds),
          child: Text(
            'Alejandro\nHernández',
            style: GoogleFonts.plusJakartaSans(
              fontWeight: FontWeight.w900,
              height: 1.05,
              color: Colors.white,
              fontSize: isDesktop ? 78 : 52,
            ),
            textAlign: isDesktop ? TextAlign.left : TextAlign.center,
          ),
        ).animate().fade(delay: 350.ms).slideY(begin: 0.2),
        const SizedBox(height: 12),

        // Subtitle with animated text
        _TypewriterText(
          texts: const [
            'Flutter Developer',
            'Mobile Engineer',
            'Cross-Platform Expert',
          ],
          style: GoogleFonts.firaCode(
            fontSize: isDesktop ? 22 : 18,
            fontWeight: FontWeight.w500,
            color: AppColors.accent,
          ),
        ).animate().fade(delay: 500.ms),
        const SizedBox(height: 20),

        Text(
          'Especializado en Flutter & Dart, diseño y desarrollo de aplicaciones móviles robustas, escalables y de alto rendimiento para Android e iOS.',
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w400,
            color: AppColors.textSecondary,
            height: 1.7,
          ),
          textAlign: isDesktop ? TextAlign.left : TextAlign.center,
        ).animate().fade(delay: 600.ms).slideY(begin: 0.2),
        const SizedBox(height: 40),

        Wrap(
          spacing: 16,
          runSpacing: 16,
          alignment: isDesktop ? WrapAlignment.start : WrapAlignment.center,
          children: [
            _GradientButton(
              label: 'Descargar CV',
              icon: Icons.download_rounded,
              large: true,
              onTap: () async {
                const url =
                    'https://drive.google.com/file/d/11q1RIElbN9IzIITODxjgntz3cA7zrjlu/view?usp=sharing';
                final uri = Uri.parse(url);
                if (await canLaunchUrl(uri)) await launchUrl(uri);
              },
            ),
            _OutlineButton(
              label: 'Ver proyectos',
              icon: Icons.arrow_forward_rounded,
              onTap: onProjectsTap ?? () {},
            ),
          ],
        ).animate().fade(delay: 700.ms).slideY(begin: 0.2),
        const SizedBox(height: 48),

        // Social links
        Row(
          mainAxisAlignment:
              isDesktop ? MainAxisAlignment.start : MainAxisAlignment.center,
          children: [
            _SocialLink(
                icon: FontAwesomeIcons.github,
                url: 'https://github.com/JosueAlejandro13'),
            const SizedBox(width: 16),
            _SocialLink(
                icon: FontAwesomeIcons.linkedin,
                url:
                    'https://www.linkedin.com/in/alejandro-hernandez-castellanos'),
            const SizedBox(width: 16),
            _SocialLink(
                icon: Icons.email, url: 'mailto:castealejandro13@gmail.com'),
          ],
        ).animate().fade(delay: 800.ms),
      ],
    );

    final avatar = _AnimatedAvatar(isDesktop: isDesktop);

    return SizedBox(
      width: double.infinity,
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1200),
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: isDesktop ? 130 : 120,
            bottom: 60,
          ),
          child: isDesktop
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(flex: 6, child: content),
                    const SizedBox(width: 60),
                    Expanded(flex: 4, child: avatar),
                  ],
                )
              : Column(
                  children: [
                    avatar,
                    const SizedBox(height: 50),
                    content,
                  ],
                ),
        ),
      ),
    );
  }
}

class _AnimatedAvatar extends StatefulWidget {
  final bool isDesktop;
  const _AnimatedAvatar({required this.isDesktop});

  @override
  State<_AnimatedAvatar> createState() => _AnimatedAvatarState();
}

class _AnimatedAvatarState extends State<_AnimatedAvatar>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _rotAnim;

  @override
  void initState() {
    super.initState();
    _ctrl =
        AnimationController(vsync: this, duration: const Duration(seconds: 8))
          ..repeat();
    _rotAnim = Tween(begin: 0.0, end: 1.0).animate(_ctrl);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = widget.isDesktop ? 360.0 : 260.0;
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Rotating gradient ring
            AnimatedBuilder(
              animation: _rotAnim,
              builder: (_, child) => Transform.rotate(
                angle: _rotAnim.value * 2 * math.pi,
                child: child,
              ),
              child: Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: SweepGradient(
                    colors: [
                      AppColors.primary,
                      AppColors.accent,
                      AppColors.primaryLight,
                      AppColors.primary,
                    ],
                  ),
                ),
              ),
            ),
            // Inner dark circle
            Container(
              width: size - 8,
              height: size - 8,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.bg,
              ),
            ),
            // Glow
            Container(
              width: size - 20,
              height: size - 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.25),
                    blurRadius: 60,
                    spreadRadius: 10,
                  ),
                ],
              ),
            ),
            // Avatar image
            ClipOval(
              child: SizedBox(
                width: size - 20,
                height: size - 20,
                child: Image.asset(
                  'assets/avatar.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Floating badge
            Positioned(
              bottom: 10,
              right: 10,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.bgCard,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withValues(alpha: 0.5),
                        blurRadius: 20)
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.flutter_dash,
                        color: AppColors.accentCyan, size: 18),
                    const SizedBox(width: 6),
                    Text(
                      'Flutter Dev',
                      style: GoogleFonts.firaCode(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ).animate(onPlay: (c) => c.repeat(reverse: true)).moveY(
                  begin: -4,
                  end: 4,
                  duration: 2.seconds,
                  curve: Curves.easeInOut),
            ),
          ],
        ),
      ),
    ).animate().fade(delay: 600.ms).scale(begin: const Offset(0.85, 0.85));
  }
}

class _OutlineButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  const _OutlineButton(
      {required this.label, required this.icon, required this.onTap});

  @override
  State<_OutlineButton> createState() => _OutlineButtonState();
}

class _OutlineButtonState extends State<_OutlineButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: 200.ms,
          padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 18),
          decoration: BoxDecoration(
            color: _hovered
                ? AppColors.primary.withValues(alpha: 0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
                color: _hovered ? AppColors.primary : AppColors.border,
                width: 1.5),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.label,
                style: TextStyle(
                  color:
                      _hovered ? AppColors.primaryLight : AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
              const SizedBox(width: 8),
              Icon(widget.icon,
                  size: 18,
                  color: _hovered
                      ? AppColors.primaryLight
                      : AppColors.textPrimary),
            ],
          ),
        ),
      ),
    );
  }
}

class _SocialLink extends StatefulWidget {
  final dynamic icon;
  final String url;
  const _SocialLink({required this.icon, required this.url});

  @override
  State<_SocialLink> createState() => _SocialLinkState();
}

class _SocialLinkState extends State<_SocialLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () async {
          final uri = Uri.parse(widget.url);
          if (await canLaunchUrl(uri)) await launchUrl(uri);
        },
        child: AnimatedContainer(
          duration: 200.ms,
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: _hovered
                ? AppColors.primary.withValues(alpha: 0.15)
                : AppColors.bgCard,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: _hovered
                    ? AppColors.primary.withValues(alpha: 0.5)
                    : AppColors.border),
          ),
          child: Center(
            child: widget.icon is IconData
                ? Icon(widget.icon as IconData,
                    size: 18,
                    color: _hovered
                        ? AppColors.primaryLight
                        : AppColors.textSecondary)
                : FaIcon(widget.icon as FaIconData,
                    size: 16,
                    color: _hovered
                        ? AppColors.primaryLight
                        : AppColors.textSecondary),
          ),
        ),
      ),
    );
  }
}

// ─── TYPEWRITER TEXT ──────────────────────────────────────────────────────────
class _TypewriterText extends StatefulWidget {
  final List<String> texts;
  final TextStyle style;
  const _TypewriterText({required this.texts, required this.style});

  @override
  State<_TypewriterText> createState() => _TypewriterTextState();
}

class _TypewriterTextState extends State<_TypewriterText> {
  int _textIndex = 0;
  int _charCount = 0;
  bool _deleting = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(milliseconds: 80), (_) {
      if (!mounted) return;
      setState(() {
        final current = widget.texts[_textIndex];
        if (!_deleting) {
          if (_charCount < current.length) {
            _charCount++;
          } else {
            Future.delayed(const Duration(milliseconds: 1500), () {
              if (mounted) setState(() => _deleting = true);
            });
          }
        } else {
          if (_charCount > 0) {
            _charCount--;
          } else {
            _deleting = false;
            _textIndex = (_textIndex + 1) % widget.texts.length;
          }
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final display = widget.texts[_textIndex].substring(0, _charCount);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(display, style: widget.style),
        AnimatedOpacity(
          opacity: 1,
          duration: 500.ms,
          child: Container(
            width: 2,
            height: 28,
            color: AppColors.accent,
          ),
        )
            .animate(onPlay: (c) => c.repeat(reverse: true))
            .fade(duration: 500.ms),
      ],
    );
  }
}

// ─── EXPERIENCE SECTION ───────────────────────────────────────────────────────
class _ExperienceSection extends StatelessWidget {
  final bool isDesktop;
  const _ExperienceSection({required this.isDesktop});

  @override
  Widget build(BuildContext context) {
    final stats = [
      _StatData(
          number: '3+',
          label: 'Años de\nExperiencia',
          icon: Icons.timeline_rounded,
          color: AppColors.primary),
      _StatData(
          number: '2',
          label: 'Apps\nPublicadas',
          icon: Icons.rocket_launch_rounded,
          color: AppColors.accent),
      _StatData(
          number: '1',
          label: 'Librería en\npub.dev',
          icon: Icons.library_books_rounded,
          color: AppColors.accentCyan),
      _StatData(
          number: '6+',
          label: 'Proyectos\nCompletos',
          icon: Icons.folder_special_rounded,
          color: AppColors.accentGreen),
    ];

    return Column(
      children: [
        // Stats row
        Wrap(
          spacing: 20,
          runSpacing: 20,
          alignment: WrapAlignment.center,
          children: stats.asMap().entries.map((e) {
            return _StatCard(data: e.value, index: e.key)
                .animate(delay: (e.key * 100).ms)
                .fade(duration: 500.ms)
                .slideY(begin: 0.2, curve: Curves.easeOut);
          }).toList(),
        ),
        const SizedBox(height: 60),
        // Timeline
        _Timeline(isDesktop: isDesktop),
      ],
    );
  }
}

class _StatData {
  final String number, label;
  final IconData icon;
  final Color color;
  const _StatData(
      {required this.number,
      required this.label,
      required this.icon,
      required this.color});
}

class _AnimatedCounterText extends StatelessWidget {
  final String numberString;
  final TextStyle style;

  const _AnimatedCounterText({
    required this.numberString,
    required this.style,
  });

  @override
  Widget build(BuildContext context) {
    final match = RegExp(r'^(\d+)(.*)$').firstMatch(numberString);
    if (match == null) {
      return Text(numberString, style: style);
    }

    final targetVal = int.parse(match.group(1)!);
    final suffix = match.group(2) ?? '';

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: targetVal.toDouble()),
      duration: const Duration(milliseconds: 1800),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Text(
          '${value.toInt()}$suffix',
          style: style,
        );
      },
    );
  }
}

class _StatCard extends StatefulWidget {
  final _StatData data;
  final int index;
  const _StatCard({required this.data, this.index = 0});

  @override
  State<_StatCard> createState() => _StatCardState();
}

class _StatCardState extends State<_StatCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final cardWidth = isMobile ? (screenWidth - 68) / 2 : 220.0;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: 250.ms,
        width: cardWidth,
        padding: EdgeInsets.all(isMobile ? 18 : 28),
        decoration: BoxDecoration(
          color: _hovered ? AppColors.bgCardLight : AppColors.bgCard,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _hovered
                ? widget.data.color.withValues(alpha: 0.4)
                : AppColors.border,
          ),
          boxShadow: _hovered
              ? [
                  BoxShadow(
                      color: widget.data.color.withValues(alpha: 0.2),
                      blurRadius: 30)
                ]
              : [
                  BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 10)
                ],
        ),
        transform: Matrix4.translationValues(0, _hovered ? -6 : 0, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: widget.data.color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(widget.data.icon, color: widget.data.color, size: 26),
            ),
            const SizedBox(height: 20),
            _AnimatedCounterText(
              numberString: widget.data.number,
              style: GoogleFonts.plusJakartaSans(
                fontSize: isMobile ? 36 : 44,
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary,
                height: 1,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              widget.data.label,
              style: TextStyle(
                  fontSize: isMobile ? 12 : 14,
                  color: AppColors.textSecondary,
                  height: 1.4),
            ),
          ],
        ),
      ),
    ).animate(onPlay: (c) => c.repeat(reverse: true)).moveY(
          begin: widget.index % 2 == 0 ? -4 : 4,
          end: widget.index % 2 == 0 ? 4 : -4,
          duration: (2200 + widget.index * 300).ms,
          curve: Curves.easeInOut,
        );
  }
}

class _Timeline extends StatelessWidget {
  final bool isDesktop;
  const _Timeline({required this.isDesktop});

  @override
  Widget build(BuildContext context) {
    final items = [
      _TimelineItem(
        year: '2024 – Presente',
        role: 'Desarrollador Flutter',
        company: 'Caleni Telematics',
        description:
            'Desarrollo de aplicaciones móviles multiplataforma con Flutter, integración con Firebase y gestión de equipos ágiles.',
        color: AppColors.primary,
      ),
      _TimelineItem(
        year: '2024 – 2025',
        role: 'Desarrollador Web / PHP',
        company: 'Caleni Telematics',
        description:
            'Plataformas web con PHP, HTML/CSS/JS y gestión de bases de datos MySQL.',
        color: AppColors.accentCyan,
      ),
    ];

    return Column(
      children: items.asMap().entries.map((e) {
        return _TimelineEntry(
                item: e.value,
                isLast: e.key == items.length - 1,
                isDesktop: isDesktop)
            .animate(delay: (e.key * 150).ms)
            .fade(duration: 600.ms)
            .slideX(begin: -0.1);
      }).toList(),
    );
  }
}

class _TimelineItem {
  final String year, role, company, description;
  final Color color;
  const _TimelineItem(
      {required this.year,
      required this.role,
      required this.company,
      required this.description,
      required this.color});
}

class _TimelineEntry extends StatefulWidget {
  final _TimelineItem item;
  final bool isLast, isDesktop;
  const _TimelineEntry(
      {required this.item, required this.isLast, required this.isDesktop});

  @override
  State<_TimelineEntry> createState() => _TimelineEntryState();
}

class _TimelineEntryState extends State<_TimelineEntry> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final isMobile = !widget.isDesktop;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Continuous Timeline line + dot column
            SizedBox(
              width: isMobile ? 30 : 40,
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  // Vertical continuous line stretching down
                  if (!widget.isLast)
                    Positioned(
                      top: 14,
                      bottom: 0,
                      child: Container(
                        width: 2,
                        color: AppColors.border,
                      ),
                    ),
                  // Glowing Dot
                  Positioned(
                    top: 6,
                    child: AnimatedContainer(
                      duration: 200.ms,
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: _hovered ? widget.item.color : AppColors.bgCard,
                        shape: BoxShape.circle,
                        border:
                            Border.all(color: widget.item.color, width: 2.5),
                        boxShadow: _hovered
                            ? [
                                BoxShadow(
                                    color: widget.item.color
                                        .withValues(alpha: 0.5),
                                    blurRadius: 12)
                              ]
                            : [],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: isMobile ? 12 : 20),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(bottom: widget.isLast ? 0 : 32),
                child: AnimatedContainer(
                  duration: 250.ms,
                  padding: EdgeInsets.all(isMobile ? 16 : 24),
                  decoration: BoxDecoration(
                    color: _hovered ? AppColors.bgCardLight : AppColors.bgCard,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: _hovered
                          ? widget.item.color.withValues(alpha: 0.35)
                          : AppColors.border,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: widget.item.color.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              widget.item.year,
                              style: GoogleFonts.firaCode(
                                color: widget.item.color,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        widget.item.role,
                        style: TextStyle(
                          fontSize: isMobile ? 16 : 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        widget.item.company,
                        style: TextStyle(
                          fontSize: 13,
                          color: widget.item.color,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        widget.item.description,
                        style: TextStyle(
                          fontSize: isMobile ? 13 : 14,
                          color: AppColors.textSecondary,
                          height: 1.6,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── TECHNOLOGIES SECTION ─────────────────────────────────────────────────────
class _TechnologiesSection extends StatelessWidget {
  final bool isDesktop;
  const _TechnologiesSection({required this.isDesktop});

  @override
  Widget build(BuildContext context) {
    final techs = [
      _TechData('Flutter', Icons.flutter_dash, AppColors.accentCyan),
      _TechData('Dart', Icons.code_rounded, Colors.blue),
      _TechData('Supabase', Icons.storage_rounded, AppColors.accentGreen),
      _TechData(
          'Firebase', Icons.local_fire_department_rounded, AppColors.accent),
      _TechData('PHP', Icons.php_rounded, Colors.indigoAccent),
      _TechData('Android', Icons.android_rounded, AppColors.accentGreen),
      _TechData('Swift/iOS', Icons.apple_rounded, Colors.grey),
      _TechData('GitHub', Icons.account_tree_rounded, AppColors.textSecondary),
      _TechData('REST API', Icons.api_rounded, AppColors.accentCyan),
    ];

    return Wrap(
      spacing: 16,
      runSpacing: 16,
      alignment: WrapAlignment.center,
      children: techs.asMap().entries.map((e) {
        return _TechCard(data: e.value, isDesktop: isDesktop)
            .animate(delay: (e.key * 80).ms)
            .fade(duration: 500.ms)
            .scale(begin: const Offset(0.85, 0.85), curve: Curves.easeOutBack);
      }).toList(),
    );
  }
}

class _TechData {
  final String name;
  final IconData icon;
  final Color color;
  const _TechData(this.name, this.icon, this.color);
}

class _TechCard extends StatefulWidget {
  final _TechData data;
  final bool isDesktop;
  const _TechCard({required this.data, required this.isDesktop});

  @override
  State<_TechCard> createState() => _TechCardState();
}

class _TechCardState extends State<_TechCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: 250.ms,
        width: widget.isDesktop ? 200 : 155,
        padding: EdgeInsets.all(widget.isDesktop ? 24 : 18),
        decoration: BoxDecoration(
          color: _hovered ? AppColors.bgCardLight : AppColors.bgCard,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _hovered
                ? widget.data.color.withValues(alpha: 0.45)
                : AppColors.border,
          ),
          boxShadow: _hovered
              ? [
                  BoxShadow(
                      color: widget.data.color.withValues(alpha: 0.18),
                      blurRadius: 30)
                ]
              : [],
        ),
        transform: Matrix4.translationValues(0, _hovered ? -8 : 0, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(widget.isDesktop ? 18 : 14),
              decoration: BoxDecoration(
                color: widget.data.color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(widget.data.icon,
                  color: widget.data.color, size: widget.isDesktop ? 44 : 34),
            ),
            SizedBox(height: widget.isDesktop ? 14 : 10),
            Text(
              widget.data.name,
              style: TextStyle(
                fontSize: widget.isDesktop ? 15 : 13,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── PROJECTS SECTION ─────────────────────────────────────────────────────────
class _ProjectsSection extends StatelessWidget {
  final bool isDesktop;
  const _ProjectsSection({required this.isDesktop});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GridView.count(
          crossAxisCount: isDesktop ? 2 : 1,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          childAspectRatio: isDesktop ? 0.8 : 0.6,
          children: [
            _ProjectCard(
              title: 'App Mark — Rutas GPS',
              description:
                  'Plataforma para trazado y seguimiento de rutas por GPS en tiempo real con notificaciones push y mapas interactivos.',
              tags: const ['Flutter', 'Firebase', 'Android', 'GPS'],
              gradient: [
                AppColors.primary.withValues(alpha: 0.2),
                AppColors.accentCyan.withValues(alpha: 0.15)
              ],
              accentColor: AppColors.primary,
              isPrivate: true,
              imagePaths: const [
                'assets/mark/1.png',
                'assets/mark/2.png',
                'assets/mark/3.png',
                'assets/mark/4.png',
                'assets/mark/5.png'
              ],
              isMobileCarousel: true,
            ),
            _ProjectCard(
              title: 'Manager Web Platform',
              description:
                  'Plataforma administrativa web robusta para gestión centralizada de datos de la aplicación Flutter.',
              tags: const ['PHP', 'JavaScript', 'HTML', 'CSS'],
              gradient: [
                AppColors.accent.withValues(alpha: 0.2),
                Colors.orange.withValues(alpha: 0.15)
              ],
              accentColor: AppColors.accent,
              isPrivate: true,
              isMobileCarousel: false,
              imagePaths: const [
                'assets/manager/1.png',
                'assets/manager/2.png',
                'assets/manager/3.png',
                'assets/manager/4.png'
              ],
            ),
            _ProjectCard(
              title: 'Consultorio PH Web',
              description:
                  'Página web profesional para consultorio médico con diseño moderno, responsivo y formularios de contacto.',
              tags: const ['HTML', 'CSS', 'JavaScript', 'Tailwind'],
              gradient: [
                AppColors.accentCyan.withValues(alpha: 0.2),
                AppColors.accentGreen.withValues(alpha: 0.15)
              ],
              accentColor: AppColors.accentCyan,
              url: 'https://anaisph.github.io/',
              githubUrl: 'https://github.com/AnaisPH/AnaisPH.github.io',
              isMobileCarousel: false,
              imagePaths: const [
                'assets/consultorioweb/1.png',
                'assets/consultorioweb/2.png',
                'assets/consultorioweb/3.png'
              ],
            ),
            _ProjectCard(
              title: 'App Consultorio PH',
              description:
                  'Aplicación móvil multiplataforma para programar, administrar y gestionar citas médicas en el consultorio.',
              tags: const ['Flutter', 'Firebase', 'Android', 'iOS'],
              gradient: [
                Colors.pink.withValues(alpha: 0.2),
                AppColors.primary.withValues(alpha: 0.15)
              ],
              accentColor: Colors.pinkAccent,
              githubUrl: 'https://github.com/JosueAlejandro13/phmov',
            ),
            _ProjectCard(
              title: 'App de Películas',
              description:
                  'Aplicación para descubrir tendencias del cine. Integración con API REST, búsqueda avanzada y favoritos.',
              tags: const ['Flutter', 'API REST', 'Dart'],
              gradient: [
                Colors.purple.withValues(alpha: 0.2),
                AppColors.primary.withValues(alpha: 0.15)
              ],
              accentColor: Colors.purpleAccent,
              githubUrl: 'https://github.com/JosueAlejandro13/PruebaT',
              imagePaths: const [
                'assets/appPeliculas/1.jpeg',
                'assets/appPeliculas/2.jpeg',
                'assets/appPeliculas/3.jpeg'
              ],
              isMobileCarousel: true,
            ),
            _ProjectCard(
              title: 'Vent — Punto de Venta',
              description:
                  'Sistema de punto de venta (POS) moderno desarrollado con Flutter y Supabase para el control de inventario, ventas y transacciones en tiempo real.',
              tags: const ['Flutter', 'Supabase', 'Dart', 'POS'],
              gradient: [
                AppColors.accentGreen.withValues(alpha: 0.2),
                AppColors.primary.withValues(alpha: 0.15)
              ],
              accentColor: AppColors.accentGreen,
              githubUrl: 'https://github.com/JosueAlejandro13/Vent',
            ),
            _ProjectCard(
              title: 'flutter_app_core_freezed',
              description:
                  'Paquete Flutter publicado en pub.dev con cliente HTTP tipado, Result<T>, BLoC y almacenamiento seguro de tokens.',
              tags: const ['Flutter', 'Package', 'pub.dev', 'BLoC'],
              gradient: [
                Colors.indigo.withValues(alpha: 0.2),
                AppColors.primary.withValues(alpha: 0.15)
              ],
              accentColor: Colors.indigoAccent,
              url: 'https://pub.dev/packages/flutter_app_core_freezed',
              showFlutterLogo: true,
            ),
          ].asMap().entries.map((e) {
            return e.value
                .animate(delay: (e.key * 120).ms)
                .fade(duration: 700.ms)
                .slideY(begin: 0.1);
          }).toList(),
        );
      },
    );
  }
}

class _ProjectCard extends StatefulWidget {
  final String title, description;
  final List<String> tags;
  final List<Color> gradient;
  final Color accentColor;
  final String? url, githubUrl;
  final List<String>? imagePaths;
  final bool showFlutterLogo, isMobileCarousel, isPrivate;

  const _ProjectCard({
    required this.title,
    required this.description,
    required this.tags,
    required this.gradient,
    required this.accentColor,
    this.url,
    this.githubUrl,
    this.imagePaths,
    this.showFlutterLogo = false,
    this.isMobileCarousel = true,
    this.isPrivate = false,
  });

  @override
  State<_ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<_ProjectCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: 280.ms,
        curve: Curves.easeOut,
        transform: Matrix4.translationValues(0, _hovered ? -10 : 0, 0),
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: _hovered
                ? widget.accentColor.withValues(alpha: 0.4)
                : AppColors.border,
            width: 1.5,
          ),
          boxShadow: _hovered
              ? [
                  BoxShadow(
                      color: widget.accentColor.withValues(alpha: 0.18),
                      blurRadius: 40,
                      offset: const Offset(0, 16))
                ]
              : [
                  BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8))
                ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Image / preview area
              Expanded(
                flex: 5,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: widget.gradient,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: widget.imagePaths != null &&
                          widget.imagePaths!.isNotEmpty
                      ? _ImageCarousel(
                          imagePaths: widget.imagePaths!,
                          isMobile: widget.isMobileCarousel)
                      : Center(
                          child: widget.showFlutterLogo
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const FlutterLogo(size: 80),
                                    const SizedBox(height: 12),
                                    Text('pub.dev package',
                                        style: TextStyle(
                                            color: widget.accentColor,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 13)),
                                  ],
                                )
                              : Icon(Icons.image_outlined,
                                  size: 56,
                                  color: Colors.white.withValues(alpha: 0.25)),
                        ),
                ),
              ),
              // Card content
              Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.all(22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Tags
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: widget.tags.map((tag) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: widget.accentColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                  color: widget.accentColor
                                      .withValues(alpha: 0.2)),
                            ),
                            child: Text(tag,
                                style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: widget.accentColor)),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        widget.title,
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                            height: 1.2),
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: Text(
                          widget.description,
                          style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                              height: 1.6),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Action buttons
                      Row(
                        children: [
                          if (widget.url != null)
                            _SmallActionButton(
                              icon: Icons.open_in_new_rounded,
                              label: 'Ver',
                              color: widget.accentColor,
                              onTap: () async {
                                final uri = Uri.parse(widget.url!);
                                if (await canLaunchUrl(uri))
                                  await launchUrl(uri);
                              },
                            ),
                          if (widget.isPrivate) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.amber.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    color: Colors.amber.withValues(alpha: 0.3)),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.lock_outline_rounded,
                                      size: 12, color: Colors.amber),
                                  SizedBox(width: 5),
                                  Text('Privado',
                                      style: TextStyle(
                                          color: Colors.amber,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700)),
                                ],
                              ),
                            ),
                          ] else if (widget.githubUrl != null) ...[
                            const SizedBox(width: 8),
                            _SmallActionButton(
                              icon: FontAwesomeIcons.github,
                              label: 'GitHub',
                              color: widget.accentColor,
                              onTap: () async {
                                final uri = Uri.parse(widget.githubUrl!);
                                if (await canLaunchUrl(uri))
                                  await launchUrl(uri);
                              },
                              isFa: true,
                            ),
                          ],
                        ],
                      ),
                    ],
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

class _SmallActionButton extends StatefulWidget {
  final dynamic icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  final bool isFa;

  const _SmallActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
    this.isFa = false,
  });

  @override
  State<_SmallActionButton> createState() => _SmallActionButtonState();
}

class _SmallActionButtonState extends State<_SmallActionButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: 200.ms,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: _hovered
                ? widget.color.withValues(alpha: 0.2)
                : widget.color.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: widget.color.withValues(alpha: 0.3)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              widget.isFa
                  ? FaIcon(widget.icon as FaIconData,
                      size: 12, color: widget.color)
                  : Icon(widget.icon as IconData,
                      size: 14, color: widget.color),
              const SizedBox(width: 6),
              Text(widget.label,
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: widget.color)),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── CONTACT SECTION ──────────────────────────────────────────────────────────
class _ContactSection extends StatelessWidget {
  final bool isDesktop;
  const _ContactSection({required this.isDesktop});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.border),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Stack(
          children: [
            // Background glow
            Positioned(
              top: -80,
              right: -80,
              child: _GlowOrb(color: AppColors.primary, size: 300),
            ),
            Positioned(
              bottom: -80,
              left: -80,
              child: _GlowOrb(color: AppColors.accent, size: 250),
            ),
            Padding(
              padding: EdgeInsets.all(isDesktop ? 48 : 24),
              child: isDesktop
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 5, child: _ContactInfo()),
                        const SizedBox(width: 60),
                        Expanded(flex: 4, child: _ContactLinks()),
                      ],
                    )
                  : Column(
                      children: [
                        _ContactInfo(),
                        const SizedBox(height: 40),
                        _ContactLinks(),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ContactInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.accentGreen.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
            border:
                Border.all(color: AppColors.accentGreen.withValues(alpha: 0.3)),
          ),
          child: const Text('✉️  Disponible ahora',
              style: TextStyle(
                  color: AppColors.accentGreen,
                  fontSize: 13,
                  fontWeight: FontWeight.w600)),
        ),
        const SizedBox(height: 20),
        ShaderMask(
          shaderCallback: (b) => const LinearGradient(
            colors: [AppColors.textPrimary, AppColors.primaryLight],
          ).createShader(b),
          child: const Text(
            '¿Tienes una idea\nen mente?',
            style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                height: 1.15),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Estoy disponible para proyectos freelance o para unirme a un gran equipo. ¡Escríbeme y hablemos de tu próximo proyecto!',
          style: TextStyle(
              fontSize: 16, color: AppColors.textSecondary, height: 1.7),
        ),
        const SizedBox(height: 36),
        _GradientButton(
          label: 'Enviar mensaje',
          icon: Icons.send_rounded,
          large: true,
          onTap: () async {
            final uri = Uri.parse('mailto:castealejandro13@gmail.com');
            if (await canLaunchUrl(uri)) await launchUrl(uri);
          },
        ),
      ],
    ).animate().fade(duration: 600.ms).slideX(begin: -0.1);
  }
}

class _ContactLinks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Contacto directo',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary)),
        const SizedBox(height: 20),
        _ContactTile(
            icon: Icons.email_rounded,
            label: 'Email',
            value: 'castealejandro13@gmail.com',
            url: 'mailto:castealejandro13@gmail.com',
            color: AppColors.primary),
        const SizedBox(height: 12),
        _ContactTile(
            icon: Icons.phone_rounded,
            label: 'Teléfono',
            value: '+52 56-21-91-51-71',
            url: 'tel:+525621915171',
            color: AppColors.accent),
        const SizedBox(height: 12),
        _ContactTile(
            icon: Icons.location_on_rounded,
            label: 'Ubicación',
            value: 'México 🇲🇽',
            color: AppColors.accentCyan),
        const SizedBox(height: 30),
        const Text('Redes sociales',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary)),
        const SizedBox(height: 16),
        Row(
          children: [
            _SocialLink(
                icon: FontAwesomeIcons.github,
                url: 'https://github.com/JosueAlejandro13'),
            const SizedBox(width: 12),
            _SocialLink(
                icon: FontAwesomeIcons.linkedin,
                url:
                    'https://www.linkedin.com/in/alejandro-hernandez-castellanos'),
            const SizedBox(width: 12),
            _SocialLink(
                icon: FontAwesomeIcons.twitter, url: 'https://twitter.com'),
          ],
        ),
      ],
    ).animate().fade(duration: 600.ms).slideX(begin: 0.1);
  }
}

class _ContactTile extends StatefulWidget {
  final IconData icon;
  final String label, value;
  final String? url;
  final Color color;

  const _ContactTile(
      {required this.icon,
      required this.label,
      required this.value,
      required this.color,
      this.url});

  @override
  State<_ContactTile> createState() => _ContactTileState();
}

class _ContactTileState extends State<_ContactTile> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: widget.url != null
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: widget.url != null
            ? () async {
                final uri = Uri.parse(widget.url!);
                if (await canLaunchUrl(uri)) await launchUrl(uri);
              }
            : null,
        child: AnimatedContainer(
          duration: 200.ms,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _hovered
                ? AppColors.bgCardLight
                : AppColors.bg.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
                color: _hovered
                    ? widget.color.withValues(alpha: 0.35)
                    : AppColors.border),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: widget.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(widget.icon, color: widget.color, size: 20),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.label,
                      style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w600)),
                  Text(widget.value,
                      style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600)),
                ],
              ),
              const Spacer(),
              if (widget.url != null)
                Icon(Icons.arrow_forward_ios_rounded,
                    size: 14,
                    color: _hovered ? widget.color : AppColors.textSecondary),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── FOOTER ───────────────────────────────────────────────────────────────────
class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.3)),
                ),
                child: Text(
                  '</>',
                  style: GoogleFonts.firaCode(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'Alejandro Hernández',
                style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w700, color: AppColors.textPrimary),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            '© ${DateTime.now().year} · Hecho con Flutter & mucho ☕ · Todos los derechos reservados.',
            style:
                const TextStyle(color: AppColors.textSecondary, fontSize: 13),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ─── IMAGE CAROUSEL ──────────────────────────────────────────────────────────
class _ImageCarousel extends StatefulWidget {
  final List<String> imagePaths;
  final bool isMobile;

  const _ImageCarousel({required this.imagePaths, this.isMobile = true});

  @override
  State<_ImageCarousel> createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<_ImageCarousel> {
  late PageController _pageController;
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_currentPage < widget.imagePaths.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      if (_pageController.hasClients) {
        _pageController.animateToPage(_currentPage,
            duration: 500.ms, curve: Curves.easeInOut);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PageView.builder(
          controller: _pageController,
          onPageChanged: (p) => setState(() => _currentPage = p),
          itemCount: widget.imagePaths.length,
          itemBuilder: (context, index) {
            return Center(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: widget.isMobile ? 20 : 12,
                  horizontal: widget.isMobile ? 16 : 12,
                ),
                child: AspectRatio(
                  aspectRatio: widget.isMobile ? 9 / 19.5 : 1.6,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A1A),
                      borderRadius:
                          BorderRadius.circular(widget.isMobile ? 24 : 12),
                      border: Border.all(color: Colors.grey.shade800, width: 4),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withValues(alpha: 0.5),
                            blurRadius: 20,
                            offset: const Offset(0, 10))
                      ],
                    ),
                    child: Column(
                      children: [
                        if (!widget.isMobile)
                          Container(
                            height: 24,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade900,
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(8)),
                            ),
                            child: Row(
                              children: [
                                _dot(Colors.red.shade400),
                                const SizedBox(width: 5),
                                _dot(Colors.orange.shade400),
                                const SizedBox(width: 5),
                                _dot(Colors.green.shade400),
                              ],
                            ),
                          ),
                        Expanded(
                          child: ClipRRect(
                            borderRadius:
                                BorderRadius.circular(widget.isMobile ? 20 : 0),
                            child: Image.asset(
                              widget.imagePaths[index],
                              fit: widget.isMobile
                                  ? BoxFit.cover
                                  : BoxFit.contain,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        // Dot indicators
        Positioned(
          bottom: widget.isMobile ? 10 : 4,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.imagePaths.length, (i) {
              return AnimatedContainer(
                duration: 300.ms,
                margin: const EdgeInsets.symmetric(horizontal: 3),
                height: 6,
                width: _currentPage == i ? 20 : 6,
                decoration: BoxDecoration(
                  gradient: _currentPage == i
                      ? const LinearGradient(
                          colors: [AppColors.primary, AppColors.accent])
                      : null,
                  color: _currentPage == i
                      ? null
                      : Colors.white.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(3),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _dot(Color color) => Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      );
}
