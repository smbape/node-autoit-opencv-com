using System;
using System.ComponentModel;
using System.IO;
using System.Reflection;
using System.Runtime.InteropServices;

public static class Test
{
    private static void Example1()
    {
        var cv = OpenCvComInterop.ObjCreate("cv");
        if (Object.ReferenceEquals(cv, null))
        {
            return;
        }

        var img = cv.imread(OpenCvComInterop.FindFile("samples\\data\\lena.jpg"));
        cv.imshow("image", img);
        cv.waitKey();
        cv.destroyAllWindows();
    }

    private static void Example2()
    {
        var cv = OpenCvComInterop.ObjCreate("cv");
        if (Object.ReferenceEquals(cv, null))
        {
            return;
        }

        dynamic[] ksize = { 5, 5 };
        dynamic blurred = null;

        var img = cv.imread(OpenCvComInterop.FindFile("samples\\data\\lena.jpg"));
        cv.GaussianBlur(img, ksize, 0, ref blurred);
        cv.imshow("image", blurred);
        cv.waitKey();
        cv.destroyAllWindows();
    }

    static void Main(String[] args)
    {
        String opencv_world_dll = null;
        String opencv_com_dll = null;
        var register = false;
        var unregister = false;
        String buildType = null;

        for (int i = 0; i < args.Length; i += 1)
        {
            switch (args[i])
            {

                case "--opencv-world-dll":
                    if (i + 1 == args.Length)
                    {
                        throw new ArgumentException("Unexpected argument " + args[i]);
                    }
                    opencv_world_dll = args[i + 1];
                    i += 1;
                    break;

                case "--opencv-com-dll":
                    if (i + 1 == args.Length)
                    {
                        throw new ArgumentException("Unexpected argument " + args[i]);
                    }
                    opencv_com_dll = args[i + 1];
                    i += 1;
                    break;

                case "--build-type":
                    if (i + 1 == args.Length)
                    {
                        throw new ArgumentException("Unexpected argument " + args[i]);
                    }
                    buildType = args[i + 1];
                    i += 1;
                    break;

                case "--register":
                    register = true;
                    break;

                case "--unregister":
                    unregister = true;
                    break;

                default:
                    throw new ArgumentException("Unexpected argument " + args[i]);
            }
        }

        OpenCvComInterop.DllOpen(
            String.IsNullOrWhiteSpace(opencv_world_dll) ? OpenCvComInterop.FindDLL("opencv_world4*", "opencv-4.*\\opencv", null, buildType) : opencv_world_dll,
            String.IsNullOrWhiteSpace(opencv_com_dll) ? OpenCvComInterop.FindDLL("autoit_opencv_com4*", null, null, buildType) : opencv_com_dll
        );

        if (register) {
            OpenCvComInterop.Register();
        }

        try
        {
            Example1();
            Example2();
        }
        finally
        {
            if (unregister) {
                OpenCvComInterop.Unregister();
            }
            OpenCvComInterop.DllClose();
        }
    }

}
