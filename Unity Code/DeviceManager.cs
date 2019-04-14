using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using System.IO;
using UnityEngine.SceneManagement;

public class DeviceManager : MonoBehaviour
{
    public Dropdown Age;
    public Dropdown Gender;
    public Dropdown Difficulty;
    public Dropdown Dexterity;
    public Dropdown Activties;
    public Dropdown IMU;
    public Slider Sys;
    public Slider Acc;
    public Slider Gyro;
    public Slider Magneto;

    public InputField Name;
    public string PatientName;
    public string gender;
    public string dexterity;
    public string difficulty;
    public string age;
    public string CurrentActivity;
    private Dictionary<string, string> PatientDictionary;
    private string PatientData;
    private static string savedDataPath;
    private string dictionaryFullName_P;
    private string PlayerInfo;
    public Text Msg;
    public GameObject UI;
    private Connection Conn;
    float StartTime;
    float CurrTime;
    string LocalAnglesCache;
    public bool ActivityChanged;
    public int SavingIteration;

    private void Start()
    {
        PatientDictionary = new Dictionary<string, string>();
        PatientData = "";
        //Time.timeScale = 0.0f;
        savedDataPath = Application.persistentDataPath + "/savedData";
        Conn = GetComponent<Connection>();
    }

    private void Update()
    {
        UpdateCalibration();
    }

    public void GameStart()
    {
        string Time_ = System.DateTime.Now.ToString("_dd_MM_yyyy_HH_mm_ss");
        StartTime = Time.realtimeSinceStartup;

        PatientName = Name.text;
        gender = Gender.options[Gender.value].text;
        dexterity = Dexterity.options[Dexterity.value].text;
        difficulty = Difficulty.options[Difficulty.value].text;
        age = Age.options[Age.value].text;
        CurrentActivity = Activties.options[Activties.value].text;
        if (PatientName == "")
        {
            PatientName = "Unknown_Subject";
        }
        /*if (Gender.value == 0)
        {
            gender = "Male";
        }
        else
        {
            gender = "Female";
        }
        if (Dexterity.value == 0)
        {
            dexterity = "Left";
        }
        else
        {
            dexterity = "Right";
        }
        switch (Difficulty.value)
        {
            case 0:
                difficulty = "Easy";
                break;
            case 1:
                difficulty = "Intermediate";
                break;
            case 2:
                difficulty = "Hard";
                break;
        }

        switch (Age.value)
        {
            case 0:
                age = "20-30";
                break;
            case 1:
                age = "30-40";
                break;
            case 2:
                age = "40-50";
                break;
            case 3:
                age = "50-60";
                break;
            case 4:
                age = "60+";
                break;
        }*/

        dictionaryFullName_P = savedDataPath + "/" + PatientName + "/" + CurrentActivity + "/" + PatientName + Time_ + ".txt";
        string Patient_Data = age + "," + gender + "," + dexterity + "," + difficulty;
        if (PatientDictionary.ContainsKey(PatientName) == false)
        {
            PatientDictionary.Add(PatientName, Patient_Data);
        }
        UI.SetActive(false);
        //Time.timeScale = 1.0f;
        Conn.Save_Statics();
        SaveEveryIteration(Patient_Data + "\n", true);
        InvokeRepeating("Saving", 0f, 0.01f);
    }

    void Saving()
    {
        if (ActivityChanged)
        {
            SaveEveryIteration(LocalAnglesCache, false);//If Replace is true, it replaces all the data
            LocalAnglesCache = "";
            CurrentActivity = Activties.options[Activties.value].text;
            string Time_ = System.DateTime.Now.ToString("_dd_MM_yyyy_HH_mm_ss");
            string Patient_Data = age + "," + gender + "," + dexterity + "," + difficulty;
            dictionaryFullName_P = savedDataPath + "/" + PatientName + "/" + CurrentActivity + "/" + PatientName + Time_ + ".txt";
            SaveEveryIteration(Patient_Data + "\n", true);
            SavingIteration = 0;
            StartTime = Time.realtimeSinceStartup;
            ActivityChanged = false;
        }
        CurrTime = Time.realtimeSinceStartup - StartTime;
        if (Conn.DeviceLocalAngles != "")
        {
            LocalAnglesCache += Conn.DeviceLocalAngles + "," + CurrTime.ToString("F3") + "\n";
            SavingIteration += 1;
        }

        if (SavingIteration >= 10)
        {
            SavingIteration = 0;
            SaveEveryIteration(LocalAnglesCache, false);//If Replace is true, it replaces all the data
            LocalAnglesCache = "";
        }

    }

    public void End()
    {
        Conn.Exit();
        Tab_Shift();
        //Time.timeScale = 0.0f;
        PatientData = Conn.DeviceLocalAngles;
        //SaveInfo_P();
        //StopAllCoroutines();
        CancelInvoke();
    }

