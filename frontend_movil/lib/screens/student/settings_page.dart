import 'package:flutter/material.dart';

import '../../app/theme/app_theme.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({
    required this.darkModeEnabled,
    required this.onDarkModeChanged,
    required this.onClearHistory,
    super.key,
  });

  final bool darkModeEnabled;
  final ValueChanged<bool> onDarkModeChanged;
  final VoidCallback onClearHistory;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true;
  late bool _darkModeEnabled = widget.darkModeEnabled;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Container(
              color: Theme.of(context).colorScheme.surface,
              padding: const EdgeInsets.fromLTRB(8, 8, 16, 12),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back),
                  ),
                  Text(
                    'Configuracion',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  _SettingsSection(
                    title: 'PREFERENCIAS',
                    children: [
                      _SwitchSettingTile(
                        icon: Icons.notifications_outlined,
                        color: AppTheme.primary,
                        title: 'Notificaciones',
                        subtitle: 'Recibir alertas',
                        value: _notificationsEnabled,
                        onChanged: (value) {
                          setState(() {
                            _notificationsEnabled = value;
                          });
                        },
                      ),
                      _SwitchSettingTile(
                        icon: Icons.dark_mode_outlined,
                        color: AppTheme.secondary,
                        title: 'Modo Oscuro',
                        subtitle: 'Tema de la app',
                        value: _darkModeEnabled,
                        onChanged: (value) {
                          setState(() {
                            _darkModeEnabled = value;
                          });
                          widget.onDarkModeChanged(value);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  _SettingsSection(
                    title: 'DATOS',
                    children: [
                      const _ActionSettingTile(
                        icon: Icons.download_outlined,
                        color: AppTheme.accent,
                        title: 'Descargar mis datos',
                        subtitle: 'Exportar informacion',
                      ),
                      _ActionSettingTile(
                        icon: Icons.delete_outline,
                        color: AppTheme.danger,
                        title: 'Borrar historial',
                        subtitle: 'Eliminar busquedas guardadas',
                        onTap: widget.onClearHistory,
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  const _AboutSection(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  const _SettingsSection({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.58),
            fontSize: 12,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 10),
        Card(
          child: Column(
            children: [
              for (var index = 0; index < children.length; index++) ...[
                children[index],
                if (index < children.length - 1) const Divider(height: 1),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _SwitchSettingTile extends StatelessWidget {
  const _SwitchSettingTile({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          _SettingIcon(icon: icon, color: color),
          const SizedBox(width: 12),
          Expanded(child: _SettingText(title: title, subtitle: subtitle)),
          Switch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}

class _ActionSettingTile extends StatelessWidget {
  const _ActionSettingTile({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            _SettingIcon(icon: icon, color: color),
            const SizedBox(width: 12),
            Expanded(
              child: _SettingText(
                title: title,
                subtitle: subtitle,
                titleColor: color == AppTheme.danger ? AppTheme.danger : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingIcon extends StatelessWidget {
  const _SettingIcon({required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, color: color, size: 21),
    );
  }
}

class _SettingText extends StatelessWidget {
  const _SettingText({
    required this.title,
    required this.subtitle,
    this.titleColor,
  });

  final String title;
  final String subtitle;
  final Color? titleColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: titleColor,
                fontSize: 14,
              ),
        ),
        const SizedBox(height: 3),
        Text(
          subtitle,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.58),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

class _AboutSection extends StatelessWidget {
  const _AboutSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ACERCA DE',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.58),
            fontSize: 12,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 10),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: const [
                _AboutRow(label: 'Version', value: '1.0.0'),
                SizedBox(height: 12),
                _AboutRow(label: 'Desarrollador', value: 'Proyecto de Grado'),
                SizedBox(height: 12),
                _AboutLink(label: 'Terminos y Condiciones'),
                SizedBox(height: 12),
                _AboutLink(label: 'Politica de Privacidad'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _AboutRow extends StatelessWidget {
  const _AboutRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.58),
          ),
        ),
        Text(value, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}

class _AboutLink extends StatelessWidget {
  const _AboutLink({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        label,
        style: const TextStyle(
          color: AppTheme.primary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
