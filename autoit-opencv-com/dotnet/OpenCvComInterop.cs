using System;
using System.Collections;
using System.Collections.Generic;
using System.ComponentModel;
using System.IO;
using System.Reflection;
using System.Runtime.InteropServices;
using System.Security.Principal;

public static class OpenCvComInterop
{
    [DllImport("kernel32.dll", CharSet = CharSet.Ansi, SetLastError = true)]
    public static extern IntPtr LoadLibrary(String dllToLoad);

    [DllImport("kernel32.dll", CharSet = CharSet.Ansi, SetLastError = true)]
    public static extern bool FreeLibrary(IntPtr hModule);

    [DllImport("kernel32.dll", CharSet = CharSet.Ansi, SetLastError = true)]
    private static extern IntPtr GetProcAddress(IntPtr hModule, String name);

    private delegate long DllInstall_api(bool bInstall, [In, MarshalAs(UnmanagedType.LPWStr)] String cmdLine);
    private delegate bool DLLActivateActCtx_api();
    private delegate bool DLLDeactivateActCtx_api();

    private static IntPtr hOpenCvWorld = IntPtr.Zero;
    private static IntPtr hOpenCvFfmpeg = IntPtr.Zero;
    private static IntPtr hOpenCvCom = IntPtr.Zero;

    private static DllInstall_api DllInstall;
    private static DLLActivateActCtx_api DLLActivateActCtx_t;
    private static DLLDeactivateActCtx_api DLLDeactivateActCtx_t;

    public static bool IsAdministrator()
    {
        using (WindowsIdentity identity = WindowsIdentity.GetCurrent())
        {
            WindowsPrincipal principal = new WindowsPrincipal(identity);
            return principal.IsInRole(WindowsBuiltInRole.Administrator);
        }
    }

    public static void DllOpen(String openCvWorldDll, String openCvComDll)
    {
        hOpenCvWorld = LoadLibrary(openCvWorldDll);
        if (hOpenCvWorld == IntPtr.Zero)
        {
            throw new Win32Exception("Failed to load opencv library '" + openCvWorldDll + "'");
        }

        var parts = openCvWorldDll.Split(Path.AltDirectorySeparatorChar, Path.DirectorySeparatorChar);
        parts[parts.Length - 1] = "opencv_videoio_ffmpeg470_64.dll";
        var openCvFfmpegDll = String.Join(Path.DirectorySeparatorChar.ToString(), parts);
        hOpenCvFfmpeg = LoadLibrary(openCvFfmpegDll);
        if (hOpenCvFfmpeg == IntPtr.Zero)
        {
            throw new Win32Exception("Failed to load ffmpeg library '" + openCvFfmpegDll + "'");
        }

        hOpenCvCom = LoadLibrary(openCvComDll);
        if (hOpenCvCom == IntPtr.Zero)
        {
            throw new Win32Exception("Failed to open autoit opencv com library '" + openCvComDll + "'");
        }

        IntPtr DllInstall_addr = GetProcAddress(hOpenCvCom, "DllInstall");
        if (DllInstall_addr == IntPtr.Zero)
        {
            throw new Win32Exception("Unable to find DllInstall method");
        }
        DllInstall = (DllInstall_api) Marshal.GetDelegateForFunctionPointer(DllInstall_addr, typeof(DllInstall_api));

        IntPtr DLLActivateActCtx_addr = GetProcAddress(hOpenCvCom, "DLLActivateActCtx");
        if (DLLActivateActCtx_addr == IntPtr.Zero)
        {
            throw new Win32Exception("Unable to find DLLActivateActCtx method");
        }
        DLLActivateActCtx_t = (DLLActivateActCtx_api) Marshal.GetDelegateForFunctionPointer(DLLActivateActCtx_addr, typeof(DLLActivateActCtx_api));

        IntPtr DLLDeactivateActCtx_addr = GetProcAddress(hOpenCvCom, "DLLDeactivateActCtx");
        if (DLLDeactivateActCtx_addr == IntPtr.Zero)
        {
            throw new Win32Exception("Unable to find DLLDeactivateActCtx method");
        }
        DLLDeactivateActCtx_t = (DLLDeactivateActCtx_api) Marshal.GetDelegateForFunctionPointer(DLLDeactivateActCtx_addr, typeof(DLLDeactivateActCtx_api));
    }

