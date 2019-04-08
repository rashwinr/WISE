using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.IO.Ports;
using UnityEngine.UI;

public class Connection : MonoBehaviour
{
    public SerialPort sp;
    public string Line;
    public int lf;//lift force
    public int gfl;//grasp force left
    public int gfr;//grasp force right
    public string DeviceLocalAngles;

    [SerializeField]
    float[] x;
    [SerializeField]
    float[] y;
    [SerializeField]
    float[] z;
    [SerializeField]
    float[] w;

    [Range(-180f, 180f)]
    public float[] angle_x;
    [Range(-180f, 180f)]
    public float[] angle_y;
    [Range(-180f, 180f)]
    public float[] angle_z;

    public Text[] A;
    public Text[] B;
    public Text[] C;
    public Text[] D;

    Quaternion L_Arm = Quaternion.identity;
    Quaternion L_Forearm = Quaternion.identity;
    Quaternion R_Arm = Quaternion.identity;
    Quaternion R_Forearm = Quaternion.identity;
    Quaternion _Back = Quaternion.identity;

    Quaternion LeftForearm = Quaternion.identity;
    Quaternion rightForearm = Quaternion.identity;
    Quaternion LeftArm = Quaternion.identity;
    Quaternion RightArm = Quaternion.identity;
    Quaternion Back = Quaternion.identity;

    public int no_devices = 5;
    bool[] _device;
    private bool SaveStatics;
    private int timeout = 0;
    public bool start;
    public bool onlyX;
    public bool onlyY;
    public bool onlyZ;
    public string ComPort;
    //public InputField Comport;
    public Text CurrentComText;
    public Text DebugText;
    static float DataSendRate = 100.0f;
    static float TimeTakenforOneMsg = 1.0f / DataSendRate;
    public bool debug = true;
    
    // Use this for initialization
    void Start()
    {
        x = new float[no_devices];
        y = new float[no_devices];
        z = new float[no_devices];
        w = new float[no_devices];

        angle_x = new float[no_devices];
        angle_y = new float[no_devices];
        angle_z = new float[no_devices];

        _device = new bool[no_devices];
        //ComPort = "4";//Default ComPort        
        Initialize();
        //InvokeMultipleStream();
        //Invokeup_date();
        //StartCoroutine("MultipleStream");
        //sp.ReadTimeout = 1;
        //sp.Close();
        //InvokeRepeating("InvokeMultipleStream", 0.1f, 0.01f);
    }

    #region Code Connecting With Arduino

    public List<string> portExists;
    public Dropdown ComPorts;

    public void Scan()
    {
        portExists = new List<string>();
        portExists.AddRange(SerialPort.GetPortNames());
        if (portExists.Count != 0)
        {
            ComPorts.ClearOptions();
            ComPorts.AddOptions(portExists);
        }
        else
        {
            ComPorts.ClearOptions();
            ComPorts.AddOptions(new List<string> { "No Ports" });
        }
    }

    public void Initialize()
    {
        Scan();
        
        if (portExists.Count != 0)
        {
            sp = new SerialPort(portExists[ComPorts.value], 115200);
            //sp = new SerialPort("COM" + ComPort, 115200); //While enabling also enable OnDiable function
            sp.NewLine = "\n";//",|";
            sp.DtrEnable = true;
            sp.ReadTimeout = 10;//25 for query
            sp.WriteTimeout = 5;
            try
            {
                sp.Open();
            }
            catch (System.Exception)
            {
                Verbose_Logging("No Device Conneced to that COM Port");
            }
            CurrentComText.text = ComPort;
            Verbose_Logging("Initialized " + portExists[ComPorts.value]);
        }
    }

    private void OnDisable()
    {
        if (sp != null)
        {
            sp.Close();
        }
        else
        {
            Debug.Log("COM Port Does Not Exist");
            //Verbose_Logging("COM Port Does Not Exist");
        }
    }

    private void OnApplicationQuit()
    {
        if (sp != null)
        {
            sp.Close();
        }
    }
    #endregion

    #region Code for Data Streaming and Parsing
    
