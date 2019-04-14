using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using System.IO;
public class PlayerController : MonoBehaviour {

   

    [Range(-180f, 180f)]
    public float[] Forearm_x;
    [Range(-180f, 180f)]
    public float[] Forearm_y;
    [Range(-180f, 180f)]
    public float[] Forearm_z;

    [Range(-180f, 180f)]
    public float[] Arm_x;
    [Range(-180f, 180f)]
    public float[] Arm_y;
    [Range(-180f, 180f)]
    public float[] Arm_z;

    [Range(-180f, 180f)]
    public float[] Back_all;

    public GameObject[] Players;
    GameObject Player;
    Transform[] PlayerShoulder;
    Transform[] PlayerForearm;
    Transform[] PlayerArm;
    
    Transform PlayerBack;

    public Dropdown Gender;
    private Connection Conn;
    private DeviceManager DM;
    public Animator anim_M;
    public Animator anim_F;
    public Animator Curr_Anim;
    public TextMesh Text_M;
    public TextMesh Text_F;

    public Transform StartArm;
    public Transform StarForearm;

    public bool Live;
    public Playback PB;
    public int PB_iteration = 0;
    public float Timer;
    public float percentage;
    // Use this for initialization
    void Start () {
        Forearm_x = new float[2];
        Forearm_y = new float[2];
        Forearm_z = new float[2];
        Arm_x = new float[2];
        Arm_y = new float[2];
        Arm_z = new float[2];

        Back_all = new float[3];
        Text_F.text = "";
        Text_M.text = "";
        PlayerShoulder = new Transform[2];
        PlayerForearm = new Transform[2];
        PlayerArm = new Transform[2];
        SetGender();
        GameObject D_M = GameObject.FindGameObjectWithTag("DeviceManager");
        Conn = D_M.GetComponent<Connection>();
        DM = D_M.GetComponent<DeviceManager>();
        PB = D_M.GetComponent<Playback>();
    }
	
	// Update is called once per frame
	void Update () {
        Timer += Time.deltaTime;
        if (Live)
        {
            Forearm_x[0] = Conn.angle_x[0];//Forearm 1 x//Change these orders according to the device order
            Forearm_x[1] = Conn.angle_x[1];//Forearm 2 x
            Arm_x[0] = Conn.angle_x[2];//Arm 1 x
            Arm_x[1] = Conn.angle_x[3];//Arm 2 x
            Forearm_y[0] = Conn.angle_y[0];//Forearm 1 y
            Forearm_y[1] = Conn.angle_y[1];//Forearm 2 y
            Forearm_z[0] = Conn.angle_z[0];
            Forearm_z[1] = Conn.angle_z[1];
            Arm_y[0] = Conn.angle_y[2];//Arm 1 y
            Arm_y[1] = Conn.angle_y[3];//Arm 2 y
            Arm_z[0] = Conn.angle_z[2];//Arm 1 x
            Arm_z[1] = Conn.angle_z[3];//Arm 2 x
            Back_all[0] = Conn.angle_x[4];
            Back_all[1] = Conn.angle_y[4];
            Back_all[2] = Conn.angle_z[4];
        }
        else if(PB.TimeStamp.Count != 0)//Change this. It is inefficient
        {
           /* percentage = Timer / (PB.TimeStamp[PB_iteration+1]- PB.TimeStamp[PB_iteration]);
            if (percentage > 1)
            {
                PB_iteration++;
                Timer = 0;
                percentage = 0;
            }
            Vector3 A_ApproxAngles = Vector3.Lerp(PB.A_Angles[PB_iteration], PB.A_Angles[PB_iteration + 1], percentage);
            Vector3 B_ApproxAngles = Vector3.Lerp(PB.B_Angles[PB_iteration], PB.B_Angles[PB_iteration + 1], percentage);
            Vector3 C_ApproxAngles = Vector3.Lerp(PB.C_Angles[PB_iteration], PB.C_Angles[PB_iteration + 1], percentage);
            Vector3 D_ApproxAngles = Vector3.Lerp(PB.D_Angles[PB_iteration], PB.D_Angles[PB_iteration + 1], percentage);
            Vector3 E_ApproxAngles = Vector3.Lerp(PB.E_Angles[PB_iteration], PB.E_Angles[PB_iteration + 1], percentage);

            Forearm_x[0] = A_ApproxAngles.x;//Forearm 1 x//Change these orders according to the device order
            Forearm_x[1] = B_ApproxAngles.x;//Forearm 2 x
            Arm_x[0] = C_ApproxAngles.x;//Arm 1 x
            Arm_x[1] = D_ApproxAngles.x;//Arm 2 x
            Forearm_y[0] = A_ApproxAngles.y;//Forearm 1 y
            Forearm_y[1] = B_ApproxAngles.y;//Forearm 2 y
            Forearm_z[0] = A_ApproxAngles.z;
            Forearm_z[1] = B_ApproxAngles.z;
            Arm_y[0] = C_ApproxAngles.y;//Arm 1 y
            Arm_y[1] = D_ApproxAngles.y;//Arm 2 y
            Arm_z[0] = C_ApproxAngles.z;//Arm 1 x
            Arm_z[1] = D_ApproxAngles.z;//Arm 2 x
            Back_all[0] = E_ApproxAngles.x;
            Back_all[1] = E_ApproxAngles.y;
            Back_all[2] = E_ApproxAngles.z;
            
            if(PB_iteration == PB.TimeStamp.Count-1)
            {
                PB_iteration = 0;
            }*/
            Forearm_x[0] = PB.A_Angles[PB_iteration].x;//Forearm 1 x//Change these orders according to the device order
            Forearm_x[1] = PB.B_Angles[PB_iteration].x;//Forearm 2 x
            Arm_x[0] = PB.C_Angles[PB_iteration].x;//Arm 1 x
            Arm_x[1] = PB.D_Angles[PB_iteration].x;//Arm 2 x
            Forearm_y[0] = PB.A_Angles[PB_iteration].y;//Forearm 1 y
            Forearm_y[1] = PB.B_Angles[PB_iteration].y;//Forearm 2 y
            Forearm_z[0] = PB.A_Angles[PB_iteration].z;
            Forearm_z[1] = PB.B_Angles[PB_iteration].z;
            Arm_y[0] = PB.C_Angles[PB_iteration].y;//Arm 1 y
            Arm_y[1] = PB.D_Angles[PB_iteration].y;//Arm 2 y
            Arm_z[0] = PB.C_Angles[PB_iteration].z;//Arm 1 x
            Arm_z[1] = PB.D_Angles[PB_iteration].z;//Arm 2 x
                                                   //Back_all[0] = PB.E_Angles[PB_iteration].x;
                                                   // Back_all[1] = PB.E_Angles[PB_iteration].y;
                                                   //Back_all[2] = PB.E_Angles[PB_iteration].z;
            PB_iteration++;
            if (PB_iteration == PB.TimeStamp.Count)
            {
                PB_iteration = 0;
            }
        }
        //MoveShoulder(Arm_x, Arm_z);
        MoveForearm(Forearm_x, Forearm_y,Forearm_z);
        MoveArm(Arm_x, Arm_y, Arm_z);
        MoveBack(Back_all[0], Back_all[1], Back_all[2]);
    }
    
