using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using System.IO;

public class RecordActivity : MonoBehaviour
{
    public Dictionary<string, List<string>> Activity;
    public InputField ActivityName;
    public List<string> ActivityKeys;
    public Quaternion[] Angles;
    private Connection Conn;
    public float TimeTaken;
    public int KeyNo;
    public Transform[] CameraTransforms;
    public GameObject cam;
    public Dropdown CameraView;
    public List<GameObject> ClonedObjects = new List<GameObject>();

    private static string savedActivityPath;
    private static string savedDataPath;

    public bool ver_log;
    // Start is called before the first frame update
    void Start()
    {
        savedActivityPath = Application.persistentDataPath + "/ActivityData";
        savedDataPath = Application.persistentDataPath + "/savedData";
        Conn = GetComponent<Connection>();
        Angles = new Quaternion[Conn.no_devices];
        ActivityKeys = new List<string>();
        Activity = new Dictionary<string, List<string>>();
        KeyNo = 0;
        //setting initial camera position
        cam.transform.position = CameraTransforms[0].position;
        cam.transform.rotation = CameraTransforms[0].rotation;
        GetAllRecordedData();
    }

    #region Recording Activities
    

    public void AddActivity()
    {
        if(ActivityName.text == "")
        {
            ActivityName.text = "Untitled_Activity";
        }

        string Path = savedActivityPath + "/" + ActivityName.text;
        Activity.Add(ActivityName.text, ActivityKeys);
        string Data = "";
        foreach(var Key in ActivityKeys)
        {
            Data += Key + "\n";
        }
        SaveActivity(Path,Data);
        PrintAllActivities();
        KeyNo = 0;
    }

    public void ChangeCameraView()
    {
        cam.transform.position = CameraTransforms[CameraView.value].position;
        cam.transform.rotation = CameraTransforms[CameraView.value].rotation;
    }

    public void AddKey()
    {        
        ActivityKeys.Add(Conn.DeviceLocalAngles);
        KeyNo = KeyNo + 1;
        PrintAllActivityElements(ActivityKeys);
    }

    public void RemoveKey()
    {
        ActivityKeys.RemoveAt(KeyNo-1);
        KeyNo = KeyNo - 1;
    }

    public void PrintAllActivities()
    {
        foreach(var act in Activity)
        {
            Debug.Log(act.Key);
            PrintAllActivityElements(act.Value);
        }
    }

    public void PrintAllActivityElements(List<string> AKeys)
    {
        foreach(var item in AKeys)
        {
            //foreach(var Vec in item)
            //{
                Debug.Log(item);
            //}
        }
    }

    #endregion

    public void PlayActiviy()
    {

    }

    #region Saving Activity
    void SaveActivity(string Path, string Data)
    {
        string DictionaryPath = Path + ".txt";
        if (!File.Exists(DictionaryPath))
        {
            Directory.CreateDirectory(savedActivityPath);
        }
        File.WriteAllText(DictionaryPath, Data);
    }
    #endregion

    #region Displaying Subject Recordings and Activities

    public RectTransform Content;
    public GameObject Item_Prefab;
    public Dropdown Activities;
    public Dropdown Subjects;
    public List<Vector2> ContentSize = new List<Vector2>();
    public List<GameObject> SubjectsUI = new List<GameObject>();

    public string[] ActivityFileNames;//Names of Activities
    public string[] SubjectIDs;//Names of Directories

    void GetActivities()
    {
        if (Directory.Exists(savedActivityPath))
        {
            string[] fileInfo = Directory.GetFiles(savedActivityPath, "*.txt");

            for (int i = 0; i < fileInfo.Length; i++)
            {
                fileInfo[i] = Path.GetFileName(fileInfo[i]);
                if (fileInfo[i] != "")
                {
                    string[] SplitNames = fileInfo[i].Split('.');
                    fileInfo[i] = SplitNames[0];
                }

                if (ver_log)
                {
                    Debug.Log(Path.GetFileName(fileInfo[i]));
                }
            }
            ActivityFileNames = fileInfo;
        }
    }

    void GetSubjects()
    {
        if (Directory.Exists(savedDataPath))
        {
            string[] DirectoryInfo = Directory.GetDirectories(savedDataPath);
            for (int i = 0; i < DirectoryInfo.Length; i++)
            {
                DirectoryInfo[i] = Path.GetFileName(DirectoryInfo[i]);
                if (ver_log)
                {
                    Debug.Log(DirectoryInfo[i]);
                }
            }
            SubjectIDs = DirectoryInfo;
        }
    }

    string[] GetSubjectActivities(string SubjectID)
    {
        
        string[] DirectoryInfo = new string[1];
        if (Directory.Exists(savedDataPath + "/" + SubjectID))
        {
            DirectoryInfo = Directory.GetDirectories(savedDataPath + "/" + SubjectID);
            for (int i = 0; i < DirectoryInfo.Length; i++)
            {
                DirectoryInfo[i] = Path.GetFileName(DirectoryInfo[i]);
                if (ver_log)
                {
                    Debug.Log(DirectoryInfo[i]);
                }
            }
        }
        return DirectoryInfo;
    }