    void Invokeup_date()
    {

        if (start)
        {
            LeftForearm = new Quaternion(x[0], y[0], z[0], w[0]);           //   A IMU
            rightForearm = new Quaternion(x[1], y[1], z[1], w[1]);          //   B IMU
            LeftArm = new Quaternion(x[2], y[2], z[2], w[2]);               //   C IMU
            RightArm = new Quaternion(x[3], y[3], z[3], w[3]);              //   D IMU
            Back = new Quaternion(x[4], y[4], z[4], w[4]);              //   E IMU

            Back = Rotatequat(Back);
            //LeftArm = LeftArm * L_Arm;//C Testing
            //RightArm = RightArm * R_Arm;//D Testing
            //LeftForearm = LeftForearm * L_Forearm;//A Testing
            //rightForearm = rightForearm * R_Forearm;//B 
            LeftForearm = Quaternion.Inverse(LeftArm) * LeftForearm;
            LeftArm = Quaternion.Inverse(Back) * LeftArm;
            rightForearm = Quaternion.Inverse(RightArm) * rightForearm;
            RightArm = Quaternion.Inverse(Back) * RightArm;
            //rightForearm =   Quaternion.Inverse(RightArm)* rightForearm;

            if (onlyX)
            {
                angle_x = new float[] { quat2eul(LeftForearm).x, quat2eul(rightForearm).x, quat2eul(LeftArm).x, quat2eul(RightArm).x, quat2eul(Back).x };
                for (int i = 0; i < angle_x.Length; i++)
                {
                    if (angle_x[i] > 180.0f)
                    {
                        angle_x[i] = angle_x[i] - 360.0f;
                    }
                }
                A[0].text = angle_x[0].ToString("F2");
                B[0].text = angle_x[1].ToString("F2");
                C[0].text = angle_x[2].ToString("F2");
                D[0].text = angle_x[3].ToString("F2");
            }
            if (onlyY)
            {
                angle_y = new float[] { quat2eul(LeftForearm).y, quat2eul(rightForearm).y, quat2eul(LeftArm).y, quat2eul(RightArm).y, quat2eul(Back).y };
                for (int i = 0; i < angle_y.Length; i++)
                {
                    if (angle_y[i] > 180.0f)
                    {
                        angle_y[i] = angle_y[i] - 360.0f;
                    }
                }
                A[1].text = angle_y[0].ToString("F2");
                B[1].text = angle_y[1].ToString("F2");
                C[1].text = angle_y[2].ToString("F2");
                D[1].text = angle_y[3].ToString("F2");
            }
            if (onlyZ)
            {
                angle_z = new float[] { quat2eul(LeftForearm).z, quat2eul(rightForearm).z, quat2eul(LeftArm).z, quat2eul(RightArm).z, quat2eul(Back).z };
                for (int i = 0; i < angle_z.Length; i++)
                {
                    if (angle_z[i] > 180.0f)
                    {
                        angle_z[i] =  angle_z[i] - 360.0f;
                    }
                }
                A[2].text = angle_z[0].ToString("F2");
                B[2].text = angle_z[1].ToString("F2");
                C[2].text = angle_z[2].ToString("F2");
                D[2].text = angle_z[3].ToString("F2");
            }
            //angle_x = new float[] { LeftForearm.eulerAngles.x, rightForearm.eulerAngles.x, LeftArm.eulerAngles.x, RightArm.eulerAngles.x };
            //angle_y = new float[] { LeftForearm.eulerAngles.y, rightForearm.eulerAngles.y, LeftArm.eulerAngles.y, RightArm.eulerAngles.y };
            //angle_z = new float[] { LeftForearm.eulerAngles.z, rightForearm.eulerAngles.z, LeftArm.eulerAngles.z, RightArm.eulerAngles.z };
            DeviceLocalAngles = "a" + "," + angle_x[0].ToString("F2") + "," + angle_y[0].ToString("F2") + "," + angle_z[0].ToString("F2") + "," + "b" + "," + angle_x[1].ToString("F2") + "," + angle_y[1].ToString("F2") + "," + angle_z[1].ToString("F2") + "," + "c" + "," + angle_x[2].ToString("F2") + "," + angle_y[2].ToString("F2") + "," + angle_z[2].ToString("F2") + "," + "d" + "," + angle_x[3].ToString("F2") + "," + angle_y[3].ToString("F2") + "," + angle_z[3].ToString("F2") + "," + "e" + "," + angle_x[4].ToString("F2") + "," + angle_y[4].ToString("F2") + "," + angle_z[4].ToString("F2");
        }
    }

    Vector3 quat2eul(Quaternion Q)
    {
        float sinr_cosp = 2.0f * (Q.w * Q.x + Q.y * Q.z);
        float cosr_cosp = 1.0f - (2.0f * (Q.x * Q.x + Q.y * Q.y));
        Vector3 euler = new Vector3();
        euler.x = Mathf.Rad2Deg * Mathf.Atan2(sinr_cosp, cosr_cosp);
        float sinp = 2.0f * (Q.w * Q.y - Q.z * Q.x);
        euler.y = - Mathf.Rad2Deg * Mathf.Asin(sinp);
        float siny_cosp = 2.0f * (Q.w * Q.z + Q.y * Q.x);
        float cosy_cosp = 1.0f -(2.0f * (Q.y * Q.y + Q.z * Q.z));
        euler.z = Mathf.Rad2Deg * Mathf.Atan2(siny_cosp, cosy_cosp);
        return euler;
    }

    Quaternion Rotatequat(Quaternion Q)
    {
        Quaternion Qk = new Quaternion(0, 0, 1, 0);
        Quaternion Qe = Quaternion.identity;
        Quaternion Qz = Q * Qk * Quaternion.Inverse(Q);
        Qz = new Quaternion(Qz.x * Mathf.Sin(Mathf.PI / 4), Qz.y * Mathf.Sin(Mathf.PI / 4), Qz.z * Mathf.Sin(Mathf.PI / 4), Mathf.Cos(Mathf.PI / 4));
        Qe = Qz * Q;
        Quaternion Qi = new Quaternion(1, 0, 0, 0);
        Quaternion Qx = Qe * Qi * Quaternion.Inverse(Qe);
        Qx = new Quaternion(Qx.x * Mathf.Sin(-Mathf.PI / 4), Qx.y * Mathf.Sin(-Mathf.PI / 4), Qx.z * Mathf.Sin(-Mathf.PI / 4), Mathf.Cos(-Mathf.PI / 4));
        Qe = Qx * Qe;
        return Qe;
    }

