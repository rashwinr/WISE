using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class Actions : MonoBehaviour
{

    public Vector2 MousePosition;
    public Vector2 CursorPosition;
    public RaycastHit MWP_Hit;//Mouse World Position hit
    public Vector3 MWP;
    public Camera cam;
    private Rigidbody[] rb;
    public float timer;
    public bool StartMoving;
    //public Image MovingStatus;
    private GameObject[] Model;
    private ColisionDetection[] CD;
    private Image Cursor_Image;
    public GameObject CloneObject;
    int scr;
    int CloneNo;
    //bool CanDrop;
    public float _timer;
    public Text Score;
    public bool S_Game;

    //UI
    public GameObject Cursor_;
    public Text Timer;
    public GameObject GameOverUI;
    public Sprite[] cursor;
    // Use this for initialization
    void Start()
    {
        Cursor_Image = Cursor_.GetComponent<Image>();
        CloneNo = -1;
        Model = new GameObject[10];
        rb = new Rigidbody[10];
        CD = new ColisionDetection[10];
        //CanDrop = true;
        scr = 0;//Score
        Score.text = scr.ToString();
        S_Game = false;
    }

    // Update is called once per frame
    void Update()
    {
        if (S_Game)
        {
            CursorMapping();
            Cursor_.transform.position = CursorPosition;
            //Cake.transform.position = new Vector3(Cursor_.transform.position.x, Cursor_.transform.position.y, 0f);
            if (StartMoving)
            {
                MoveCube();
                //Clamping Y Co-ordinate of Cake
                if (Model[CloneNo].transform.position.y > 12.0f)
                {
                    Model[CloneNo].transform.position = new Vector3(Model[CloneNo].transform.position.x, 12.0f, 14.74f);
                }
                if (Model[CloneNo].transform.position.y < -2.4f)
                {
                    Model[CloneNo].transform.position = new Vector3(Model[CloneNo].transform.position.x, -2.4f, 14.74f);
                }

                //Clamping for Bowl Avoiding
               /* if (Model[CloneNo].transform.position.y < -1.0f && Model[CloneNo].transform.position.x < -6.0f && Model[CloneNo].transform.position.x > -10.7f)
                {
                    if (Model[CloneNo].transform.position.x < -6.0f && Model[CloneNo].transform.position.x > -8.0f)
                    {
                        Model[CloneNo].transform.position = new Vector3(-6.0f, Model[CloneNo].transform.position.y, 14.74f);
                        CanDrop = false;
                    }
                    if (Model[CloneNo].transform.position.x < -8.0f && Model[CloneNo].transform.position.x > -10.7f)
                    {
                        Model[CloneNo].transform.position = new Vector3(-10.7f, Model[CloneNo].transform.position.y, 14.74f);
                        CanDrop = false;
                    }
                }
                else
                {
                    CanDrop = true;
                }*/
            }
            else
            {
                Cursor_Image.sprite = cursor[0];
            }

            CursorWorldCoordinates();

            if (StartMoving == true && CD[CloneNo].Collision)//&& CanDrop)
            {
                StartMoving = false;
                rb[CloneNo].useGravity = true;
                Ray ray = cam.ScreenPointToRay(Input.mousePosition);
                if (Physics.Raycast(ray, out MWP_Hit))
                {
                    // MWP = MWP_Hit.point;
                    if (MWP_Hit.collider.tag == "PickUp")
                    {
                        Model[CloneNo].SetActive(false);
                    }
                }
            }
        }
    }
    public IEnumerator StartCountdown()
    {
        _timer = 30;
        while (_timer > 0)
        {
            if (_timer < 10)
            {
                Timer.text = "0:0" + _timer.ToString();
                Timer.color = Color.red;
            }
            else
            {
                Timer.text = "0:" + _timer.ToString();
                Timer.color = Color.black;
            }
            yield return new WaitForSeconds(1.0f);
            _timer--;
        }

        EndGame();//Game Over
    }
    public void StartGame()
    {
        scr = 0;
        Score.text = "0";
        GameOverUI.SetActive(false);
        StopAllCoroutines();
        StartCoroutine("StartCountdown");
        Cursor.visible = false;
        S_Game = true;
        for (int i = 0; i < Model.Length; i++)
        {
            if (Model[i] != null)
            {
                Model[i].SetActive(false);
            }
        }
    }

    public void EndGame()
    {
        Timer.text = "0:" + "00";
        GameOverUI.SetActive(true);
        Cursor.visible = true;
        S_Game = false;
        StartMoving = false;
    }

    private void CursorWorldCoordinates()
    {
        Ray ray = cam.ScreenPointToRay(Input.mousePosition);
        if (Physics.Raycast(ray, out MWP_Hit))
        {
            // MWP = MWP_Hit.point;
            if (MWP_Hit.collider.tag == "PickUp" && StartMoving == false)
            {
                timer = timer + Time.deltaTime;
            }
            else
            {
                timer = 0f;
            }

            if (MWP_Hit.collider.tag == "Drop" && StartMoving == true )//&& CanDrop)
            {
                MoveCube();
                StartMoving = false;
                rb[CloneNo].useGravity = true;
                scr = scr + 1;//Score
                Score.text = scr.ToString();
                Debug.Log("Drop");
            }
        }

        float x = -16.0f + MousePosition.x * 31.0f; // Clamping X Position
        float y = -5.5f + MousePosition.y * 17.5f; // Clamping X Position // 1.0 is the y offset with screen
        

        if (timer > 0.5f)
        {
            CloneNo = CloneNo + 1;
            Debug.Log("pick");
            if (Model[CloneNo] == null)
            {
                Model[CloneNo] = Instantiate(CloneObject);
                rb[CloneNo] = Model[CloneNo].GetComponent<Rigidbody>();
                CD[CloneNo] = Model[CloneNo].GetComponent<ColisionDetection>();
            }
            Model[CloneNo].SetActive(true);
            //CanDrop = true;
            MWP.z = Random.Range(14.0f, 15.0f);
            //Model[CloneNo].SetActive(false);
            Model[CloneNo].transform.position = new Vector3(9.0f, -2.0f, MWP.z);            
            //Model[CloneNo].SetActive(true);
            rb[CloneNo].useGravity = false;
            Cursor_Image.sprite = cursor[1];
            CD[CloneNo].Collision = false;
            StartMoving = true;
            timer = 0;

            if (CloneNo == 9)
            {
                CloneNo = 0;
            }
        }

        MWP = new Vector3(x, y, MWP.z);
    }

    private void CursorMapping()
    {
        MousePosition = cam.ScreenToViewportPoint(Input.mousePosition);
        if (MousePosition.x > 1.0f)
        {
            MousePosition.x = 1.0f;
        }
        if (MousePosition.x < 0f)
        {
            MousePosition.x = 0f;
        }
        if (MousePosition.y < 0f)
        {
            MousePosition.y = 0f;
        }
        if (MousePosition.y > 1.0f)
        {
            MousePosition.y = 1.0f;
        }
        CursorPosition.x = MousePosition.x * 1920;
        CursorPosition.y = MousePosition.y * 1080;
    }
/*
    private void OnTriggerEnter(Collider other)
    {
        if (other.tag == "Drop")
        {
            rb.MovePosition(new Vector3(-3.0f, 2.0f, 0f));
            StartMoving = false;
            rb.useGravity = true;
            Model[CloneNo].SetActive(false);
            Cursor_Image.sprite = cursor[0];
            //Score
        }
    }
    private void OnCollisionEnter(Collision collision)//add Later
    {
        if (collision.collider.tag == "Table")
        {
            StartMoving = false;
            rb.useGravity = true;
            Cursor_Image.sprite = cursor[0];
        }
    }
    */
    private void MoveCube()
    {
        rb[CloneNo].MovePosition(new Vector3(MWP.x, MWP.y, MWP.z));

        //Cake Clamping
        //if (transform.position.x > 20.0f)
        //{
        //    transform.position = new Vector3(20.0f, transform.position.y, 0f);
        //}
        //if (transform.position.x < -8.0f)
        //{
        //    transform.position = new Vector3(-8.0f, transform.position.y, 0f);
        //}
    }
}

