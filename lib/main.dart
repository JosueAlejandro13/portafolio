import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() {
  runApp(const PortfolioWeb());
}

class PortfolioWeb extends StatelessWidget {
  const PortfolioWeb({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JAHC',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true).copyWith(
        scaffoldBackgroundColor:
            const Color(0xFF0B0F19), // Dark sleek background
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF00F0FF), // Neon cyan
          brightness: Brightness.dark,
          primary: const Color(0xFF00F0FF),
          secondary: const Color(0xFF7000FF), // Neon purple
        ),
        textTheme: GoogleFonts.outfitTextTheme(ThemeData.dark().textTheme),
      ),
      home: const PortfolioHomePage(),
    );
  }
}

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

  void _scrollToTop() {
    _scrollController.animateTo(0,
        duration: const Duration(seconds: 1), curve: Curves.easeInOut);
  }

  void _scrollToSection(GlobalKey key) {
    if (key.currentContext != null) {
      Scrollable.ensureVisible(
        key.currentContext!,
        duration: const Duration(seconds: 1),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 800;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: ClipRRect(
          child: AppBar(
            backgroundColor: const Color(0xFF0B0F19).withOpacity(0.8),
            elevation: 0,
            title: Padding(
              padding: EdgeInsets.only(left: isDesktop ? 40.0 : 0.0),
              child: Text(
                '<Dev/>',
                style: GoogleFonts.firaCode(
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ).animate().fade(duration: 800.ms).slideX(begin: -0.2),
            ),
            actions: isDesktop
                ? [
                    _NavBarItem(title: 'Inicio', onTap: _scrollToTop),
                    _NavBarItem(
                        title: 'Experiencia',
                        onTap: () => _scrollToSection(_experienceKey)),
                    _NavBarItem(
                        title: 'Tecnologías',
                        onTap: () => _scrollToSection(_techKey)),
                    _NavBarItem(
                        title: 'Proyectos',
                        onTap: () => _scrollToSection(_projectsKey)),
                    const SizedBox(width: 40),
                  ]
                : [],
          ),
        ),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            _HeroSection(isDesktop: isDesktop),
            const SizedBox(height: 100),
            _SectionContainer(
              key: _experienceKey,
              title: 'Experiencia Profesional',
              child: _ExperienceSection(isDesktop: isDesktop),
            ),
            const SizedBox(height: 120),
            _SectionContainer(
              key: _techKey,
              title: 'Tecnologías que Domino',
              child: _TechnologiesSection(isDesktop: isDesktop),
            ),
            const SizedBox(height: 120),
            _SectionContainer(
              key: _projectsKey,
              title: 'Proyectos Destacados',
              child: _ProjectsSection(isDesktop: isDesktop),
            ),
            const SizedBox(height: 120),
            _SectionContainer(
              title: 'Hablemos',
              child: _ContactSection(isDesktop: isDesktop),
            ),
            const SizedBox(height: 80),
            _Footer(),
          ],
        ),
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const _NavBarItem({required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TextButton(
        onPressed: onTap,
        style: TextButton.styleFrom(
          foregroundColor: Colors.white70,
        ),
        child: Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}

class _SectionContainer extends StatelessWidget {
  final String title;
  final Widget child;

  const _SectionContainer(
      {super.key, required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
            ).animate().fade(duration: 600.ms).slideY(begin: 0.2).shimmer(
                delay: 500.ms, duration: 1000.ms, color: Colors.white24),
            const SizedBox(height: 8),
            Container(
              height: 4,
              width: 60,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(2),
              ),
            )
                .animate()
                .scaleX(begin: 0, duration: 600.ms, curve: Curves.easeOut),
            const SizedBox(height: 40),
            child,
          ],
        ),
      ),
    );
  }
}

class _HeroSection extends StatelessWidget {
  final bool isDesktop;

  const _HeroSection({required this.isDesktop});

