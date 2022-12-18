using System;
using System.ComponentModel;
using System.IO;
using System.Reflection;
using System.Runtime.InteropServices;

public static class Test
{
    private static void Example(String video)
    {
        var cv = OpenCvComInterop.ObjCreate("cv");
        if (Object.ReferenceEquals(cv, null))
        {
            throw new Win32Exception("Failed to create cv object");
        }

        var VideoCapture = OpenCvComInterop.ObjCreate("cv.VideoCapture");
        var cap = VideoCapture.create(video);
        if (!cap.isOpened())
        {
            throw new Win32Exception($"!>Error: cannot open the video file {video}.");
        }

        var frame = OpenCvComInterop.ObjCreate("cv.Mat");

        while (true)
        {
            if (!cap.read(frame))
            {
                Console.WriteLine("!>Error: cannot read the video or end of the video.");
                break;
            }

            cv.imshow("capture video file", frame);
            var key = cv.waitKey(30);
            if (key == 27 || key == 'q' || key == 'Q')
            {
                break;
            }
        }

        // The program does not terminate without this
        Marshal.ReleaseComObject(frame);
        Marshal.ReleaseComObject(cap);
        Marshal.ReleaseComObject(VideoCapture);
        Marshal.ReleaseComObject(cv);
    }

    static void Main(String[] args)
    {
        String opencv_world_dll = null;
        String opencv_com_dll = null;
        var register = false;
        var unregister = false;
        String buildType = null;
        String video = OpenCvComInterop.FindFile("samples\\data\\vtest.avi");

        for (int i = 0; i < args.Length; i += 1)
        {
            switch (args[i])
            {

                case "--video":
                    if (i + 1 == args.Length)
                    {
                        throw new ArgumentException("Unexpected argument " + args[i]);
                    }
                    video = args[i + 1];
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

        if (register)
        {
            OpenCvComInterop.Register();
        }

        try
        {
            Example(video);
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
