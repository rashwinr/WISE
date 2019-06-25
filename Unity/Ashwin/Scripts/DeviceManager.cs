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
    public Dropdown PatientMenu_Activities;
    public GameObject cam;
    public Dropdown CameraView;
    public Slider[] Sys;
    public Slider[] Acc;
    public Slider[] Gyro;
    public Slider[] Magneto;

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
    public bool pause;
    public Transform[] CameraTransforms;
    public GameObject[] PlayerTexts;
    public bool CameraChangeDone = false;
    public GameObject[] PlayerModels;
    public List<string> ActivitiesNames;
    public List<string> Rec_Activities;
    private RecordActivity RA;
    public Toggle RecordedAct;
    private void Start()
    {
        pause = true;
        RA = GetComponent<RecordActivity>();
        ActivitiesNames = new List<string>();
        Rec_Activities = new List<string>();
        foreach (var Option in Activties.options)
        {
            ActivitiesNames.Add(Option.text);
        }
        RefreshActivities();
        PatientDictionary = new Dictionary<string, string>();
        PatientData = "";
        //Time.timeScale = 0.0f;
        savedDataPath = Application.persistentDataPath + "/savedData";
        Conn = GetComponent<Connection>();
        PatientMenu_Activities.options = Activties.options;
        cam.transform.position = CameraTransforms[CameraView.value].position;
        cam.transform.rotation = CameraTransforms[CameraView.value].rotation;
    }

    public void RefreshActivities()
    {
        RA.GetActivities();
        Rec_Activities.AddRange(RA.ActivityFileNames);
        Activties.ClearOptions();
        Activties.AddOptions(Rec_Activities);
        SetActivities();
    }

    private void Update()
    {
        UpdateCalibration();
    }

    public void SetActivities()
    {
        if (RecordedAct.isOn)
        {
            Activties.ClearOptions();
            Activties.AddOptions(Rec_Activities);
        }
        else
        {
            Activties.ClearOptions();
            Activties.AddOptions(ActivitiesNames);
        }
        PatientMenu_Activities.options = Activties.options;
    }

    public void GameStart()
    {

        pause = false;
        string Time_ = System.DateTime.Now.ToString("_dd_MM_yyyy_HH_mm_ss");

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

        StartTime = Time.realtimeSinceStartup;
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
        pause = true;
    }

    #region MainMenu UI

    public Dropdown TabShift;
    public GameObject[] Tabs;

    public void ChangeCameraView()
    {
        cam.transform.position = CameraTransforms[CameraView.value].position;
        cam.transform.rotation = CameraTransforms[CameraView.value].rotation;
        if(CameraView.value == 0 || CameraView.value == 1)
        {
            PlayerTexts[0].transform.rotation = Quaternion.Euler(0f, CameraView.value * 180.0f, 0f);
            PlayerTexts[1].transform.rotation = Quaternion.Euler(0f, CameraView.value * 180.0f, 0f);
            //Rotating Models when the camera view changes
            PlayerModels[0].transform.rotation = Quaternion.Euler(0f, CameraView.value * -20.0f, 0f);
            PlayerModels[1].transform.rotation = Quaternion.Euler(0f, CameraView.value * 20.0f, 0f);
            PlayerModels[0].transform.localPosition = new Vector3(0.7f, 0.5f, -1.7f);
            PlayerModels[1].transform.localPosition = new Vector3(-3.34f, 0.5f, -1.6f);
        }
        else if(CameraView.value == 2)
        {
            PlayerTexts[0].transform.rotation = Quaternion.Euler(0f, 90.0f, 0f);
            PlayerTexts[1].transform.rotation = Quaternion.Euler(0f, 90.0f, 0f);
            PlayerModels[0].transform.localPosition = new Vector3(0.7f, 0.5f, -3.7f);
            PlayerModels[1].transform.localPosition = new Vector3(-3.34f, 0.5f, -1.6f);
            PlayerTexts[0].transform.rotation = Quaternion.Euler(0f, -90.0f, 0f);
            PlayerTexts[1].transform.rotation = Quaternion.Euler(0f, -90.0f, 0f);
        }
        else if(CameraView.value == 3)
        {
            PlayerTexts[0].transform.rotation = Quaternion.Euler(0f, -90.0f, 0f);
            PlayerTexts[1].transform.rotation = Quaternion.Euler(0f, -90.0f, 0f);
            PlayerModels[0].transform.localPosition = new Vector3(0.7f, 0.5f, -1.7f);
            PlayerModels[1].transform.localPosition = new Vector3(-3.34f, 0.5f, -3.6f);
            PlayerTexts[0].transform.rotation = Quaternion.Euler(0f, 90.0f, 0f);
            PlayerTexts[1].transform.rotation = Quaternion.Euler(0f, 90.0f, 0f);
        }
        
    }
    public void OnActivityChange()
    {
        ActivityChanged = true;
        CameraChangeDone = false;
        if(pause)
        {
            Activties.value = PatientMenu_Activities.value;
        }
        else
        {
            PatientMenu_Activities.value = Activties.value;
        }
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
        for(int i = 0; i < 5; i++)
        {
            Sys[i].value = Conn.Calibrations[i][0] / 3.0f;
            Acc[i].value = Conn.Calibrations[i][1] / 3.0f;
            Gyro[i].value = Conn.Calibrations[i][2] / 3.0f;
            Magneto[i].value = Conn.Calibrations[i][3] / 3.0f;
        }
    
    //    Sys.value = Conn.Calibrations[IMU.value][0] / 3.0f;
    //    Acc.value = Conn.Calibrations[IMU.value][1] / 3.0f;
    //    Gyro.value = Conn.Calibrations[IMU.value][2] / 3.0f;
    //    Magneto.value = Conn.Calibrations[IMU.value][3] / 3.0f;
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
