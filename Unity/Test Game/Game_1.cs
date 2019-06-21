using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;
using System.IO;

public class Game_1 : MonoBehaviour {

    private Rigidbody rb;
    public float speed;
    public float jumpforce;
    public GameObject Game_Over;
    public GameObject Pause_UI;
    public GameObject Game_UI;
    private bool pause;
    public Text Score;
    public Text H_Score_GO;
    public Text H_Score_PAUSE;
    private bool jumping;
    public int score;
    public int H_Score;
    public GameObject[] Floors;
    private int floor_index;
    private float floor_X;
    private Dictionary<string, int[]> PatientDictionary = new Dictionary<string, int[]>();
    private static string savedDataPath;
    private static string dictionaryName_P = "PatientData.txt";
    private static string dictionaryFullName_P;
    private static string stringCurrentPlayer;
    private string CurrentPlayer;
    public float timer;
    public float FallMultiplier = 1.5f;
    public float LowJumpMultiplier = 1.0f;
    public Text GO_Score;

    // Use this for initialization
    void Start () {
        rb = this.gameObject.GetComponent<Rigidbody>();
        savedDataPath = Application.persistentDataPath + "/savedData";
        dictionaryFullName_P = savedDataPath + "/" + dictionaryName_P;
        stringCurrentPlayer = savedDataPath + "/" + "CurrentPlayer";
        LoadCP();
        LoadData_P();
        if (PatientDictionary.ContainsKey(CurrentPlayer))
        {
            H_Score = PatientDictionary[CurrentPlayer][0];
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

        score = 0;
        floor_X = 105.0f;
        Time.timeScale = 1;
    }
	
	// Update is called once per frame
	void Update () {
        if (!pause)
        {
            if (speed < 8.0f)
            {
                timer += Time.deltaTime;
                if (timer > 5.0f)
                {
                    timer = 0f;
                    speed += 0.2f;
                }
            }
            if (!jumping)
            {
                if (Input.GetKeyDown(KeyCode.Space))
                {
                    Debug.Log("Jump");
                    rb.AddForce(Vector3.up * jumpforce, ForceMode.Impulse);//jump
                    jumping = true;
                }               
            }
            else
            {
                if(rb.velocity.y < 0)
                {
                    rb.velocity += Vector3.up * Physics.gravity.y* FallMultiplier * Time.deltaTime;
                }
                else if(rb.velocity.y > 0 && !Input.GetKey(KeyCode.Space))
                {
                    rb.velocity += Vector3.up * Physics.gravity.y * LowJumpMultiplier * Time.deltaTime;
                }
            }
            transform.Translate(Vector3.right * Time.deltaTime * speed);//keep moving forward
        }
	}

    public void OnTriggerEnter(Collider col)
    {
        if(col.gameObject.tag == "MainCamera")
        {
            Game_Over.SetActive(true);//GameOver
            Pause_UI.SetActive(false);
            Game_UI.SetActive(false);
            pause = true;
            Time.timeScale = 0;
            GO_Score.text = score.ToString(); 

            if (score > H_Score)
            {
                H_Score = score;
                H_Score_GO.text = H_Score.ToString();
                H_Score_PAUSE.text = H_Score.ToString();
                //Save Data
                if (PatientDictionary.ContainsKey(CurrentPlayer))
                {
                    PatientDictionary[CurrentPlayer][0] = H_Score;
                    SaveData_P();
                }
                else
                {
                    PatientDictionary.Add(CurrentPlayer, new int[] { H_Score, 0 });
                    SaveData_P();
                }
            }
        }
        if(col.gameObject.tag == "PointBar")
        {
            score = score+1;//Give Point
            Score.text = score.ToString();
            if (score > 2)
            {
                floor_index = floor_index + 1;
                if (floor_index > Floors.Length - 1)
                {
                    floor_index = 0;
                }
                floor_X = floor_X + 15.0f;
                Floors[floor_index].transform.position = new Vector3(floor_X, Floors[floor_index].transform.position.y, Floors[floor_index].transform.position.z);
            }
        }
    }

    public void OnCollisionEnter(Collision col)
    {
        jumping = false;
    }

    public void OnCollisionExit(Collision col)
    {
        jumping = true;
    }

    public void MainMenu()
    {
        SceneManager.LoadSceneAsync(0);
    }

    public void Retry()
    {
        SceneManager.LoadSceneAsync(1);
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
                    int[] scores = new int[] { int.Parse(buffer[1]), int.Parse(buffer[2])};
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
