using System;
using System.Collections;
using System.Collections.Generic;
using System.ComponentModel;
using System.Diagnostics.CodeAnalysis;
using System.IO;
using System.Reflection;
using System.Runtime.InteropServices;
using System.Security.Principal;

public static class OpenCvComInterop
{
    // https://github.com/microsoft/vstest/blob/main/src/Microsoft.TestPlatform.ObjectModel/RegistryFreeActivationContext.cs
    // Activation Context API Functions
    [DllImport("Kernel32.dll", SetLastError = true, EntryPoint = "CreateActCtxW")]
    public extern static IntPtr CreateActCtx(ref ACTCTX actctx);

    [DllImport("Kernel32.dll", SetLastError = true)]
    [return: MarshalAs(UnmanagedType.Bool)]
    public static extern bool ActivateActCtx(IntPtr hActCtx, out IntPtr lpCookie);

    [DllImport("kernel32.dll", SetLastError = true)]
    [return: MarshalAs(UnmanagedType.Bool)]
    public static extern bool DeactivateActCtx(int dwFlags, IntPtr lpCookie);

    [DllImport("Kernel32.dll", SetLastError = true)]
    public static extern void ReleaseActCtx(IntPtr hActCtx);

    // Activation context structure
    [StructLayout(LayoutKind.Sequential, Pack = 4, CharSet = CharSet.Unicode)]
    [SuppressMessage("Style", "IDE1006:Naming Styles", Justification = "Layout struct")]
    public struct ACTCTX
    {
        public Int32 cbSize;
        public UInt32 dwFlags;
        public string lpSource;
        public UInt16 wProcessorArchitecture;
        public UInt16 wLangId;
        public string lpAssemblyDirectory;
        public string lpResourceName;
        public string lpApplicationName;
        public IntPtr hModule;
    }

    public static readonly IntPtr INVALID_HANDLE_VALUE = new IntPtr(-1);
    public static readonly UInt32 ACTCTX_FLAG_PROCESSOR_ARCHITECTURE_VALID = 1 << 0;
    public static readonly UInt32 ACTCTX_FLAG_LANGID_VALID = 1 << 1;
    public static readonly UInt32 ACTCTX_FLAG_ASSEMBLY_DIRECTORY_VALID = 1 << 2;
    public static readonly UInt32 ACTCTX_FLAG_RESOURCE_NAME_VALID = 1 << 3;
    public static readonly UInt32 ACTCTX_FLAG_SET_PROCESS_DEFAULT = 1 << 4;
    public static readonly UInt32 ACTCTX_FLAG_APPLICATION_NAME_VALID = 1 << 5;
    public static readonly UInt32 ACTCTX_FLAG_HMODULE_VALID = 1 << 7;

    [DllImport("kernel32.dll", CharSet = CharSet.Ansi, SetLastError = true)]
    public static extern IntPtr LoadLibrary(string dllToLoad);

    [DllImport("kernel32.dll", CharSet = CharSet.Ansi, SetLastError = true)]
    public static extern bool FreeLibrary(IntPtr hModule);

    [DllImport("kernel32.dll", CharSet = CharSet.Ansi, SetLastError = true)]
    private static extern IntPtr GetProcAddress(IntPtr hModule, string name);

    private delegate long DllInstall_api(bool bInstall, [In, MarshalAs(UnmanagedType.LPWStr)] string cmdLine);
    private delegate bool DllActivateManifest_api([In, MarshalAs(UnmanagedType.LPWStr)] string manifest);
    private delegate bool DllActivateActCtx_api(ref ACTCTX actctx);
    private delegate bool DllDeactivateActCtx_api();

    private static IntPtr hOpenCvWorld = IntPtr.Zero;
    private static IntPtr hOpenCvFfmpeg = IntPtr.Zero;
    private static IntPtr hOpenCvCom = IntPtr.Zero;

    private static DllInstall_api DllInstall;
    private static DllActivateManifest_api DllActivateManifest_t;
    private static DllActivateActCtx_api DllActivateActCtx_t;
    private static DllDeactivateActCtx_api DllDeactivateActCtx_t;

