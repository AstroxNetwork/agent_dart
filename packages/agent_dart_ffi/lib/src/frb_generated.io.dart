// This file is automatically generated, so please do not edit it.
// @generated by `flutter_rust_bridge`@ 2.5.0.

// ignore_for_file: unused_import, unused_element, unnecessary_import, duplicate_ignore, invalid_use_of_internal_member, annotate_overrides, non_constant_identifier_names, curly_braces_in_flow_control_structures, prefer_const_literals_to_create_immutables, unused_field

import 'api.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:ffi' as ffi;
import 'frb_generated.dart';
import 'p256.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated_io.dart';
import 'schnorr.dart';
import 'secp256k1.dart';
import 'types.dart';

abstract class AgentDartApiImplPlatform extends BaseApiImpl<AgentDartWire> {
  AgentDartApiImplPlatform({
    required super.handler,
    required super.wire,
    required super.generalizedFrbRustBinding,
    required super.portManager,
  });

  @protected
  String dco_decode_String(dynamic raw);

  @protected
  AesDecryptReq dco_decode_aes_decrypt_req(dynamic raw);

  @protected
  AesEncryptReq dco_decode_aes_encrypt_req(dynamic raw);

  @protected
  BLSVerifyReq dco_decode_bls_verify_req(dynamic raw);

  @protected
  bool dco_decode_bool(dynamic raw);

  @protected
  AesDecryptReq dco_decode_box_autoadd_aes_decrypt_req(dynamic raw);

  @protected
  AesEncryptReq dco_decode_box_autoadd_aes_encrypt_req(dynamic raw);

  @protected
  BLSVerifyReq dco_decode_box_autoadd_bls_verify_req(dynamic raw);

  @protected
  ED25519FromSeedReq dco_decode_box_autoadd_ed_25519_from_seed_req(dynamic raw);

  @protected
  ED25519SignReq dco_decode_box_autoadd_ed_25519_sign_req(dynamic raw);

  @protected
  ED25519VerifyReq dco_decode_box_autoadd_ed_25519_verify_req(dynamic raw);

  @protected
  P256FromSeedReq dco_decode_box_autoadd_p_256_from_seed_req(dynamic raw);

  @protected
  P256ShareSecretReq dco_decode_box_autoadd_p_256_share_secret_req(dynamic raw);

  @protected
  P256SignWithSeedReq dco_decode_box_autoadd_p_256_sign_with_seed_req(
      dynamic raw);

  @protected
  P256VerifyReq dco_decode_box_autoadd_p_256_verify_req(dynamic raw);

  @protected
  PBKDFDeriveReq dco_decode_box_autoadd_pbkdf_derive_req(dynamic raw);

  @protected
  PhraseToSeedReq dco_decode_box_autoadd_phrase_to_seed_req(dynamic raw);

  @protected
  SchnorrFromSeedReq dco_decode_box_autoadd_schnorr_from_seed_req(dynamic raw);

  @protected
  SchnorrSignWithSeedReq dco_decode_box_autoadd_schnorr_sign_with_seed_req(
      dynamic raw);

  @protected
  SchnorrVerifyReq dco_decode_box_autoadd_schnorr_verify_req(dynamic raw);

  @protected
  ScriptDeriveReq dco_decode_box_autoadd_script_derive_req(dynamic raw);

  @protected
  Secp256k1FromSeedReq dco_decode_box_autoadd_secp_256_k_1_from_seed_req(
      dynamic raw);

  @protected
  Secp256k1RecoverReq dco_decode_box_autoadd_secp_256_k_1_recover_req(
      dynamic raw);

  @protected
  Secp256k1ShareSecretReq dco_decode_box_autoadd_secp_256_k_1_share_secret_req(
      dynamic raw);

  @protected
  Secp256k1SignWithRngReq dco_decode_box_autoadd_secp_256_k_1_sign_with_rng_req(
      dynamic raw);

