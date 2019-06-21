using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.IO.Ports;
using System;
using System.Threading;

public class ArduinoSendRecieve : MonoBehaviour
{
    #region Single Thread
    private SerialPort stream;
    // Start is called before the first frame update
    void Start()
    {
        stream = new SerialPort("COM5", 9600);
        stream.ReadTimeout = 50;
        stream.Open();
    
        WriteToArduino("PING");
        StartCoroutine
        (
            AsynchronousReadFromArduino
            ((string s) => Debug.Log(s),     // Callback
               () => Debug.LogError("Error!"), // Error callback
                10000f                          // Timeout (milliseconds)
            )
        );
    }


    public void WriteToArduino(string message)
    {
        stream.WriteLine(message);
        stream.BaseStream.Flush();
    }

    public void WriteandRead(string message)
    {
        WriteToArduino(message);
        StartCoroutine
        (
            AsynchronousReadFromArduino
            ((string s) => Debug.Log(s),     // Callback
               () => Debug.LogError("Error!"), // Error callback
                10000f                          // Timeout (milliseconds)
            )
        );
    }

    public void OnlyRead()
    {
        StartCoroutine
        (
            AsynchronousReadFromArduino
            ((string s) => Debug.Log(s),     // Callback
               () => Debug.LogError("Error!"), // Error callback
                10000f                          // Timeout (milliseconds)
            )
        );
    }

    public string ReadFromArduino(int timeout = 0)
    {
        stream.ReadTimeout = timeout;
        try
        {
            return stream.ReadLine();
        }
        catch (TimeoutException e)
        {
            return null;
        }
    }

    public IEnumerator AsynchronousReadFromArduino(Action<string> callback, Action fail = null, float timeout = float.PositiveInfinity)
    {
        DateTime initialTime = DateTime.Now;
        DateTime nowTime;
        TimeSpan diff = default(TimeSpan);

        string dataString = null;

        do
        {
            try
            {
                dataString = stream.ReadLine();
            }
            catch (TimeoutException)
            {
                dataString = null;
            }

            if (dataString != null)
            {
                callback(dataString);
                yield break; // Terminates the Coroutine
            }
            else
                yield return null; // Wait for next frame

            nowTime = DateTime.Now;
            diff = nowTime - initialTime;
            
        } while (diff.Milliseconds < timeout);

        if (fail != null)
            fail();
        yield return null;
    }
    #endregion

    #region Multi Thread
    /*
    private Queue outputQueue;  // From Unity to Arduino
    private Queue inputQueue;   // From Arduino to Unity
    private Thread thread;

    public void StartThread()
    {
        outputQueue = Queue.Synchronized(new Queue());
        inputQueue = Queue.Synchronized(new Queue());

        // Creates and starts the thread
        thread = new Thread(ThreadLoop);
        thread.Start();
    }

    public void SendToArduino(string command)
    {
        outputQueue.Enqueue(command);
    }

    public string ReadFromArduino()
    {
        if (inputQueue.Count == 0)
            return null;

        return (string)inputQueue.Dequeue();
    }

    public string port;
    public int baudRate;
    public int timeout;
    public void ThreadLoop()
    {
        // The code of the thread goes here...
        // Opens the connection on the serial port
        stream = new SerialPort(port, baudRate);

        stream.ReadTimeout = 50;
        stream.Open();

        // Looping
        while (true)
        {
            // Send to Arduino
            if (outputQueue.Count != 0)
            {
                string command = outputQueue.Dequeue();
                WriteToArduino(command);
            }

            // Read from Arduino
            string result = ReadFromArduino(timeout);
            if (result != null)
                inputQueue.Enqueue(result);
        }
    }

    public bool looping = true;

    public void StopThread()
    {
        lock (this)
        {
            looping = false;
        }
    }

    public void IsLooping()
    {
        lock (this)
        {
            return looping;
        }
    }

    public void ThreadLoop()
    {
	...

	// Looping
	while (IsLooping())
        {
		...
	}

        // Close the stream
        stream.Close();
    }*/
    #endregion
}

