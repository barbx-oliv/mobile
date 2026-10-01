import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/auth_provider.dart';
import '../controllers/time_clock_provider.dart';
import '../models/time_record_model.dart';
import '../theme/app_theme.dart';
import '../utils/date_formatter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  AuthMethod _selectedAuthMethod = AuthMethod.biometric;

  void _onClockButtonPressed(TimeRecordType type) async {
    final auth = context.read<AuthProvider>();
    final clock = context.read<TimeClockProvider>();
    final employee = auth.currentUser;

    if (employee == null) return;

    // Diálogo de confirmação com transparência para o usuário
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        final distance = clock.currentDistance;
        final isWithin = clock.isWithinRadius;

        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          title: Row(
            children: [
              Icon(type.icon, color: type.color),
              const SizedBox(width: 10),
              Text('Registrar ${type.label}'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Confirme as informações antes de autenticar a batida de ponto:',
                style: TextStyle(color: Colors.grey[700], fontSize: 13),
              ),
              const SizedBox(height: 14),
              _buildDialogInfoRow('Colaborador:', '${employee.name} (${employee.nif})'),
              _buildDialogInfoRow('Horário:', AppFormatters.formatTimeWithSeconds(clock.currentTime)),
              _buildDialogInfoRow('Tipo de Batida:', type.label),
              _buildDialogInfoRow(
                'Distância Sede:',
                distance != null ? AppFormatters.formatDistance(distance) : 'Obtendo...',
                color: isWithin ? AppTheme.accentGreen : AppTheme.accentDanger,
              ),
              _buildDialogInfoRow(
                'Status Raio (100m):',
                isWithin ? 'Apto (≤ 100m)' : 'Bloqueado (> 100m)',
                color: isWithin ? AppTheme.accentGreen : AppTheme.accentDanger,
              ),
              _buildDialogInfoRow(
                'Validação:',
                _selectedAuthMethod == AuthMethod.biometric
                    ? 'Reconhecimento Facial / Biometria'
                    : 'Confirmação Manual',
              ),
              if (!isWithin) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppTheme.accentDanger.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppTheme.accentDanger.withValues(alpha: 0.3)),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.warning_amber_rounded, color: AppTheme.accentDanger, size: 20),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Atenção: Você está a mais de 100 metros do local de trabalho. O registro será bloqueado.',
                          style: TextStyle(
                            color: AppTheme.accentDanger,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: isWithin ? type.color : AppTheme.accentDanger,
              ),
              child: Text(
                _selectedAuthMethod == AuthMethod.biometric
                    ? 'Autenticar com Biometria'
                    : 'Confirmar Batida',
              ),
            ),
          ],
        );
      },
    );

    if (confirm != true || !mounted) return;

    final success = await clock.registerClock(
      employee: employee,
      type: type,
      authMethod: _selectedAuthMethod,
    );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(clock.successMessage ?? 'Ponto registrado com sucesso!'),
          backgroundColor: AppTheme.accentGreen,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 4),
        ),
      );
    } else if (clock.errorMessage != null) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Row(
            children: [
              Icon(Icons.gpp_bad_rounded, color: AppTheme.accentDanger),
              SizedBox(width: 8),
              Text('Validação Não Concluída'),
            ],
          ),
          content: Text(clock.errorMessage!),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Entendido'),
            ),
            if (clock.currentDistance != null && clock.currentDistance! > 100)
              ElevatedButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                  clock.setWorkplaceToCurrentLocation();
                },
                child: const Text('Fixar meu local para teste'),
              ),
          ],
        ),
      );
    }
  }

  Widget _buildDialogInfoRow(String label, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: color ?? AppTheme.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final clock = context.watch<TimeClockProvider>();
    final employee = auth.currentUser;

    final todayRecords = clock.records.where((r) {
      final now = DateTime.now();
      return r.timestamp.year == now.year &&
          r.timestamp.month == now.month &&
          r.timestamp.day == now.day;
    }).toList();

    final lastRecord = clock.records.isNotEmpty ? clock.records.first : null;

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await clock.refreshLocation();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Card Superior: Identificação do Colaborador + Relógio em Tempo Real
                Card(
                  color: AppTheme.primaryColor,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 22,
                              backgroundColor: Colors.white.withValues(alpha: 0.15),
                              child: Text(
                                employee != null && employee.name.isNotEmpty
                                    ? employee.name[0].toUpperCase()
                                    : 'F',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    employee?.name ?? 'Colaborador',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    'NIF: ${employee?.nif ?? "--"} • ${employee?.role ?? "--"}',
                                    style: TextStyle(
                                      color: Colors.grey[300],
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        const Divider(color: Colors.white24, height: 1),
                        const SizedBox(height: 18),
                        // Relógio Digital Dinâmico
                        Text(
                          AppFormatters.formatTimeWithSeconds(clock.currentTime),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 38,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 2,
                            fontFeatures: [],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          AppFormatters.formatFullDate(clock.currentTime),
                          style: TextStyle(
                            color: Colors.grey[300],
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Card de Geolocalização e Status do Raio de 100 Metros
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: (clock.isWithinRadius
                                        ? AppTheme.accentGreen
                                        : AppTheme.accentDanger)
                                    .withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                clock.isWithinRadius
                                    ? Icons.location_on_rounded
                                    : Icons.location_off_rounded,
                                color: clock.isWithinRadius
                                    ? AppTheme.accentGreen
                                    : AppTheme.accentDanger,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Geolocalização do Trabalho',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.textPrimary,
                                    ),
                                  ),
                                  Text(
                                    clock.workplace.name,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppTheme.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              tooltip: 'Atualizar Coordenadas GPS',
                              icon: clock.isLoadingLocation
                                  ? const SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(strokeWidth: 2),
                                    )
                                  : const Icon(Icons.refresh_rounded),
                              onPressed:
                                  clock.isLoadingLocation ? null : () => clock.refreshLocation(),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Banner de Status de Aprovação do Raio de 100m
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          decoration: BoxDecoration(
                            color: clock.isWithinRadius
                                ? const Color(0xFFECFDF5) // Emerald 50
                                : const Color(0xFFFEF2F2), // Red 50
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: clock.isWithinRadius
                                  ? const Color(0xFFA7F3D0)
                                  : const Color(0xFFFECACA),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                clock.isWithinRadius
                                    ? Icons.verified_rounded
                                    : Icons.cancel_rounded,
                                color: clock.isWithinRadius
                                    ? AppTheme.accentGreen
                                    : AppTheme.accentDanger,
                                size: 24,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      clock.isWithinRadius
                                          ? 'DENTRO DO LIMITE (≤ 100 METROS)'
                                          : 'FORA DO LIMITE PERMITIDO (> 100M)',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: clock.isWithinRadius
                                            ? AppTheme.accentGreen
                                            : AppTheme.accentDanger,
                                      ),
                                    ),
                                    Text(
                                      clock.currentDistance != null
                                          ? 'Distância atual: ${AppFormatters.formatDistance(clock.currentDistance!)}'
                                          : 'Obtendo distância via GPS...',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: clock.isWithinRadius
                                            ? const Color(0xFF065F46)
                                            : const Color(0xFF991B1B),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Detalhamento de Coordenadas
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Suas Coordenadas:',
                                      style: TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
                                  Text(
                                    clock.currentPosition != null
                                        ? '${clock.currentPosition!.latitude.toStringAsFixed(5)}, ${clock.currentPosition!.longitude.toStringAsFixed(5)}'
                                        : 'Aguardando GPS...',
                                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                            TextButton.icon(
                              onPressed: () => clock.setWorkplaceToCurrentLocation(),
                              icon: const Icon(Icons.my_location_rounded, size: 16),
                              label: const Text(
                                'Ajustar para Teste',
                                style: TextStyle(fontSize: 11),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Seleção de Modo de Autenticação para a Batida
                Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Método de Validação da Batida',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: ChoiceChip(
                                avatar: const Icon(Icons.face_unlock_rounded, size: 18),
                                label: const Text('Reconhecimento Facial / Biometria'),
                                selected: _selectedAuthMethod == AuthMethod.biometric,
                                onSelected: (sel) {
                                  if (sel) setState(() => _selectedAuthMethod = AuthMethod.biometric);
                                },
                              ),
                            ),
                            const SizedBox(width: 8),
                            ChoiceChip(
                              avatar: const Icon(Icons.password_rounded, size: 18),
                              label: const Text('Senha'),
                              selected: _selectedAuthMethod == AuthMethod.password,
                              onSelected: (sel) {
                                if (sel) setState(() => _selectedAuthMethod = AuthMethod.password);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Grade com os 4 Tipos de Registro de Ponto
                const Text(
                  'Registrar Batida',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 10),

                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.6,
                  children: [
                    _buildClockActionCard(TimeRecordType.entry),
                    _buildClockActionCard(TimeRecordType.lunchOut),
                    _buildClockActionCard(TimeRecordType.lunchIn),
                    _buildClockActionCard(TimeRecordType.exit),
                  ],
                ),

                const SizedBox(height: 16),

                // Resumo Rápido de Hoje
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Batidas Realizadas Hoje',
                                style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${todayRecords.length} registro(s)',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const VerticalDivider(),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Último Registro',
                                style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                lastRecord != null
                                    ? '${lastRecord.type.label} às ${AppFormatters.formatTime(lastRecord.timestamp)}'
                                    : 'Nenhum hoje',
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.primaryBlue,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildClockActionCard(TimeRecordType type) {
    final clock = context.watch<TimeClockProvider>();
    final isWithin = clock.isWithinRadius;

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: clock.isSubmitting ? null : () => _onClockButtonPressed(type),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: type.color.withValues(alpha: 0.3),
              width: 1.5,
            ),
          ),
          padding: const EdgeInsets.all(14),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: type.color.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(type.icon, color: type.color, size: 22),
                  ),
                  Icon(
                    isWithin ? Icons.check_circle_outline_rounded : Icons.block_rounded,
                    size: 18,
                    color: isWithin ? AppTheme.accentGreen : AppTheme.accentDanger,
                  ),
                ],
              ),
              const Spacer(),
              Text(
                type.label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: type.color,
                ),
              ),
              Text(
                isWithin ? 'Apto para bater' : 'Fora do raio 100m',
                style: TextStyle(
                  fontSize: 10,
                  color: isWithin ? AppTheme.textSecondary : AppTheme.accentDanger,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
