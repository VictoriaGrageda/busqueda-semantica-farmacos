import 'package:flutter/material.dart';

import '../../app/theme/app_theme.dart';
import '../../widgets/app_gradient_header.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({
    required this.favoriteCount,
    required this.historyCount,
    required this.onSettingsTap,
    super.key,
  });

  final int favoriteCount;
  final int historyCount;
  final VoidCallback onSettingsTap;

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
                        color: Colors.white.withOpacity(0.2),
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
                            'Estudiante de Medicina',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'estudiante@gmail.com',
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
                      const VerticalDivider(width: 1),
                      Expanded(
                        child: _ProfileMetric(
                          icon: Icons.history,
                          value: '$historyCount',
                          label: 'Busquedas',
                          color: AppTheme.secondary,
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
              children: [
                _ProfileAction(
                  icon: Icons.settings_outlined,
                  title: 'Configuracion',
                  subtitle: 'Personaliza tu experiencia',
                  color: AppTheme.primary,
                  onTap: onSettingsTap,
                ),
                const SizedBox(height: 12),
                const _ProfileAction(
                  icon: Icons.verified_user_outlined,
                  title: 'Privacidad y Seguridad',
                  subtitle: 'Gestiona tus datos',
                  color: AppTheme.secondary,
                ),
                const SizedBox(height: 12),
                const _ProfileAction(
                  icon: Icons.account_circle_outlined,
                  title: 'Informacion de la cuenta',
                  subtitle: 'Datos de Google',
                  color: AppTheme.accent,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.logout),
                    label: const Text('Cerrar Sesion'),
                    style: TextButton.styleFrom(
                      foregroundColor: AppTheme.danger,
                      backgroundColor: AppTheme.danger.withOpacity(0.1),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                const Text(
                  'FarmacoBolivia v1.0.0',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Desarrollado para estudiantes de medicina',
                  textAlign: TextAlign.center,
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
          Text(value, style: Theme.of(context).textTheme.titleLarge),
          Text(
            label,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.58),
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
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: onTap,
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
      ),
    );
  }
}