    string[] GetSubjectRecordingTimeStamps(string ActivityName, string SubjectID)
    {
        string[] fileInfo = new string[1];
        
        if (Directory.Exists(savedDataPath + "/" + SubjectID + "/" + ActivityName))
        {
            fileInfo = Directory.GetFiles(savedDataPath + "/" + SubjectID + "/" + ActivityName, "*.txt");
            string[] filePaths = new string[fileInfo.Length*2];
            for (int i = 0; i < fileInfo.Length; i++)
            {
                filePaths[i + fileInfo.Length] = fileInfo[i];
                fileInfo[i] = Path.GetFileName(fileInfo[i]);
                if (fileInfo[i] != "")
                {
                    string[] SplitNames = fileInfo[i].Split('_');
                    string[] TimeStamp = new string[6];

                    for(int j = SplitNames.Length - 6; j < SplitNames.Length; j++)
                    {
                       // Debug.Log(i + SplitNames[i] + SplitNames.Length);
                        TimeStamp[j + 6 - SplitNames.Length] = SplitNames[j];
                        if((j + 6 - SplitNames.Length) == 5)
                        {
                            string[] SplitText = TimeStamp[j + 6 - SplitNames.Length].Split('.');
                            TimeStamp[j + 6 - SplitNames.Length] = SplitText[0];
                        }
                    }
                    
                    fileInfo[i] = TimeStamp[1] + "/" + TimeStamp[0] + "/" + TimeStamp[2] + "  " + TimeStamp[3] + ":" + TimeStamp[4] + ":" + TimeStamp[5];
                    //Debug.Log("Done");
                }

                if (ver_log)
                {
                    Debug.Log(fileInfo[i]);
                }
                //Debug.Log(i + "," + fileInfo.Length + "," + filePaths.Length);
                filePaths[i] = fileInfo[i];
                //Debug.Log(filePaths[i + fileInfo.Length]);
            }
            return filePaths;
        }
        return fileInfo;
    }

    public GameObject EmptyObj;

    void GetAllRecordedData()//Should be called only once at the start of the program
    {
        Activities.ClearOptions();
        Subjects.ClearOptions();
        ContentSize.Clear();
        GetActivities();
        GetSubjects();
        SubjectsUI.Clear();
        List<string> Sub_Act = new List<string>();
        Sub_Act.AddRange(SubjectIDs);
        Subjects.AddOptions(Sub_Act);
        Sub_Act.Clear();

        Sub_Act.AddRange(ActivityFileNames);
        Activities.AddOptions(Sub_Act);
        Subjects.AddOptions(Sub_Act);

        foreach (string SubjectID in SubjectIDs)
        {
            GameObject EmptySubject = Instantiate(EmptyObj, Content);
            EmptySubject.name = SubjectID;
            ClonedObjects.Add(EmptySubject);
            string[] SubjectActivities;//Names of Directories of Activitiesz    
            SubjectActivities = GetSubjectActivities(SubjectID);
            float TempSize = 0f;
            foreach (string Activity in SubjectActivities)
            {
                string[] SubjectRecordingTimeStamps;//Names of Recording Files Time Stamps of Subject Activities
                SubjectRecordingTimeStamps = GetSubjectRecordingTimeStamps(Activity, SubjectID);
                
                for (int i = 0; i < SubjectRecordingTimeStamps.Length/2; i++)
                {
                    //Debug.Log("Done");

                    
                    GameObject Clone = Instantiate(Item_Prefab, EmptySubject.transform);
                    ClonedObjects.Add(Clone);
                    RectTransform CloneTransform = Clone.GetComponent<RectTransform>();
                    CloneTransform.localPosition = new Vector3(-6.1f, (-42.0f - (110.0f * i))-TempSize, 0f);
                    SetupAndLoadData CloneSLD = Clone.GetComponent<SetupAndLoadData>();
                    CloneSLD.TimeStamp = SubjectRecordingTimeStamps[i];
                    CloneSLD.ActivityName = Activity;
                    CloneSLD.Path = SubjectRecordingTimeStamps[i + (SubjectRecordingTimeStamps.Length/2)];
                    CloneSLD.LoadingTextReferenceDataDone();
                }
                TempSize += (SubjectRecordingTimeStamps.Length / 2) * 110.0f;
            }
            if (TempSize > 580.0f)
            {
                ContentSize.Add(new Vector2(Content.sizeDelta.x, TempSize));
            }
            else
            {
                ContentSize.Add(new Vector2(Content.sizeDelta.x, 580.0f));
            }
            SubjectsUI.Add(EmptySubject);
            DisableAllContent();
        }
    }

    public void RefreshFiles()
    {
        DeleteAllClonedObjects();
        GetAllRecordedData();
    }

    private void DeleteAllClonedObjects()
    {
        foreach(GameObject Clone in ClonedObjects)
        {
            Destroy(Clone);
        }
        ClonedObjects.Clear();
    }

    public void SetContentSize()
    {
        DisableAllContent();
        Content.sizeDelta = ContentSize[Subjects.value];
        SubjectsUI[Subjects.value].SetActive(true);
    }

    public void DisableAllContent()
    {
        foreach(GameObject Subject in SubjectsUI)
        {
            Subject.SetActive(false);
        }
    }
    #endregion
}
