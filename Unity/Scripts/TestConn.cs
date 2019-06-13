using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.IO.Ports;
using UnityEngine.UI;

public class TestConn : MonoBehaviour
{
    #region Declarations
    public SerialPort sp;
    public string Line;
    public int lf;//lift force
    public int gfl;//grasp force left
    public int gfr;//grasp force right
    public List<string> DeviceLocalAngles;

    [SerializeField]
    float[] x;
    [SerializeField]
    float[] y;
    [SerializeField]
    float[] z;
    [SerializeField]
    float[] w;

    [Range(0f, 360f)]
    public float[] angle_x;
    [Range(0f, 360f)]
    public float[] angle_y;
    [Range(0f, 360f)]
    public float[] angle_z;

    public Text A_x;
    public Text A_y;
    public Text A_z;

    Quaternion L_Arm = Quaternion.identity;
    Quaternion L_Forearm = Quaternion.identity;
    Quaternion R_Arm = Quaternion.identity;
    Quaternion R_Forearm = Quaternion.identity;

    Quaternion LeftForearm = Quaternion.identity;
    Quaternion rightForearm = Quaternion.identity;
    Quaternion LeftArm = Quaternion.identity;
    Quaternion RightArm = Quaternion.identity;

    public GameObject[] Male;
    public GameObject[] Female;
    public int no_devices = 4;
    private bool SaveStatics;
    private int timeout = 0;
    public bool start;
    public bool onlyX;
    public bool onlyY;
    public bool onlyZ;

    #endregion

    void Start()
    {
        x = new float[no_devices];
        y = new float[no_devices];
        z = new float[no_devices];
        w = new float[no_devices];

        angle_x = new float[no_devices];
        angle_y = new float[no_devices];
        angle_z = new float[no_devices];

        sp = new SerialPort("COM3", 115200); //While enabling also enable OnDiable function

        sp.Open();
        //InvokeMultipleStream();
        //Invokeup_date();
        //StartCoroutine("MultipleStream");
        //sp.ReadTimeout = 1;
        //sp.Close();
        //InvokeRepeating("InvokeMultipleStream", 0.1f, 0.01f);
    }

    #region Data Recieve Test

    #endregion

    #region Satic Stuff
    private void OnDisable()
    {
        sp.Close();
    }

    public void Save_Statics()
    {
        SaveStatics = true;
        start = true;
        DeviceLocalAngles = new List<string>();
        InvokeRepeating("InvokeMultipleStream", 0f, 0.018f);
        //InvokeRepeating("Invokeup_date", 0.1f, 0.1f);
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
        //StopCoroutine("up_date");
        CancelInvoke();
    }
    #endregion*/

    #region IEnumerator
    IEnumerator MultipleStream()
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

                //if (timeout > 50)
                //{
                //    sp.Close();
                //    timeout = 0;
                //    yield return new WaitForSeconds(1 / 100);
                //    sp.Open();
                //}
                if (a)
                {
                    sp.BaseStream.Flush();
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
                    }
                }
                else
                {
                    yield return new WaitForSecondsRealtime(1.0f);
                }
            }
            yield return new WaitForSecondsRealtime(1.0f / 1000.0f);
            //yield return null;

        }

    }

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
            yield return new WaitForEndOfFrame();
        }
    }
    #endregion
    float ti;
    #region Invoke
    void InvokeMultipleStream()
    {
        Line = "";
        if (sp.IsOpen)
        {
            bool a = true;
            try
            {
                sp.ReadTimeout = 50;
                sp.WriteTimeout = 50;
                ti = Time.realtimeSinceStartup;
                Line = sp.ReadLine();
                ti -= Time.realtimeSinceStartup;
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
                sp.BaseStream.Flush();
                //Debug.Log("open");

                 print(Line);
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
                }
                else
                {
                    //Debug.Log(Line);
                }
            }



        }
        Debug.Log(ti.ToString("F4"));
    }

    void Invokeup_date()
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

    #endregion

    #region Testing
    public void ReadSP()
    {
        InvokeMultipleStream();
    }
    #endregion
}