    public float Hts;//Highest Time Stamp
    void InvokeMultipleStream()
    {
        if (sp != null)
        {
            float ts = 0;
            ts = Time.realtimeSinceStartup;
            Line = "";
            if (ReadFromArduino())
            {
                ParseAngles();
            }
            ts = Time.realtimeSinceStartup - ts;
            if (ts > Hts)
            {
                Hts = ts;
            }
            //Debug.Log(ts.ToString("F4"));
            //Debug.Log("a");
        }
        else
        {
            Verbose_Logging("No Device Connected");
        }
    }

    public void WriteToArduino(string message)
    {
        sp.WriteLine(message);
        sp.BaseStream.Flush();
    }

    public bool ReadFromArduino()
    {
        bool ReadStatus = true;
        if (sp!= null && sp.IsOpen)
        {
            try
            {
                //WriteToArduino("a");
                Line = sp.ReadLine();
                DebugText.text = Line;
                ReadStatus = true;
                timeout = 0;
                sp.BaseStream.Flush();
            }
            catch (System.TimeoutException)// ex)
            {
                //ts = Time.realtimeSinceStartup - ts;
                timeout = timeout + 1;
                Verbose_Logging("Receive Data Error. Read Timeout");// MessageBox.Show(ex.Message, "Receive Data Error. Read Timeout", MessageBoxButtons.OK, MessageBoxIcon.Error);
                ReadStatus = false;
            }

            if (timeout > 50)
            {
                sp.Close();
                timeout = 0;
            }
        }
        else
        {
            Initialize();
        }
        return ReadStatus;
    }

    public void ParseAngles()
    {
        bool ReadStatus = true;
        //Debug.Log("open");
        // print(Line);
        string[] forces = Line.Split(',');
        if (forces.Length == 5 || forces.Length == 10 || forces.Length == 15 || forces.Length == 20)//forces.Length == (no_devices * 5))
        {
            for (int i = 0; i < forces.Length; i++)
            {
                if (forces[i] == "")
                {
                    ReadStatus = false;
                }
            }
            if (ReadStatus)
            {
                try
                {
                    for (int i = 0; i < forces.Length / 5; i++)//no_devices; i++)
                    {
                        Verbose_Logging("Got Data");
                        switch (forces[i * 5])//5 i the number of elements in a data set. a,w,x,y,z
                        {
                            case "a":
                                w[0] = (float.Parse(forces[(5 * i) + 1]) * 2.0f / 999.0f) - 1.0f;
                                x[0] = (float.Parse(forces[(5 * i) + 2]) * 2.0f / 999.0f) - 1.0f;
                                y[0] = (float.Parse(forces[(5 * i) + 3]) * 2.0f / 999.0f) - 1.0f;
                                z[0] = (float.Parse(forces[(5 * i) + 4]) * 2.0f / 999.0f) - 1.0f;
                                if (!_device[0])
                                {
                                    L_Forearm = new Quaternion(x[0], y[0], z[0], w[0]);
                                    //L_Forearm = Quaternion.Normalize(L_Forearm);
                                    L_Forearm = Quaternion.Inverse(L_Forearm);
                                    Verbose_Logging(L_Forearm + " A");// Device A
                                    _device[0] = true;
                                }
                                break;
                            case "b":
                                w[1] = (float.Parse(forces[(5 * i) + 1]) * 2.0f / 999.0f) - 1.0f;
                                x[1] = (float.Parse(forces[(5 * i) + 2]) * 2.0f / 999.0f) - 1.0f;
                                y[1] = (float.Parse(forces[(5 * i) + 3]) * 2.0f / 999.0f) - 1.0f;
                                z[1] = (float.Parse(forces[(5 * i) + 4]) * 2.0f / 999.0f) - 1.0f;
                                if (!_device[1])
                                {
                                    R_Forearm = new Quaternion(x[1], y[1], z[1], w[1]);
                                    R_Forearm = Quaternion.Inverse(R_Forearm);
                                    Verbose_Logging(R_Forearm + " B");// Device B
                                    _device[1] = true;
                                }
                                break;
                            case "c":
                                w[2] = (float.Parse(forces[(5 * i) + 1]) * 2.0f / 999.0f) - 1.0f;
                                x[2] = (float.Parse(forces[(5 * i) + 2]) * 2.0f / 999.0f) - 1.0f;
                                y[2] = (float.Parse(forces[(5 * i) + 3]) * 2.0f / 999.0f) - 1.0f;
                                z[2] = (float.Parse(forces[(5 * i) + 4]) * 2.0f / 999.0f) - 1.0f;
                                if (!_device[2])
                                {
                                    L_Arm = new Quaternion(x[2], y[2], z[2], w[2]);
                                   // L_Arm = Quaternion.Normalize(L_Arm);
                                    //Debug.Log(L_Arm);//Device C
                                    L_Arm = Quaternion.Inverse(L_Arm);
                                    Verbose_Logging(L_Arm + " C");// Device C
                                    _device[2] = true;
                                }
                                break;
                            case "d":
                                w[3] = (float.Parse(forces[(5 * i) + 1]) * 2.0f / 999.0f) - 1.0f;
                                x[3] = (float.Parse(forces[(5 * i) + 2]) * 2.0f / 999.0f) - 1.0f;
                                y[3] = (float.Parse(forces[(5 * i) + 3]) * 2.0f / 999.0f) - 1.0f;
                                z[3] = (float.Parse(forces[(5 * i) + 4]) * 2.0f / 999.0f) - 1.0f;
                                if (!_device[3])
                                {
                                    R_Arm = new Quaternion(x[3], y[3], z[3], w[3]);
                                    R_Arm = Quaternion.Inverse(R_Arm);
                                    Verbose_Logging(R_Arm + " D");// Device D
                                    _device[3] = true;
                                }
                                break;
                            case "e":
                                w[4] = (float.Parse(forces[(5 * i) + 1]) * 2.0f / 999.0f) - 1.0f;
                                x[4] = (float.Parse(forces[(5 * i) + 2]) * 2.0f / 999.0f) - 1.0f;
                                y[4] = (float.Parse(forces[(5 * i) + 3]) * 2.0f / 999.0f) - 1.0f;
                                z[4] = (float.Parse(forces[(5 * i) + 4]) * 2.0f / 999.0f) - 1.0f;
                                if (!_device[3])
                                {
                                    _Back = new Quaternion(x[4], y[4], z[4], w[4]);
                                    _Back = Quaternion.Inverse(_Back);
                                    Verbose_Logging(R_Arm + " E");// Device E
                                    _device[4] = true;
                                }
                                break;
                            default:
                                break;
                        }
                        //Save_Statics();
                    }
                }
                catch (System.FormatException)
                {
                    Verbose_Logging("Format Error");
                }

            }
        }
        else
        {
            //Debug.Log(Line);
        }
    }
    #endregion