  @protected
  Secp256k1SignWithSeedReq
      dco_decode_box_autoadd_secp_256_k_1_sign_with_seed_req(dynamic raw);

  @protected
  Secp256k1VerifyReq dco_decode_box_autoadd_secp_256_k_1_verify_req(
      dynamic raw);

  @protected
  SeedToKeyReq dco_decode_box_autoadd_seed_to_key_req(dynamic raw);

  @protected
  int dco_decode_box_autoadd_u_8(dynamic raw);

  @protected
  ED25519FromSeedReq dco_decode_ed_25519_from_seed_req(dynamic raw);

  @protected
  ED25519Res dco_decode_ed_25519_res(dynamic raw);

  @protected
  ED25519SignReq dco_decode_ed_25519_sign_req(dynamic raw);

  @protected
  ED25519VerifyReq dco_decode_ed_25519_verify_req(dynamic raw);

  @protected
  KeyDerivedRes dco_decode_key_derived_res(dynamic raw);

  @protected
  Uint8List dco_decode_list_prim_u_8_strict(dynamic raw);

  @protected
  int? dco_decode_opt_box_autoadd_u_8(dynamic raw);

  @protected
  Uint8List? dco_decode_opt_list_prim_u_8_strict(dynamic raw);

  @protected
  P256FromSeedReq dco_decode_p_256_from_seed_req(dynamic raw);

  @protected
  P256IdentityExport dco_decode_p_256_identity_export(dynamic raw);

  @protected
  P256ShareSecretReq dco_decode_p_256_share_secret_req(dynamic raw);

  @protected
  P256SignWithSeedReq dco_decode_p_256_sign_with_seed_req(dynamic raw);

  @protected
  P256VerifyReq dco_decode_p_256_verify_req(dynamic raw);

  @protected
  PBKDFDeriveReq dco_decode_pbkdf_derive_req(dynamic raw);

  @protected
  PhraseToSeedReq dco_decode_phrase_to_seed_req(dynamic raw);

  @protected
  SchnorrFromSeedReq dco_decode_schnorr_from_seed_req(dynamic raw);

  @protected
  SchnorrIdentityExport dco_decode_schnorr_identity_export(dynamic raw);

  @protected
  SchnorrSignWithSeedReq dco_decode_schnorr_sign_with_seed_req(dynamic raw);

  @protected
  SchnorrVerifyReq dco_decode_schnorr_verify_req(dynamic raw);

  @protected
  ScriptDeriveReq dco_decode_script_derive_req(dynamic raw);

  @protected
  Secp256k1FromSeedReq dco_decode_secp_256_k_1_from_seed_req(dynamic raw);

  @protected
  Secp256k1IdentityExport dco_decode_secp_256_k_1_identity_export(dynamic raw);

  @protected
  Secp256k1RecoverReq dco_decode_secp_256_k_1_recover_req(dynamic raw);

  @protected
  Secp256k1ShareSecretReq dco_decode_secp_256_k_1_share_secret_req(dynamic raw);

  @protected
  Secp256k1SignWithRngReq dco_decode_secp_256_k_1_sign_with_rng_req(
      dynamic raw);

  @protected
  Secp256k1SignWithSeedReq dco_decode_secp_256_k_1_sign_with_seed_req(
      dynamic raw);

  @protected
  Secp256k1VerifyReq dco_decode_secp_256_k_1_verify_req(dynamic raw);

  @protected
  SeedToKeyReq dco_decode_seed_to_key_req(dynamic raw);

  @protected
  SignatureFFI dco_decode_signature_ffi(dynamic raw);

  @protected
  int dco_decode_u_32(dynamic raw);

  @protected
  int dco_decode_u_8(dynamic raw);

  @protected
  void dco_decode_unit(dynamic raw);

  @protected
  String sse_decode_String(SseDeserializer deserializer);

  @protected
  AesDecryptReq sse_decode_aes_decrypt_req(SseDeserializer deserializer);

  @protected
  AesEncryptReq sse_decode_aes_encrypt_req(SseDeserializer deserializer);

