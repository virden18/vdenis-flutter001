import 'package:flutter/material.dart';
import 'package:vdenis/components/side_menu.dart';
import 'package:vdenis/constants/constantes.dart';
import 'package:vdenis/theme/colors.dart';
import 'package:vdenis/theme/text.style.dart';
import 'package:vdenis/theme/theme.dart';

class AcercaDeScreen extends StatelessWidget {
  const AcercaDeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AcercaDeConstantes.tituloSodep),
        backgroundColor: AppTheme.bootcampTheme.appBarTheme.backgroundColor,
        foregroundColor: AppTheme.bootcampTheme.appBarTheme.foregroundColor,
      ),
      drawer: const SideMenu(),
      backgroundColor: AppTheme.bootcampTheme.scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo de la empresa centrado
              Center(
                child: Container(
                  width: 120,
                  height: 120,
                  padding: const EdgeInsets.all(8),
                  child: Center(
                    child: Image.asset(AcercaDeConstantes.logo, height: 120),
                  ),
                ),
              ),
      
              _buildTitle(AcercaDeConstantes.sobreNosotros),
              const SizedBox(height: 16),
              _buildCompanySection(),
              const SizedBox(height: 32),

              _buildTitle(AcercaDeConstantes.valoresSodepianos),
              const SizedBox(height: 16),
              _buildValoresSection(),
              const SizedBox(height: 32),

              _buildTitle(AcercaDeConstantes.contacto),
              const SizedBox(height: 16),
              _buildContactSection(),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(String title) {
    return Text(
      title,
      style: AppTheme.bootcampTheme.textTheme.headlineLarge,
    );
  }

  Widget _buildCompanySection() {
    return Container(
      decoration: AppTheme.sectionBorderGray05,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AcercaDeConstantes.sobreSodep,
            style: AppTextStyles.bodyLg,
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }

  Widget _buildValoresSection() {
    // Lista de valores con sus descripciones
    final valores = [
      {
        'titulo': 'Honestidad',
        'descripcion':
            'Actuamos con transparencia y verdad en todas nuestras relaciones',
        'icon': Icons.verified_user,
      },
      {
        'titulo': 'Calidad',
        'descripcion':
            'Nos esforzamos por la excelencia en cada proyecto y servicio',
        'icon': Icons.star,
      },
      {
        'titulo': 'Flexibilidad',
        'descripcion': 'Nos adaptamos a las necesidades cambiantes del mercado',
        'icon': Icons.sync,
      },
      {
        'titulo': 'Comunicación',
        'descripcion':
            'Mantenemos diálogo abierto y efectivo con todos nuestros stakeholders',
        'icon': Icons.forum,
      },
      {
        'titulo': 'Autogestión',
        'descripcion':
            'Fomentamos la responsabilidad personal y la iniciativa propia',
        'icon': Icons.self_improvement,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...valores.map(
          (valor) => _buildValorCard(
            titulo: valor['titulo'] as String,
            descripcion: valor['descripcion'] as String,
            icon: valor['icon'] as IconData,
          ),
        ),
      ],
    );
  }

  Widget _buildValorCard({
    required String titulo,
    required String descripcion,
    required IconData icon,
  }) {
    return Card(
      color: AppTheme.bootcampTheme.cardTheme.color,
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icono del valor
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.blue02,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: AppTheme.bootcampTheme.colorScheme.primary, size: 28),
            ),
            const SizedBox(width: 16),
            // Contenido del valor
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    style: AppTheme.bootcampTheme.textTheme.labelLarge
                  ),
                  const SizedBox(height: 4),
                  Text(descripcion, style: AppTextStyles.bodyMd),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactSection() {
    // Lista de información de contacto
    final contactInfo = [
      {
        'icon': Icons.location_on_outlined,
        'title': 'Dirección',
        'content':'Bélgica 839 c/ Eusebio Lillo, Asunción, Paraguay',
      },
      {
        'icon': Icons.phone_outlined,
        'title': 'Teléfono',
        'content': '(+595)981-131-694',
      },
      {
        'icon': Icons.email_outlined,
        'title': 'Email',
        'content': 'info@sodep.com.py',
      },
      {
        'icon': Icons.web_outlined,
        'title': 'Sitio Web',
        'content': 'www.sodep.com.py',
      },
    ];
    return Container(
      decoration: AppTheme.sectionBorderGray05,
      padding: const EdgeInsets.all(16),
      child: Column(
        children:
            contactInfo
                .map(
                  (info) => _buildContactItem(
                    icon: info['icon'] as IconData,
                    title: info['title'] as String,
                    content: info['content'] as String,
                  ),
                )
                .toList(),
      ),
    );
  }

  Widget _buildContactItem({
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icono del contacto
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.blue02,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppTheme.bootcampTheme.colorScheme.primary, size: 24),
          ),
          const SizedBox(width: 16),
          // Contenido del contacto
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTheme.bootcampTheme.textTheme.labelLarge),
                const SizedBox(height: 4),
                Text(content, style:  AppTheme.bootcampTheme.textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
