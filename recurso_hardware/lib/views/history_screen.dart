import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/time_clock_provider.dart';
import '../models/time_record_model.dart';
import '../theme/app_theme.dart';
import '../utils/date_formatter.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  TimeRecordType? _filterType;

  @override
  Widget build(BuildContext context) {
    final clock = context.watch<TimeClockProvider>();
    final allRecords = clock.records;

    final filteredRecords = _filterType == null
        ? allRecords
        : allRecords.where((r) => r.type == _filterType).toList();

    final unsyncedCount = allRecords.where((r) => !r.syncedToFirebase).length;

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        title: const Text('Histórico de Registros'),
        actions: [
          if (unsyncedCount > 0)
            TextButton.icon(
              onPressed: () async {
                final messenger = ScaffoldMessenger.of(context);
                final count = await clock.syncPendingRecords();
                if (!mounted) return;
                if (count > 0) {
                  messenger.showSnackBar(
                    SnackBar(
                      content: Text('$count registro(s) sincronizado(s) com o Firebase!'),
                      backgroundColor: AppTheme.accentGreen,
                    ),
                  );
                }
              },
              icon: const Icon(Icons.cloud_upload_outlined, color: Colors.amberAccent, size: 18),
              label: Text(
                'Sincronizar ($unsyncedCount)',
                style: const TextStyle(color: Colors.amberAccent, fontSize: 12),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          // Barra de Filtros por Tipo de Ponto
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  FilterChip(
                    label: const Text('Todos'),
                    selected: _filterType == null,
                    onSelected: (_) => setState(() => _filterType = null),
                  ),
                  const SizedBox(width: 8),
                  ...TimeRecordType.values.map((type) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        avatar: Icon(type.icon, size: 16, color: type.color),
                        label: Text(type.label),
                        selected: _filterType == type,
                        onSelected: (selected) {
                          setState(() {
                            _filterType = selected ? type : null;
                          });
                        },
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
          const Divider(height: 1, color: AppTheme.borderLight),

          // Lista de Registros
          Expanded(
            child: filteredRecords.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.history_toggle_off_rounded,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Nenhum registro encontrado',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            _filterType == null
                                ? 'Bata seu ponto na tela inicial para visualizar o histórico aqui.'
                                : 'Nenhum registro do tipo selecionado.',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredRecords.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 12),
                    itemBuilder: (ctx, index) {
                      final record = filteredRecords[index];
                      return _buildRecordCard(record);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecordCard(TimeRecordModel record) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _showRecordDetails(record),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: record.type.color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(record.type.icon, color: record.type.color, size: 20),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          record.type.label,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: record.type.color,
                          ),
                        ),
                        Text(
                          AppFormatters.formatFullDate(record.timestamp),
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    AppFormatters.formatTimeWithSeconds(record.timestamp),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(color: AppTheme.borderLight, height: 1),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Distância GPS
                  Row(
                    children: [
                      const Icon(Icons.near_me_rounded, size: 14, color: AppTheme.accentGreen),
                      const SizedBox(width: 4),
                      Text(
                        '${AppFormatters.formatDistance(record.distanceToWorkplace)} da sede',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  // Autenticação
                  Row(
                    children: [
                      Icon(record.authMethod.icon, size: 14, color: AppTheme.primaryBlue),
                      const SizedBox(width: 4),
                      Text(
                        record.authMethod == AuthMethod.biometric ? 'Biometria' : 'Senha',
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  // Status Firebase
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: record.syncedToFirebase
                          ? AppTheme.accentGreen.withValues(alpha: 0.12)
                          : AppTheme.accentWarning.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      record.syncedToFirebase ? 'Firebase OK' : 'Local',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: record.syncedToFirebase
                            ? AppTheme.accentGreen
                            : AppTheme.accentWarning,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showRecordDetails(TimeRecordModel record) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: record.type.color.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(record.type.icon, color: record.type.color, size: 24),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Registro de ${record.type.label}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          Text(
                            'ID: ${record.id}',
                            style: const TextStyle(fontSize: 10, color: AppTheme.textSecondary),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Divider(),
                _buildDetailRow('Colaborador:', '${record.employeeName} (NIF: ${record.employeeNif})'),
                _buildDetailRow('Data e Hora:', AppFormatters.formatDateTime(record.timestamp)),
                _buildDetailRow('Latitude:', record.latitude.toStringAsFixed(6)),
                _buildDetailRow('Longitude:', record.longitude.toStringAsFixed(6)),
                _buildDetailRow('Distância do Trabalho:', '${record.distanceToWorkplace.toStringAsFixed(2)} metros'),
                _buildDetailRow('Validação de Raio:', record.isWithinRadius ? 'Aprovado (≤ 100m)' : 'Reprovado (> 100m)'),
                _buildDetailRow('Método de Validação:', record.authMethod.label),
                _buildDetailRow(
                  'Sincronização Cloud:',
                  record.syncedToFirebase ? 'Sincronizado com Cloud Firestore' : 'Armazenado no Dispositivo (Pendente de Envio)',
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(ctx).pop(),
                    child: const Text('Fechar Detalhes'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: AppTheme.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 12,
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