  @override
  Widget build(BuildContext context) {
    final content = Column(
      crossAxisAlignment:
          isDesktop ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.3)),
          ),
          child: Text(
            'Disponible para nuevos proyectos',
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ).animate().fade(delay: 200.ms).slideY(begin: 0.2),
        const SizedBox(height: 24),
        Text(
          'Alejandro Hernández',
          style: Theme.of(context).textTheme.displayLarge?.copyWith(
                fontWeight: FontWeight.w900,
                height: 1.1,
                color: Colors.white,
                fontSize: isDesktop ? 80 : 56,
              ),
          textAlign: isDesktop ? TextAlign.left : TextAlign.center,
        ).animate().fade(delay: 400.ms).slideY(begin: 0.2),
        const SizedBox(height: 16),
        Text(
          'Desarrollador de software especializado en Flutter, con experiencia en el diseño y desarrollo de aplicaciones móviles robustas, escalables y de alto rendimiento para Android e iOS.',
          style: TextStyle(
            fontSize: isDesktop ? 18 : 16,
            fontWeight: FontWeight.w400,
            color: Colors.white70,
            height: 1.5,
          ),
          textAlign: isDesktop ? TextAlign.left : TextAlign.center,
        ).animate().fade(delay: 600.ms).slideY(begin: 0.2),
        const SizedBox(height: 32),
        ElevatedButton.icon(
          onPressed: () async {
            const url =
                'https://drive.google.com/file/d/11q1RIElbN9IzIITODxjgntz3cA7zrjlu/view?usp=sharing'; // Pega aquí tu link de Drive
            final uri = Uri.parse(url);
            if (await canLaunchUrl(uri)) {
              await launchUrl(uri);
            }
          },
          icon: const Icon(Icons.download_rounded),
          label: const Text('Descargar CV',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Colors.black,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 10,
            shadowColor: Theme.of(context).colorScheme.primary.withOpacity(0.5),
          ),
        )
            .animate(onPlay: (controller) => controller.repeat(reverse: true))
            .scaleXY(begin: 1, end: 1.05, duration: 1000.ms),
      ],
    );

    final avatar = Container(
      width: isDesktop ? 400 : 280,
      height: isDesktop ? 400 : 280,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: SweepGradient(
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.secondary,
            Theme.of(context).colorScheme.primary,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
            blurRadius: 50,
            spreadRadius: 10,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFF0B0F19), // Fondo interno
          ),
          child: ClipOval(
            child: Image.asset(
              'assets/avatar.png',
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    )
        .animate()
        .fade(delay: 800.ms)
        .scale(begin: const Offset(0.8, 0.8))
        .shimmer(duration: 2000.ms);

    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 800),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1200),
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: isDesktop ? 120 : 160,
            bottom: 40,
          ),
          child: isDesktop
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: content),
                    const SizedBox(width: 40),
                    avatar,
                  ],
                )
              : Column(
                  children: [
                    avatar,
                    const SizedBox(height: 60),
                    content,
                  ],
                ),
        ),
      ),
    );
  }
}

class _ExperienceSection extends StatelessWidget {
  final bool isDesktop;