  @protected
  BLSVerifyReq sse_decode_bls_verify_req(SseDeserializer deserializer);

  @protected
  bool sse_decode_bool(SseDeserializer deserializer);

  @protected
  AesDecryptReq sse_decode_box_autoadd_aes_decrypt_req(
      SseDeserializer deserializer);

  @protected
  AesEncryptReq sse_decode_box_autoadd_aes_encrypt_req(
      SseDeserializer deserializer);

  @protected
  BLSVerifyReq sse_decode_box_autoadd_bls_verify_req(
      SseDeserializer deserializer);

  @protected
  ED25519FromSeedReq sse_decode_box_autoadd_ed_25519_from_seed_req(
      SseDeserializer deserializer);

  @protected
  ED25519SignReq sse_decode_box_autoadd_ed_25519_sign_req(
      SseDeserializer deserializer);

  @protected
  ED25519VerifyReq sse_decode_box_autoadd_ed_25519_verify_req(
      SseDeserializer deserializer);

  @protected
  P256FromSeedReq sse_decode_box_autoadd_p_256_from_seed_req(
      SseDeserializer deserializer);

  @protected
  P256ShareSecretReq sse_decode_box_autoadd_p_256_share_secret_req(
      SseDeserializer deserializer);

  @protected
  P256SignWithSeedReq sse_decode_box_autoadd_p_256_sign_with_seed_req(
      SseDeserializer deserializer);

  @protected
  P256VerifyReq sse_decode_box_autoadd_p_256_verify_req(
      SseDeserializer deserializer);

  @protected
  PBKDFDeriveReq sse_decode_box_autoadd_pbkdf_derive_req(
      SseDeserializer deserializer);

  @protected
  PhraseToSeedReq sse_decode_box_autoadd_phrase_to_seed_req(
      SseDeserializer deserializer);

  @protected
  SchnorrFromSeedReq sse_decode_box_autoadd_schnorr_from_seed_req(
      SseDeserializer deserializer);

  @protected
  SchnorrSignWithSeedReq sse_decode_box_autoadd_schnorr_sign_with_seed_req(
      SseDeserializer deserializer);

  @protected
  SchnorrVerifyReq sse_decode_box_autoadd_schnorr_verify_req(
      SseDeserializer deserializer);

  @protected
  ScriptDeriveReq sse_decode_box_autoadd_script_derive_req(
      SseDeserializer deserializer);

  @protected
  Secp256k1FromSeedReq sse_decode_box_autoadd_secp_256_k_1_from_seed_req(
      SseDeserializer deserializer);

  @protected
  Secp256k1RecoverReq sse_decode_box_autoadd_secp_256_k_1_recover_req(
      SseDeserializer deserializer);

  @protected
  Secp256k1ShareSecretReq sse_decode_box_autoadd_secp_256_k_1_share_secret_req(
      SseDeserializer deserializer);

  @protected
  Secp256k1SignWithRngReq sse_decode_box_autoadd_secp_256_k_1_sign_with_rng_req(
      SseDeserializer deserializer);

  @protected
  Secp256k1SignWithSeedReq
      sse_decode_box_autoadd_secp_256_k_1_sign_with_seed_req(
          SseDeserializer deserializer);

  @protected
  Secp256k1VerifyReq sse_decode_box_autoadd_secp_256_k_1_verify_req(
      SseDeserializer deserializer);

  @protected
  SeedToKeyReq sse_decode_box_autoadd_seed_to_key_req(
      SseDeserializer deserializer);

  @protected
  int sse_decode_box_autoadd_u_8(SseDeserializer deserializer);

  @protected
  ED25519FromSeedReq sse_decode_ed_25519_from_seed_req(
      SseDeserializer deserializer);

  @protected
  ED25519Res sse_decode_ed_25519_res(SseDeserializer deserializer);

  @protected
  ED25519SignReq sse_decode_ed_25519_sign_req(SseDeserializer deserializer);