    #region Buttons
    public void Save_Statics()
    {
        start = true;
        //DeviceLocalAngles = new List<string>();
        SaveStatics = true;
        InvokeRepeating("InvokeMultipleStream", 0f, TimeTakenforOneMsg);//Remember Invoke doesnt happen when time.timescale is 0
        InvokeRepeating("Invokeup_date", 0f, 0.01f);
        //Remove all the calibration settings
        for (int i = 0; i < no_devices; i++)
        {
            _device[i] = false;
        }
        //StartCoroutine("up_date");
        //StartCoroutine("MultipleStream");
    }

    public void Exit()
    {
        L_Arm = Quaternion.identity;
        L_Forearm = Quaternion.identity;
        R_Arm = Quaternion.identity;
        R_Forearm = Quaternion.identity;
        start = false;
        StopAllCoroutines();
        CancelInvoke();
        //sp.Close();
        //Remove all the calibration settings
        //for(int i = 0; i< no_devices; i++)
        //{
        //    _device[i] = false;
        //}
    }

    public void CloseSerialPort()
    {
        if (sp != null)
        {
            sp.Close();
        }        
    }

    public void GetComPort()
    {
        if (sp != null)
        {
            sp.Close();
        }
        //ComPort = Comport.text;
        Initialize();
    }

    public void Verbose_Logging(string msg)
    {
        if (debug)
        {
            Debug.Log(msg);
            DebugText.text = msg;
        }
    }
    #endregion

    #region Unused Code

    //void Update()
    //{
    //    Shoulder = new Quaternion(x[0], y[0], z[0], w[0]);
    //    Forearm = new Quaternion(x[1], y[1], z[1], w[1]);

    /* Limits of Human Rotation : 
    Shoulder : -10|350 < x < 10 (always changes)(third move) || y = 0 (never changes) || -45|315 < z < 0 (changes sometimes)
    arm : -30|330 < x < 30 (together with shoulder)(second move) || -90|270 < y < 110 (solo) || -45|315 < z < 90(together only if grater than 315)
    Forearm : -30|330 < x < 40 (scale with shoulder complete movement)(first move) || y = 0 || 0 < z < 130
    Actual Forearm Value: -30|330 < x < 40 || y = 0 || 0 < z < 130
    Actual Shoulder : -40|320 < x < 40 || -90|270 < y < 110 || -45|315 < z < 90
    */

    //    Debug.Log(Shoulder.eulerAngles + " " + Forearm.eulerAngles);
    //    NewForearm = Forearm;
    //    NewShoulder = Shoulder;
    //    if(Forearm.eulerAngles.x > 330.0f)
    //    {
    //        NewForearm = Quaternion.Euler(330.0f, Forearm.eulerAngles.y, Forearm.eulerAngles.z);
    //    }
    //    else if(Forearm.eulerAngles.x < 40.0f)
    //    {
    //        NewForearm = Quaternion.Euler(40.0f, Forearm.eulerAngles.y, Forearm.eulerAngles.z);
    //    }

    //    if (Forearm.eulerAngles.y != 0f)
    //    {
    //        NewForearm = Quaternion.Euler(NewForearm.eulerAngles.x , 0f, Forearm.eulerAngles.z);
    //    }

    //    else if (Forearm.eulerAngles.z > 130.0f)
    //    {
    //        NewForearm = Quaternion.Euler(NewForearm.eulerAngles.x, NewForearm.eulerAngles.y, 130.0f);
    //    }
    //    // ----------------------- Shoulder -------------------------------------
    //    if (Shoulder.eulerAngles.x > 320.0f)
    //    {
    //        NewShoulder = Quaternion.Euler(320.0f, Shoulder.eulerAngles.y, Shoulder.eulerAngles.z);
    //    }
    //    else if (Shoulder.eulerAngles.x < 40.0f)
    //    {
    //        NewShoulder = Quaternion.Euler(40.0f, Shoulder.eulerAngles.y, Shoulder.eulerAngles.z);
    //    }

