using System;
using System.ComponentModel;
using System.Runtime.InteropServices;
using OpenCV.InteropServices;

public static class Test
{
    private static void CompiletimeExample(int cameraId)
    {
        ICv_Object cv = new Cv_Object();

        var cap = cv.VideoCapture[cameraId];
        if (!cap.isOpened())
        {
            throw new Win32Exception("!>Error: cannot open the camera " + cameraId);
        }

        var CAP_FPS = 60;
        var CAP_SPF = 1000 / CAP_FPS;

        cap.set(cv.enums.CAP_PROP_FRAME_WIDTH, 1280);
        cap.set(cv.enums.CAP_PROP_FRAME_HEIGHT, 720);
        cap.set(cv.enums.CAP_PROP_FPS, CAP_FPS);

        var frame = new Cv_Mat_Object();
        dynamic[] point = {10, 30};
        dynamic[] color = {255, 0, 255};

        while (true)
        {
            var start = cv.getTickCount();
            if (cap.read(frame))
            {
                // Flip the image horizontally to give the mirror impression
                var oldframe = frame;
                frame = cv.flip(frame, 1);

                // Memory leak without this
                Marshal.ReleaseComObject(oldframe);
            }
            else
            {
                throw new Win32Exception("!>Error: cannot read the camera " + cameraId);
            }
            var fps = cv.getTickFrequency() / (cv.getTickCount() - start);

            cv.putText(frame, "FPS : " + Math.Round(fps), point, cv.enums.FONT_HERSHEY_PLAIN, 2, color, 3);
            cv.imshow("capture camera", frame);

            var key = cv.waitKey(30);
            if (key == 27 || key == 'q' || key == 'Q')
            {
                break;
            }
        }

        // The program does not terminate without this
        Marshal.ReleaseComObject(frame);
        Marshal.ReleaseComObject(cap);
        Marshal.ReleaseComObject(cv);
    }

    private static void RuntimeExample(int cameraId)
    {
        var cv = OpenCvComInterop.ObjCreate("cv");
        if (ReferenceEquals(cv, null))
        {
            throw new Win32Exception("Failed to create cv object");
        }

        var cap = cv.VideoCapture(cameraId);
        if (!cap.isOpened())
        {
            throw new Win32Exception("!>Error: cannot open the camera " + cameraId);
        }

        var CAP_FPS = 60;
        var CAP_SPF = 1000 / CAP_FPS;

        cap.set(cv.enums.CAP_PROP_FRAME_WIDTH, 1280);
        cap.set(cv.enums.CAP_PROP_FRAME_HEIGHT, 720);
        cap.set(cv.enums.CAP_PROP_FPS, CAP_FPS);

        var frame = OpenCvComInterop.ObjCreate("cv.Mat");
        dynamic[] point = {10, 30};
        dynamic[] color = {255, 0, 255};

        while (true)
        {
            var start = cv.getTickCount();
            if (cap.read(frame))
            {
                // Flip the image horizontally to give the mirror impression
                var oldframe = frame;
                frame = cv.flip(frame, 1);

                // Memory leak without this
                Marshal.ReleaseComObject(oldframe);
            }
            else
            {
                throw new Win32Exception("!>Error: cannot read the camera " + cameraId);
            }
            var fps = cv.getTickFrequency() / (cv.getTickCount() - start);

            cv.putText(frame, "FPS : " + Math.Round(fps), point, cv.enums.FONT_HERSHEY_PLAIN, 2, color, 3);
            cv.imshow("capture camera", frame);

            var key = cv.waitKey(30);
            if (key == 27 || key == 'q' || key == 'Q')
            {
                break;
            }
        }

        // The program does not terminate without this
        Marshal.ReleaseComObject(frame);
        Marshal.ReleaseComObject(cap);
        Marshal.ReleaseComObject(cv);
    }

    static void Main(string[] args)
    {
        string opencv_world_dll = null;
        string opencv_com_dll = null;
        var register = false;
        var unregister = false;
        string buildType = null;
        int cameraId = 0;

        for (int i = 0; i < args.Length; i += 1)
        {
            switch (args[i])
            {

                case "--camera":
                    if (i + 1 == args.Length)
                    {
                        throw new ArgumentException("Unexpected argument " + args[i]);
                    }
                    cameraId = Int32.Parse(args[i + 1]);
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

        if (register)
        {
            OpenCvComInterop.Register();
        }

        OpenCvComInterop.DllActivateManifest();
        try {
            CompiletimeExample(cameraId);
        }
        finally
        {
            OpenCvComInterop.DllDeactivateActCtx();
        }

        try
        {
            RuntimeExample(cameraId);
        }
        finally
        {
            if (unregister)
            {
                OpenCvComInterop.Unregister();
            }
            OpenCvComInterop.DllClose();
        }
    }

}
