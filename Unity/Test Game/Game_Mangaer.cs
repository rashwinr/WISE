using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using System.IO;
using UnityEngine.SceneManagement;

public class Game_Mangaer : MonoBehaviour {
    
    public InputField Name;
    public InputField Username;
    public InputField AccountPassword;
    public InputField MasterPassword;
    public GameObject PatientDetails;
    public Text PatientData;
    public string Master_Password;
    private float msgtimer;
    
    private Dictionary<string, int[]> PatientDictionary;
    private Dictionary<string, string> LoginData;
    private static string savedDataPath;
    private static string dictionaryName_P = "PatientData.txt";
    private static string dictionaryName_I = "InstructorLoginData.txt";
    private static string dictionaryFullName_P;
    private static string dictionaryFullName_I;
    private static string stringCurrentPlayer;

    public Text MainMenuMsg;
    public Text InstructorMsg;
    // Use this for initialization
    void Start () {
        savedDataPath = Application.persistentDataPath + "/savedData";
        dictionaryFullName_P = savedDataPath + "/" + dictionaryName_P;
        dictionaryFullName_I = savedDataPath + "/" + dictionaryName_I;
        stringCurrentPlayer = savedDataPath + "/" + "CurrentPlayer";
        //Debug.Log(dictionaryFullName_I + "\n" + dictionaryFullName_P);
        LoadData_P();
        LoadLoginData();//get saved data
        PrintDictionary();
        Time.timeScale = 1;
	}
	
	// Update is called once per frame
	void Update () {
        if (Input.GetKeyDown(KeyCode.Space))
        {
            gameObject.transform.Translate(Vector3.up);
        }

        transform.Translate(Vector3.forward * Time.deltaTime);
        if(msgtimer < 0.1f)
        {
            MainMenuMsg.text = "";
            InstructorMsg.text = "";
        }
        else
        {
            msgtimer -= Time.deltaTime;
        }
	}

    public void GameRun()
    {

    }
    
    void PrintDictionary()
    {
        string Data = "";
        foreach (var item in PatientDictionary)
        {
            Data += "Patient Name: " + item.Key + " || Game 1: " + item.Value[0] + " || Game 2: " + item.Value[1] + "\n";
        }
        PatientData.text = Data;
    }

    public void PlayGame(int scene)
    {
        if(Name.text != "")
        {
            SaveCP();
            SceneManager.LoadSceneAsync(scene);//Start Game
        }
        else
        {
            MainMenuMsg.text = "Enter Your Name";
            Debug.Log("Enter Your Name");//Show text to enter the name
            msgtimer = 1.0f;
        }
    }

    public void ShowPatientDetails()
    {
        if (LoginData.ContainsKey(Username.text))
        {
            if(AccountPassword.text == LoginData[Username.text])
            {
                PrintDictionary();
                PatientDetails.SetActive(true);//Login and show patient data
                Debug.Log("Logged in Succesfully");
            }
            else
            {
                InstructorMsg.text = "Incorrect Password";
                msgtimer = 1.0f;
                Debug.Log("Wrong Password");//incorrect password
            }
        }
        else
        {
            InstructorMsg.text = "Username Does not exist";
            msgtimer = 1.0f;
            Debug.Log("Username Does not exist");//username does not exist
        }
    }

    public void CreateUsername()
    {
        if (LoginData.ContainsKey(Username.text))
        {
            InstructorMsg.text = "Username Already Exists";
            msgtimer = 1.0f;
            Debug.Log("Username Already Exists");//User Already Exists
        }
        else
        {
            if(MasterPassword.text != Master_Password)
            {
                InstructorMsg.text = "Incorrect Master Password";
                msgtimer = 1.0f;
                Debug.Log("Wrong Master Password"); //wrong Master Password
            }
            else
            {
                LoginData.Add(Username.text, AccountPassword.text);//add login data to dictionary
                SaveLoginData();
                Debug.Log("Account Created");
                PrintDictionary();
                PatientDetails.SetActive(true);//Login and show patient data
            }
        }
    }

    void LoadLoginData()
    {
        LoginData = new Dictionary<string, string>();

        // CreateDirectory() checks for existence and 
        // automagically creates the directory if necessary
        Directory.CreateDirectory(savedDataPath);

        // the file is a simple key,value list, one dictionary item per line
        if (File.Exists(dictionaryFullName_I))
        {
            string[] fileContent = File.ReadAllLines(dictionaryFullName_I);

            foreach (string line in fileContent)
            {
                string[] buffer = line.Split(',');
                if (buffer.Length == 2)
                    LoginData.Add(buffer[0], buffer[1]);
            }
        }
    }

    void SaveLoginData()
    {
        if (LoginData != null)
        {
            string fileContent = "";

            foreach (var item in LoginData)
            {
                fileContent += item.Key + "," + item.Value + "\n";
            }

            File.WriteAllText(dictionaryFullName_I, fileContent);
            Debug.Log("Login Data Saved");
        }
    }

    void LoadData_P()
    {
        PatientDictionary = new Dictionary<string, int[]>();

        // CreateDirectory() checks for existence and 
        // automagically creates the directory if necessary
        Directory.CreateDirectory(savedDataPath);

        // the file is a simple key,value list, one dictionary item per line
        if (File.Exists(dictionaryFullName_P))
        {
            string[] fileContent = File.ReadAllLines(dictionaryFullName_P);

            foreach (string line in fileContent)
            {
                string[] buffer = line.Split(',');
                if (buffer.Length == 3)
                {
                    int[] scores = new int[] { int.Parse(buffer[1]), int.Parse(buffer[2]) };
                    PatientDictionary.Add(buffer[0], scores);
                }
            }
        }
    }

    void SaveData_P()
    {
        if (PatientDictionary != null)
        {
            string fileContent = "";

            foreach (var item in PatientDictionary)
            {
                fileContent += item.Key + "," + item.Value[0] + "," + item.Value[1] + "\n";
            }

            File.WriteAllText(dictionaryFullName_P, fileContent);
        }
    }

    void SaveCP()
    {
        File.WriteAllText(stringCurrentPlayer, Name.text);
    }
}