  @protected
  ED25519VerifyReq sse_decode_ed_25519_verify_req(SseDeserializer deserializer);

  @protected
  KeyDerivedRes sse_decode_key_derived_res(SseDeserializer deserializer);

  @protected
  Uint8List sse_decode_list_prim_u_8_strict(SseDeserializer deserializer);

  @protected
  int? sse_decode_opt_box_autoadd_u_8(SseDeserializer deserializer);

  @protected
  Uint8List? sse_decode_opt_list_prim_u_8_strict(SseDeserializer deserializer);

  @protected
  P256FromSeedReq sse_decode_p_256_from_seed_req(SseDeserializer deserializer);

  @protected
  P256IdentityExport sse_decode_p_256_identity_export(
      SseDeserializer deserializer);

  @protected
  P256ShareSecretReq sse_decode_p_256_share_secret_req(
      SseDeserializer deserializer);

  @protected
  P256SignWithSeedReq sse_decode_p_256_sign_with_seed_req(
      SseDeserializer deserializer);

  @protected
  P256VerifyReq sse_decode_p_256_verify_req(SseDeserializer deserializer);

  @protected
  PBKDFDeriveReq sse_decode_pbkdf_derive_req(SseDeserializer deserializer);

  @protected
  PhraseToSeedReq sse_decode_phrase_to_seed_req(SseDeserializer deserializer);

  @protected
  SchnorrFromSeedReq sse_decode_schnorr_from_seed_req(
      SseDeserializer deserializer);

  @protected
  SchnorrIdentityExport sse_decode_schnorr_identity_export(
      SseDeserializer deserializer);

  @protected
  SchnorrSignWithSeedReq sse_decode_schnorr_sign_with_seed_req(
      SseDeserializer deserializer);

  @protected
  SchnorrVerifyReq sse_decode_schnorr_verify_req(SseDeserializer deserializer);

  @protected
  ScriptDeriveReq sse_decode_script_derive_req(SseDeserializer deserializer);

  @protected
  Secp256k1FromSeedReq sse_decode_secp_256_k_1_from_seed_req(
      SseDeserializer deserializer);

  @protected
  Secp256k1IdentityExport sse_decode_secp_256_k_1_identity_export(
      SseDeserializer deserializer);

  @protected
  Secp256k1RecoverReq sse_decode_secp_256_k_1_recover_req(
      SseDeserializer deserializer);

  @protected
  Secp256k1ShareSecretReq sse_decode_secp_256_k_1_share_secret_req(
      SseDeserializer deserializer);

  @protected
  Secp256k1SignWithRngReq sse_decode_secp_256_k_1_sign_with_rng_req(
      SseDeserializer deserializer);

  @protected
  Secp256k1SignWithSeedReq sse_decode_secp_256_k_1_sign_with_seed_req(
      SseDeserializer deserializer);

  @protected
  Secp256k1VerifyReq sse_decode_secp_256_k_1_verify_req(
      SseDeserializer deserializer);

  @protected
  SeedToKeyReq sse_decode_seed_to_key_req(SseDeserializer deserializer);

  @protected
  SignatureFFI sse_decode_signature_ffi(SseDeserializer deserializer);

  @protected
  int sse_decode_u_32(SseDeserializer deserializer);

  @protected
  int sse_decode_u_8(SseDeserializer deserializer);

  @protected
  void sse_decode_unit(SseDeserializer deserializer);

  @protected
  int sse_decode_i_32(SseDeserializer deserializer);

  @protected
  void sse_encode_String(String self, SseSerializer serializer);

  @protected
  void sse_encode_aes_decrypt_req(AesDecryptReq self, SseSerializer serializer);

  @protected
  void sse_encode_aes_encrypt_req(AesEncryptReq self, SseSerializer serializer);

  @protected
  void sse_encode_bls_verify_req(BLSVerifyReq self, SseSerializer serializer);

  @protected
  void sse_encode_bool(bool self, SseSerializer serializer);

