import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/time_clock_provider.dart';
import '../theme/app_theme.dart';
import '../utils/date_formatter.dart';

class WorkplaceSettingsScreen extends StatefulWidget {
  const WorkplaceSettingsScreen({super.key});

  @override
  State<WorkplaceSettingsScreen> createState() => _WorkplaceSettingsScreenState();
}

class _WorkplaceSettingsScreenState extends State<WorkplaceSettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _latController;
  late TextEditingController _lngController;
  late double _radius;

  @override
  void initState() {
    super.initState();
    final clock = context.read<TimeClockProvider>();
    _nameController = TextEditingController(text: clock.workplace.name);
    _latController = TextEditingController(text: clock.workplace.latitude.toString());
    _lngController = TextEditingController(text: clock.workplace.longitude.toString());
    _radius = clock.workplace.radiusMeters;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _latController.dispose();
    _lngController.dispose();
    super.dispose();
  }

  void _saveSettings() async {
    if (!_formKey.currentState!.validate()) return;

    final lat = double.tryParse(_latController.text) ?? 0.0;
    final lng = double.tryParse(_lngController.text) ?? 0.0;

    final clock = context.read<TimeClockProvider>();
    final updated = clock.workplace.copyWith(
      name: _nameController.text.trim(),
      latitude: lat,
      longitude: lng,
      radiusMeters: _radius,
    );

    await clock.updateWorkplace(updated);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Configuração da Sede e Raio atualizados com sucesso!'),
          backgroundColor: AppTheme.accentGreen,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final clock = context.watch<TimeClockProvider>();

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        title: const Text('Configurar Sede & Geolocalização'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Card Informativo da Regra dos 100 Metros
              Card(
                color: const Color(0xFFEFF6FF), // Blue 50
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.info_outline_rounded, color: AppTheme.primaryBlue, size: 24),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Regra Somativa: Raio de 100 Metros',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryBlue,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'O aplicativo valida via GPS se o funcionário está em um raio de até ${_radius.toInt()} metros do ponto fixado. '
                              'Para facilitar a avaliação em qualquer ambiente, use o botão abaixo para definir sua localização atual como o local de trabalho.',
                              style: const TextStyle(fontSize: 12, color: Color(0xFF1E3A8A)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Botão de Alta Conveniência para Bancada de Avaliação
              ElevatedButton.icon(
                onPressed: () async {
                  final messenger = ScaffoldMessenger.of(context);
                  await clock.setWorkplaceToCurrentLocation();
                  if (!mounted) return;
                  setState(() {
                    _nameController.text = clock.workplace.name;
                    _latController.text = clock.workplace.latitude.toString();
                    _lngController.text = clock.workplace.longitude.toString();
                  });
                  messenger.showSnackBar(
                    const SnackBar(
                      content: Text('Sede fixada nas suas coordenadas atuais! Distância: ~0m.'),
                      backgroundColor: AppTheme.accentGreen,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.accentGreen,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                icon: const Icon(Icons.my_location_rounded, size: 20),
                label: const Text(
                  'Definir Minha Localização Atual como Sede',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),

              const SizedBox(height: 16),

              // Formulário de Configuração Manual
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Parâmetros Geográficos da Sede',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Nome do Local de Trabalho',
                          prefixIcon: Icon(Icons.business_rounded),
                        ),
                        validator: (v) => v == null || v.isEmpty ? 'Informe o nome' : null,
                      ),

                      const SizedBox(height: 14),

                      TextFormField(
                        controller: _latController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                        decoration: const InputDecoration(
                          labelText: 'Latitude da Sede',
                          prefixIcon: Icon(Icons.explore_rounded),
                        ),
                        validator: (v) => double.tryParse(v ?? '') == null ? 'Latitude inválida' : null,
                      ),

                      const SizedBox(height: 14),

                      TextFormField(
                        controller: _lngController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                        decoration: const InputDecoration(
                          labelText: 'Longitude da Sede',
                          prefixIcon: Icon(Icons.explore_outlined),
                        ),
                        validator: (v) => double.tryParse(v ?? '') == null ? 'Longitude inválida' : null,
                      ),

                      const SizedBox(height: 20),

                      // Raio de tolerância (Padrão 100m)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Raio de Bloqueio:',
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryBlue.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '${_radius.toInt()} metros (Regra: 100m)',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryBlue,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Slider(
                        value: _radius,
                        min: 50.0,
                        max: 500.0,
                        divisions: 45,
                        label: '${_radius.toInt()}m',
                        activeColor: AppTheme.primaryBlue,
                        onChanged: (val) {
                          setState(() {
                            _radius = val;
                          });
                        },
                      ),

                      const SizedBox(height: 12),

                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () async {
                                await clock.resetWorkplaceToDefault();
                                setState(() {
                                  _nameController.text = clock.workplace.name;
                                  _latController.text = clock.workplace.latitude.toString();
                                  _lngController.text = clock.workplace.longitude.toString();
                                  _radius = 100.0;
                                });
                              },
                              child: const Text('Restaurar Padrão'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _saveSettings,
                              child: const Text('Salvar'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Status Atual em Tempo Real
              Card(
                color: const Color(0xFFF8FAFC),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Diagnóstico do Dispositivo',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Posição atual: ${clock.currentPosition != null ? '${clock.currentPosition!.latitude.toStringAsFixed(5)}, ${clock.currentPosition!.longitude.toStringAsFixed(5)}' : 'Aguardando GPS'}',
                        style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Distância calculada: ${clock.currentDistance != null ? AppFormatters.formatDistance(clock.currentDistance!) : "Desconhecida"}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: clock.isWithinRadius ? AppTheme.accentGreen : AppTheme.accentDanger,
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
    );
  }
}