  const _ExperienceSection({required this.isDesktop});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 24,
      runSpacing: 24,
      alignment: WrapAlignment.center,
      children: [
        _HoverCard(
          child: _StatWidget(
            number: '3+',
            title: 'Años de\nExperiencia',
            icon: Icons.timeline,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        _HoverCard(
          child: _StatWidget(
            number: '2',
            title: 'Apps\nPublicadas',
            icon: Icons.rocket_launch,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        _HoverCard(
          child: _StatWidget(
            number: '1',
            title: 'Librería en\npub.dev',
            icon: Icons.library_books,
            color: Colors.pinkAccent,
          ),
        ),
      ]
          .animate(interval: 200.ms)
          .fade(duration: 600.ms)
          .slideY(begin: 0.2, curve: Curves.easeOut),
    );
  }
}

class _StatWidget extends StatelessWidget {
  final String number;
  final String title;
  final IconData icon;
  final Color color;

  const _StatWidget({
    required this.number,
    required this.title,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: const Color(0xFF151B2B),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: color, size: 32),
          ),
          const SizedBox(height: 24),
          Text(
            number,
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.white70,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _TechnologiesSection extends StatelessWidget {
  final bool isDesktop;

  const _TechnologiesSection({required this.isDesktop});

  @override
  Widget build(BuildContext context) {
    final techList = [
      {
        'name': 'Flutter',
        'icon': Icons.flutter_dash,
        'color': Colors.lightBlue
      },
      {'name': 'Dart', 'icon': Icons.code, 'color': Colors.blueAccent},
      {
        'name': 'Firebase',
        'icon': Icons.local_fire_department,
        'color': Colors.orange
      },
      {'name': 'PHP', 'icon': Icons.php, 'color': Colors.indigoAccent},
      {'name': 'Android', 'icon': Icons.android, 'color': Colors.green},
      {'name': 'Swift', 'icon': Icons.apple, 'color': Colors.orangeAccent},
      {'name': 'GitHub', 'icon': Icons.account_tree, 'color': Colors.white},
    ];

    return Wrap(
      spacing: 24,
      runSpacing: 24,
      alignment: WrapAlignment.center,
      children: techList
          .map((tech) {
            return _HoverCard(
              child: _TechWidget(
                name: tech['name'] as String,
                icon: tech['icon'] as IconData,
                color: tech['color'] as Color,
                isDesktop: isDesktop,
              ),
            );
          })
          .toList()
          .animate(interval: 100.ms)
          .fade(duration: 500.ms)
          .scale(curve: Curves.easeOutBack),
    );
  }
}

class _TechWidget extends StatelessWidget {
  final String name;
  final IconData icon;
  final Color color;
  final bool isDesktop;

  const _TechWidget({
    required this.name,
    required this.icon,
    required this.color,
    required this.isDesktop,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isDesktop ? 260 : 160,
      padding: EdgeInsets.all(isDesktop ? 32 : 20),
      decoration: BoxDecoration(
        color: const Color(0xFF151B2B),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(isDesktop ? 24 : 16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Icon(icon, color: color, size: isDesktop ? 64 : 40),
          ),
          SizedBox(height: isDesktop ? 24 : 16),
          Text(
            name,
            style: TextStyle(
              fontSize: isDesktop ? 24 : 18,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _ProjectsSection extends StatelessWidget {
  final bool isDesktop;

  const _ProjectsSection({required this.isDesktop});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = isDesktop ? 2 : 1;
        final childAspectRatio = isDesktop ? 0.85 : 0.55;

        return GridView.count(
          crossAxisCount: crossAxisCount,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 24,
          mainAxisSpacing: 24,
          childAspectRatio: childAspectRatio,
          children: [
            _ProjectCard(
              title: 'App Mark (Rutas GPS)',
              description:
                  'Plataforma para trazado y seguimiento de rutas por GPS en tiempo real.',
              tags: const ['Flutter', 'Firebase', 'Android'],
              imageColor: Colors.blueAccent.withOpacity(0.2),
              isPrivate: true,
              imagePaths: const [
                'assets/mark/1.png',
                'assets/mark/2.png',
                'assets/mark/3.png',
                'assets/mark/4.png',
                'assets/mark/5.png',
                'assets/mark/6.png',
                'assets/mark/7.png',
                'assets/mark/8.png',
                'assets/mark/9.png',
              ],
              isMobileCarousel: true,
            ),
            _ProjectCard(
              title: 'Manager Web Platform',
              description:
                  'Plataforma administrativa web para gestión de datos de la aplicación Flutter.',
              tags: const ['PHP', 'JS', 'HTML', 'CSS'],
              imageColor: Colors.orangeAccent.withOpacity(0.2),
              isPrivate: true,
              isMobileCarousel: false,
              imagePaths: const [
                'assets/manager/1.png',
                'assets/manager/2.png',
                'assets/manager/3.png',
                'assets/manager/4.png',
                'assets/manager/5.png',
                'assets/manager/6.png',
                'assets/manager/7.png',
              ],
            ),
            _ProjectCard(
              title: 'Consultorio PH Web',
              description:
                  'Página web profesional e informativa para un consultorio médico moderno.',
              tags: const ['HTML', 'CSS', 'JS', 'Tailwind'],
              imageColor: Colors.tealAccent.withOpacity(0.2),
              url: 'https://anaisph.github.io/',
              githubUrl: 'https://github.com/AnaisPH/AnaisPH.github.io',
              isMobileCarousel: false,
              imagePaths: const [
                'assets/consultorioweb/1.png',
                'assets/consultorioweb/2.png',
                'assets/consultorioweb/3.png',
                'assets/consultorioweb/4.png',
                'assets/consultorioweb/5.png',
              ],
            ),
            _ProjectCard(
              title: 'App Consultorio PH',
              description:
                  'Aplicación móvil multiplataforma para programar y administrar citas en el consultorio.',
              tags: const ['Flutter', 'Firebase', 'Android', 'iOS'],
              imageColor: Colors.pinkAccent.withOpacity(0.2),
              githubUrl: 'https://github.com/JosueAlejandro13/phmov',
            ),
            _ProjectCard(
              title: 'App de Películas',
              description:
                  'Aplicación móvil orientada a descubrir las tendencias actuales del cine.',
              tags: const ['Flutter', 'API REST'],
              imageColor: Colors.purpleAccent.withOpacity(0.2),
              githubUrl: 'https://github.com/JosueAlejandro13/PruebaT',
              imagePaths: const [
                'assets/appPeliculas/1.jpeg',
                'assets/appPeliculas/2.jpeg',
                'assets/appPeliculas/3.jpeg',
                'assets/appPeliculas/4.jpeg',
                'assets/appPeliculas/5.jpeg',
                'assets/appPeliculas/6.jpeg',
                'assets/appPeliculas/7.jpeg',
              ],
            ),
            _ProjectCard(
              title: 'flutter_app_core_freezed',
              description:
                  'Un paquete ligero de Flutter que proporciona los bloques de construcción esenciales para aplicaciones en producción: cliente HTTP tipado, envoltorio funcional Result<T>, gestión de estado basada en BLoC y almacenamiento seguro de tokens.',
              tags: const ['Flutter', 'Package', 'pub.dev'],
              imageColor: Colors.indigo.withOpacity(0.2),
              url: 'https://pub.dev/packages/flutter_app_core_freezed',
              showFlutterLogo: true,
            ),
          ].animate(interval: 200.ms).fade(duration: 800.ms).slideX(begin: 0.1),
        );
      },
    );
  }
}

class _ProjectCard extends StatefulWidget {
  final String title;
  final String description;
  final List<String> tags;
  final Color imageColor;
  final String? url;
  final String? imagePath;
  final List<String>? imagePaths;
  final String? githubUrl;
  final bool showFlutterLogo;
  final bool isMobileCarousel;
  final bool isPrivate;

  const _ProjectCard({
    required this.title,
    required this.description,
    required this.tags,
    required this.imageColor,
    this.url,
    this.imagePath,
    this.imagePaths,
    this.githubUrl,
    this.showFlutterLogo = false,
    this.isMobileCarousel = true,
    this.isPrivate = false,
  });

  @override
  State<_ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<_ProjectCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      cursor: SystemMouseCursors.basic,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        transform: Matrix4.identity()..translate(0.0, isHovered ? -10.0 : 0.0),
        decoration: BoxDecoration(
          color: const Color(0xFF151B2B),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isHovered
                ? Theme.of(context).colorScheme.primary.withOpacity(0.5)
                : Colors.white.withOpacity(0.05),
            width: 2,
          ),
          boxShadow: [
            if (isHovered)
              BoxShadow(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                blurRadius: 30,
                spreadRadius: -5,
              ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 5,
                child: Container(
                  color: widget.imageColor,
                  child:
                      widget.imagePaths != null && widget.imagePaths!.isNotEmpty
                          ? _ImageCarousel(
                              imagePaths: widget.imagePaths!,
                              isMobile: widget.isMobileCarousel,
                            )
                          : widget.imagePath != null
                              ? Image.asset(
                                  widget.imagePath!,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                )
                              : Center(
                                  child: widget.showFlutterLogo
                                      ? const FlutterLogo(size: 100)
                                      : Icon(Icons.image_outlined,
                                          size: 60,
                                          color: Colors.white.withOpacity(0.3)),
                                ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        widget.description,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                          height: 1.5,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: widget.tags.map((tag) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              tag,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          if (widget.url != null)
                            _ProjectActionButton(
                              icon: Icons.visibility_outlined,
                              label: 'Ver',
                              onTap: () async {
                                final uri = Uri.parse(widget.url!);
                                if (await canLaunchUrl(uri)) {
                                  await launchUrl(uri);
                                }
                              },
                            ),
                          if (widget.isPrivate) ...[
                            const SizedBox(width: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.orange.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                    color: Colors.orange.withOpacity(0.3)),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.lock_outline,
                                      size: 14, color: Colors.orange),
                                  SizedBox(width: 6),
                                  Text(
                                    'Proyecto empresarial privado',
                                    style: TextStyle(
                                      color: Colors.orange,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ] else if (widget.githubUrl != null) ...[
                            const SizedBox(width: 12),
                            _ProjectActionButton(
                              icon: FontAwesomeIcons.github,
                              label: 'GitHub',
                              onTap: () async {
                                final uri = Uri.parse(widget.githubUrl!);
                                if (await canLaunchUrl(uri)) {
                                  await launchUrl(uri);
                                }
                              },
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

class _ContactSection extends StatelessWidget {
  final bool isDesktop;

  const _ContactSection({required this.isDesktop});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary.withOpacity(0.1),
            Theme.of(context).colorScheme.secondary.withOpacity(0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: isDesktop
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: _ContactInfo()),
                const SizedBox(width: 40),
                Expanded(child: _ContactForm()),
              ],
            )
          : Column(
              children: [
                _ContactInfo(),
                const SizedBox(height: 40),
                _ContactForm(),
              ],
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
        const Text(
          '¿Tienes una idea en mente?',
          style: TextStyle(
              fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(height: 16),
        const Text(
          'Estoy disponible para trabajos freelance o para unirme a un gran equipo. ¡Escríbeme y hablemos!',
          style: TextStyle(fontSize: 18, color: Colors.white70, height: 1.5),
        ),
        const SizedBox(height: 40),
        _ContactItem(
          icon: Icons.email,
          text: 'castealejandro13@gmail.com',
          url: 'mailto:castealejandro13@gmail.com',
        ),
        const SizedBox(height: 16),
        _ContactItem(
          icon: Icons.phone,
          text: '+52 56-21-91-51-71',
          url: 'tel:+525621915171',
        ),
        const SizedBox(height: 16),
        _ContactItem(
          icon: Icons.location_on,
          text: 'México',
        ),
      ],
    );
  }
}

class _ContactItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final String? url;

  const _ContactItem({required this.icon, required this.text, this.url});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        if (url != null) {
          final uri = Uri.parse(url!);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri);
          }
        }
      },
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Theme.of(context).colorScheme.primary),
            ),
            const SizedBox(width: 16),
            Text(
              text,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

class _ContactForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.flutter_dash,
          size: 200,
          color: Colors.blue,
        ),
      )
          .animate(onPlay: (controller) => controller.repeat(reverse: true))
          .moveY(
              begin: -15, end: 15, duration: 2.seconds, curve: Curves.easeInOut)
          .scale(
              begin: const Offset(0.95, 0.95),
              end: const Offset(1.05, 1.05),
              duration: 2.seconds,
              curve: Curves.easeInOut),
    );
  }
}

class _Footer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40),
      width: double.infinity,
      color: Colors.black26,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.account_tree, color: Colors.white70)),
              IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.work, color: Colors.white70)),
              IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.code, color: Colors.white70)),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            '© ${DateTime.now().year} Creado con Flutter y mucho ☕',
            style: const TextStyle(color: Colors.white54, fontSize: 14),
          ),
        ],
      ),
    );
  }
}

