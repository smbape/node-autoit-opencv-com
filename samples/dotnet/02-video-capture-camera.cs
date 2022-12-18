using System;
using System.ComponentModel;
using System.IO;
using System.Reflection;
using System.Runtime.InteropServices;

public static class Test
{
    private static void Example(int cameraId)
    {
        var cv = OpenCvComInterop.ObjCreate("cv");
        if (Object.ReferenceEquals(cv, null))
        {
            throw new Win32Exception("Failed to create cv object");
        }

        var VideoCapture = OpenCvComInterop.ObjCreate("cv.VideoCapture");
        var cap = VideoCapture.create(cameraId);
        if (!cap.isOpened())
        {
            throw new Win32Exception("!>Error: cannot open the camera " + cameraId);
        }

        var frame = OpenCvComInterop.ObjCreate("cv.Mat");

        while (true)
        {
            if (cap.read(frame))
            {
                // Flip the image horizontally to give the mirror impression
                var oldframe = frame;
                frame = cv.flip(frame, 1);
                cv.imshow("capture camera", frame);

                // Memory leak without this
                Marshal.ReleaseComObject(oldframe);
            }
            else
            {
                throw new Win32Exception("!>Error: cannot read the camera " + cameraId);
            }

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
            String.IsNullOrWhiteSpace(opencv_world_dll) ? OpenCvComInterop.FindDLL("opencv_world4*", "opencv-4.*\\opencv", null, buildType) : opencv_world_dll,
            String.IsNullOrWhiteSpace(opencv_com_dll) ? OpenCvComInterop.FindDLL("autoit_opencv_com4*", null, null, buildType) : opencv_com_dll
        );

        if (register)
        {
            OpenCvComInterop.Register();
        }

        try
        {
            Example(cameraId);
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
