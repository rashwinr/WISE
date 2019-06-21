using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.IO.Ports;

public class Conn : MonoBehaviour
{
    public SerialPort sp1;
    public SerialPort sp2;
    public string Line;
    // Start is called before the first frame update
    void Start()
    {
        sp1 = Initialize("4",4800);
        InvokeRepeating("read", 0.2f, 0.01f);
        //sp2 = Initialize("3",115200);
    }

    // Update is called once per frame
    void Update()
    {
        //read(sp1);
        //read(sp2);
    }

    public SerialPort Initialize(string ComPort, int BaudRate)
    {
        SerialPort sp = new SerialPort("COM" + ComPort, BaudRate); //While enabling also enable OnDiable function
        sp.NewLine = "\n";//",|";
        sp.DtrEnable = true;
        sp.ReadTimeout = 5;
        sp.WriteTimeout = 5;
        sp.Open();
        Debug.Log("Initialized");
        return sp;
    }

    public void read()
    {
        Line = "";
        if (sp1.IsOpen)
        {
            try
            {
                Line = sp1.ReadLine();
                sp1.BaseStream.Flush();
            }
            catch (System.TimeoutException)// ex)
            {
                Debug.Log("Receive Data Error. Read Timeout");// MessageBox.Show(ex.Message, "Receive Data Error. Read Timeout", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        Debug.Log(Line);
    }

    private void OnApplicationQuit()
    {
        sp1.Close();
        //sp2.Close();
    }
}