    //    if (Shoulder.eulerAngles.y > 270.0f)
    //    {
    //        NewShoulder = Quaternion.Euler(NewShoulder.eulerAngles.x, 270.0f, Shoulder.eulerAngles.z);
    //    }
    //    else if (Shoulder.eulerAngles.y < 110.0f)
    //    {
    //        NewShoulder = Quaternion.Euler(NewShoulder.eulerAngles.x, 110.0f, Shoulder.eulerAngles.z);
    //    }

    //    if (Shoulder.eulerAngles.z > 315.0f)
    //    {
    //        NewShoulder = Quaternion.Euler(NewShoulder.eulerAngles.x, NewShoulder.eulerAngles.y, 315.0f);
    //    }
    //    else if (Shoulder.eulerAngles.z < 90.0f)
    //    {
    //        NewShoulder = Quaternion.Euler(NewShoulder.eulerAngles.x, NewShoulder.eulerAngles.y, 90.0f);
    //    }
    //    // just for seeing final euler angles
    //    FinalForearm = NewForearm.eulerAngles;
    //    FinalShoulder = NewShoulder.eulerAngles;
    //    // ------------------- Moving Character------------------------------------------
    //    if (Shoulder.eulerAngles.z < 0.0f)
    //    {
    //        Male[0].transform.localRotation = Quaternion.Euler(Male[0].transform.localRotation.x, Male[0].transform.localRotation.y, Shoulder.eulerAngles.z);
    //    }
    //    else
    //    {
    //        Male[0].transform.localRotation = Quaternion.Euler(Male[0].transform.localRotation.x, Male[0].transform.localRotation.y, 0f);
    //    }
    //    Male[1].transform.localRotation = Shoulder;
    //    Male[2].transform.localRotation = Forearm;
    //}

    /* private void Update()
     {
         if (start)
         {
             LeftForearm = new Quaternion(x[0], y[0], z[0], w[0]);
             rightForearm = new Quaternion(x[1], y[1], z[1], w[1]);
             LeftArm = new Quaternion(x[2], y[2], z[2], w[2]);
             RightArm = new Quaternion(x[3], y[3], z[3], w[3]);

             LeftArm = LeftArm * L_Arm;
             RightArm = RightArm * R_Arm;
             LeftForearm = LeftForearm * Quaternion.Inverse(L_Arm);
             rightForearm = rightForearm * Quaternion.Inverse(R_Arm);

             Debug.Log("Calculating");
             angle_x = new float[] { LeftForearm.eulerAngles.x, rightForearm.eulerAngles.x, LeftArm.eulerAngles.x, RightArm.eulerAngles.x };
             angle_y = new float[] { LeftForearm.eulerAngles.y, rightForearm.eulerAngles.y, LeftArm.eulerAngles.y, RightArm.eulerAngles.y };
             angle_z = new float[] { LeftForearm.eulerAngles.z, rightForearm.eulerAngles.z, LeftArm.eulerAngles.z, RightArm.eulerAngles.z };
             DeviceLocalAngles.Add("a" + "," + angle_x[0].ToString("F2") + "," + angle_y[0].ToString("F2") + "," + angle_z[0].ToString("F2") + "," + "b" + "," + angle_x[1].ToString("F2") + "," + angle_y[1].ToString("F2") + "," + angle_z[1].ToString("F2") + "," + "c" + "," + angle_x[2].ToString("F2") + "," + angle_y[2].ToString("F2") + "," + angle_z[2].ToString("F2") + "," + "d" + "," + angle_x[3].ToString("F2") + "," + angle_y[3].ToString("F2") + "," + angle_z[3].ToString("F2"));
         }
     }*/

    IEnumerator up_date()
    {
        while (true)
        {
            if (start)
            {
                LeftForearm = new Quaternion(x[0], y[0], z[0], w[0]);
                rightForearm = new Quaternion(x[1], y[1], z[1], w[1]);
                LeftArm = new Quaternion(x[2], y[2], z[2], w[2]);
                RightArm = new Quaternion(x[3], y[3], z[3], w[3]);

                LeftArm = LeftArm * L_Arm;
                RightArm = RightArm * R_Arm;
                LeftForearm = LeftForearm * Quaternion.Inverse(L_Arm);
                rightForearm = rightForearm * Quaternion.Inverse(R_Arm);

                if (onlyX)
                {
                    angle_x = new float[] { LeftForearm.eulerAngles.x, rightForearm.eulerAngles.x, LeftArm.eulerAngles.x, RightArm.eulerAngles.x };
                    A[0].text = angle_x[2].ToString("F2");
                }
                if (onlyY)
                {
                    angle_y = new float[] { LeftForearm.eulerAngles.y, rightForearm.eulerAngles.y, LeftArm.eulerAngles.y, RightArm.eulerAngles.y };
                    A[1].text = angle_y[2].ToString("F2");
                }
                if (onlyZ)
                {
                    angle_z = new float[] { LeftForearm.eulerAngles.z, rightForearm.eulerAngles.z, LeftArm.eulerAngles.z, RightArm.eulerAngles.z };
                    A[2].text = angle_z[2].ToString("F2");
                }
                //angle_x = new float[] { LeftForearm.eulerAngles.x, rightForearm.eulerAngles.x, LeftArm.eulerAngles.x, RightArm.eulerAngles.x };
                //angle_y = new float[] { LeftForearm.eulerAngles.y, rightForearm.eulerAngles.y, LeftArm.eulerAngles.y, RightArm.eulerAngles.y };
                //angle_z = new float[] { LeftForearm.eulerAngles.z, rightForearm.eulerAngles.z, LeftArm.eulerAngles.z, RightArm.eulerAngles.z };
                DeviceLocalAngles = ("a" + "," + angle_x[0].ToString("F2") + "," + angle_y[0].ToString("F2") + "," + angle_z[0].ToString("F2") + "," + "b" + "," + angle_x[1].ToString("F2") + "," + angle_y[1].ToString("F2") + "," + angle_z[1].ToString("F2") + "," + "c" + "," + angle_x[2].ToString("F2") + "," + angle_y[2].ToString("F2") + "," + angle_z[2].ToString("F2") + "," + "d" + "," + angle_x[3].ToString("F2") + "," + angle_y[3].ToString("F2") + "," + angle_z[3].ToString("F2"));
            }
            yield return new WaitForEndOfFrame();
        }
    }

