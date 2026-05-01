

# Referencia de la API de Agent Dart

Agent Dart es una biblioteca para conectar aplicaciones Dart y Flutter con el Internet Computer, proporcionando herramientas para interactuar con canisters y realizar operaciones criptográficas.

---

## Índice

- [Clases y Métodos](#clases-y-métodos)
  - [Agent](#agent)
  - [ReplicaRejectCode](#replicarejectcode)
  - [ReadStateOptions](#readstateoptions)
  - [QueryResponseStatus](#queryresponsestatus)
  - [QueryResponse](#queryresponse)
  - [Reply](#reply)
  - [QueryResponseReplied](#queryresponsereplied)
  - [QueryResponseRejected](#queryresponserejected)
  - [QueryFields](#queryfields)
  - [CallOptions](#calloptions)
  - [ReadStateResponse](#readstateresponse)
  - [ResponseBody](#responsebody)
  - [SubmitResponse](#submitresponse)
- [Criptografía](#criptografía)
  - [Mnemónica](#mnemónica)
  - [BLS](#bls)
  - [ED25519](#ed25519)
  - [Secp256k1](#secp256k1)
  - [Secp256r1](#secp256r1)
  - [Schnorr](#schnorr)
  - [AES](#aes)

---

## Clases y Métodos

### Agent

La clase `Agent` es la principal para realizar llamadas y consultas a un replicante del Internet Computer.

```dart
abstract class Agent {
  /// Devuelve la identificación principal asociada con este agente (por defecto).
  /// Solo muestra la principal del identidad predeterminada en el agente, que es la principal
  /// utilizada cuando las llamadas no especifican una identidad.
  Future<Principal> getPrincipal();

  /// Envía una consulta de estado de lectura al replicante. Esto incluye una lista de rutas a devolver,
  /// y devolverá un Certificado. Esto solo rechazará errores de comunicación,
  /// pero el certificado podría contener menos información de la solicitada.
  /// @param effectiveCanisterId Una identificación de Canister relacionada con esta llamada.
  /// @param options Las opciones para esta llamada.
  Future<ReadStateResponse> readState(
    Principal effectiveCanisterId,
    ReadStateOptions options,
    Identity? identity,
  );

  /// Envía una solicitud de llamada a un canister.
  /// @param canisterId La principal del Canister al que enviar la llamada.
  /// @param fields Las opciones para crear y enviar la llamada.
  /// @param identity La identidad a usar para la llamada.
  Future<SubmitResponse> callRequest(
    Principal canisterId,
    CallOptions fields,
    Identity? identity,
  );

  /// Consulta el punto de extremo de estado del replicante. Esto normalmente tiene varios campos que
  /// corresponden a la versión del replicante, su clave pública raíz y cualquier otra
  /// información hecha pública.
  /// @returns Un JsonObject que es esencialmente un registro de campos del punto de extremo de estado.
  Future<Map> status();

  /// Envía una llamada de consulta a un canister. Consulte
  /// [la especificación de interfaz](https://sdk.dfinity.org/docs/interface-spec/#http-query).
  /// @param canisterId La principal del Canister al que enviar la consulta.
  /// @param options Opciones para crear y enviar la consulta.
  /// @returns La respuesta del replicante. La promesa solo rechazará cuando el error de comunicación
  ///     haya ocurrido. Si la consulta en sí falló pero no hubo errores de protocolo, la respuesta será
  ///     de tipo QueryResponseRejected.
  Future<QueryResponse> query(
    Principal canisterId,
    QueryFields options,
    Identity? identity,
  );

  /// Por defecto, el agente está configurado para comunicarse con el Internet Computer principal,
  /// y verifica las respuestas usando una clave pública codificada en el hardware.
  ///
  /// Esta función instruirá al agente para que solicite al punto de extremo su clave pública,
  /// y use esa en su lugar. Esto es necesario al comunicarse con una instancia de prueba local,
  /// por ejemplo.
  ///
  /// Solo use esto cuando NO está comunicándose con el Internet Computer principal,
  /// de lo contrario está expuesto a ataques de hombre en el medio. ¡No llame a esta
  /// función por defecto!
  Future<BinaryBlob> fetchRootKey();
}
```

---

### ReplicaRejectCode

Códigos utilizados por el replicante para rechazar un mensaje.

```dart
@immutable
class ReplicaRejectCode {
  const ReplicaRejectCode._();

  /// Error fatal del sistema.
  static const sysFatal = 1;

  /// Error transitorio del sistema.
  static const sysTransient = 2;

  /// Identificación del destino inválida.
  static const destinationInvalid = 3;

  /// Rechazo del canister.
  static const canisterReject = 4;

  /// Error del canister.
  static const canisterError = 5;
}
```

---

### ReadStateOptions

Opciones para realizar una llamada a `Agent.readState`.

```dart
@immutable
class ReadStateOptions {
  const ReadStateOptions({required this.paths});

  /// Una lista de rutas para leer el estado.
  final List<List<BinaryBlob>> paths;
}
```

---

### QueryResponseStatus

Estado de la respuesta de una consulta.

```dart
@immutable
class QueryResponseStatus {
  const QueryResponseStatus._();

  /// La consulta fue respondida correctamente.
  static const replied = 'replied';

  /// La consulta fue rechazada.
  static const rejected = 'rejected';
}
```

---

### QueryResponse

Respuesta de una consulta.

```dart
@immutable
abstract class QueryResponse extends QueryResponseBase {
  const QueryResponse({
    this.reply,
    this.rejectCode,
    this.rejectMessage,
    required super.status,
  });

  /// La respuesta si la consulta fue exitosa.
  final Reply? reply;

  /// Código de rechazo si la consulta fue rechazada.
  final int? rejectCode;

  /// Mensaje de rechazo si la consulta fue rechazada.
  final String? rejectMessage;
}
```

---

### Reply

Respuesta de una consulta exitosa.

```dart
@immutable
class Reply {
  const Reply(this.arg);

  /// Argumento binario codificado devuelto por la consulta.
  final BinaryBlob? arg;
}
```

---

### QueryResponseReplied

Respuesta de consulta exitosa.

```dart
class QueryResponseReplied extends QueryResponseBase {
  const QueryResponseReplied({super.status = QueryResponseStatus.replied});
}
```

---

### QueryResponseRejected

Respuesta de consulta rechazada.

```dart
class QueryResponseRejected extends QueryResponseBase {
  const QueryResponseRejected({
    this.rejectCode,
    this.rejectMessage,
    super.status = QueryResponseStatus.rejected,
  });

  /// Código de rechazo.
  final int? rejectCode;

  /// Mensaje de rechazo.
  final String? rejectMessage;
}
```

---

### QueryFields

Opciones para realizar una consulta.

```dart
@immutable
class QueryFields {
  const QueryFields({required this.methodName, this.arg});

  /// El nombre del método a llamar.
  final String methodName;

  /// Un argumento binario codificado. Esto ya está codificado y se enviará tal cual.
  final BinaryBlob? arg;
}
```

---

### CallOptions

Opciones para realizar una llamada.

```dart
@immutable
class CallOptions {
  const CallOptions({
    required this.methodName,
    required this.arg,
    this.effectiveCanisterId,
    this.callSync = true,
  });

  /// El nombre del método a llamar.
  final String methodName;

  /// Un argumento binario codificado. Esto ya está codificado y se enviará tal cual.
  final BinaryBlob arg;

  /// Una identificación de canister efectiva, usada para enrutamiento. Esto solo debe mencionarse
  /// si es diferente de la identificación del canister.
  final Principal? effectiveCanisterId;

  /// Indica si se debe llamar al punto de extremo de forma síncrona.
  final bool callSync;
}
```

---

### ReadStateResponse

Respuesta de una consulta de estado de lectura.

```dart
@immutable
abstract class ReadStateResponse {
  const ReadStateResponse({required this.certificate});

  /// Certificado de la consulta de estado.
  final BinaryBlob certificate;
}
```

---

### ResponseBody

Cuerpo de la respuesta HTTP.

```dart
@immutable
abstract class ResponseBody {
  const ResponseBody({this.ok, this.status, this.statusText});

  /// Indica si la respuesta fue exitosa.
  final bool? ok;

  /// Código de estado HTTP.
  final int? status;

  /// Texto del código de estado HTTP.
  final String? statusText;
}
```

---

### SubmitResponse

Respuesta de una solicitud de llamada.

```dart
@immutable
abstract class SubmitResponse {
  const SubmitResponse({this.requestId, this.response});

  /// Identificador de la solicitud.
  final RequestId? requestId;

  /// Cuerpo de la respuesta.
  final ResponseBody? response;

  /// Convierte la respuesta a formato JSON.
  Map<String, dynamic> toJson();
}
```

---

## Criptografía

### Mnemónica

Funciones para trabajar con frases semilla (mnemónicas).

```dart
/// Convierte una frase semilla y contraseña en una semilla criptográfica.
Future<Uint8List> mnemonicPhraseToSeed({required PhraseToSeedReq req});

/// Convierte una semilla en una clave pública.
Future<Uint8List> mnemonicSeedToKey({required SeedToKeyReq req});
```

---

### BLS

Funciones para firmas BLS (Boneh-Lynn-Shacham).

```dart
/// Inicializa el módulo BLS.
Future<bool> blsInit();

/// Verifica una firma BLS.
Future<bool> blsVerify({required BLSVerifyReq req});
```

---

### ED25519

Funciones para firmas ED25519.

```dart
/// Genera una clave pública a partir de una semilla.
Future<ED25519Res> ed25519FromSeed({required ED25519FromSeedReq req});

/// Firma un mensaje con una clave privada.
Future<Uint8List> ed25519Sign({required ED25519SignReq req});

/// Verifica una firma ED25519.
Future<bool> ed25519Verify({required ED25519VerifyReq req});
```

---

### Secp256k1

Funciones para firmas Secp256k1 (usadas en Bitcoin).

```dart
/// Genera una clave pública a partir de una semilla.
Future<Secp256k1IdentityExport> secp256K1FromSeed({required Secp256k1FromSeedReq req});

/// Firma un mensaje con una clave privada.
Future<SignatureFFI> secp256K1Sign({required Secp256k1SignWithSeedReq req});

/// Firma un mensaje con una clave privada usando un generador de números aleatorios.
Future<SignatureFFI> secp256K1SignWithRng({required Secp256k1SignWithRngReq req});

/// Firma recuperable (usada en transacciones Bitcoin).
Future<SignatureFFI> secp256K1SignRecoverable({required Secp256k1SignWithSeedReq req});

/// Verifica una firma Secp256k1.
Future<bool> secp256K1Verify({required Secp256k1VerifyReq req});

/// Obtiene una clave compartida a partir de una clave privada y una clave pública.
Future<Uint8List> secp256K1GetSharedSecret({required Secp256k1ShareSecretReq req});

/// Recupera una clave privada a partir de un mensaje y una firma.
Future<Uint8List> secp256K1Recover({required Secp256k1RecoverReq req});
```

---

### Secp256r1

Funciones para firmas Secp256r1 (usadas en Ethereum).

```dart
/// Genera una clave pública a partir de una semilla.
Future<P256IdentityExport> p256FromSeed({required P256FromSeedReq req});

/// Firma un mensaje con una clave privada.
Future<SignatureFFI> p256Sign({required P256SignWithSeedReq req});

/// Verifica una firma Secp256r1.
Future<bool> p256Verify({required P256VerifyReq req});

/// Obtiene una clave compartida a partir de una clave privada y una clave pública.
Future<Uint8List> p256GetSharedSecret({required P256ShareSecretReq req});
```

---

### Schnorr

Funciones para firmas Schnorr.

```dart
/// Genera una clave pública a partir de una semilla.
Future<SchnorrIdentityExport> schnorrFromSeed({required SchnorrFromSeedReq req});

/// Firma un mensaje con una clave privada.
Future<SignatureFFI> schnorrSign({required SchnorrSignWithSeedReq req});

/// Verifica una firma Schnorr.
Future<bool> schnorrVerify({required SchnorrVerifyReq req});
```

---

### AES

Funciones de cifrado AES.

```dart
/// Cifra un mensaje usando AES-128 en modo CTR.
Future<Uint8List> aes128CtrEncrypt({required AesEncryptReq req});

/// Descifra un mensaje usando AES-128 en modo CTR.
Future<Uint8List> aes128CtrDecrypt({required AesDecryptReq req});

/// Cifra un mensaje usando AES-256 en modo CBC.
Future<Uint8List> aes256CbcEncrypt({required AesEncryptReq req});

/// Descifra un mensaje usando AES-256 en modo CBC.
Future<Uint8List> aes256CbcDecrypt({required AesDecryptReq req});

/// Cifra un mensaje usando AES-256 en modo GCM.
Future<Uint8List> aes256GcmEncrypt({required AesEncryptReq req});

/// Descifra un mensaje usando AES-256 en modo GCM.
Future<Uint8List> aes256GcmDecrypt({required AesDecryptReq req});

/// Deriva una clave usando PBKDF2.
Future<KeyDerivedRes> pbkdf2DeriveKey({required PBKDFDeriveReq req});

/// Deriva una clave usando Scrypt.
Future<KeyDerivedRes> scryptDeriveKey({required ScriptDeriveReq req});
```

---

## Tipos de Datos

### PhraseToSeedReq

Requisitos para convertir una frase semilla en una semilla.

```dart
class PhraseToSeedReq {
  final String phrase;
  final String password;

  const PhraseToSeedReq({
    required this.phrase,
    required this.password,
  });
}
```

### SeedToKeyReq

Requisitos para convertir una semilla en una clave.

```dart
class SeedToKeyReq {
  final Uint8List seed;
  final String path;

  const SeedToKeyReq({
    required this.seed,
    required this.path,
  });
}
```

### BLSVerifyReq

Requisitos para verificar una firma BLS.

```dart
class BLSVerifyReq {
  final Uint8List signature;
  final Uint8List message;
  final Uint8List publicKey;

  const BLSVerifyReq({
    required this.signature,
    required this.message,
    required this.publicKey,
  });
}
```

### ED25519FromSeedReq

Requisitos para generar una clave pública ED25519 a partir de una semilla.

```dart
class ED25519FromSeedReq {
  final Uint8List seed;

  const ED25519FromSeedReq({
    required this.seed,
  });
}
```

### ED25519SignReq

Requisitos para firmar un mensaje con ED25519.

```dart
class ED25519SignReq {
  final Uint8List seed;
  final Uint8List message;

  const ED25519SignReq({
    required this.seed,
    required this.message,
  });
}
```

### ED25519VerifyReq

Requisitos para verificar una firma ED25519.

```dart
class ED25519VerifyReq {
  final Uint8List sig;
  final Uint8List message;
  final Uint8List pubKey;

  const ED25519VerifyReq({
    required this.sig,
    required this.message,
    required this.pubKey,
  });
}
```

### Secp256k1FromSeedReq

Requisitos para generar una clave pública Secp256k1 a partir de una semilla.

```dart
class Secp256k1FromSeedReq {
  final Uint8List seed;

  const Secp256k1FromSeedReq({
    required this.seed,
  });
}
```

### Secp256k1SignWithSeedReq

Requisitos para firmar un mensaje con Secp256k1.

```dart
class Secp256k1SignWithSeedReq {
  final Uint8List msg;
  final Uint8List seed;

  const Secp256k1SignWithSeedReq({
    required this.msg,
    required this.seed,
  });
}
```

### Secp256k1VerifyReq

Requisitos para verificar una firma Secp256k1.

```dart
class Secp256k1VerifyReq {
  final Uint8List messageHash;
  final Uint8List signatureBytes;
  final Uint8List publicKeyBytes;

  const Secp256k1VerifyReq({
    required this.messageHash,
    required this.signatureBytes,
    required this.publicKeyBytes,
  });
}
```

### P256FromSeedReq

Requisitos para generar una clave pública Secp256r1 a partir de una semilla.

```dart
class P256FromSeedReq {
  final Uint8List seed;

  const P256FromSeedReq({
    required this.seed,
  });
}
```

### P256SignWithSeedReq

Requisitos para firmar un mensaje con Secp256r1.

```dart
class P256SignWithSeedReq {
  final Uint8List msg;
  final Uint8List seed;

  const P256SignWithSeedReq({
    required this.msg,
    required this.seed,
  });
}
```

### P256VerifyReq

Requisitos para verificar una firma Secp256r1.

```dart
class P256VerifyReq {
  final Uint8List messageHash;
  final Uint8List signatureBytes;
  final Uint8List publicKeyBytes;

  const P256VerifyReq({
    required this.messageHash,
    required this.signatureBytes,
    required this.publicKeyBytes,
  });
}
```

### SchnorrFromSeedReq

Requisitos para generar una clave pública Schnorr a partir de una semilla.

```dart
class SchnorrFromSeedReq {
  final Uint8List seed;

  const SchnorrFromSeedReq({
    required this.seed,
  });
}
```

### SchnorrSignWithSeedReq

Requisitos para firmar un mensaje con Schnorr.

```dart
class SchnorrSignWithSeedReq {
  final Uint8List msg;
  final Uint8List seed;
  final Uint8List? auxRand;

  const SchnorrSignWithSeedReq({
    required this.msg,
    required this.seed,
    this.auxRand,
  });
}
```

### SchnorrVerifyReq

Requisitos para verificar una firma Schnorr.

```dart
class SchnorrVerifyReq {
  final Uint8List messageHash;
  final Uint8List signatureBytes;
  final Uint8List publicKeyBytes;

  const SchnorrVerifyReq({
    required this.messageHash,
    required this.signatureBytes,
    required this.publicKeyBytes,
  });
}
```

### AesEncryptReq

Requisitos para cifrar un mensaje con AES.

```dart
class AesEncryptReq {
  final Uint8List key;
  final Uint8List iv;
  final Uint8List message;

  const AesEncryptReq({
    required this.key,
    required this.iv,
    required this.message,
  });
}
```

### AesDecryptReq

Requisitos para descifrar un mensaje con AES.

```dart
class AesDecryptReq {
  final Uint8List key;
  final Uint8List iv;
  final Uint8List cipherText;

  const AesDecryptReq({
    required this.key,
    required this.iv,
    required this.cipherText,
  });
}
```

### PBKDFDeriveReq

Requisitos para derivar una clave con PBKDF2.

```dart
class PBKDFDeriveReq {
  final Uint8List password;
  final Uint8List salt;
  final int c;

  const PBKDFDeriveReq({
    required this.password,
    required this.salt,
    required this.c,
  });
}
```

### ScriptDeriveReq

Requisitos para derivar una clave con Scrypt.

```dart
class ScriptDeriveReq {
  final Uint8List password;
  final Uint8List salt;
  final int n;
  final int p;
  final int r;

  const ScriptDeriveReq({
    required this.password,
    required this.salt,
    required this.n,
    required this.p,
    required this.r,
  });
}
```

### SignatureFFI

Estructura de firma.

```dart
class SignatureFFI {
  /// Esta es la clave pública codificada en formato DER.
  final Uint8List? publicKey;

  /// Los bytes de la firma.
  final Uint8List? signature;

  const SignatureFFI({
    this.publicKey,
    this.signature,
  });
}
```

### KeyDerivedRes

Resultado de la derivación de una clave.

```dart
class KeyDerivedRes {
  final Uint8List leftBits;
  final Uint8List rightBits;

  const KeyDerivedRes({
    required this.leftBits,
    required this.rightBits,
  });
}
```

---