    public void SetGender()
    {
        
        if (Gender.value == 1)
        {//Female
            Player = Players[0];
            PlayerShoulder[0] = Players[1].transform;
            PlayerShoulder[1] = Players[2].transform;
            PlayerForearm[0] = Players[5].transform;
            PlayerForearm[1] = Players[6].transform;
            PlayerArm[0] = Players[3].transform;
            PlayerArm[1] = Players[4].transform;
            PlayerBack = Players[14].transform;
            anim_M.enabled = false;
            anim_F.enabled = false;
            Curr_Anim = anim_M;
            //anim_F.SetBool("Hand Lift", true);
            Text_F.text = "Patient";
            Text_M.text = "Instructor";
        }
        else
        {//Male
            Player = Players[7];
            PlayerShoulder[0] = Players[8].transform;
            PlayerShoulder[1] = Players[9].transform;
            PlayerForearm[0] = Players[12].transform;
            PlayerForearm[1] = Players[13].transform;
            PlayerArm[0] = Players[10].transform;
            PlayerArm[1] = Players[11].transform;
            PlayerBack = Players[15].transform;
            anim_M.enabled = false;
            anim_F.enabled = true;
            Curr_Anim = anim_F;
            //anim_M.SetBool("Hand Lift", true);
            Text_F.text = "Instructor";
            Text_M.text = "Patient";
        }
        Curr_Anim.enabled = true;
        //Player.transform.rotation = Quaternion.Euler(0f, 0.0f, 0f);
    }
    #region Movements
    void MoveShoulder(float[] x, float[] z)
    {
        //----------//
        float[] z_ = new float[2];
        z_[0] = z[0];
        z_[1] = z[1];
        if (x[0] < 355.0f && x[0] > 180.0f)
        {
            x[0] = 355.0f;
        }
        else if (x[0] > 5.0f && x[0] <= 180.0f)
        {
            x[0] = 5.0f;
        }
        if (x[1] < 355.0f && x[1] > 180.0f)
        {
            x[1] = 355.0f;
        }
        else if (x[1] > 5.0f && x[1] <= 180.0f)
        {
            x[1] = 5.0f;
        }
        //---------//
       
            if (z_[0] > 45.0f && z_[0] > 157.0f)
            {
                z_[0] = 0.0f;
            }
            else if (z_[0] > 45.0f && z_[0] <= 157.0f)
            {
                z_[0] = 45.0f;
            }
        
            if (z_[1] > 45.0f && z_[1] > 157.0f)
            {
                z_[1] = 0.0f;
            }
            else if (z_[1] > 45.0f && z_[1] <= 157.0f)
            {
                z_[1] = 45.0f;
            }
        
        //float x_ = -10 + (x[0] * 20) / 40; 
        PlayerShoulder[0].localRotation = Quaternion.Euler(-x[0], 0f, -z_[0]);
        PlayerShoulder[1].localRotation = Quaternion.Euler(x[1], 0f, z_[1]);
    }