    IEnumerator Stream()
    {
        while (true)
        {
            sp.BaseStream.Flush();
            Line = "";
            Line = sp.ReadLine();
            // print(Line);
            string[] forces = Line.Split(',');
            bool a = true;

            if (forces.Length == (no_devices * 5))
            {
                for (int i = 0; i < forces.Length; i++)
                {
                    if (forces[i] == "")
                    {
                        a = false;
                    }
                }
                if (a)
                {
                    for (int i = 0; i < no_devices; i++)
                    {

                        w[i] = float.Parse(forces[i + 1]);
                        x[i] = float.Parse(forces[i + 2]);
                        y[i] = float.Parse(forces[i + 4]);
                        z[i] = float.Parse(forces[i + 3]);
                    }
                }
            }
            /*if (sp.IsOpen)
            {
                try
                {
                    sp.ReadTimeout = 2500;
                    sp.WriteTimeout = 2500;
                    Line = sp.ReadTo("\r\n");
                }
                catch (System.TimeoutException ex)
                {
                    Debug.Log("Receive Data Error. Read Timeout");// MessageBox.Show(ex.Message, "Receive Data Error. Read Timeout", MessageBoxButtons.OK, MessageBoxIcon.Error);
                }
                catch { }
            }
            //Line.Trim();//Remove the empty spaces

            string[] forces = Line.Split(',');
            if (forces.Length == 3)
            {
                LF = int.Parse(forces[0]);
                GFL = int.Parse(forces[1]);
                GFR = int.Parse(forces[2]);
                Debug.Log(LF + " " + GFL + " " + GFL);
            }
            sp.Close();*/
            yield return new WaitForSeconds(1 / 1000);
        }

    }

