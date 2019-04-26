using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class RecordActivity : MonoBehaviour
{
    public Dictionary<string,List<Vector3[]>> Activity;
    public InputField ActivityName;
    public List<Vector3[]> ActivityKeys;
    public Vector3[] Angles;
    private Connection Conn;
    public float TimeTaken;
    public int KeyNo;
    public Transform[] CameraTransforms;
    public GameObject cam;
    public Dropdown CameraView;
    
    // Start is called before the first frame update
    void Start()
    {
        Conn = GetComponent<Connection>();
        Angles = new Vector3[4];
        ActivityKeys = new List<Vector3[]>();
        Activity = new Dictionary<string, List<Vector3[]>>();
        KeyNo = 0;
        //setting initial camera position
        cam.transform.position = CameraTransforms[0].position;
        cam.transform.rotation = CameraTransforms[0].rotation;
    }

    public void AddActivity()
    {
        if(ActivityName.text == "")
        {
            ActivityName.text = "Untitled_Activity";
        }


        Activity.Add(ActivityName.text, ActivityKeys);
        PrintAllActivities();
        KeyNo = 0;
    }

    public void ChangeCameraView()
    {
        switch (CameraView.value)
        {
            case 0:
                cam.transform.position = CameraTransforms[0].position;
                cam.transform.rotation = CameraTransforms[0].rotation;
                break;
            case 1:
                cam.transform.position = CameraTransforms[1].position;
                cam.transform.rotation = CameraTransforms[1].rotation;
                break;
            case 2:
                cam.transform.position = CameraTransforms[2].position;
                cam.transform.rotation = CameraTransforms[2].rotation;
                break;
        }
    }

    public void AddKey()
    { 
        Angles[0] = new Vector3(Conn.angle_x[0], Conn.angle_y[0], Conn.angle_z[0]);
        Angles[1] = new Vector3(Conn.angle_x[1], Conn.angle_y[1], Conn.angle_z[1]);
        Angles[2] = new Vector3(Conn.angle_x[2], Conn.angle_y[2], Conn.angle_z[2]);
        Angles[3] = new Vector3(Conn.angle_x[3], Conn.angle_y[3], Conn.angle_z[3]);

        ActivityKeys.Add(Angles);
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

    public void PrintAllActivityElements(List<Vector3[]> AKeys)
    {
        foreach(var item in AKeys)
        {
            foreach(var Vec in item)
            {
                Debug.Log(Vec);
            }
        }
    }

    public void PlayActiviy()
    {

    }
}