    public static bool IsAdministrator()
    {
        using (WindowsIdentity identity = WindowsIdentity.GetCurrent())
        {
            WindowsPrincipal principal = new WindowsPrincipal(identity);
            return principal.IsInRole(WindowsBuiltInRole.Administrator);
        }
    }

    public static void DllOpen(string openCvWorldDll, string openCvComDll)
    {
        hOpenCvWorld = LoadLibrary(openCvWorldDll);
        if (hOpenCvWorld == IntPtr.Zero)
        {
            throw new Win32Exception(Marshal.GetLastWin32Error(), "Failed to load opencv library '" + openCvWorldDll + "'");
        }

        var parts = openCvWorldDll.Split(Path.AltDirectorySeparatorChar, Path.DirectorySeparatorChar);
        parts[parts.Length - 1] = "opencv_videoio_ffmpeg4100_64.dll";
        var openCvFfmpegDll = string.Join(Path.DirectorySeparatorChar.ToString(), parts);
        hOpenCvFfmpeg = LoadLibrary(openCvFfmpegDll);
        if (hOpenCvFfmpeg == IntPtr.Zero)
        {
            throw new Win32Exception(Marshal.GetLastWin32Error(), "Failed to load ffmpeg library '" + openCvFfmpegDll + "'");
        }

        hOpenCvCom = LoadLibrary(openCvComDll);
        if (hOpenCvCom == IntPtr.Zero)
        {
            throw new Win32Exception(Marshal.GetLastWin32Error(), "Failed to open autoit opencv com library '" + openCvComDll + "'");
        }

        IntPtr DllInstall_addr = GetProcAddress(hOpenCvCom, "DllInstall");
        if (DllInstall_addr == IntPtr.Zero)
        {
            throw new Win32Exception(Marshal.GetLastWin32Error(), "Unable to find DllInstall method");
        }
        DllInstall = (DllInstall_api) Marshal.GetDelegateForFunctionPointer(DllInstall_addr, typeof(DllInstall_api));

        IntPtr DllActivateActCtx_addr = GetProcAddress(hOpenCvCom, "DllActivateActCtx");
        if (DllActivateActCtx_addr == IntPtr.Zero)
        {
            throw new Win32Exception(Marshal.GetLastWin32Error(), "Unable to find DllActivateActCtx method");
        }
        DllActivateActCtx_t = (DllActivateActCtx_api) Marshal.GetDelegateForFunctionPointer(DllActivateActCtx_addr, typeof(DllActivateActCtx_api));

        IntPtr DllActivateManifest_addr = GetProcAddress(hOpenCvCom, "DllActivateManifest");
        if (DllActivateManifest_addr == IntPtr.Zero)
        {
            throw new Win32Exception(Marshal.GetLastWin32Error(), "Unable to find DllActivateManifest method");
        }
        DllActivateManifest_t = (DllActivateManifest_api) Marshal.GetDelegateForFunctionPointer(DllActivateManifest_addr, typeof(DllActivateManifest_api));

        IntPtr DllDeactivateActCtx_addr = GetProcAddress(hOpenCvCom, "DllDeactivateActCtx");
        if (DllDeactivateActCtx_addr == IntPtr.Zero)
        {
            throw new Win32Exception(Marshal.GetLastWin32Error(), "Unable to find DllDeactivateActCtx method");
        }
        DllDeactivateActCtx_t = (DllDeactivateActCtx_api) Marshal.GetDelegateForFunctionPointer(DllDeactivateActCtx_addr, typeof(DllDeactivateActCtx_api));
    }

    public static void DllClose()
    {
        FreeLibrary(hOpenCvCom);
        FreeLibrary(hOpenCvFfmpeg);
        FreeLibrary(hOpenCvWorld);
    }

    public static bool DllActivateManifest(string manifest = null)
    {
        if (string.IsNullOrWhiteSpace(manifest)) {
            manifest = Environment.GetEnvironmentVariable("OPENCV_ACTCTX_MANIFEST");
        }
        return DllActivateManifest_t(manifest);
    }

