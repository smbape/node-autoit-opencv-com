#pragma once

#if defined _WIN32
#  define AUTOIT_CDECL __cdecl
#  define AUTOIT_STDCALL __stdcall
#else
#  define AUTOIT_CDECL
#  define AUTOIT_STDCALL
#endif

#ifndef AUTOIT_EXTERN_C
#  ifdef __cplusplus
#    define AUTOIT_EXTERN_C extern "C"
#  else
#    define AUTOIT_EXTERN_C
#  endif
#endif

#ifndef AUTOIT_EXPORTS
# if (defined _WIN32 || defined WINCE || defined __CYGWIN__) && defined(AUTOITAPI_EXPORTS)
#   define AUTOIT_EXPORTS __declspec(dllexport)
# elif defined __GNUC__ && __GNUC__ >= 4 && (defined(AUTOITAPI_EXPORTS) || defined(__APPLE__))
#   define AUTOIT_EXPORTS __attribute__ ((visibility ("default")))
# elif defined __clang__ 
#   define AUTOIT_EXPORTS __attribute__ ((visibility ("default")))
# else
#   define AUTOIT_EXPORTS
# endif
#endif

#ifndef AUTOITAPI
#  define AUTOITAPI(rettype) AUTOIT_EXTERN_C AUTOIT_EXPORTS rettype AUTOIT_CDECL
#endif