    void ResetCharacter()
    {
        PlayerArm[0].localRotation = Quaternion.identity;
        PlayerArm[1].localRotation = Quaternion.identity;
        PlayerShoulder[0].localRotation = Quaternion.identity;
        PlayerShoulder[1].localRotation = Quaternion.identity;
        PlayerForearm[0].localRotation = Quaternion.identity;
        PlayerForearm[1].localRotation = Quaternion.identity;
    }

    void MoveBack(float x, float y, float z)
    {
        PlayerBack.localRotation = Quaternion.Euler(-x, 0f, y);
    }
    
    void MoveForearm(float[] x, float[] y, float[] z)
    {
        ////----------//
        //if (x[0] < 330.0f && x[0] > 145.0f)
        //{
        //    x[0] = 330.0f;
        //}
        //else if (x[0] > 40.0f && x[0] <= 145.0f)
        //{
        //    x[0] = 40.0f;
        //}
        //if (x[1] < 330.0f && x[1] > 145.0f)
        //{
        //    x[1] = 330.0f;
        //}
        //else if (x[1] > 40.0f && x[1] <= 145.0f)
        //{
        //    x[1] = 40.0f;
        //}
        ////---------//
        //if (y[0] < 360.0f && y[0] > 230.0f)
        //{
        //    y[0] = 0.0f;
        //}
        //else if (y[0] > 100.0f && y[0] <= 230.0f)
        //{
        //    y[0] = 100.0f;
        //}
        //if (y[1] < 360.0f && y[1] > 230.0f)
        //{
        //    y[1] = 0.0f;
        //}
        //else if (y[1] > 100.0f && y[1] <= 230.0f)
        //{
        //    y[1] = 100.0f;
        //}
        PlayerForearm[0].localRotation = Quaternion.Euler(-x[0], -z[0], y[0]);
        PlayerForearm[1].localRotation = Quaternion.Euler(-x[1], -z[1], y[1]);
    }

    void MoveArm(float[] x, float[] y, float[] z)
    {
        /*if (y[0] < 270.0f && y[0] > 190.0f)
        {
            y[0] = 270.0f;
        }
        else if (y[0] > 90.0f && y[0] <= 190.0f)
        {
            y[0] = 90.0f;
        }
        if (y[1] < 270.0f && y[1] > 190.0f)
        {
            y[1] = 270.0f;
        }
        else if (y[1] > 90.0f && y[1] <= 190.0f)
        {
            y[1] = 90.0f;
        }*/
        //----------//
        //if (x[0] < 330.0f && x[0] > 180.0f)
        //{
        //    x[0] = 330.0f;
        //}
        //else if (x[0] > 30.0f && x[0] <= 180.0f)
        //{
        //    x[0] = 30.0f;
        //}
        //if (x[1] < 330.0f && x[1] > 180.0f)
        //{
        //    x[1] = 330.0f;
        //}
        //else if (x[1] > 30.0f && x[1] <= 180.0f)
        //{
        //    x[1] = 30.0f;
        //}
        //---------//
        //if (z[0] < 315.0f && z[0] > 202.0f)
        //{
        //    z[0] = 315.0f;
        //}
        //else if (z[0] > 45.0f && z[0] <= 202.0f)
        //{
        //    z[0] = 45.0f;
        //}
        //if (z[1] < 315.0f && z[1] > 202.0f)
        //{
        //    z[1] = 315.0f;
        //}
        //else if (z[1] > 45.0f && z[1] <= 202.0f)
        //{
        //    z[1] = 45.0f;
        //}
        PlayerArm[0].localRotation = Quaternion.Euler(-x[0], -z[0], y[0]);
        PlayerArm[1].localRotation = Quaternion.Euler(x[1], -z[1], y[1]);
    }

    #endregion

    #region Animation
    public Dropdown Activities;

    public void Start_()
    {
        Curr_Anim.SetBool("Pause", false);
        Live = true;
    }

    public void _animate()
    {
        Curr_Anim.SetInteger("Activities", Activities.value);
    }

    public void Exit_()
    {
        Curr_Anim.SetBool("Pause", true);
        Live = false;
    }

    #endregion

    #region Scoring System
    public Vector3[] Targets;
    public float ProgressPercent;
    public Vector3 HighestAchivedValues;
    public void Scoring()
    {
        if(Targets == null)
        {
            Targets = new Vector3[Activities.options.Count - 1];
        }


    }

    #endregion
}
