// Generated by Apple Swift version 4.1.2 effective-3.3.2 (swiftlang-902.0.54 clang-902.0.39.2)
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgcc-compat"

#if !defined(__has_include)
# define __has_include(x) 0
#endif
#if !defined(__has_attribute)
# define __has_attribute(x) 0
#endif
#if !defined(__has_feature)
# define __has_feature(x) 0
#endif
#if !defined(__has_warning)
# define __has_warning(x) 0
#endif

#if __has_include(<swift/objc-prologue.h>)
# include <swift/objc-prologue.h>
#endif

#pragma clang diagnostic ignored "-Wauto-import"
#include <objc/NSObject.h>
#include <stdint.h>
#include <stddef.h>
#include <stdbool.h>

#if !defined(SWIFT_TYPEDEFS)
# define SWIFT_TYPEDEFS 1
# if __has_include(<uchar.h>)
#  include <uchar.h>
# elif !defined(__cplusplus)
typedef uint_least16_t char16_t;
typedef uint_least32_t char32_t;
# endif
typedef float swift_float2  __attribute__((__ext_vector_type__(2)));
typedef float swift_float3  __attribute__((__ext_vector_type__(3)));
typedef float swift_float4  __attribute__((__ext_vector_type__(4)));
typedef double swift_double2  __attribute__((__ext_vector_type__(2)));
typedef double swift_double3  __attribute__((__ext_vector_type__(3)));
typedef double swift_double4  __attribute__((__ext_vector_type__(4)));
typedef int swift_int2  __attribute__((__ext_vector_type__(2)));
typedef int swift_int3  __attribute__((__ext_vector_type__(3)));
typedef int swift_int4  __attribute__((__ext_vector_type__(4)));
typedef unsigned int swift_uint2  __attribute__((__ext_vector_type__(2)));
typedef unsigned int swift_uint3  __attribute__((__ext_vector_type__(3)));
typedef unsigned int swift_uint4  __attribute__((__ext_vector_type__(4)));
#endif

#if !defined(SWIFT_PASTE)
# define SWIFT_PASTE_HELPER(x, y) x##y
# define SWIFT_PASTE(x, y) SWIFT_PASTE_HELPER(x, y)
#endif
#if !defined(SWIFT_METATYPE)
# define SWIFT_METATYPE(X) Class
#endif
#if !defined(SWIFT_CLASS_PROPERTY)
# if __has_feature(objc_class_property)
#  define SWIFT_CLASS_PROPERTY(...) __VA_ARGS__
# else
#  define SWIFT_CLASS_PROPERTY(...)
# endif
#endif

#if __has_attribute(objc_runtime_name)
# define SWIFT_RUNTIME_NAME(X) __attribute__((objc_runtime_name(X)))
#else
# define SWIFT_RUNTIME_NAME(X)
#endif
#if __has_attribute(swift_name)
# define SWIFT_COMPILE_NAME(X) __attribute__((swift_name(X)))
#else
# define SWIFT_COMPILE_NAME(X)
#endif
#if __has_attribute(objc_method_family)
# define SWIFT_METHOD_FAMILY(X) __attribute__((objc_method_family(X)))
#else
# define SWIFT_METHOD_FAMILY(X)
#endif
#if __has_attribute(noescape)
# define SWIFT_NOESCAPE __attribute__((noescape))
#else
# define SWIFT_NOESCAPE
#endif
#if __has_attribute(warn_unused_result)
# define SWIFT_WARN_UNUSED_RESULT __attribute__((warn_unused_result))
#else
# define SWIFT_WARN_UNUSED_RESULT
#endif
#if __has_attribute(noreturn)
# define SWIFT_NORETURN __attribute__((noreturn))
#else
# define SWIFT_NORETURN
#endif
#if !defined(SWIFT_CLASS_EXTRA)
# define SWIFT_CLASS_EXTRA
#endif
#if !defined(SWIFT_PROTOCOL_EXTRA)
# define SWIFT_PROTOCOL_EXTRA
#endif
#if !defined(SWIFT_ENUM_EXTRA)
# define SWIFT_ENUM_EXTRA
#endif
#if !defined(SWIFT_CLASS)
# if __has_attribute(objc_subclassing_restricted)
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_CLASS_EXTRA
#  define SWIFT_CLASS_NAMED(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# else
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
#  define SWIFT_CLASS_NAMED(SWIFT_NAME) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# endif
#endif

