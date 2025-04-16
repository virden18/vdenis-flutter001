import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vdenis/constants/constants.dart';
import 'package:vdenis/domain/noticia.dart';
import 'package:vdenis/helpers/common_widgets_helper.dart';

class NoticiaCardHelper {
  static Widget buildNoticiaCard(Noticia noticia) {
    final DateFormat formatter = DateFormat(Constants.formatoFecha);
    final String formattedDate = formatter.format(noticia.publicadaEl);
    
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.symmetric(vertical: 0),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    noticia.titulo,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    noticia.descripcion,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  CommonWidgetsHelper.buildInfoLines(
                    noticia.fuente,
                    formattedDate
                  )
                ],
              ),
            ),
          ),
          Container(
            width: 100,
            height: 100,
            margin: const EdgeInsets.all(8),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              child: Image.network(
                'https://picsum.photos/200/300?random=${noticia.titulo.hashCode}',
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}