    IEnumerator MultipleStream()
    {
        float ts;
        
        while (true)
        {
            ts = Time.realtimeSinceStartup;
            
            Line = "";
            if (sp.IsOpen)
            {
                bool a = true;
                try
                {
                    WriteToArduino("a");
                    Line = sp.ReadLine();
                    
                    a = true;
                    timeout = 0;
                }
                catch (System.TimeoutException)// ex)
                {
                    timeout = timeout + 1;
                    Debug.Log("Receive Data Error. Read Timeout");// MessageBox.Show(ex.Message, "Receive Data Error. Read Timeout", MessageBoxButtons.OK, MessageBoxIcon.Error);
                    a = false;
                }

                //if (timeout > 50)
                //{
                //    sp.Close();
                //    timeout = 0;
                //    yield return new WaitForSeconds(1 / 100);
                //    sp.Open();
                //}
                if (a)
                {
                    //sp.BaseStream.Flush();                    
                    Debug.Log("open");

                    // print(Line);
                    string[] forces = Line.Split(',');


                    if (forces.Length == 5 || forces.Length == 10 || forces.Length == 15 || forces.Length == 20)//forces.Length == (no_devices * 5))
                    {
                        for (int i = 0; i < forces.Length; i++)
                        {
                            if (forces[i] == "")
                            {
                                a = false;
                            }
                        }
                        if (a)
                        {
                            try
                            {
                                for (int i = 0; i < forces.Length / 5; i++)//no_devices; i++)
                                {

                                    switch (forces[i * 5])
                                    {
                                        case "a":
                                            w[0] = (float.Parse(forces[(5 * i) + 1]) - 100f) / 100f;
                                            x[0] = (float.Parse(forces[(5 * i) + 2]) - 100f) / 100f;
                                            y[0] = (float.Parse(forces[(5 * i) + 4]) - 100f) / 100f;
                                            z[0] = (float.Parse(forces[(5 * i) + 3]) - 100f) / 100f;
                                            break;
                                        case "b":
                                            w[1] = (float.Parse(forces[(5 * i) + 1]) - 100f) / 100f;
                                            x[1] = (float.Parse(forces[(5 * i) + 2]) - 100f) / 100f;
                                            y[1] = (float.Parse(forces[(5 * i) + 4]) - 100f) / 100f;
                                            z[1] = (float.Parse(forces[(5 * i) + 3]) - 100f) / 100f;
                                            break;
                                        case "c":
                                            w[2] = (float.Parse(forces[(5 * i) + 1]) - 100f) / 100f;
                                            x[2] = (float.Parse(forces[(5 * i) + 2]) - 100f) / 100f;
                                            y[2] = (float.Parse(forces[(5 * i) + 4]) - 100f) / 100f;
                                            z[2] = (float.Parse(forces[(5 * i) + 3]) - 100f) / 100f;
                                            break;
                                        case "d":
                                            w[3] = (float.Parse(forces[(5 * i) + 1]) - 100f) / 100f;
                                            x[3] = (float.Parse(forces[(5 * i) + 2]) - 100f) / 100f;
                                            y[3] = (float.Parse(forces[(5 * i) + 4]) - 100f) / 100f;
                                            z[3] = (float.Parse(forces[(5 * i) + 3]) - 100f) / 100f;
                                            break;
                                        default:
                                            break;
                                    }
                                }
                            }
                            catch (System.FormatException)
                            {
                                Debug.Log("Format Error");
                            }
                            if (SaveStatics)
                            {
                                R_Forearm = new Quaternion(x[1], y[1], z[1], w[1]);
                                R_Forearm = Quaternion.Inverse(R_Forearm);
                                R_Arm = new Quaternion(x[3], y[3], z[3], w[3]);
                                R_Arm = Quaternion.Inverse(R_Arm);
                                L_Forearm = new Quaternion(x[0], y[0], z[0], w[0]);
                                L_Forearm = Quaternion.Inverse(L_Forearm);
                                L_Arm = new Quaternion(x[2], y[2], z[2], w[2]);
                                Debug.Log(L_Arm);
                                L_Arm = Quaternion.Inverse(L_Arm);
                                Debug.Log(L_Arm);
                                SaveStatics = false;
                            }
                            //Quaternion LeftForearm = new Quaternion(x[0], y[0], z[0], w[0]);
                            //Quaternion rightForearm = new Quaternion(x[1], y[1], z[1], w[1]);
                            //Quaternion LeftArm = new Quaternion(x[2], y[2], z[2], w[2]);
                            //Quaternion RightArm = new Quaternion(x[3], y[3], z[3], w[3]);

                            //LeftArm = LeftArm * L_Arm;
                            //RightArm = RightArm * R_Arm;
                            //LeftForearm = LeftForearm * Quaternion.Inverse(LeftArm);
                            //rightForearm = rightForearm * Quaternion.Inverse(RightArm);

                            //angle_x = new float[] { LeftForearm.eulerAngles.x, rightForearm.eulerAngles.x, LeftArm.eulerAngles.x, RightArm.eulerAngles.x };
                            //angle_y = new float[] { LeftForearm.eulerAngles.y, rightForearm.eulerAngles.y, LeftArm.eulerAngles.y, RightArm.eulerAngles.y };
                            //angle_z = new float[] { LeftForearm.eulerAngles.z, rightForearm.eulerAngles.z, LeftArm.eulerAngles.z, RightArm.eulerAngles.z };
                        }
                        else
                        {
                            //Debug.Log(Line);
                        }
                    }
                }
                else
                {
                    //yield return new WaitForSecondsRealtime(1.0f);
                }
            }
            ts = Time.realtimeSinceStartup - ts;
            //Debug.Log(ts);
            yield return new WaitForSecondsRealtime(1.0f / 1000.0f);
            //yield return null;

        }

    }

    IEnumerator SingleStream()
    {
        while (true)
        {
            Line = "";
            if (sp.IsOpen)
            {
                bool a = true;
                try
                {
                    sp.ReadTimeout = 50;
                    sp.WriteTimeout = 50;
                    Line = sp.ReadLine();
                    a = true;
                    timeout = 0;
                }
                catch (System.TimeoutException)// ex)
                {
                    timeout = timeout + 1;
                    Debug.Log("Receive Data Error. Read Timeout");// MessageBox.Show(ex.Message, "Receive Data Error. Read Timeout", MessageBoxButtons.OK, MessageBoxIcon.Error);
                    a = false;
                }

                if (timeout > 50)
                {
                    sp.Close();
                    timeout = 0;
                    yield return new WaitForSeconds(1 / 100);
                    sp.Open();
                }
                if (a)
                {
                    sp.BaseStream.Flush();
                    Debug.Log("open");

                    // print(Line);
                    string[] forces = Line.Split(',');


                    if (forces.Length == 5)
                    {
                        for (int i = 0; i < forces.Length; i++)
                        {
                            if (forces[i] == "")
                            {
                                a = false;
                            }
                        }
                        if (a)
                        {
                            try
                            {
                                switch (forces[0])
                                {
                                    case "a":
                                        w[0] = (float.Parse(forces[1]) - 100f) / 100f;
                                        x[0] = (float.Parse(forces[2]) - 100f) / 100f;
                                        y[0] = (float.Parse(forces[4]) - 100f) / 100f;
                                        z[0] = (float.Parse(forces[3]) - 100f) / 100f;
                                        break;
                                    case "b":
                                        w[1] = (float.Parse(forces[1]) - 100f) / 100f;
                                        x[1] = (float.Parse(forces[2]) - 100f) / 100f;
                                        y[1] = (float.Parse(forces[4]) - 100f) / 100f;
                                        z[1] = (float.Parse(forces[3]) - 100f) / 100f;
                                        break;
                                    case "c":
                                        w[2] = (float.Parse(forces[1]) - 100f) / 100f;
                                        x[2] = (float.Parse(forces[2]) - 100f) / 100f;
                                        y[2] = (float.Parse(forces[4]) - 100f) / 100f;
                                        z[2] = (float.Parse(forces[3]) - 100f) / 100f;
                                        break;
                                    case "d":
                                        w[3] = (float.Parse(forces[1]) - 100f) / 100f;
                                        x[3] = (float.Parse(forces[2]) - 100f) / 100f;
                                        y[3] = (float.Parse(forces[4]) - 100f) / 100f;
                                        z[3] = (float.Parse(forces[3]) - 100f) / 100f;
                                        break;
                                    default:
                                        break;
                                }
                            }
                            catch (System.FormatException)
                            {
                                Debug.Log("Format Error");
                            }
                            if (SaveStatics)
                            {
                                R_Forearm = new Quaternion(x[1], y[1], z[1], w[1]);
                                R_Forearm = Quaternion.Inverse(R_Forearm);
                                R_Arm = new Quaternion(x[3], y[3], z[3], w[3]);
                                R_Arm = Quaternion.Inverse(R_Arm);
                                L_Forearm = new Quaternion(x[0], y[0], z[0], w[0]);
                                L_Forearm = Quaternion.Inverse(L_Forearm);
                                L_Arm = new Quaternion(x[2], y[2], z[2], w[2]);
                                L_Arm = Quaternion.Inverse(L_Arm);
                                SaveStatics = false;
                            }

                        }
                    }
                }
            }
            yield return new WaitForSeconds(1 / 10);
            //yield return null;

        }

    }

