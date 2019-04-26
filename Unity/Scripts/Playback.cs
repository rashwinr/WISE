using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.IO;
using UnityEngine.UI;

public class Playback : MonoBehaviour
{
    
    public string[] patientDetails;
    public List<Vector3> A_Angles;
    public List<Vector3> B_Angles;
    public List<Vector3> C_Angles;
    public List<Vector3> D_Angles;
    public List<Vector3> E_Angles;
    public List<float> TimeStamp;
    public int LineCount;
    public string saveddatapath;
    public string Filename = "Test2_26_03_2019_12_49_06";
    // Start is called before the first frame update
    void Start()
    {
        patientDetails = new string[4];
        A_Angles = new List<Vector3>();
        B_Angles = new List<Vector3>();
        C_Angles = new List<Vector3>();
        D_Angles = new List<Vector3>();
        E_Angles = new List<Vector3>();
        TimeStamp = new List<float>();
        //LoadFile();
        //saveddatapath = Application.persistentDataPath + "/savedData/Test2/Shoulder Abduction";
    }

    // Update is called once per frame
    public void LoadFile()
    {
        Directory.CreateDirectory(saveddatapath);
        string[] filePaths = Directory.GetFiles(saveddatapath, "*.txt");
        if (File.Exists(saveddatapath + "/" + "/" + Filename + ".txt"))
        {
            string[] fileContent = File.ReadAllLines(saveddatapath + "/" + "/" + Filename + ".txt");
            int i = 0;
            foreach (string line in fileContent)
            {
                if (i == 0)
                {
                    string[] buffer = line.Split(',');
                    if (buffer.Length == 4)
                    {
                        patientDetails = buffer;
                    }
                }
                else
                {
                    string[] buffer = line.Split(',');
                    Debug.Log(buffer.Length);
                    if (buffer.Length == 21)
                    {
                        bool ReadStatus = true;
                        for (int j = 0; j < buffer.Length; j++)
                        {
                            if (buffer[j] == "")
                            {
                                ReadStatus = false;
                            }
                        }
                        if (ReadStatus)
                        {
                            TimeStamp.Add(float.Parse(buffer[20]));
                            Debug.Log("Timed");
                            try
                            {
                                for (int j = 0; j < 5; j++)//5 is no_devices
                                {
                                    Vector3 Angles;
                                    switch (buffer[j * 4])//4 is dataset
                                    {
                                        case "a":
                                            Angles = new Vector3(float.Parse(buffer[1]), float.Parse(buffer[2]), float.Parse(buffer[3]));
                                            A_Angles.Add(Angles);
                                            break;
                                        case "b":
                                            Angles = new Vector3(float.Parse(buffer[5]), float.Parse(buffer[6]), float.Parse(buffer[7]));
                                            B_Angles.Add(Angles);
                                            break;
                                        case "c":
                                            Angles = new Vector3(float.Parse(buffer[9]), float.Parse(buffer[10]), float.Parse(buffer[11]));
                                            C_Angles.Add(Angles);
                                            break;
                                        case "d":
                                            Angles = new Vector3(float.Parse(buffer[13]), float.Parse(buffer[14]), float.Parse(buffer[15]));
                                            D_Angles.Add(Angles);
                                            break;
                                        case "e":
                                            Angles = new Vector3(float.Parse(buffer[17]), float.Parse(buffer[18]), float.Parse(buffer[19]));
                                            E_Angles.Add(Angles);
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
                        }
                    }
                    
                }
                i++;
                LineCount = i;
            }
        }
        else
        {
            Debug.Log("Path Does not exist");
        }
    }
}