  @protected
  void sse_encode_box_autoadd_aes_decrypt_req(
      AesDecryptReq self, SseSerializer serializer);

  @protected
  void sse_encode_box_autoadd_aes_encrypt_req(
      AesEncryptReq self, SseSerializer serializer);

  @protected
  void sse_encode_box_autoadd_bls_verify_req(
      BLSVerifyReq self, SseSerializer serializer);

  @protected
  void sse_encode_box_autoadd_ed_25519_from_seed_req(
      ED25519FromSeedReq self, SseSerializer serializer);

  @protected
  void sse_encode_box_autoadd_ed_25519_sign_req(
      ED25519SignReq self, SseSerializer serializer);

  @protected
  void sse_encode_box_autoadd_ed_25519_verify_req(
      ED25519VerifyReq self, SseSerializer serializer);

  @protected
  void sse_encode_box_autoadd_p_256_from_seed_req(
      P256FromSeedReq self, SseSerializer serializer);

  @protected
  void sse_encode_box_autoadd_p_256_share_secret_req(
      P256ShareSecretReq self, SseSerializer serializer);

  @protected
  void sse_encode_box_autoadd_p_256_sign_with_seed_req(
      P256SignWithSeedReq self, SseSerializer serializer);

  @protected
  void sse_encode_box_autoadd_p_256_verify_req(
      P256VerifyReq self, SseSerializer serializer);

  @protected
  void sse_encode_box_autoadd_pbkdf_derive_req(
      PBKDFDeriveReq self, SseSerializer serializer);

  @protected
  void sse_encode_box_autoadd_phrase_to_seed_req(
      PhraseToSeedReq self, SseSerializer serializer);

  @protected
  void sse_encode_box_autoadd_schnorr_from_seed_req(
      SchnorrFromSeedReq self, SseSerializer serializer);

  @protected
  void sse_encode_box_autoadd_schnorr_sign_with_seed_req(
      SchnorrSignWithSeedReq self, SseSerializer serializer);

  @protected
  void sse_encode_box_autoadd_schnorr_verify_req(
      SchnorrVerifyReq self, SseSerializer serializer);

  @protected
  void sse_encode_box_autoadd_script_derive_req(
      ScriptDeriveReq self, SseSerializer serializer);

  @protected
  void sse_encode_box_autoadd_secp_256_k_1_from_seed_req(
      Secp256k1FromSeedReq self, SseSerializer serializer);

  @protected
  void sse_encode_box_autoadd_secp_256_k_1_recover_req(
      Secp256k1RecoverReq self, SseSerializer serializer);

  @protected
  void sse_encode_box_autoadd_secp_256_k_1_share_secret_req(
      Secp256k1ShareSecretReq self, SseSerializer serializer);

  @protected
  void sse_encode_box_autoadd_secp_256_k_1_sign_with_rng_req(
      Secp256k1SignWithRngReq self, SseSerializer serializer);

  @protected
  void sse_encode_box_autoadd_secp_256_k_1_sign_with_seed_req(
      Secp256k1SignWithSeedReq self, SseSerializer serializer);

  @protected
  void sse_encode_box_autoadd_secp_256_k_1_verify_req(
      Secp256k1VerifyReq self, SseSerializer serializer);

  @protected
  void sse_encode_box_autoadd_seed_to_key_req(
      SeedToKeyReq self, SseSerializer serializer);

  @protected
  void sse_encode_box_autoadd_u_8(int self, SseSerializer serializer);

  @protected
  void sse_encode_ed_25519_from_seed_req(
      ED25519FromSeedReq self, SseSerializer serializer);

  @protected
  void sse_encode_ed_25519_res(ED25519Res self, SseSerializer serializer);

  @protected
  void sse_encode_ed_25519_sign_req(
      ED25519SignReq self, SseSerializer serializer);

  @protected
  void sse_encode_ed_25519_verify_req(
      ED25519VerifyReq self, SseSerializer serializer);

  @protected
  void sse_encode_key_derived_res(KeyDerivedRes self, SseSerializer serializer);

