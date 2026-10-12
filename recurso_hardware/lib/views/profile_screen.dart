import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/auth_provider.dart';
import '../controllers/time_clock_provider.dart';
import '../services/firebase_service.dart';
import '../theme/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final clock = context.watch<TimeClockProvider>();
    final firebaseService = context.watch<FirebaseService>();
    final employee = auth.currentUser;

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        title: const Text('Perfil & Recursos de Hardware'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Card do Colaborador
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: AppTheme.primaryBlue,
                      child: Text(
                        employee != null && employee.name.isNotEmpty
                            ? employee.name[0].toUpperCase()
                            : 'F',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            employee?.name ?? 'Não identificado',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            employee?.role ?? '',
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppTheme.primaryBlue,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'NIF: ${employee?.nif ?? "--"} | ${employee?.department ?? "--"}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                          Text(
                            employee?.email ?? '',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Card de Diagnóstico dos Recursos de Hardware
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.memory_rounded, color: AppTheme.primaryBlue, size: 22),
                        SizedBox(width: 8),
                        Text(
                          'Recursos de Hardware & Integrações',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Biometria
                    _buildDiagnosticItem(
                      icon: Icons.face_unlock_rounded,
                      title: 'Biometria / Reconhecimento Facial',
                      subtitle: auth.isBiometricSupported
                          ? 'Sensor biométrico disponível no dispositivo'
                          : 'Hardware biométrico não detectado ou inativo',
                      statusColor: auth.isBiometricSupported
                          ? AppTheme.accentGreen
                          : AppTheme.accentWarning,
                      statusText: auth.isBiometricSupported ? 'Ativo' : 'Indisponível',
                    ),
                    const Divider(height: 20),

                    // GPS / Geolocalização
                    _buildDiagnosticItem(
                      icon: Icons.gps_fixed_rounded,
                      title: 'Geolocalização (GPS Nativo)',
                      subtitle: clock.currentPosition != null
                          ? 'Coordenadas obtidas com precisão'
                          : 'Verificando sinal de GPS...',
                      statusColor: clock.currentPosition != null
                          ? AppTheme.accentGreen
                          : AppTheme.accentWarning,
                      statusText: clock.currentPosition != null ? 'Conectado' : 'Aguardando',
                    ),
                    const Divider(height: 20),

                    // Firebase
                    _buildDiagnosticItem(
                      icon: Icons.cloud_done_rounded,
                      title: 'Integração Firebase / Cloud Firestore',
                      subtitle: firebaseService.isInitialized
                          ? 'Conexão ativa em tempo real com o banco de dados'
                          : 'Modo Local / Demonstração ativo (Pronto para conectar)',
                      statusColor: firebaseService.isInitialized
                          ? AppTheme.accentGreen
                          : AppTheme.primaryBlue,
                      statusText: firebaseService.isInitialized ? 'Online' : 'Modo Demo',
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Card de Ações de Sincronização
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: Color(0xFFEFF6FF),
                        child: Icon(Icons.sync_rounded, color: AppTheme.primaryBlue),
                      ),
                      title: const Text('Sincronizar com a Nuvem'),
                      subtitle: const Text('Enviar registros pendentes para o Firebase'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () async {
                        final count = await clock.syncPendingRecords();
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(clock.successMessage ?? '$count registro(s) sincronizados.'),
                              backgroundColor: AppTheme.accentGreen,
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Botão Logout
            OutlinedButton.icon(
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Encerrar Sessão'),
                    content: const Text('Deseja realmente sair da sua conta?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(false),
                        child: const Text('Cancelar'),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.of(ctx).pop(true),
                        style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accentDanger),
                        child: const Text('Sair'),
                      ),
                    ],
                  ),
                );

                if (confirm == true) {
                  await auth.logout();
                }
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.accentDanger,
                side: const BorderSide(color: AppTheme.accentDanger),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              icon: const Icon(Icons.logout_rounded, size: 20),
              label: const Text('Encerrar Sessão do Colaborador'),
            ),

            const SizedBox(height: 20),
            Center(
              child: Text(
                'Avaliação Somativa - Situação de Aprendizagem\nRecursos de Hardware • Flutter Mobile',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 11, color: Colors.grey[500]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDiagnosticItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color statusColor,
    required String statusText,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: statusColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: statusColor, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: statusColor.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            statusText,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: statusColor,
            ),
          ),
        ),
      ],
    );
  }
}