// Widget utilitario para efectos de Hover
class _HoverCard extends StatefulWidget {
  final Widget child;

  const _HoverCard({required this.child});

  @override
  State<_HoverCard> createState() => _HoverCardState();
}

class _HoverCardState extends State<_HoverCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.identity()..scale(isHovered ? 1.05 : 1.0),
        child: widget.child,
      ),
    );
  }
}

class _ProjectActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ProjectActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 16),
      label: Text(label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
      style: ElevatedButton.styleFrom(
        backgroundColor:
            Theme.of(context).colorScheme.primary.withOpacity(0.15),
        foregroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.3)),
        ),
      ),
    );
  }
}

class _ImageCarousel extends StatefulWidget {
  final List<String> imagePaths;
  final bool isMobile;

  const _ImageCarousel({
    required this.imagePaths,
    this.isMobile = true,
  });

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
    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_currentPage < widget.imagePaths.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
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
          onPageChanged: (int page) {
            setState(() {
              _currentPage = page;
            });
          },
          itemCount: widget.imagePaths.length,
          itemBuilder: (context, index) {
            return Center(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: widget.isMobile ? 20.0 : 12.0,
                  horizontal: widget.isMobile ? 16.0 : 12.0,
                ),
                child: AspectRatio(
                  aspectRatio: widget.isMobile
                      ? 9 / 19.5
                      : 1.6, // Aspect ratio de smartphone o laptop
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(
                          0xFF1A1A1A), // Color del borde del dispositivo
                      borderRadius:
                          BorderRadius.circular(widget.isMobile ? 24 : 12),
                      border: Border.all(color: Colors.grey.shade800, width: 4),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        if (!widget.isMobile)
                          Container(
                            height: 25,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade900,
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(8)),
                            ),
                            child: Row(
                              children: [
                                _browserDot(Colors.red.shade400),
                                const SizedBox(width: 6),
                                _browserDot(Colors.orange.shade400),
                                const SizedBox(width: 6),
                                _browserDot(Colors.green.shade400),
                              ],
                            ),
                          ),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                                widget.isMobile ? 20 : 0),
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
        Positioned(
          bottom: widget.isMobile ? 12 : 2,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.imagePaths.length, (index) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                height: widget.isMobile ? 8 : 6,
                width: _currentPage == index
                    ? (widget.isMobile ? 24 : 18)
                    : (widget.isMobile ? 8 : 6),
                decoration: BoxDecoration(
                  color: _currentPage == index
                      ? Theme.of(context).colorScheme.primary
                      : Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _browserDot(Color color) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}