    /*private void LateUpdate()
    {

        if (start)
        {
            LeftForearm = new Quaternion(x[0], y[0], z[0], w[0]);
            rightForearm = new Quaternion(x[1], y[1], z[1], w[1]);
            LeftArm = new Quaternion(x[2], y[2], z[2], w[2]);
            RightArm = new Quaternion(x[3], y[3], z[3], w[3]);

            LeftArm = LeftArm * L_Arm;
            RightArm = RightArm * R_Arm;
            LeftForearm = LeftForearm * Quaternion.Inverse(L_Arm);
            rightForearm = rightForearm * Quaternion.Inverse(R_Arm);

            if (onlyX)
            {
                angle_x = new float[] { LeftForearm.eulerAngles.x, rightForearm.eulerAngles.x, LeftArm.eulerAngles.x, RightArm.eulerAngles.x };
                A_x.text = angle_x[2].ToString();
            }
            if (onlyY)
            {
                angle_y = new float[] { LeftForearm.eulerAngles.y, rightForearm.eulerAngles.y, LeftArm.eulerAngles.y, RightArm.eulerAngles.y };
                A_y.text = angle_y[2].ToString();
            }
            if (onlyZ)
            {
                angle_z = new float[] { LeftForearm.eulerAngles.z, rightForearm.eulerAngles.z, LeftArm.eulerAngles.z, RightArm.eulerAngles.z };
                A_z.text = angle_z[2].ToString();
            }
            //angle_x = new float[] { LeftForearm.eulerAngles.x, rightForearm.eulerAngles.x, LeftArm.eulerAngles.x, RightArm.eulerAngles.x };
            //angle_y = new float[] { LeftForearm.eulerAngles.y, rightForearm.eulerAngles.y, LeftArm.eulerAngles.y, RightArm.eulerAngles.y };
            //angle_z = new float[] { LeftForearm.eulerAngles.z, rightForearm.eulerAngles.z, LeftArm.eulerAngles.z, RightArm.eulerAngles.z };
            DeviceLocalAngles.Add("a" + "," + angle_x[0].ToString("F2") + "," + angle_y[0].ToString("F2") + "," + angle_z[0].ToString("F2") + "," + "b" + "," + angle_x[1].ToString("F2") + "," + angle_y[1].ToString("F2") + "," + angle_z[1].ToString("F2") + "," + "c" + "," + angle_x[2].ToString("F2") + "," + angle_y[2].ToString("F2") + "," + angle_z[2].ToString("F2") + "," + "d" + "," + angle_x[3].ToString("F2") + "," + angle_y[3].ToString("F2") + "," + angle_z[3].ToString("F2"));
        }
    }
    */

    /*private void FixedUpdate()
    {
        
        if (di == 0)
        {
            if (start)
            {
                InvokeMultipleStream();
            }
            di = 0;
        }
        else
        {
            di += 1;
        }
        
        
    }*/

    /*void SaveStatics_()
    {
        if (savestatics && _device[0] && _device[1] && _device[2] && _device[3])
        {
            savestatics = false;
        }
        quaternion leftforearm = new quaternion(x[0], y[0], z[0], w[0]);
        quaternion
        rightforearm = new quaternion(x[1], y[1], z[1], w[1]);
        quaternion leftarm = new quaternion(x[2], y[2], z[2], w[2]);
        quaternion rightarm = new quaternion(x[3], y[3], z[3], w[3]);

        leftarm = leftarm * l_arm;
        rightarm = rightarm * r_arm;
        leftforearm = leftforearm * quaternion.inverse(leftarm);
        rightforearm = rightforearm * quaternion.inverse(rightarm);

        angle_x = new float[] { leftforearm.eulerangles.x, rightforearm.eulerangles.x, leftarm.eulerangles.x, rightarm.eulerangles.x };
        angle_y = new float[] { leftforearm.eulerangles.y, rightforearm.eulerangles.y, leftarm.eulerangles.y, rightarm.eulerangles.y };
        angle_z = new float[] { leftforearm.eulerangles.z, rightforearm.eulerangles.z, leftarm.eulerangles.z, rightarm.eulerangles.z };
    }*/
    #endregion
}
