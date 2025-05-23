import 'package:vdenis/core/base_service.dart';
import 'package:vdenis/constants/constants.dart';
import 'package:vdenis/domain/preferencia.dart';

class PreferenciaService extends BaseService {
  /// Obtiene las preferencias del usuario identificadas por su email
  Future<Preferencia> obtenerPreferenciaPorEmail(String email) async {
    final endpoint = '${ApiConstantes.preferenciasEndpoint}/$email';
    final Map<String, dynamic> responseData = await get<Map<String, dynamic>>(
      endpoint,
      errorMessage: 'Error al obtener preferencias',
    );
    
    return PreferenciaMapper.fromMap(responseData);
  }

  /// Actualiza las preferencias del usuario en la API
  Future<void> guardarPreferencias(Preferencia preferencia) async {
    final endpoint = '${ApiConstantes.preferenciasEndpoint}/${preferencia.email}';
    final dataToSend = PreferenciaMapper.ensureInitialized().encodeMap(preferencia);
    
    await put(
      endpoint,
      data: dataToSend,
      errorMessage: 'Error al guardar preferencias',
    );
  }
    /// Crea un nuevo registro de preferencias en la API
  Future<Preferencia> crearPreferencias(String email, {List<String>? categorias}) async {
    final Map<String, dynamic> preferenciasData = {
      'email': email,
      'categoriasSeleccionadas': categorias ?? []
    };

    await post(
      ApiConstantes.preferenciasEndpoint,
      data: preferenciasData,
      errorMessage: 'Error al crear preferencias',
    );
    
    return Preferencia(
      email: email,
      categoriasSeleccionadas: categorias ?? []
    );
  }
}
