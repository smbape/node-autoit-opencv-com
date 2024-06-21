using System;
using System.ComponentModel;
using OpenCV.InteropServices;

public static class Test
{
    private static void CompiletimeExample(string image)
    {
        ICv_Object cv = new Cv_Object();

        var img = cv.imread(image);
        cv.imshow("image", img);
        cv.waitKey();
        cv.destroyAllWindows();
    }

    private static void RuntimeExample(string image)
    {
        var cv = OpenCvComInterop.ObjCreate("cv");
        if (ReferenceEquals(cv, null))
        {
            throw new Win32Exception("Failed to create cv object");
        }

        var img = cv.imread(image);
        cv.imshow("image", img);
        cv.waitKey();
        cv.destroyAllWindows();
    }

    static void Main(string[] args)
    {
        string opencv_world_dll = null;
        string opencv_com_dll = null;
        var register = false;
        var unregister = false;
        string buildType = null;
        string image = OpenCvComInterop.FindFile("samples\\data\\lena.jpg", new string[] { "opencv-4.10.0-*\\opencv\\sources" });

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
            string.IsNullOrWhiteSpace(opencv_world_dll) ? OpenCvComInterop.FindDLL("opencv_world4100*", null, null, buildType) : opencv_world_dll,
            string.IsNullOrWhiteSpace(opencv_com_dll) ? OpenCvComInterop.FindDLL("autoit_opencv_com4100*", null, null, buildType) : opencv_com_dll
        );

        if (register) {
            OpenCvComInterop.Register();
        }

        OpenCvComInterop.DllActivateManifest();
        try {
            CompiletimeExample(image);
        }
        finally
        {
            OpenCvComInterop.DllDeactivateActCtx();
        }

        try
        {;
            RuntimeExample(image);
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