#if !defined(SWIFT_PROTOCOL)
# define SWIFT_PROTOCOL(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
# define SWIFT_PROTOCOL_NAMED(SWIFT_NAME) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
#endif

#if !defined(SWIFT_EXTENSION)
# define SWIFT_EXTENSION(M) SWIFT_PASTE(M##_Swift_, __LINE__)
#endif

#if !defined(OBJC_DESIGNATED_INITIALIZER)
# if __has_attribute(objc_designated_initializer)
#  define OBJC_DESIGNATED_INITIALIZER __attribute__((objc_designated_initializer))
# else
#  define OBJC_DESIGNATED_INITIALIZER
# endif
#endif
#if !defined(SWIFT_ENUM_ATTR)
# if defined(__has_attribute) && __has_attribute(enum_extensibility)
#  define SWIFT_ENUM_ATTR __attribute__((enum_extensibility(open)))
# else
#  define SWIFT_ENUM_ATTR
# endif
#endif
#if !defined(SWIFT_ENUM)
# define SWIFT_ENUM(_type, _name) enum _name : _type _name; enum SWIFT_ENUM_ATTR SWIFT_ENUM_EXTRA _name : _type
# if __has_feature(generalized_swift_name)
#  define SWIFT_ENUM_NAMED(_type, _name, SWIFT_NAME) enum _name : _type _name SWIFT_COMPILE_NAME(SWIFT_NAME); enum SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_ENUM_ATTR SWIFT_ENUM_EXTRA _name : _type
# else
#  define SWIFT_ENUM_NAMED(_type, _name, SWIFT_NAME) SWIFT_ENUM(_type, _name)
# endif
#endif
#if !defined(SWIFT_UNAVAILABLE)
# define SWIFT_UNAVAILABLE __attribute__((unavailable))
#endif
#if !defined(SWIFT_UNAVAILABLE_MSG)
# define SWIFT_UNAVAILABLE_MSG(msg) __attribute__((unavailable(msg)))
#endif
#if !defined(SWIFT_AVAILABILITY)
# define SWIFT_AVAILABILITY(plat, ...) __attribute__((availability(plat, __VA_ARGS__)))
#endif
#if !defined(SWIFT_DEPRECATED)
# define SWIFT_DEPRECATED __attribute__((deprecated))
#endif
#if !defined(SWIFT_DEPRECATED_MSG)
# define SWIFT_DEPRECATED_MSG(...) __attribute__((deprecated(__VA_ARGS__)))
#endif
#if __has_feature(attribute_diagnose_if_objc)
# define SWIFT_DEPRECATED_OBJC(Msg) __attribute__((diagnose_if(1, Msg, "warning")))
#else
# define SWIFT_DEPRECATED_OBJC(Msg) SWIFT_DEPRECATED_MSG(Msg)
#endif
#if __has_feature(modules)
@import ObjectiveC;
@import Foundation;
#endif

#pragma clang diagnostic ignored "-Wproperty-attribute-mismatch"
#pragma clang diagnostic ignored "-Wduplicate-method-arg"
#if __has_warning("-Wpragma-clang-attribute")
# pragma clang diagnostic ignored "-Wpragma-clang-attribute"
#endif
#pragma clang diagnostic ignored "-Wunknown-pragmas"
#pragma clang diagnostic ignored "-Wnullability"

#if __has_attribute(external_source_symbol)
# pragma push_macro("any")
# undef any
# pragma clang attribute push(__attribute__((external_source_symbol(language="Swift", defined_in="ThorModels",generated_declaration))), apply_to=any(function,enum,objc_interface,objc_category,objc_protocol))
# pragma pop_macro("any")
#endif

@class Address;
@class Cancellable;
@class Signature;

