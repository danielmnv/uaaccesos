# uaaccesos

A new Flutter project.

### Requisitos
```console
$ npm install -g firebase-tools
$ cd functions/ && npm install
```

### Firebase Emulator

##### Config
Firebase y Flutter ya vienen configurados para que al inicar el emulador tanto Firestore y Cloud Functions funcionen en la red local, únicamente Firebase Authentication funciona con el entorno de producción, esto con el propósito de mantener una consistencia entre los usuarios y la información en Firestore.

Configuracion de app:
```dart
await Firebase.initializeApp();

FirebaseFirestore.instance.settings = Settings(
host: Platform.isAndroid ? '10.0.2.2:8080' : 'localhost:8080',
sslEnabled: false,
persistenceEnabled: false,
);

FirebaseFunctions.instance.useFunctionsEmulator(origin: Platform.isAndroid ? 'http://10.0.2.2:5001' : 'http://localhost:5001');
``` 

##### Run
Para ejecutar el emulador de firebase, únicamente se requieren las modalidades de functions y firestore. Para inicializar el módulo de firestore con información se utiliza el directorio **data/** para importar los registros:
```console
$ firebase emulators:start --import=data/
```

> Si se quiere guardar la información manipulda/agregada durante la ejecucion, agregar el parámetro ```--export-on-exit=data/```
