# Select a hash backend

INCLUDE(SanitizeBool)

# USE_SHA1=CollisionDetection(ON)/HTTPS/Generic/OFF

SanitizeBool(USE_SHA1)
IF(USE_SHA1 STREQUAL ON)
	SET(USE_SHA1 "CollisionDetection")
ELSEIF(USE_SHA1 STREQUAL "HTTPS")
	IF(USE_HTTPS STREQUAL "SecureTransport")
		SET(USE_SHA1 "CommonCrypto")
	ELSEIF(USE_HTTPS STREQUAL "WinHTTP")
		SET(USE_SHA1 "Win32")
	ELSEIF(USE_HTTPS)
		SET(USE_SHA1 ${USE_HTTPS})
	ELSE()
		SET(USE_SHA1 "CollisionDetection")
	ENDIF()
ENDIF()

IF(USE_SHA1 STREQUAL "CollisionDetection")
	SET(GIT_SHA1_COLLISIONDETECT 1)
	ADD_DEFINITIONS(-DSHA1DC_NO_STANDARD_INCLUDES=1)
	ADD_DEFINITIONS(-DSHA1DC_CUSTOM_INCLUDE_SHA1_C=\"common.h\")
	ADD_DEFINITIONS(-DSHA1DC_CUSTOM_INCLUDE_UBC_CHECK_C=\"common.h\")
	FILE(GLOB SRC_SHA1 hash/sha1/collisiondetect.* hash/sha1/sha1dc/*)
ELSEIF(USE_SHA1 STREQUAL "OpenSSL")
	# OPENSSL_FOUND should already be set, we're checking USE_HTTPS

	SET(GIT_SHA1_OPENSSL 1)
	IF(CMAKE_SYSTEM_NAME MATCHES "FreeBSD")
		LIST(APPEND LIBGIT2_PC_LIBS "-lssl")
	ELSE()
		LIST(APPEND LIBGIT2_PC_REQUIRES "openssl")
	ENDIF()
	FILE(GLOB SRC_SHA1 hash/sha1/openssl.*)
ELSEIF(USE_SHA1 STREQUAL "CommonCrypto")
	SET(GIT_SHA1_COMMON_CRYPTO 1)
	FILE(GLOB SRC_SHA1 hash/sha1/common_crypto.*)
ELSEIF(USE_SHA1 STREQUAL "mbedTLS")
	SET(GIT_SHA1_MBEDTLS 1)
	FILE(GLOB SRC_SHA1 hash/sha1/mbedtls.*)
	LIST(APPEND LIBGIT2_SYSTEM_INCLUDES ${MBEDTLS_INCLUDE_DIR})
	LIST(APPEND LIBGIT2_LIBS ${MBEDTLS_LIBRARIES})
	# mbedTLS has no pkgconfig file, hence we can't require it
	# https://github.com/ARMmbed/mbedtls/issues/228
	# For now, pass its link flags as our own
	LIST(APPEND LIBGIT2_PC_LIBS ${MBEDTLS_LIBRARIES})
ELSEIF(USE_SHA1 STREQUAL "Win32")
	SET(GIT_SHA1_WIN32 1)
	FILE(GLOB SRC_SHA1 hash/sha1/win32.*)
ELSEIF(USE_SHA1 STREQUAL "Generic")
	FILE(GLOB SRC_SHA1 hash/sha1/generic.*)
ELSE()
	MESSAGE(FATAL_ERROR "Asked for unknown SHA1 backend: ${USE_SHA1}")
ENDIF()

ADD_FEATURE_INFO(SHA ON "using ${USE_SHA1}")