    #region MainMenu UI

    public Dropdown TabShift;
    public GameObject[] Tabs;

    public void OnActivityChange()
    {
        ActivityChanged = true;
    }

    public void NextActivity()
    {
        if (Activties.value != Activties.options.Count - 1)
        {
            Activties.value++;
            OnActivityChange();
        }
    }

    public void PreviousActivity()
    {
        if (Activties.value != 0)
        {
            Activties.value--;
            OnActivityChange();
        }
    }

    public void Tab_Shift()
    {
        DisableAllTabs();
        Tabs[TabShift.value].SetActive(true);
    }

    void DisableAllTabs()
    {
        for (int i = 0; i < Tabs.Length; i++)
        {
            Tabs[i].SetActive(false);
        }
    }

    public void UpdateCalibration()
    {
        Sys.value = Conn.Calibrations[IMU.value][0] / 3.0f;
        Acc.value = Conn.Calibrations[IMU.value][1] / 3.0f;
        Gyro.value = Conn.Calibrations[IMU.value][2] / 3.0f;
        Magneto.value = Conn.Calibrations[IMU.value][3] / 3.0f;
    }
    #endregion

    #region Save and Load
    void LoadInfo_P()
    {
        PatientDictionary = new Dictionary<string, string>();

        // CreateDirectory() checks for existence and 
        // automagically creates the directory if necessary
        Directory.CreateDirectory(savedDataPath + "/" + PatientName + "/" + CurrentActivity);

        string[] filePaths = Directory.GetFiles(savedDataPath + "/" + PatientName + "/" + CurrentActivity, "*.txt");

        // the file is a simple key,value list, one dictionary item per line
        if (File.Exists(dictionaryFullName_P))
        {
            string[] fileContent = File.ReadAllLines(dictionaryFullName_P);
            int i = 0;
            foreach (string line in fileContent)
            {
                if (i == 0)
                {
                    string[] buffer = line.Split(',');
                    if (buffer.Length == 5)
                    {
                        string playerinfo = buffer[1] + buffer[2] + buffer[3] + buffer[4];
                        PatientDictionary.Add(buffer[0], playerinfo);
                    }
                }
                else
                {

                }
                i++;
            }
        }
    }

    //void SaveInfo_P()
    //{
    //    if (!File.Exists(dictionaryFullName_P))
    //    {
    //        Directory.CreateDirectory(savedDataPath + "/" + PatientName + "/" + CurrentActivity);
    //    }
    //        if (PatientDictionary != null)
    //    {
    //        string fileContent = "";

    //        /*foreach (var item in PatientDictionary)
    //        {
    //            fileContent += item.Key + "," + item.Value + "\n";
    //        }*/
    //        fileContent += PatientName + "," + age + "," + gender + "," + dexterity + "," + difficulty + "\n";//First line of file with patient data
    //        foreach (var item in PatientData)
    //        {
    //            fileContent += item + "\n";
    //        }

    //        File.WriteAllText(dictionaryFullName_P, fileContent);
    //    }
    //}

    void SaveEveryIteration(string Data, bool Replace)
    {
        if (!File.Exists(dictionaryFullName_P))
        {
            Directory.CreateDirectory(savedDataPath + "/" + PatientName + "/" + CurrentActivity);
        }

        if (Replace)
        {
            File.WriteAllText(dictionaryFullName_P, Data);
        }
        else
        {
            File.AppendAllText(dictionaryFullName_P, Data);
        }
    }

    //void LoadData_P()
    //{
    //    PatientDictionary = new List<int[]>();

    //    // CreateDirectory() checks for existence and 
    //    // automagically creates the directory if necessary
    //    Directory.CreateDirectory(savedDataPath);

    //    // the file is a simple key,value list, one dictionary item per line
    //    if (File.Exists(dictionaryFullName_P))
    //    {
    //        string[] fileContent = File.ReadAllLines(dictionaryFullName_P);

    //        foreach (string line in fileContent)
    //        {
    //            string[] buffer = line.Split(',');
    //            if (buffer.Length == 3)
    //            {
    //                int[] angles = new int[] { int.Parse(buffer[0]), int.Parse(buffer[1]), int.Parse(buffer[2]) };
    //                PatientDictionary.Add(angles);
    //            }
    //        }
    //    }
    //}

    //void SaveData_P()
    //{
    //    if (PatientDictionary != null)
    //    {
    //        string fileContent = "";

    //        foreach (var item in PatientDictionary)
    //        {
    //            fileContent += item[0] + "," + item[1] + "," + item[2] + "\n";
    //        }

    //        File.WriteAllText(dictionaryFullName_P, fileContent);
    //    }
    //}
    #endregion
    public void Quit()
    {
        Application.Quit();
    }
}