SWIFT_CLASS("_TtC10ThorModels7Account")
@interface Account : NSObject
@property (nonatomic, readonly, copy) NSData * _Nullable privateKey;
@property (nonatomic, readonly, strong) Address * _Nullable address;
@property (nonatomic, readonly, copy) NSString * _Nullable mnemonicPhrase;
@property (nonatomic, readonly, copy) NSData * _Nullable mnemonicData;
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
+ (nonnull instancetype)new SWIFT_DEPRECATED_MSG("-init is unavailable");
- (nullable instancetype)initWithPrivateKey:(NSData * _Nonnull)privateKey;
+ (Account * _Nullable)randomMnemonicAccount SWIFT_WARN_UNUSED_RESULT;
- (nullable instancetype)initWithMnemonicPhrase:(NSString * _Nonnull)mnemonicPhrase;
- (Cancellable * _Nonnull)encryptSecretStorageJSONWithPassword:(NSString * _Nonnull)password callback:(void (^ _Nonnull)(NSString * _Nullable, NSError * _Nullable))callback SWIFT_WARN_UNUSED_RESULT;
+ (Cancellable * _Nonnull)decryptSecretStorageJSONWithJson:(NSString * _Nonnull)json password:(NSString * _Nonnull)password callback:(void (^ _Nonnull)(Account * _Nullable, NSError * _Nullable))callback SWIFT_WARN_UNUSED_RESULT;
- (Signature * _Nullable)signDigestWithDigest:(NSData * _Nonnull)digest SWIFT_WARN_UNUSED_RESULT;
+ (Address * _Nullable)verifyDigestWithDigest:(NSData * _Nonnull)digest signature:(Signature * _Nonnull)signature SWIFT_WARN_UNUSED_RESULT;
@end


SWIFT_CLASS("_TtC10ThorModels7Address")
@interface Address : NSObject
@property (nonatomic, readonly, copy) NSData * _Nullable data;
@property (nonatomic, readonly, copy) NSString * _Nullable hexString;
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
+ (nonnull instancetype)new SWIFT_DEPRECATED_MSG("-init is unavailable");
- (nullable instancetype)initWithData:(NSData * _Nonnull)data;
- (nullable instancetype)initWithHexString:(NSString * _Nullable)hexString;
- (BOOL)isEqual:(id _Nullable)object SWIFT_WARN_UNUSED_RESULT;
@end


SWIFT_CLASS("_TtC10ThorModels9BigNumber")
@interface BigNumber : NSObject
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)initWithInteger:(NSInteger)integer;
- (nonnull instancetype)initWithData:(NSData * _Nonnull)data;
- (nullable instancetype)initWithDecimalString:(NSString * _Nonnull)decimalString;
- (nullable instancetype)initWithHexString:(NSString * _Nonnull)hexString;
- (BigNumber * _Nonnull)addWithOther:(BigNumber * _Nonnull)other SWIFT_WARN_UNUSED_RESULT;
- (BigNumber * _Nonnull)subWithOther:(BigNumber * _Nonnull)other SWIFT_WARN_UNUSED_RESULT;
- (BigNumber * _Nonnull)mulWithOther:(BigNumber * _Nonnull)other SWIFT_WARN_UNUSED_RESULT;
- (BigNumber * _Nonnull)divWithOther:(BigNumber * _Nonnull)other SWIFT_WARN_UNUSED_RESULT;
- (BigNumber * _Nonnull)modWithOther:(BigNumber * _Nonnull)other SWIFT_WARN_UNUSED_RESULT;
- (NSString * _Nullable)formatStringWithRadix:(int32_t)radix SWIFT_WARN_UNUSED_RESULT;
- (NSString * _Nullable)decimalString SWIFT_WARN_UNUSED_RESULT;
- (NSString * _Nullable)hexString SWIFT_WARN_UNUSED_RESULT;
- (NSComparisonResult)compareWithOther:(BigNumber * _Nonnull)other SWIFT_WARN_UNUSED_RESULT;
- (BOOL)lessThanWithOther:(BigNumber * _Nonnull)other SWIFT_WARN_UNUSED_RESULT;
- (BOOL)lessThanEqualToOther:(BigNumber * _Nonnull)other SWIFT_WARN_UNUSED_RESULT;
- (BOOL)greaterThanWithOther:(BigNumber * _Nonnull)other SWIFT_WARN_UNUSED_RESULT;
- (BOOL)greaterThanEqualToOther:(BigNumber * _Nonnull)other SWIFT_WARN_UNUSED_RESULT;
- (BOOL)isNegative SWIFT_WARN_UNUSED_RESULT;
@end


SWIFT_CLASS("_TtC10ThorModels8BlockRef")
@interface BlockRef : NSObject
@property (nonatomic, readonly, copy) NSData * _Null_unspecified data;
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
+ (nonnull instancetype)new SWIFT_DEPRECATED_MSG("-init is unavailable");
- (nonnull instancetype)initWithBlockNumber:(uint32_t)blockNumber;
@end


