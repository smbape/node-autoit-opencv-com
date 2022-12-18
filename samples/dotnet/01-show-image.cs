using System;
using System.ComponentModel;
using System.IO;
using System.Reflection;
using System.Runtime.InteropServices;

public static class Test
{
    private static void Example(String image)
    {
        var cv = OpenCvComInterop.ObjCreate("cv");
        if (Object.ReferenceEquals(cv, null))
        {
            throw new Win32Exception("Failed to create cv object");
        }

        var img = cv.imread(image);
        cv.imshow("image", img);
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
        String image = OpenCvComInterop.FindFile("samples\\data\\lena.jpg");

        for (int i = 0; i < args.Length; i += 1)
        {
            switch (args[i])
            {

                case "--image":
                    if (i + 1 == args.Length)
                    {
                        throw new ArgumentException("Unexpected argument " + args[i]);
                    }
                    image = args[i + 1];
                    i += 1;
                    break;

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
            Example(image);
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
