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

    public Quaternion LeftForearm = Quaternion.identity;
    public Quaternion rightForearm = Quaternion.identity;
    public Quaternion LeftArm = Quaternion.identity;
    public Quaternion RightArm = Quaternion.identity;
    public Quaternion Back = Quaternion.identity;

    public float[] LeftAngles = new float[5];
    public float[] RightAngles = new float[5];

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

    public List<int[]> Calibrations = new List<int[]>();
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
        for (int i = 0; i < no_devices; i++) {
            Calibrations.Add(new int[] { 0, 0, 0, 0, 0 });
        }
        //InvokeRepeating("InvokeMultipleStream", 5.0f, TimeTakenforOneMsg);//Remember Invoke doesnt happen when time.timescale is 0
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
            Quaternion _Left_Forearm_ = new Quaternion(x[0], y[0], z[0], w[0]);           //   A IMU
            Quaternion _right_Forearm_ = new Quaternion(x[1], y[1], z[1], w[1]);          //   B IMU
            Quaternion _Left_Arm_ = new Quaternion(x[2], y[2], z[2], w[2]);               //   C IMU
            Quaternion _Right_Arm_ = new Quaternion(x[3], y[3], z[3], w[3]);              //   D IMU
            Quaternion _Back_ = new Quaternion(x[4], y[4], z[4], w[4]);              //   E IMU

            // RightAngles = getrightarm(_Back_, Left_Arm, Left_Forearm);
            // LeftAngles = getleftarm(_Back_, Right_Arm, right_Forearm);

            // Quaternion Left_Forearm = new Quaternion(z[0], -x[0], y[0], w[0]);           //   A IMU
            //Quaternion right_Forearm = new Quaternion(z[1], -x[1], y[1], w[1]);          //   B IMU
            //Quaternion Left_Arm = new Quaternion(z[2], -x[2], y[2], w[2]);               //   C IMU
            // Quaternion Right_Arm = new Quaternion(z[3], -x[3], y[3], w[3]);              //   D IMU
            //Quaternion _Back_ = new Quaternion(y[4], -x[4], -z[4], w[4]);              //   E IMU


            //LeftArm = LeftArm * L_Arm;//C Testing
            //RightArm = RightArm * R_Arm;//D Testing
            //LeftForearm = LeftForearm * L_Forearm;//A Testing
            //rightForearm = rightForearm * R_Forearm;//B 

            Quaternion Left_Arm = Quaternion.Inverse(RotateLeftArm(_Back_)) * _Left_Arm_;
            Quaternion Left_Forearm = Quaternion.Inverse(RotateLeftForeArm(_Left_Arm_)) * _Left_Forearm_;
            Quaternion Right_Arm = Quaternion.Inverse(_Back_) * _Right_Arm_;
            //Quaternion right_Forearm = Quaternion.Inverse(_Right_Arm_) * _right_Forearm_;
            Quaternion right_Forearm = Quaternion.Inverse(RotateRightForeArm(_Right_Arm_)) * _right_Forearm_;
            
            //_Back_.ToAngleAxis(out angle, out axis);
            //Back = Quaternion.AngleAxis(angle, new Vector3(axis.x,-axis.z,axis.y));
            Vector3 axis;
            float angle;

            Left_Forearm.ToAngleAxis(out angle, out axis);
            //LeftForearm = Quaternion.AngleAxis(-angle, new Vector3(axis.x, axis.z, axis.y));//Old Design
            LeftForearm = Quaternion.AngleAxis(-angle, new Vector3(-axis.y, axis.z, axis.x));//New Design

            Left_Arm.ToAngleAxis(out angle, out axis);
            //LeftArm = Quaternion.AngleAxis(-angle, new Vector3(axis.x, axis.z, axis.y));//Old Design
            LeftArm = Quaternion.AngleAxis(-angle, new Vector3(-axis.y, axis.x, -axis.z));//New Design

            Right_Arm.ToAngleAxis(out angle, out axis);
            //RightArm = Quaternion.AngleAxis(-angle, new Vector3(axis.x, axis.z, axis.y));//Old Design
            RightArm = Quaternion.AngleAxis(-angle, new Vector3(axis.y, -axis.x, -axis.z));//New Design

            right_Forearm.ToAngleAxis(out angle, out axis);
            //rightForearm = Quaternion.AngleAxis(-angle, new Vector3(axis.x, axis.z, axis.y));//Old Design
            rightForearm = Quaternion.AngleAxis(-angle, new Vector3(axis.y, axis.z, -axis.x));//New Design
            
            //Rotatequat(_Back_).ToAngleAxis(out angle, out axis);
            //Back = Quaternion.AngleAxis(-angle, new Vector3(axis.y, -axis.x, -axis.z));

            Back = BackAdjust(_Back_);
            Back.ToAngleAxis(out angle, out axis);
            Back = Quaternion.AngleAxis(-angle, new Vector3(axis.y, -axis.x, -axis.z));
            //Back = Rotatequat(_Back_); //working solution

            if (onlyX)
            {
                angle_x = new float[] { quat2eul(LeftForearm, 0).x, quat2eul(rightForearm, 1).x, quat2eul(LeftArm, 2).x, quat2eul(RightArm, 3).x, quat2eul(Back, 4).x };
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
                angle_y = new float[] { quat2eul(LeftForearm, 0).y, quat2eul(rightForearm, 1).y, quat2eul(LeftArm, 2).y, quat2eul(RightArm, 3).y, quat2eul(Back, 4).y };
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
                angle_z = new float[] { quat2eul(LeftForearm, 0).z, quat2eul(rightForearm, 1).z, quat2eul(LeftArm, 2).z, quat2eul(RightArm, 3).z, quat2eul(Back, 4).z };
                for (int i = 0; i < angle_z.Length; i++)
                {
                    if (angle_z[i] > 180.0f)
                    {
                        angle_z[i] = angle_z[i] - 360.0f;
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
            //DeviceLocalAngles = "a" + "," + angle_x[0].ToString("F2") + "," + angle_y[0].ToString("F2") + "," + angle_z[0].ToString("F2") + "," + "b" + "," + angle_x[1].ToString("F2") + "," + angle_y[1].ToString("F2") + "," + angle_z[1].ToString("F2") + "," + "c" + "," + angle_x[2].ToString("F2") + "," + angle_y[2].ToString("F2") + "," + angle_z[2].ToString("F2") + "," + "d" + "," + angle_x[3].ToString("F2") + "," + angle_y[3].ToString("F2") + "," + angle_z[3].ToString("F2") + "," + "e" + "," + angle_x[4].ToString("F2") + "," + angle_y[4].ToString("F2") + "," + angle_z[4].ToString("F2");
            DeviceLocalAngles = "a" + "," + LeftForearm.w.ToString("F2") + "," + LeftForearm.x.ToString("F2") + "," + LeftForearm.y.ToString("F2") + "," + LeftForearm.z.ToString("F2") + "," + "b" + "," + rightForearm.w.ToString("F2") + "," + rightForearm.x.ToString("F2") + "," + rightForearm.y.ToString("F2") + "," + rightForearm.z.ToString("F2") + "," + "c" + "," + LeftArm.w.ToString("F2") + "," + LeftArm.x.ToString("F2") + "," + LeftArm.y.ToString("F2") + "," + LeftArm.z.ToString("F2") + "," + "d" + "," + RightArm.w.ToString("F2") + "," + RightArm.x.ToString("F2") + "," + RightArm.y.ToString("F2") + "," + RightArm.z.ToString("F2") + "," + "e" + "," + Back.w.ToString("F2") + "," + Back.x.ToString("F2") + "," + Back.y.ToString("F2") + "," + Back.z.ToString("F2");
        }
    }

    Vector3 quat2eul(Quaternion Q, int Device)
    {
        float sinr_cosp = 2.0f * (Q.w * Q.x + Q.y * Q.z);
        float cosr_cosp = 1.0f - (2.0f * (Q.x * Q.x + Q.y * Q.y));
        Vector3 euler = new Vector3();
        euler.x = Mathf.Rad2Deg * Mathf.Atan2(sinr_cosp, cosr_cosp);

        float sinp = 2.0f * (Q.w * Q.y - Q.z * Q.x);
        euler.y = -Mathf.Rad2Deg * Mathf.Asin(sinp);

        float siny_cosp = 2.0f * (Q.w * Q.z + Q.y * Q.x);
        float cosy_cosp = 1.0f - (2.0f * (Q.y * Q.y + Q.z * Q.z));
        euler.z = Mathf.Rad2Deg * Mathf.Atan2(siny_cosp, cosy_cosp);
        if (float.IsNaN(euler.x) || float.IsNaN(euler.y) || float.IsNaN(euler.z))
        {
            euler.x = angle_x[Device];
            euler.y = angle_y[Device];
            euler.z = angle_z[Device];
        }
        return euler;
    }
    /*
    Vector3 quat2eul(Quaternion Q, int Device)
    {
        float sinr_cosp = 2.0f * (Q.w * Q.x - Q.y * Q.z);
        float cosr_cosp = 1.0f - (2.0f * (Q.x * Q.x + Q.y * Q.y));
        Vector3 euler = new Vector3();
        euler.x = Mathf.Rad2Deg * Mathf.Atan2(sinr_cosp, cosr_cosp);

        float sinp = 2.0f * (Q.w * Q.y + Q.z * Q.x);
        if (Mathf.Abs(sinp) >= 0.99999f)
        {
            euler.y = Mathf.Rad2Deg * Mathf.Sign(sinp) * Mathf.PI / 2;
        }
        if (Mathf.Abs(sinp) < 0.99999f)
        {
            euler.y = Mathf.Rad2Deg * Mathf.Asin(sinp);
        }
        float siny_cosp = 2.0f * (Q.w * Q.z - Q.y * Q.x);
        float cosy_cosp = 1.0f - (2.0f * (Q.y * Q.y + Q.z * Q.z));
        euler.z = Mathf.Rad2Deg * Mathf.Atan2(siny_cosp, cosy_cosp);
        if (float.IsNaN(euler.x) || float.IsNaN(euler.y) || float.IsNaN(euler.z))
        {
            euler.x = angle_x[Device];
            euler.y = angle_y[Device];
            euler.z = angle_z[Device];
        }
        return euler;
    }*/

    float[] getleftarm(Quaternion back, Quaternion arm, Quaternion wrist)
    {
        float[] lefthand = new float[5];
        Quaternion Qi = new Quaternion(1, 0, 0, 0);
        Quaternion Qj = new Quaternion(0, 1, 0, 0);
        Quaternion Qk = new Quaternion(0, 0, 1, 0);

        Quaternion Vxb = back * (Qi * Quaternion.Inverse(back));
        Vector3 IE = new Vector3(Vxb.x, Vxb.y, Vxb.z);//Vxb
        Quaternion Vzb_ = back * (Quaternion.Inverse(Qk) * Quaternion.Inverse(back));
        Vector3 KE = new Vector3(Vzb_.x, Vzb_.y, Vzb_.z);//Vzb_
        Quaternion Vxb_ = Quaternion.Inverse(Vxb);
        Vector3 V_xb_ = new Vector3(Vxb_.x, Vxb_.y, Vxb_.z);//Vxb_
        Quaternion Vyb_ = back * (Quaternion.Inverse(Qj) * Quaternion.Inverse(back));
        Vector3 JE = new Vector3(Vyb_.x, Vyb_.y, Vyb_.z);//Vyb_
        Quaternion Vza = arm * (Qk * Quaternion.Inverse(arm));
        Vector3 V_za = new Vector3(Vza.x, Vza.y, Vza.z);//Vza
        Quaternion Vxa_ = arm * (Quaternion.Inverse(Qi) * Quaternion.Inverse(arm));
        Vector3 IC = new Vector3(Vxa_.x, Vxa_.y, Vxa_.z);//Vxa_
        Quaternion Vzw = wrist * (Qk * Quaternion.Inverse(wrist));
        Vector3 V_zw = new Vector3(Vzw.x, Vzw.y, Vzw.z);//Vzw
        Quaternion Vxw_ = wrist * (Quaternion.Inverse(Qi) * Quaternion.Inverse(wrist));
        Vector3 V_xw_ = new Vector3(Vxw_.x, Vxw_.y, Vxw_.z);//Vxw_

        float[] V = { Vector3.Dot(IC, IE), Vector3.Dot(IC, JE), Vector3.Dot(IC, KE) };


        // shoulder extension flexion
        lefthand[0] = Mathf.Atan2(V[2], V[0]) * Mathf.Rad2Deg;

        // shoulder abduction adduction
        lefthand[1] = Mathf.Atan2(V[1], V[0]) * Mathf.Rad2Deg;

        // shoulder internal external rotation 
        Vector3 A1 = V_za;
        Vector3 A2 = V_xb_ - (Vector3.Dot(V_xb_, IC) * IC);

        if (Vector3.Dot(IC, IE) > 0.9)
        {
            A2 = JE - (Vector3.Dot(JE, IC) * IC);
        }

        lefthand[2] = Mathf.Acos(Vector3.Dot(A1, A2) / A2.magnitude) * Mathf.Rad2Deg;

        // elbow extension flexion
        Vector3 XW = V_xw_- Vector3.Dot(V_xw_, V_za) * V_za;
        lefthand[3] = Mathf.Acos(Vector3.Dot(IC, XW) / XW.magnitude) * Mathf.Rad2Deg;

        // elbow pronation supination
        Vector3 ZWa = V_za - Vector3.Dot(V_za, V_xw_) * V_xw_;
        Vector3 Ref = Vector3.Cross(V_xw_, V_za);
        lefthand[4] = Mathf.Atan2(Vector3.Dot(V_zw,Ref), Vector3.Dot(V_zw, ZWa)) * Mathf.Rad2Deg; 

        return lefthand;
    }

    float[] getrightarm(Quaternion back, Quaternion arm, Quaternion wrist)
    {
        float[] rightarm = new float[5];
        Quaternion Qi = new Quaternion(1, 0, 0, 0);
        Quaternion Qj = new Quaternion(0, 1, 0, 0);
        Quaternion Qk = new Quaternion(0, 0, 1, 0);

        Quaternion Vzb_ = back * (Quaternion.Inverse(Qk) * Quaternion.Inverse(back));
        Vector3 KE = new Vector3(Vzb_.x, Vzb_.y, Vzb_.z);//Vzb_
        Quaternion Vxb = back * (Qi * Quaternion.Inverse(back));
        Vector3 IE = new Vector3(Vxb.x, Vxb.y, Vxb.z);//Vxb        
        Quaternion Vxb_ = Quaternion.Inverse(Vxb);
        Vector3 V_xb_ = new Vector3(Vxb_.x, Vxb_.y, Vxb_.z);//Vxb_
        Quaternion Vyb = back * (Qj * Quaternion.Inverse(back));
        Vector3 JE = new Vector3(Vyb.x, Vyb.y, Vyb.z);//Vyb_
        Quaternion Vza = arm * (Qk * Quaternion.Inverse(arm));
        Vector3 V_za = new Vector3(Vza.x, Vza.y, Vza.z);//Vza
        Quaternion Vxa = arm * (Qi * Quaternion.Inverse(arm));
        Vector3 IC = new Vector3(Vxa.x, Vxa.y, Vxa.z);//Vxa_
        Quaternion Vxa_ = Quaternion.Inverse(Vxa);
        Vector3 V_xa_ = new Vector3(Vxa_.x, Vxa_.y, Vxa_.z);//Vxb_
        Quaternion Vzw = wrist * (Qk * Quaternion.Inverse(wrist));
        Vector3 V_zw = new Vector3(Vzw.x, Vzw.y, Vzw.z);//Vzw
        Quaternion Vxw = wrist * (Quaternion.Inverse(Qi) * Quaternion.Inverse(wrist));
        Vector3 V_xw = new Vector3(Vxw.x, Vxw.y, Vxw.z);//Vxw_

        float[] V = { Vector3.Dot(IC, IE), Vector3.Dot(IC, JE), Vector3.Dot(IC, KE) };


        // shoulder extension flexion
        rightarm[0] = Mathf.Atan2(V[2], V[0]) * Mathf.Rad2Deg;

        // shoulder abduction adduction
        rightarm[1] = Mathf.Atan2(V[1], V[0]) * Mathf.Rad2Deg;

        // shoulder internal external rotation 
        Vector3 A1 = V_za;
        Vector3 A2 = V_xb_ - (Vector3.Dot(V_xb_, IC) * IC);

        if (Vector3.Dot(IC, IE) > 0.9)
        {
            A2 = JE - (Vector3.Dot(JE, IC) * IC);
        }

        rightarm[2] = Mathf.Acos(Vector3.Dot(A1, A2) / A2.magnitude) * Mathf.Rad2Deg;

        // elbow extension flexion
        Vector3 XW = V_xw - Vector3.Dot(V_xw, V_za) * V_za;
        rightarm[3] = Mathf.Acos(Vector3.Dot(IC, XW) / XW.magnitude) * Mathf.Rad2Deg;

        // elbow pronation supination
        Vector3 ZWa = V_za - Vector3.Dot(V_za, V_xw) * V_xw;
        Vector3 Ref = Vector3.Cross(V_xw, V_za);
        rightarm[4] = Mathf.Atan2(Vector3.Dot(V_zw, Ref), Vector3.Dot(V_zw, ZWa)) * Mathf.Rad2Deg;

        return rightarm;
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

    Quaternion BackAdjust(Quaternion Q)
    {
        Quaternion Qe = Quaternion.identity;

        Quaternion Qj = new Quaternion(0, 1, 0, 0);
        Quaternion Qy = Q * Qj * Quaternion.Inverse(Q);
        Vector3 Y = new Vector3(Qy.x, Qy.y, Qy.z);
        float th = -Mathf.Atan2(Y.x,Y.y);
        Quaternion Qref = new Quaternion(0, 0, Mathf.Sin(th / 2), Mathf.Cos(th / 2));

        Qj = new Quaternion(0, 1, 0, 0);
        Qy = Qref * Qj * Quaternion.Inverse(Qref);
        Qy = new Quaternion(Qy.x * Mathf.Sin(Mathf.PI / 4), Qy.y * Mathf.Sin(Mathf.PI / 4), Qy.z * Mathf.Sin(Mathf.PI / 4), Mathf.Cos(Mathf.PI / 4));
        Qref = Qy * Qref;
        Qe = Quaternion.Inverse(Qref) * Q;
        return Qe;
    }

    Quaternion RotateLeftArm(Quaternion Q)
    {
        Quaternion Qk = new Quaternion(0, 0, 1, 0);
        Quaternion Qe = Quaternion.identity;
        Quaternion Qz = Q * Qk * Quaternion.Inverse(Q);
        Qz = new Quaternion(Qz.x * Mathf.Sin(Mathf.PI / 2), Qz.y * Mathf.Sin(Mathf.PI / 2), Qz.z * Mathf.Sin(Mathf.PI / 2), Mathf.Cos(Mathf.PI / 2));
        Qe = Qz * Q;
        return Qe;
    }

    Quaternion RotateLeftForeArm(Quaternion Q)
    {
        Quaternion Qj = new Quaternion(0, 1, 0, 0);
        Quaternion Qe = Quaternion.identity;
        Quaternion Qy = Q * Qj * Quaternion.Inverse(Q);
        Qy = new Quaternion(Qy.x * Mathf.Sin(Mathf.PI / 4), Qy.y * Mathf.Sin(Mathf.PI / 4), Qy.z * Mathf.Sin(Mathf.PI / 4), Mathf.Cos(Mathf.PI / 4));
        Qe = Qy * Q;
        return Qe;
    }

    Quaternion RotateRightForeArm(Quaternion Q)
    {
        Quaternion Qj = new Quaternion(0, -1, 0, 0);
        Quaternion Qe = Quaternion.identity;
        Quaternion Qy = Q * Qj * Quaternion.Inverse(Q);
        Qy = new Quaternion(Qy.x * Mathf.Sin(Mathf.PI / 4), Qy.y * Mathf.Sin(Mathf.PI / 4), Qy.z * Mathf.Sin(Mathf.PI / 4), Mathf.Cos(Mathf.PI / 4));
        Qe = Qy * Q;
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
                                Calibrations[0] = new int[] { 3, 3, 3, 3 };
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
                                Calibrations[1] = new int[] { 3, 3, 3, 3 };
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
                                Calibrations[2] = new int[] { 3, 3, 3, 3 };
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
                                Calibrations[3] = new int[] { 3, 3, 3, 3 };
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
                                Calibrations[4] = new int[] { 3, 3, 3, 3 };
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
        else if (forces.Length == 6)
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
                    if(forces[0] == "cal")
                      Verbose_Logging(" Recieved Calibratoin Data");
                        switch (forces[1])//5 i the number of elements in a data set. a,w,x,y,z
                        {
                            case "a":
                            Calibrations[0] = new int[] { int.Parse(forces[2]), int.Parse(forces[3]), int.Parse(forces[4]), int.Parse(forces[5]) };
                                break;
                            case "b":
                            Calibrations[1] = new int[] { int.Parse(forces[2]), int.Parse(forces[3]), int.Parse(forces[4]), int.Parse(forces[5]) };
                            break;
                            case "c":
                            Calibrations[2] = new int[] { int.Parse(forces[2]), int.Parse(forces[3]), int.Parse(forces[4]), int.Parse(forces[5]) };
                            break;
                            case "d":
                            Calibrations[3] = new int[] { int.Parse(forces[2]), int.Parse(forces[3]), int.Parse(forces[4]), int.Parse(forces[5]) };
                            break;
                            case "e":
                            Calibrations[4] = new int[] { int.Parse(forces[2]), int.Parse(forces[3]), int.Parse(forces[4]), int.Parse(forces[5]) };
                            break;
                            default:
                                break;
                        }
                        //Save_Statics();
                    
                }
                catch (System.FormatException)
                {
                    Verbose_Logging("Format Error");
                }
            }
        }
        else
        {
            Debug.Log("Wrong Data: "+ Line);
        }
    }
    #endregion

    #region Buttons
    public void Save_Statics()
    {
        CancelInvoke();
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
