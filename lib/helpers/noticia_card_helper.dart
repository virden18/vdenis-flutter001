import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vdenis/constants/constants.dart';
import 'package:vdenis/domain/noticia.dart';
import 'package:vdenis/helpers/common_widgets_helper.dart';

class NoticiaCardHelper {
  static Widget buildNoticiaCard(Noticia noticia) {
    final DateFormat formatter = DateFormat(Constants.formatoFecha);
    final String formattedDate = formatter.format(noticia.publicadaEl);

    return Column(
      children: [
        Card(
          color: Colors.white,
          margin: EdgeInsets.zero, // Sin margen entre los elementos
          elevation: 0.0, // Sin sombra
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero, // Sin bordes redondeados
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
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
                            '·',
                            formattedDate,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: 125,
                    height: 80,
                    margin: const EdgeInsets.all(8),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      child: Image.network(
                        'https://picsum.photos/200/300?random=${noticia.titulo.hashCode}',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(Icons.star_border),
                    onPressed: () {
                      // Acción para marcar como favorito
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.share),
                    onPressed: () {
                      // Acción para compartir
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.more_vert),
                    onPressed: () {
                      // Acción para mostrar más opciones
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          color: const Color.fromARGB(255, 213, 208, 208),
          margin: const EdgeInsets.fromLTRB(0, 0, 0, 2),
        ),
      ],
    );
  }
}