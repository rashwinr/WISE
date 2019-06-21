using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class CursorMovement : MonoBehaviour {

    public Vector2 MousePosition;
    public GameObject Cursor_;
    public Vector2 CursorPosition;
    public RaycastHit MWP_Hit;//Mouse World Position hit
    public Vector3 MWP;
    private Camera cam;
    private PickupDropTrigger PDT;
    public Rigidbody rb;
    public float timer;
    public bool StartMoving;
    //public Image MovingStatus;
    public Animator anim;
    public bool Processing;
    private CakeStatus CS;
    public GameObject Model;
    public Sprite[] cursor;
    private Image Cursor_Image;
    // Use this for initialization
    void Start () {
        Cursor.visible = false;
        cam = Camera.main;
        CS = Model.GetComponent<CakeStatus>();
        Cursor_Image = Cursor_.GetComponent<Image>();
	}

    // Update is called once per frame
    void Update()
    {
        CursorMapping();
        Cursor_.transform.position = CursorPosition;
        //Cake.transform.position = new Vector3(Cursor_.transform.position.x, Cursor_.transform.position.y, 0f);
        if (StartMoving)
        {
            MoveCube();
        }

        CursorWorldCoordinates();

        
        if (Processing)
        {
            Processing = CS.Processing;
        }
        else if(CS.Process == 2)
        {
            //Model.SetActive(false);
            rb.MovePosition(new Vector3(16.76f, 2.0f, 0f));// Resetting the cube position
            CS.Process = 0;
            //Model.transform.localPosition = new Vector3(3.0f, 0f, 0f);
            //Model.SetActive(true);
            anim.SetTrigger("Reset");
        }

        //Clamping Y Co-ordinate of Cake
        if (transform.position.y > 15.0f)
        {
            transform.position = new Vector3(transform.position.x, 15.0f, 0f);
        }
        if (transform.position.y < 1.0f)
        {
            transform.position = new Vector3(transform.position.x, 1.0f, 0f);
        }
    }

    private void CursorWorldCoordinates()
    {
        Ray ray = cam.ScreenPointToRay(Input.mousePosition);
        if (Physics.Raycast(ray, out MWP_Hit))
        {
           // MWP = MWP_Hit.point;
            if (MWP_Hit.collider.tag == "Cake" && StartMoving == false)
            {
                timer = timer + Time.deltaTime;
            }
            else
            {
                timer = 0f;
            }
        }
        
        float x = -8.0f + MousePosition.x*29.0f;
        float y = -3.0f+1.0f + MousePosition.y * 16.0f;
        MWP = new Vector3(x, y, 0f);

        if (timer > 0.5f && !Processing)
        {
            Debug.Log("pick");
            StartMoving = true;
            rb.useGravity = false;
            timer = 0;
            Cursor_Image.sprite = cursor[1];
        }

        
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

    private void OnTriggerEnter(Collider other)
    {
        //if(other.tag == "PickUp")
        //{
        //    rb.MovePosition(new Vector3(-3.0f, 2.0f, 0f));
        //    StartMoving = false;
        //    rb.useGravity = true;
        //    MovingStatus.color = Color.red;
        //    //
        //}
        
        if(other.tag == "Drop" && CS.Process == 0)
        {
           rb.MovePosition(new Vector3(-3.0f, 2.0f, 0f));
            StartMoving = false;
            rb.useGravity = true;
            Cursor_Image.sprite = cursor[0];
            CS.Process = 1;
            anim.SetTrigger("Bake");
            CS.Processing = true;
            Processing = true;
            //Score
        }

        if (other.tag == "Pack" && CS.Process == 1)
        {
            rb.MovePosition(new Vector3(14.2f, 2.0f, 0f));
            StartMoving = false;
            rb.useGravity = true;
            Cursor_Image.sprite = cursor[0];
            CS.Process = 2;
            anim.SetTrigger("Pack");
            CS.Processing = true;
            Processing = true;
            //Score
        }
    }
    private void OnCollisionEnter(Collision collision)
    {
        if(collision.collider.tag == "Table")
        {
            StartMoving = false;
            rb.useGravity = true;
            Cursor_Image.sprite = cursor[0];
        }
    }
    private void MoveCube()
    {
        rb.MovePosition(new Vector3(MWP.x, MWP.y, 0f));

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