  @protected
  void sse_encode_list_prim_u_8_strict(
      Uint8List self, SseSerializer serializer);

  @protected
  void sse_encode_opt_box_autoadd_u_8(int? self, SseSerializer serializer);

  @protected
  void sse_encode_opt_list_prim_u_8_strict(
      Uint8List? self, SseSerializer serializer);

  @protected
  void sse_encode_p_256_from_seed_req(
      P256FromSeedReq self, SseSerializer serializer);

  @protected
  void sse_encode_p_256_identity_export(
      P256IdentityExport self, SseSerializer serializer);

  @protected
  void sse_encode_p_256_share_secret_req(
      P256ShareSecretReq self, SseSerializer serializer);

  @protected
  void sse_encode_p_256_sign_with_seed_req(
      P256SignWithSeedReq self, SseSerializer serializer);

  @protected
  void sse_encode_p_256_verify_req(
      P256VerifyReq self, SseSerializer serializer);

  @protected
  void sse_encode_pbkdf_derive_req(
      PBKDFDeriveReq self, SseSerializer serializer);

  @protected
  void sse_encode_phrase_to_seed_req(
      PhraseToSeedReq self, SseSerializer serializer);

  @protected
  void sse_encode_schnorr_from_seed_req(
      SchnorrFromSeedReq self, SseSerializer serializer);

  @protected
  void sse_encode_schnorr_identity_export(
      SchnorrIdentityExport self, SseSerializer serializer);

  @protected
  void sse_encode_schnorr_sign_with_seed_req(
      SchnorrSignWithSeedReq self, SseSerializer serializer);

  @protected
  void sse_encode_schnorr_verify_req(
      SchnorrVerifyReq self, SseSerializer serializer);

  @protected
  void sse_encode_script_derive_req(
      ScriptDeriveReq self, SseSerializer serializer);

  @protected
  void sse_encode_secp_256_k_1_from_seed_req(
      Secp256k1FromSeedReq self, SseSerializer serializer);

  @protected
  void sse_encode_secp_256_k_1_identity_export(
      Secp256k1IdentityExport self, SseSerializer serializer);

  @protected
  void sse_encode_secp_256_k_1_recover_req(
      Secp256k1RecoverReq self, SseSerializer serializer);

  @protected
  void sse_encode_secp_256_k_1_share_secret_req(
      Secp256k1ShareSecretReq self, SseSerializer serializer);

  @protected
  void sse_encode_secp_256_k_1_sign_with_rng_req(
      Secp256k1SignWithRngReq self, SseSerializer serializer);

  @protected
  void sse_encode_secp_256_k_1_sign_with_seed_req(
      Secp256k1SignWithSeedReq self, SseSerializer serializer);

  @protected
  void sse_encode_secp_256_k_1_verify_req(
      Secp256k1VerifyReq self, SseSerializer serializer);

  @protected
  void sse_encode_seed_to_key_req(SeedToKeyReq self, SseSerializer serializer);

  @protected
  void sse_encode_signature_ffi(SignatureFFI self, SseSerializer serializer);

  @protected
  void sse_encode_u_32(int self, SseSerializer serializer);

  @protected
  void sse_encode_u_8(int self, SseSerializer serializer);

  @protected
  void sse_encode_unit(void self, SseSerializer serializer);

  @protected
  void sse_encode_i_32(int self, SseSerializer serializer);
}

// Section: wire_class

class AgentDartWire implements BaseWire {
  factory AgentDartWire.fromExternalLibrary(ExternalLibrary lib) =>
      AgentDartWire(lib.ffiDynamicLibrary);

  /// Holds the symbol lookup function.
  final ffi.Pointer<T> Function<T extends ffi.NativeType>(String symbolName)
      _lookup;

  /// The symbols are looked up in [dynamicLibrary].
  AgentDartWire(ffi.DynamicLibrary dynamicLibrary)
      : _lookup = dynamicLibrary.lookup;
}
