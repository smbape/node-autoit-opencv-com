using System;
using System.ComponentModel;
using System.Runtime.InteropServices;
using OpenCV.InteropServices;

public struct Optional<T>
{
    private bool? _empty;
    public bool empty
    {
        get { return _empty ?? true; }
        private set { _empty = value; }
    }

    public T value { get; private set; }

    public static implicit operator Optional<T>(T obj)
    {
        var optional = new Optional<T>();
        optional.empty = false;
        optional.value = obj;
        return optional;
    }
}

public class Color
{
}

public static class Test
{

    private static void CompiletimeExample(
        int cameraId,
        Optional<Color> optionalColor = new Optional<Color>(),
        Optional<int> optionalInt = new Optional<int>()
    )
    {
        Color cyan = optionalColor.empty ? new Color() : optionalColor.value;
        if (optionalColor.empty)
        {
            CompiletimeExample(cameraId, cyan);
            return;
        }
        object pArg0 = optionalColor.empty ? System.Reflection.Missing.Value : (object) optionalColor.value;

        IVectorOfChar_Object VectorOfChar = new VectorOfChar_Object();

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
        dynamic[] point = { 10, 30 };
        dynamic[] color = { 255, 0, 255 };

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

        cv.destroyAllWindows();

        // The program does not terminate without this
        Marshal.ReleaseComObject(frame);
        Marshal.ReleaseComObject(cap);
        Marshal.ReleaseComObject(cv);
    }

    private static void CompiletimeExample1()
    {
        ICv_Object cv = new Cv_Object();

        var img = cv.imread(OpenCvComInterop.FindFile("samples\\data\\lena.jpg"));
        cv.imshow("image", img);
        cv.waitKey();
        cv.destroyAllWindows();
    }

    private static void CompiletimeExample2()
    {
        ICv_Object cv = new Cv_Object();

        var img = cv.imread(OpenCvComInterop.FindFile("samples\\data\\lena.jpg"));
        dynamic[] ksize = { 5, 5 };
        dynamic blurred = null;
        cv.gaussianBlur(img, ksize, 0, ref blurred);
        cv.imshow("image", blurred);
        cv.waitKey();
        cv.destroyAllWindows();
    }

    private static void RuntimeExample1()
    {
        var cv = OpenCvComInterop.ObjCreate("cv");
        if (Object.ReferenceEquals(cv, null))
        {
            throw new Win32Exception("Failed to create cv com");
        }

        var img = cv.imread(OpenCvComInterop.FindFile("samples\\data\\lena.jpg"));
        cv.imshow("image", img);
        cv.waitKey();
        cv.destroyAllWindows();
    }

    private static void RuntimeExample2()
    {
        var cv = OpenCvComInterop.ObjCreate("cv");
        if (Object.ReferenceEquals(cv, null))
        {
            throw new Win32Exception("Failed to create cv com");
        }

        dynamic[] ksize = { 5, 5 };
        dynamic blurred = null;

        var img = cv.imread(OpenCvComInterop.FindFile("samples\\data\\lena.jpg"));
        cv.GaussianBlur(img, ksize, 0, ref blurred);
        cv.imshow("image", blurred);
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
            string.IsNullOrWhiteSpace(opencv_world_dll) ? OpenCvComInterop.FindDLL("opencv_world470*", buildType: buildType) : opencv_world_dll,
            string.IsNullOrWhiteSpace(opencv_com_dll) ? OpenCvComInterop.FindDLL("autoit_opencv_com470*", buildType: buildType) : opencv_com_dll
        );

        if (register)
        {
            OpenCvComInterop.Register();
        }

        OpenCvComInterop.DllActivateManifest();
        try {
            CompiletimeExample(0);
            CompiletimeExample1();
            CompiletimeExample2();
        }
        finally
        {
            OpenCvComInterop.DllDeactivateActCtx();
        }

        try
        {
            RuntimeExample1();
            RuntimeExample2();
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
