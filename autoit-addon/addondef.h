#pragma once

#if defined _WIN32
#  define ADDON_CDECL __cdecl
#  define ADDON_STDCALL __stdcall
#else
#  define ADDON_CDECL
#  define ADDON_STDCALL
#endif

#ifndef ADDON_EXTERN_C
#  ifdef __cplusplus
#    define ADDON_EXTERN_C extern "C"
#  else
#    define ADDON_EXTERN_C
#  endif
#endif

#ifndef ADDON_EXPORTS
# if (defined _WIN32 || defined WINCE || defined __CYGWIN__) && defined(ADDON_API_EXPORTS)
#   define ADDON_EXPORTS __declspec(dllexport)
# elif defined __GNUC__ && __GNUC__ >= 4 && (defined(ADDON_API_EXPORTS) || defined(__APPLE__))
#   define ADDON_EXPORTS __attribute__ ((visibility ("default")))
# elif defined __clang__ 
#   define ADDON_EXPORTS __attribute__ ((visibility ("default")))
# else
#   define ADDON_EXPORTS
# endif
#endif

#ifndef ADDON_API
#  define ADDON_API(rettype) ADDON_EXTERN_C ADDON_EXPORTS rettype ADDON_CDECL
#endif