    public static bool DllActivateActCtx(ref ACTCTX actctx)
    {
        return DllActivateActCtx_t(ref actctx);
    }

    public static bool DllDeactivateActCtx()
    {
        return DllDeactivateActCtx_t();
    }

    public static void Register(string cmdLine = "")
    {
        if (string.IsNullOrWhiteSpace(cmdLine) && !IsAdministrator())
        {
            cmdLine = "user";
        }

        var hr = DllInstall(true, cmdLine);
        if (hr < 0)
        {
            throw new Win32Exception(Marshal.GetLastWin32Error(), "!>Error: DllInstall " + hr);
        }
    }

    public static void Unregister(string cmdLine = "")
    {
        if (string.IsNullOrWhiteSpace(cmdLine) && !IsAdministrator())
        {
            cmdLine = "user";
        }

        var hr = DllInstall(false, cmdLine);
        if (hr < 0)
        {
            throw new Win32Exception(Marshal.GetLastWin32Error(), "!>Error: DllInstall " + hr);
        }
    }

    public static dynamic ObjCreate(string progID)
    {
        DllActivateManifest();

        try {
            string[] namespaces = { "", "OpenCV.", "OpenCV.cv.", "OpenCV.com.", "OpenCV.std." };
            foreach (string itNamespace in namespaces)
            {
                Type ObjType = Type.GetTypeFromProgID(itNamespace + progID);
                if (ObjType != null)
                {
                    return Activator.CreateInstance(ObjType);
                }
            }

            return null;
        }
        finally {
            DllDeactivateActCtx();
        }
    }

    public static dynamic Params(ref Hashtable kwargs)
    {
        dynamic[] pairs = new dynamic[kwargs.Count];

        var NamedParameter = ObjCreate("NamedParameters");

        int i = 0;
        foreach (DictionaryEntry de in kwargs)
        {
            dynamic[] pair = { de.Key, de.Value };
            pairs[i++] = pair;
        }

        return NamedParameter.create(pairs);
    }

    public const int FLTA_FILES = 1 << 0;
    public const int FLTA_FOLDERS = 1 << 1;
    public const int FLTA_FILESFOLDERS = FLTA_FILES | FLTA_FOLDERS;

    private static List<string> FindFiles(ref string[] parts, string rootPath, int flags, bool relative, int i = 0)
    {
        var matches = new List<string>();

        if ((flags & FLTA_FILESFOLDERS) == 0)
        {
            return matches;
        }

        var last_part = parts.Length - 1;
        var found = false;
        var relindex = rootPath.Length + 1;
        var dir = rootPath;

        for (; i <= last_part; i++)
        {
            found = false;
            var part = parts[i];

            if (
                (i != last_part || (flags & FLTA_FOLDERS) == FLTA_FOLDERS) &&
                part.Contains("?") && part.Contains("*")
            )
            {
                dir = dir + Path.DirectorySeparatorChar + part;
                found = Directory.Exists(dir) || File.Exists(dir);
                if (!found)
                {
                    break;
                }
                continue;
            }

            if (!Directory.Exists(dir))
            {
                break;
            }

            foreach (var path in Directory.GetFileSystemEntries(dir, part))
            {
                var filename = Path.GetFileName(path);
                var filepath = dir + Path.DirectorySeparatorChar + filename;
                var relpath = filepath.Substring(relindex);

                if (i == last_part)
                {
                    bool is_valid = (flags & FLTA_FILESFOLDERS) == FLTA_FILESFOLDERS;
                    if (!is_valid)
                    {
                        is_valid = (flags & FLTA_FILES) == FLTA_FILES && File.Exists(filepath) ||
                            (flags & FLTA_FILES) == FLTA_FOLDERS && Directory.Exists(filepath);
                    }

                    if (is_valid)
                    {
                        matches.Add(relative ? relpath : filepath);
                    }

                    continue;
                }

                var nextMatches = FindFiles(ref parts, filepath, flags, false, i + 1);

                foreach (var match in nextMatches)
                {
                    filepath = match;
                    relpath = filepath.Substring(relindex);
                    matches.Add(relative ? relpath : filepath);
                }
            }

            break;
        }

        if (found)
        {
            var filepath = dir;
            var relpath = filepath.Substring(relindex);

            bool is_valid = (flags & FLTA_FILESFOLDERS) == FLTA_FILESFOLDERS;
            if (!is_valid)
            {
                is_valid = (flags & FLTA_FILES) == FLTA_FILES && File.Exists(filepath) ||
                    (flags & FLTA_FILES) == FLTA_FOLDERS && Directory.Exists(filepath);
            }

            if (is_valid)
            {
                matches.Add(relative ? relpath : filepath);
            }
        }

        return matches;
    }

