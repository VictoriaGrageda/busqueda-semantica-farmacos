import 'package:flutter/material.dart';

import '../../app/theme/app_theme.dart';
import '../../widgets/app_gradient_header.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({
    required this.favoriteCount,
    required this.historyCount,
    required this.recentCount,
    super.key,
  });

  final int favoriteCount;
  final int historyCount;
  final int recentCount;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: ListView(
        children: [
          AppGradientHeader(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 42),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Perfil',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                      ),
                ),
                const SizedBox(height: 22),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.18),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 42,
                      ),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Estudiante de medicina',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Modo estudiante',
                            style: TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Transform.translate(
            offset: const Offset(0, -22),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Card(
                child: IntrinsicHeight(
                  child: Row(
                    children: [
                      Expanded(
                        child: _ProfileMetric(
                          icon: Icons.favorite,
                          value: '$favoriteCount',
                          label: 'Favoritos',
                          color: AppTheme.primary,
                        ),
                      ),
                      VerticalDivider(width: 1),
                      Expanded(
                        child: _ProfileMetric(
                          icon: Icons.history,
                          value: '$historyCount',
                          label: 'Busquedas',
                          color: AppTheme.secondary,
                        ),
                      ),
                      VerticalDivider(width: 1),
                      Expanded(
                        child: _ProfileMetric(
                          icon: Icons.medication_outlined,
                          value: '$recentCount',
                          label: 'Recientes',
                          color: AppTheme.accent,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                _ProfileSectionTitle('Cuenta'),
                SizedBox(height: 10),
                _ProfileAction(
                  icon: Icons.account_circle_outlined,
                  title: 'Informacion de la cuenta',
                  subtitle: 'Se conectara con Google mas adelante',
                  color: AppTheme.accent,
                ),
                SizedBox(height: 12),
                _ProfileAction(
                  icon: Icons.school_outlined,
                  title: 'Rol actual',
                  subtitle: 'Estudiante, sin panel administrativo',
                  color: AppTheme.secondary,
                ),
                SizedBox(height: 22),
                _ProfileSectionTitle('Preferencias'),
                SizedBox(height: 10),
                _ProfileAction(
                  icon: Icons.settings_outlined,
                  title: 'Configuracion',
                  subtitle: 'Personaliza tu experiencia',
                  color: AppTheme.primary,
                ),
                SizedBox(height: 12),
                _ProfileAction(
                  icon: Icons.notifications_outlined,
                  title: 'Notificaciones',
                  subtitle: 'Recordatorios y alertas academicas pendientes',
                  color: AppTheme.warning,
                ),
                SizedBox(height: 12),
                _ProfileAction(
                  icon: Icons.language_outlined,
                  title: 'Idioma y region',
                  subtitle: 'Espanol, Bolivia',
                  color: AppTheme.secondary,
                ),
                SizedBox(height: 22),
                _ProfileSectionTitle('Seguridad'),
                SizedBox(height: 10),
                _ProfileAction(
                  icon: Icons.verified_user_outlined,
                  title: 'Privacidad y seguridad',
                  subtitle: 'Gestion de datos cuando exista login',
                  color: AppTheme.secondary,
                ),
                SizedBox(height: 12),
                _ProfileAction(
                  icon: Icons.login_outlined,
                  title: 'Inicio de sesion con Google',
                  subtitle: 'Pendiente para una siguiente etapa',
                  color: AppTheme.primary,
                ),
                SizedBox(height: 22),
                _ProfileSectionTitle('Informacion'),
                SizedBox(height: 10),
                _ProfileAction(
                  icon: Icons.info_outline,
                  title: 'Acerca de FarmaEdu',
                  subtitle: 'Apoyo academico para busqueda farmacologica',
                  color: AppTheme.accent,
                ),
                SizedBox(height: 24),
                Text(
                  'FarmaEdu Movil v1.0.0',
                  style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileSectionTitle extends StatelessWidget {
  const _ProfileSectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }
}

class _ProfileMetric extends StatelessWidget {
  const _ProfileMetric({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Text(
            label,
            style: TextStyle(
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withOpacity(0.58),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileAction extends StatelessWidget {
  const _ProfileAction({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(9),
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: Theme.of(context).textTheme.titleMedium),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}
