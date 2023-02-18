using System;
using System.ComponentModel;
using System.Runtime.InteropServices;
using OpenCV.InteropServices;

public static class Test
{
    private static void CompiletimeExample(string image)
    {
        ICv_Object cv = new Cv_Object();
        var img = cv.imread(image);
        var img_grey = cv.cvtColor(img, cv.enums.COLOR_BGR2GRAY);
        cv.threshold(img_grey, 100, 255, cv.enums.THRESH_BINARY);
        var thresh = cv.extended[1];
        var contours = cv.findContours(thresh, cv.enums.RETR_TREE, cv.enums.CHAIN_APPROX_SIMPLE);

        Console.WriteLine($"Found ({contours.Length}) contours");

        dynamic[] color = {0, 0, 255};
        cv.drawContours(img, contours, -1, color, 2);
        cv.imshow("Image", img);
        cv.waitKey();
        cv.destroyAllWindows();
    }

    private static void RuntimeExample(string image)
    {
        var cv = OpenCvComInterop.ObjCreate("cv");
        var img = cv.imread(image);
        var img_grey = cv.cvtColor(img, cv.enums.COLOR_BGR2GRAY);
        cv.threshold(img_grey, 100, 255, cv.enums.THRESH_BINARY);
        var thresh = cv.extended[1];
        var contours = cv.findContours(thresh, cv.enums.RETR_TREE, cv.enums.CHAIN_APPROX_SIMPLE);

        Console.WriteLine($"Found ({contours.Length}) contours");

        dynamic[] color = {0, 0, 255};
        cv.drawContours(img, contours, -1, color, 2);
        cv.imshow("Image", img);
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
        string image = OpenCvComInterop.FindFile("samples\\data\\pic1.png");

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
            string.IsNullOrWhiteSpace(opencv_world_dll) ? OpenCvComInterop.FindDLL("opencv_world470*", null, null, buildType) : opencv_world_dll,
            string.IsNullOrWhiteSpace(opencv_com_dll) ? OpenCvComInterop.FindDLL("autoit_opencv_com470*", null, null, buildType) : opencv_com_dll
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
        {
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