    public static void DllClose()
    {
        FreeLibrary(hOpenCvCom);
        FreeLibrary(hOpenCvWorld);
        FreeLibrary(hOpenCvFfmpeg);
    }

    public static bool DLLActivateActCtx()
    {
        return DLLActivateActCtx_t();
    }

    public static bool DLLDeactivateActCtx()
    {
        return DLLDeactivateActCtx_t();
    }

    public static void Register(String cmdLine = "")
    {
        if (String.IsNullOrWhiteSpace(cmdLine) && !IsAdministrator())
        {
            cmdLine = "user";
        }

        var hr = DllInstall(true, cmdLine);
        if (hr < 0)
        {
            throw new Win32Exception("!>Error: DllInstall " + hr);
        }
    }

    public static void Unregister(String cmdLine = "")
    {
        if (String.IsNullOrWhiteSpace(cmdLine) && !IsAdministrator())
        {
            cmdLine = "user";
        }

        var hr = DllInstall(false, cmdLine);
        if (hr < 0)
        {
            throw new Win32Exception("!>Error: DllInstall " + hr);
        }
    }

    public static dynamic ObjCreate(String progID)
    {
        DLLActivateActCtx();

        try {
            String[] namespaces = { "", "OpenCV.", "OpenCV.cv." };
            foreach (String itNamespace in namespaces)
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
            DLLDeactivateActCtx();
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

    private static List<String> FindFiles(ref String[] parts, String rootPath, int flags, bool relative, int i = 0)
    {
        var matches = new List<String>();

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

    public static String NormalizePath(String path)
    {
        var parts = path.Split('/', '\\');
        int end = 0;

        foreach (var part in parts)
        {
            if (String.IsNullOrWhiteSpace(part) || part == ".")
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

        String normalized = parts[0];
        for (int i = 1; i < end; i++)
        {
            normalized += Path.DirectorySeparatorChar + parts[i];
        }

        return normalized;
    }

    public static String[] FindFiles(String path, String rootPath, int flags = FLTA_FILESFOLDERS, bool relative = true)
    {
        var parts = path.Split('/', '\\');
        var files = FindFiles(ref parts, rootPath, flags, relative);
        return files.ToArray();
    }

    public static String FindFile(String path)
    {
        String rootPath = Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location);
        return FindFile(path, rootPath);
    }

    public static String FindFile(String path, String rootPath, String filter = null)
    {
        return FindFile(path, rootPath, filter, new[] { "." });
    }

    public static String FindFile(String path, String rootPath, String[] hints)
    {
        return FindFile(path, rootPath, "", hints);
    }

    public static String FindFile(String path, String rootPath, String filter, String[] hints)
    {
        String found = "";

        if (String.IsNullOrWhiteSpace(path))
        {
            return found;
        }

        while (true)
        {
            foreach (var search_path in hints)
            {
                if (String.IsNullOrWhiteSpace(search_path))
                {
                    continue;
                }

                var spath = search_path;
                if (!String.IsNullOrWhiteSpace(filter))
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

    public static String FindDLL(String path, String filter = null, String rootPath = null, String buildType = null)
    {
        if (String.IsNullOrWhiteSpace(rootPath)) {
            rootPath = Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location);
        }

        if (String.IsNullOrWhiteSpace(buildType)) {
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

        String postSuffix = buildType == "Debug" ? "d" : "";

        var hints = new List<string>{
            ".",
            "autoit-opencv-com",
            "autoit-opencv-com\\build_x64\\bin\\" + buildType,
            "opencv\\build\\x64\\vc*\\bin",
            "opencv-4.7.0-*\\build\\x64\\vc*\\bin",
            "opencv-4.7.0-*\\opencv\\build\\x64\\vc*\\bin"
        };

        return FindFile(path + postSuffix + ".dll", rootPath, filter, hints.ToArray());
    }
}
