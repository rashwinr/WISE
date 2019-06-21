using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;
using System.IO;

public class Game_2 : MonoBehaviour {

    public Transform[] PlaceHolders;
    public float spawnSpeed;
    public float spawnTimer;
    public float MoveSpeed;
    public float timer;
    public GameObject[] Destroyers;
    public int score;
    private Rigidbody rb;

    public GameObject Game_Over;
    public GameObject Pause_UI;
    public GameObject Game_UI;
    private bool pause;
    public Text Score;
    public Text H_Score_GO;
    public Text H_Score_PAUSE;
    public int H_Score;
    private Dictionary<string, int[]> PatientDictionary = new Dictionary<string, int[]>();
    private static string savedDataPath;
    private static string dictionaryName_P = "PatientData.txt";
    private static string dictionaryFullName_P;
    private static string stringCurrentPlayer;
    private string CurrentPlayer;

    // Use this for initialization
    void Start () {
        rb = GetComponent<Rigidbody>();
        savedDataPath = Application.persistentDataPath + "/savedData";
        dictionaryFullName_P = savedDataPath + "/" + dictionaryName_P;
        stringCurrentPlayer = savedDataPath + "/" + "CurrentPlayer";
        LoadCP();
        LoadData_P();
        if (PatientDictionary.ContainsKey(CurrentPlayer))
        {
            H_Score = PatientDictionary[CurrentPlayer][1];
        }
        else
        {
            H_Score = 0;
        }
        H_Score_GO.text = H_Score.ToString();
        H_Score_PAUSE.text = H_Score.ToString();
        Game_Over.SetActive(false);
        Pause_UI.SetActive(false);
        Game_UI.SetActive(true);

        score = -1;
        spawnTimer = 5f;
        Time.timeScale = 1;
    }
	
	// Update is called once per frame
	void Update () {
        if (!pause)
        {
            if (spawnSpeed > 0.1)
            {
                timer += Time.deltaTime;
                if (timer > 5.0f)
                {
                    timer = 0f;
                    spawnSpeed -= 0.2f;
                }
            }
            spawnTimer += Time.deltaTime;
            if (spawnTimer > spawnSpeed)
            {
                score = score + 1;
                Score.text = score.ToString();
                spawnTimer = 0f;
                for (int i = 0; i < PlaceHolders.Length; i++)
                {
                    Instantiate(Destroyers[Random.Range(0, Destroyers.Length)], PlaceHolders[Random.Range(0,PlaceHolders.Length)]);
                }
            }
        }
    }

    private void FixedUpdate()
    {
        if (Input.GetKey(KeyCode.RightArrow))
        {
            rb.MovePosition(transform.position + Vector3.right * MoveSpeed * Time.deltaTime);
        }

        if (Input.GetKey(KeyCode.LeftArrow))
        {
            rb.MovePosition(transform.position + Vector3.left * MoveSpeed * Time.deltaTime);
        }
    }

    public void OnCollisionEnter(Collision col)
    {
        if (col.gameObject.tag == "Destroyer")
        {
            Game_Over.SetActive(true);//GameOver
            Pause_UI.SetActive(false);
            Game_UI.SetActive(false);
            pause = true;
            Time.timeScale = 0;

            if (score > H_Score)
            {
                H_Score = score;
                H_Score_GO.text = H_Score.ToString();
                H_Score_PAUSE.text = H_Score.ToString();
                //Save Data
                if (PatientDictionary.ContainsKey(CurrentPlayer))
                {
                    PatientDictionary[CurrentPlayer][1] = H_Score;
                    SaveData_P();
                }
                else
                {
                    PatientDictionary.Add(CurrentPlayer, new int[] { 0, H_Score});
                    SaveData_P();
                }
            }
        }
    }

    public void MainMenu()
    {
        SceneManager.LoadSceneAsync(0);
    }

    public void Retry()
    {
        SceneManager.LoadSceneAsync(2);
    }

    public void Pause()
    {
        pause = !pause;
        if (pause)
        {
            Time.timeScale = 0;
            Game_Over.SetActive(false);
            Pause_UI.SetActive(true);
            Game_UI.SetActive(false);
        }
        else
        {
            Time.timeScale = 1;
            Game_Over.SetActive(false);
            Pause_UI.SetActive(false);
            Game_UI.SetActive(true);
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

    void LoadCP()
    {
        CurrentPlayer = "";
        // CreateDirectory() checks for existence and 
        // automagically creates the directory if necessary
        Directory.CreateDirectory(savedDataPath);

        // the file is a simple key,value list, one dictionary item per line
        if (File.Exists(stringCurrentPlayer))
        {
            CurrentPlayer = File.ReadAllText(stringCurrentPlayer);
        }
    }
}
