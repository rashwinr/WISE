using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.IO;
using UnityEngine.UI;

public class Playback : MonoBehaviour
{
    public List<List<Quaternion>> DataCache;
    public List<List<Quaternion>> ActivityCache;// = new List<List<Quaternion>>();
    public List<List<float>> TimeStampCache;
    public List<List<float>> ActivityTimeStampCache;// = new List<List<float>>();
    public int DataCacheToken = 0;
    public string[] patientDetails;
    public List<Quaternion> A_Quat;
    public List<Quaternion> B_Quat;
    public List<Quaternion> C_Quat;
    public List<Quaternion> D_Quat;
    public List<Quaternion> E_Quat;
    public List<float> TimeStamp;
    public int LineCount;
    //public string saveddatapath;
    //public string Filename = "Test2_26_03_2019_12_49_06";
    // Start is called before the first frame update
    void Awake()
    {
        patientDetails = new string[4];
        DataCache = new List<List<Quaternion>>();
        ActivityCache = new List<List<Quaternion>>();
        TimeStampCache = new List<List<float>>();
        ActivityTimeStampCache = new List<List<float>>();
        A_Quat = new List<Quaternion>();
        B_Quat = new List<Quaternion>();
        C_Quat = new List<Quaternion>();
        D_Quat = new List<Quaternion>();
        E_Quat = new List<Quaternion>();
        TimeStamp = new List<float>();
        //LoadFile();
        //saveddatapath = Application.persistentDataPath + "/savedData/Test2/Shoulder Abduction";
    }

    // Update is called once per frame
    public int LoadFile(string FilePath)
    {
        TimeStamp.Clear();
        A_Quat.Clear();
        B_Quat.Clear();
        C_Quat.Clear();
        D_Quat.Clear();
        E_Quat.Clear();
        if (File.Exists(FilePath))
        {
            string[] fileContent = File.ReadAllLines(FilePath);
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
                    //Debug.Log(buffer.Length);
                    if (buffer.Length == 26)
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
                            TimeStamp.Add(float.Parse(buffer[25]));
                            //Debug.Log("Timed");
                            try
                            {
                                for (int j = 0; j < 5; j++)//5 is no_devices
                                {
                                    Quaternion Quat = Quaternion.identity;
                                    switch (buffer[j * 5])//5 is dataset
                                    {
                                        case "a":
                                            Quat = new Quaternion(float.Parse(buffer[2]), float.Parse(buffer[3]), float.Parse(buffer[4]), float.Parse(buffer[1]));
                                            A_Quat.Add(Quat);
                                            break;
                                        case "b":
                                            Quat = new Quaternion(float.Parse(buffer[7]), float.Parse(buffer[8]), float.Parse(buffer[9]), float.Parse(buffer[6]));
                                            B_Quat.Add(Quat);
                                            break;
                                        case "c":
                                            Quat = new Quaternion(float.Parse(buffer[12]), float.Parse(buffer[13]), float.Parse(buffer[14]), float.Parse(buffer[11]));
                                            C_Quat.Add(Quat);
                                            break;
                                        case "d":
                                            Quat = new Quaternion(float.Parse(buffer[17]), float.Parse(buffer[18]), float.Parse(buffer[19]), float.Parse(buffer[16]));
                                            D_Quat.Add(Quat);
                                            break;
                                        case "e":
                                            Quat = new Quaternion(float.Parse(buffer[22]), float.Parse(buffer[23]), float.Parse(buffer[24]), float.Parse(buffer[21]));
                                            E_Quat.Add(Quat);
                                            break;
                                        default:
                                            break;
                                    }

                                    if(Quat.w == 0 && Quat.x == 0 && Quat.y == 0 && Quat.z == 0)
                                    {
                                        Quat = Quaternion.identity;
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

        int token = DataCacheToken;
        DataCache.Add(A_Quat);
        DataCache.Add(B_Quat);
        DataCache.Add(C_Quat);
        DataCache.Add(D_Quat);
        DataCache.Add(E_Quat);
        TimeStampCache.Add(TimeStamp);
        //Debug.Log(TimeStamp.Count);
        DataCacheToken += 5;
        return token;
    }

    public void LoadActivityFile(string ActivityName)
    {
        TimeStamp.Clear();
        A_Quat.Clear();
        B_Quat.Clear();
        C_Quat.Clear();
        D_Quat.Clear();
        E_Quat.Clear();
        string FilePath = Application.persistentDataPath + "/ActivityData/" + ActivityName + ".txt";
        if (File.Exists(FilePath))
        {
            string[] fileContent = File.ReadAllLines(FilePath);
            int i = 0;
            foreach (string line in fileContent)
            {
                string[] buffer = line.Split(',');
                //Debug.Log(line);
                if (buffer.Length == 26)
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
                        TimeStamp.Add(float.Parse(buffer[25]));
                        //Debug.Log("Timed");
                        try
                        {
                            for (int j = 0; j < 5; j++)//5 is no_devices
                            {
                                Quaternion Quat = Quaternion.identity;
                                switch (buffer[j * 5])//5 is dataset
                                {
                                    case "a":
                                        float a = float.Parse(buffer[2]);
                                        Quat = new Quaternion(a, float.Parse(buffer[3]), float.Parse(buffer[4]), float.Parse(buffer[1]));
                                        A_Quat.Add(Quat);
                                        break;
                                    case "b":
                                        Quat = new Quaternion(float.Parse(buffer[7]), float.Parse(buffer[8]), float.Parse(buffer[9]), float.Parse(buffer[6]));
                                        B_Quat.Add(Quat);
                                        break;
                                    case "c":
                                        Quat = new Quaternion(float.Parse(buffer[12]), float.Parse(buffer[13]), float.Parse(buffer[14]), float.Parse(buffer[11]));
                                        C_Quat.Add(Quat);
                                        break;
                                    case "d":
                                        Quat = new Quaternion(float.Parse(buffer[17]), float.Parse(buffer[18]), float.Parse(buffer[19]), float.Parse(buffer[16]));
                                        D_Quat.Add(Quat);
                                        break;
                                    case "e":
                                        Quat = new Quaternion(float.Parse(buffer[22]), float.Parse(buffer[23]), float.Parse(buffer[24]), float.Parse(buffer[21]));
                                        E_Quat.Add(Quat);
                                        break;
                                    default:
                                        break;
                                }
                                if (Quat.w == 0 && Quat.x == 0 && Quat.y == 0 && Quat.z == 0)
                                {
                                    Quat = Quaternion.identity;
                                }

                            }
                        }
                        catch (System.FormatException)
                        {
                            Debug.Log("Format Error");
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
        ActivityCache.Add(A_Quat);
        ActivityCache.Add(B_Quat);
        ActivityCache.Add(C_Quat);
        ActivityCache.Add(D_Quat);
        ActivityCache.Add(E_Quat);
        ActivityTimeStampCache.Add(TimeStamp);
        //Debug.Log(ActivityCache[0][1].x);
    }

}
