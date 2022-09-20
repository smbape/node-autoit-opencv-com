#pragma once

// Si vous incluez SDKDDKVer.h, cela définit la dernière plateforme Windows disponible.

// Si vous souhaitez générer votre application pour une plateforme Windows précédente, incluez WinSDKVer.h et
// définissez la macro _WIN32_WINNT à la plateforme que vous souhaitez prendre en charge avant d'inclure SDKDDKVer.h.

// bazel has an hardcoded _WIN32_WINNT value which makes the compilation to failed
// undefine it to let winsdk set the correct value
// see  https://github.com/bazelbuild/bazel/issues/15024
//      https://github.com/bazelbuild/bazel/issues/12737
#if defined(_WIN32_WINNT) && !defined(_INC_SDKDDKVER)
#undef _WIN32_WINNT
#endif

#include <SDKDDKVer.h>