SWIFT_CLASS("_TtC10ThorModels7Bytes32")
@interface Bytes32 : NSObject
@property (nonatomic, readonly, copy) NSData * _Nullable data;
@property (nonatomic, readonly, copy) NSString * _Nullable hexString;
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
+ (nonnull instancetype)new SWIFT_DEPRECATED_MSG("-init is unavailable");
- (nullable instancetype)initWithData:(NSData * _Nonnull)data;
- (BOOL)isEqual:(id _Nullable)object SWIFT_WARN_UNUSED_RESULT;
@end


SWIFT_CLASS("_TtC10ThorModels11Cancellable")
@interface Cancellable : NSObject
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)initWithCancelCallback:(void (^ _Nullable)(void))cancelCallback;
- (void)cancel;
@end


SWIFT_CLASS("_TtC10ThorModels6Clause")
@interface Clause : NSObject
@property (nonatomic, strong) Address * _Nullable toAddress;
@property (nonatomic, strong) BigNumber * _Nullable value;
@property (nonatomic, copy) NSData * _Nullable data;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)initToAddress:(Address * _Nullable)toAddress value:(BigNumber * _Nullable)value data:(NSData * _Nullable)data;
@end


SWIFT_CLASS("_TtC10ThorModels6Crypto")
@interface Crypto : NSObject
@property (nonatomic, copy) NSData * _Null_unspecified data;
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
+ (nonnull instancetype)new SWIFT_DEPRECATED_MSG("-init is unavailable");
- (nonnull instancetype)initWithCapacity:(NSInteger)capacity OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)initWithData:(NSData * _Nonnull)data OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)initWithLength:(NSInteger)length OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithHexString:(NSString * _Nonnull)hexString OBJC_DESIGNATED_INITIALIZER;
- (void)KECCAK256;
+ (NSData * _Nonnull)KECCAK256WithData:(NSData * _Nonnull)data SWIFT_WARN_UNUSED_RESULT;
- (void)BLAKE2B;
+ (NSData * _Nonnull)BLAKE2BWithData:(NSData * _Nonnull)data SWIFT_WARN_UNUSED_RESULT;
@end


SWIFT_CLASS("_TtC10ThorModels16RLPSerialization")
@interface RLPSerialization : NSObject
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC10ThorModels5RegEx")
@interface RegEx : NSObject
- (BOOL)matchesAnyWithStr:(NSString * _Nonnull)str SWIFT_WARN_UNUSED_RESULT;
- (BOOL)matchesExactlyWithStr:(NSString * _Nonnull)str SWIFT_WARN_UNUSED_RESULT;
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
+ (nonnull instancetype)new SWIFT_DEPRECATED_MSG("-init is unavailable");
@end


SWIFT_CLASS("_TtC10ThorModels9Signature")
@interface Signature : NSObject
@property (nonatomic, readonly, copy) NSData * _Null_unspecified data;
@property (nonatomic, readonly, copy) NSData * _Null_unspecified sig;
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
+ (nonnull instancetype)new SWIFT_DEPRECATED_MSG("-init is unavailable");
- (nullable instancetype)initWithData:(NSData * _Nonnull)data v:(uint8_t)v;
- (nullable instancetype)initWithSig:(NSData * _Nonnull)sig;
@end


SWIFT_CLASS("_TtC10ThorModels11Transaction")
@interface Transaction : NSObject
@property (nonatomic, strong) BlockRef * _Null_unspecified blockRef;
@property (nonatomic, copy) NSArray<Clause *> * _Nonnull clauses;
@property (nonatomic, strong) Bytes32 * _Nullable dependsOn;
@property (nonatomic, strong) Signature * _Nullable signature;
@property (nonatomic, readonly, strong) Address * _Nullable signer;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (void)appendClauseWithClause:(Clause * _Nonnull)clause;
- (Bytes32 * _Nonnull)signingHash SWIFT_WARN_UNUSED_RESULT;
- (NSData * _Nullable)serializeAndReturnError:(NSError * _Nullable * _Nullable)error SWIFT_WARN_UNUSED_RESULT;
- (Bytes32 * _Nullable)ID SWIFT_WARN_UNUSED_RESULT;
@end

#if __has_attribute(external_source_symbol)
# pragma clang attribute pop
#endif
#pragma clang diagnostic pop