    public static string NormalizePath(string path)
    {
        var parts = path.Split('/', '\\');
        int end = 0;

        foreach (var part in parts)
        {
            if (string.IsNullOrWhiteSpace(part) || part == ".")
            {
                continue;
            }

            if (part == "..")
            {
                end = Math.Max(0, end - 1);
            }
            else
            {
                parts[end++] = part;
            }
        }

        if (end == 0)
        {
            return "";
        }

        string normalized = parts[0];
        for (int i = 1; i < end; i++)
        {
            normalized += Path.DirectorySeparatorChar + parts[i];
        }

        return normalized;
    }

    public static string[] FindFiles(string path, string rootPath, int flags = FLTA_FILESFOLDERS, bool relative = true)
    {
        var parts = path.Split('/', '\\');
        var files = FindFiles(ref parts, rootPath, flags, relative);
        return files.ToArray();
    }

    public static string FindFile(string path)
    {
        string rootPath = Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location);
        return FindFile(path, rootPath);
    }

    public static string FindFile(string path, string[] hints)
    {
        string rootPath = Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location);
        return FindFile(path, rootPath, hints);
    }

    public static string FindFile(string path, string rootPath, string filter = null)
    {
        return FindFile(path, rootPath, filter, new[] { "." });
    }

    public static string FindFile(string path, string rootPath, string[] hints)
    {
        return FindFile(path, rootPath, "", hints);
    }

    public static string FindFile(string path, string rootPath, string filter, string[] hints)
    {
        string found = "";

        if (string.IsNullOrWhiteSpace(path))
        {
            return found;
        }

        while (true)
        {
            foreach (var search_path in hints)
            {
                if (string.IsNullOrWhiteSpace(search_path))
                {
                    continue;
                }

                var spath = search_path;
                if (!string.IsNullOrWhiteSpace(filter))
                {
                    spath = filter + Path.DirectorySeparatorChar + spath;
                }
                spath += Path.DirectorySeparatorChar + path;

                var matches = FindFiles(NormalizePath(spath), rootPath, FLTA_FILESFOLDERS, false);
                if (matches.Length != 0)
                {
                    return matches[0];
                }
            }

            var parentPath = Directory.GetParent(rootPath);
            if (parentPath == null)
            {
                break;
            }
            rootPath = parentPath.FullName;
        }

        return found;
    }

    public static string FindDLL(string path, string filter = null, string rootPath = null, string buildType = null)
    {
        if (string.IsNullOrWhiteSpace(rootPath)) {
            rootPath = Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location);
        }

        if (string.IsNullOrWhiteSpace(buildType)) {
#if DEBUG
        buildType = "Debug";
#else
        buildType = "Release";
#endif
        }

        if (buildType != "Debug")
        {
            buildType = "Release";
        }

        string postSuffix = buildType == "Debug" ? "d" : "";

        var hints = new List<string>{
            ".",
            "autoit-opencv-com",
            "autoit-opencv-com\\build_x64\\bin\\" + buildType,
            "opencv\\build\\x64\\vc*\\bin",
            "opencv-4.10.0-*\\build\\x64\\vc*\\bin",
            "opencv-4.10.0-*\\opencv\\build\\x64\\vc*\\bin"
        };

        return FindFile(path + postSuffix + ".dll", rootPath, filter, hints.ToArray());
    }
}
