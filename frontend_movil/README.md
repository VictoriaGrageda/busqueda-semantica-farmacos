# frontend_movil

Aplicacion Flutter del buscador farmacologico.

## Carpetas principales

- `lib/app/`: widget raiz y tema visual.
- `lib/config/`: configuracion de entorno, como la URL del backend.
- `lib/models/`: modelos que representan la respuesta de la API.
- `lib/screens/`: pantallas completas de la aplicacion.
- `lib/services/`: clientes HTTP e integraciones externas.
- `lib/widgets/`: componentes visuales reutilizables.
- `test/`: pruebas de widgets.

## Comandos

```powershell
flutter pub get
flutter run -d chrome
flutter test
flutter analyze
```

El backend por defecto se espera en:

```text
http://127.0.0.1:8000
```

Puedes cambiarlo con:

```powershell
flutter run -d chrome --dart-define=API_BASE_URL=http://127.0.0.1:8000
```
