using System;
using System.ComponentModel;
using System.IO;
using System.Reflection;
using System.Runtime.InteropServices;

public static class AutoItOpenCV
{
    [DllImport("kernel32.dll")]
    private static extern IntPtr LoadLibrary(string dllToLoad);

    [DllImport("kernel32.dll")]
    private static extern bool FreeLibrary(IntPtr hModule);

    [DllImport("kernel32.dll", CharSet = CharSet.Ansi, SetLastError = true)]
    private static extern IntPtr GetProcAddress(IntPtr hModule, string name);

    private delegate long DllInstall_api(bool bInstall, [In, MarshalAs(UnmanagedType.LPWStr)] string cmdLine);

    private static IntPtr _h_opencv_world_dll = IntPtr.Zero;
    private static IntPtr _h_autoit_opencv_com_dll = IntPtr.Zero;
    private static DllInstall_api DllInstall;

    public static void DllOpen(string opencv_world_dll, string autoit_opencv_com_dll)
    {
        _h_opencv_world_dll = LoadLibrary(opencv_world_dll);
        if (_h_opencv_world_dll == IntPtr.Zero)
        {
            throw new Win32Exception("Failed to load opencv library " + opencv_world_dll);
        }

        _h_autoit_opencv_com_dll = LoadLibrary(autoit_opencv_com_dll);
        if (_h_autoit_opencv_com_dll == IntPtr.Zero)
        {
            throw new Win32Exception("Failed to open autoit com library " + autoit_opencv_com_dll);
        }

        IntPtr DllInstall_addr = GetProcAddress(_h_autoit_opencv_com_dll, "DllInstall");
        if (DllInstall_addr == IntPtr.Zero)
        {
            throw new Win32Exception();
        }

        DllInstall = (DllInstall_api)Marshal.GetDelegateForFunctionPointer(DllInstall_addr, typeof(DllInstall_api));
    }

    public static void DllClose()
    {
        FreeLibrary(_h_autoit_opencv_com_dll);
        FreeLibrary(_h_opencv_world_dll);
    }

    public static void Register(string cmdLine = "user")
    {
        var hr = DllInstall(true, cmdLine);
        if (hr < 0)
        {
            throw new Win32Exception("!>Error: DllInstall " + hr);
        }
    }

    public static void Unregister(string cmdLine = "user")
    {
        var hr = DllInstall(false, cmdLine);
        if (hr < 0)
        {
            throw new Win32Exception("!>Error: DllInstall " + hr);
        }
    }

    public static dynamic ObjCreate(string progID)
    {
        string[] namespaces = { "", "OpenCV.", "OpenCV.cv." };
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

    private static void Example1()
    {
        var cv = ObjCreate("cv");
        if (Object.ReferenceEquals(cv, null))
        {
            return;
        }

        var img = cv.imread(Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location) + "\\..\\..\\..\\samples\\data\\lena.jpg");
        cv.imshow("image", img);
        cv.waitKey();
        cv.destroyAllWindows();
    }

    private static void Example2()
    {
        var cv = ObjCreate("cv");
        if (Object.ReferenceEquals(cv, null))
        {
            return;
        }

        dynamic[] ksize = {5, 5};
        dynamic blurred = null;

        var img = cv.imread(Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location) + "\\..\\..\\..\\samples\\data\\lena.jpg");
        cv.GaussianBlur(img, ksize, 0, ref blurred);
        cv.imshow("image", blurred);
        cv.waitKey();
        cv.destroyAllWindows();
    }

    static void Main()
    {
#if DEBUG
        const string RELEASE_TYPE = "Debug";
        const string DLL_SUFFFIX = "d";
#else
        const string RELEASE_TYPE = "Release";
        const string DLL_SUFFFIX = "";
#endif

        DllOpen(
            Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location) + "\\..\\..\\..\\opencv-4.5.5-vc14_vc15\\opencv\\build\\x64\\vc15\\bin\\opencv_world455" + DLL_SUFFFIX + ".dll",
            Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location) + "\\..\\..\\..\\autoit-opencv-com\\build_x64\\" + RELEASE_TYPE + "\\autoit_opencv_com455" + DLL_SUFFFIX + ".dll"
        );

        Register();

        try
        {
            Example1();
            Example2();
        }
        finally
        {
            Unregister();
            DllClose();
        }
    }

}
