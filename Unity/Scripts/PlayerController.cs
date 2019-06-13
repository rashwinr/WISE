using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using System.IO;
public class PlayerController : MonoBehaviour {

    public int PlayBackToken = -1;

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
    public bool PlayingBack;
    Vector3 BackAngle;
    public int TimeStampCount;
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

    #region Update for Euler Angles (Not Being Used)
    /*// Update is called once per frame
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
        else if(PB.TimeStamp.Count != 0 && PlayingBack)//Change this. It is inefficient
        {
            percentage = Timer / (PB.TimeStamp[PB_iteration+1]- PB.TimeStamp[PB_iteration]);
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
            }
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
    }*/
    #endregion

    bool PausePB = false;
    public void PausePlayback()
    {
        PausePB = !PausePB;
    }

    private void FixedUpdate()
    {
        if (Live)
        {
            MoveForearm(Conn.LeftForearm, Conn.rightForearm);
            MoveArm(Conn.LeftArm, Conn.RightArm);
            MoveBack(Conn.Back);
        }
        else if (PlayingBack && PlayBackToken != -1 && TimeStampCount != -1)
        {

            PB_iteration = Mathf.RoundToInt(Iterations.value);
            if (!PausePB)
            {
                Timer = PB.TimeStampCache[(PlayBackToken / 5)][PB_iteration] + Time.fixedUnscaledDeltaTime;
                if (PB_iteration < 15.0f && Timer > 2.0f)
                {
                    PB_iteration++;
                }
                else
                {
                    //float DeltaT = Mathf.Abs(PB.TimeStampCache[(PlayBackToken / 5)][PB_iteration + 1] - PB.TimeStampCache[(PlayBackToken / 5)][PB_iteration]);
                    //percentage = Timer / DeltaT;
                    for (int i = 0; i < PB.TimeStampCache[(PlayBackToken / 5)].Count; i++)
                    {
                        if (Timer < PB.TimeStampCache[(PlayBackToken / 5)][i])
                        {
                            if (i < 15 && PB.TimeStampCache[(PlayBackToken / 5)][i] > 2.0f)
                            {
                                continue;
                            }
                            else
                            {
                                int diff = i - PB_iteration;
                                PB_iteration += diff;
                                Timer = 0f;
                                break;
                            }
                        }
                    }
                }
            }
            /*if (percentage > 1 || DeltaT > 0.2f)
            {
                PB_iteration++;
                Timer = 0;
                percentage = 0;
            }*/
            if (PB_iteration >= TimeStampCount)
            {
                PB_iteration = 0;
                //PlayingBack = false;
                //TimeStampCount = 0;
                //return;
            }
            //Debug.Log(PB_iteration + " , " + PB.TimeStampCache[(PlayBackToken / 5)].Count);
            //Quaternion A_ApproxQuat = Quaternion.Slerp(PB.DataCache[PlayBackToken][PB_iteration], PB.DataCache[PlayBackToken][PB_iteration + 1], percentage);
            //Quaternion B_ApproxQuat = Quaternion.Slerp(PB.DataCache[PlayBackToken + 1][PB_iteration], PB.DataCache[PlayBackToken + 1][PB_iteration + 1], percentage);
            //Quaternion C_ApproxQuat = Quaternion.Slerp(PB.DataCache[PlayBackToken + 2][PB_iteration], PB.DataCache[PlayBackToken + 2][PB_iteration + 1], percentage);
            //Quaternion D_ApproxQuat = Quaternion.Slerp(PB.DataCache[PlayBackToken + 3][PB_iteration], PB.DataCache[PlayBackToken + 3][PB_iteration + 1], percentage);
            //Quaternion E_ApproxQuat = Quaternion.Slerp(PB.DataCache[PlayBackToken + 4][PB_iteration], PB.DataCache[PlayBackToken + 4][PB_iteration + 1], percentage);
            Quaternion A_ApproxQuat = PB.DataCache[PlayBackToken][PB_iteration];
            Quaternion B_ApproxQuat = PB.DataCache[PlayBackToken + 1][PB_iteration];
            Quaternion C_ApproxQuat = PB.DataCache[PlayBackToken + 2][PB_iteration];
            Quaternion D_ApproxQuat = PB.DataCache[PlayBackToken + 3][PB_iteration];
            Quaternion E_ApproxQuat = PB.DataCache[PlayBackToken + 4][PB_iteration];

            Iterations.value = PB_iteration;
            MoveForearm(A_ApproxQuat, B_ApproxQuat);
            MoveArm(C_ApproxQuat, D_ApproxQuat);
            MoveBack(E_ApproxQuat);
        }
        else
        {
            PB_iteration = 0;
            Timer = 0;
            percentage = 0;
            TimeStampCount = 0;
        }
    }

    #region Character Setup
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

    void ResetCharacter()
    {
        PlayerArm[0].localRotation = Quaternion.identity;
        PlayerArm[1].localRotation = Quaternion.identity;
        PlayerShoulder[0].localRotation = Quaternion.identity;
        PlayerShoulder[1].localRotation = Quaternion.identity;
        PlayerForearm[0].localRotation = Quaternion.identity;
        PlayerForearm[1].localRotation = Quaternion.identity;
    }
    #endregion

    #region Movements

    /* Previous code for euler angles
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
    
    void MoveShoulder(float[] x, float[] z)
    {
        PlayerShoulder[0].localRotation = Quaternion.Euler(-x[0], 0f, -z_[0]);
        PlayerShoulder[1].localRotation = Quaternion.Euler(x[1], 0f, z_[1]);
    }
    */    
    void MoveBack(Quaternion Back)
    {
        BackAngle = quat2eul(Back);
        PlayerBack.localRotation = Quaternion.Euler(-BackAngle.x, 0f, BackAngle.y);
    }

    Vector3 quat2eul(Quaternion Q)
    {
        float sinr_cosp = 2.0f * (Q.w * Q.x + Q.y * Q.z);
        float cosr_cosp = 1.0f - (2.0f * (Q.x * Q.x + Q.y * Q.y));
        Vector3 euler = new Vector3();
        euler.x = Mathf.Rad2Deg * Mathf.Atan2(sinr_cosp, cosr_cosp);

        float sinp = 2.0f * (Q.w * Q.y - Q.z * Q.x);
        euler.y = -Mathf.Rad2Deg * Mathf.Asin(sinp);

        float siny_cosp = 2.0f * (Q.w * Q.z + Q.y * Q.x);
        float cosy_cosp = 1.0f - (2.0f * (Q.y * Q.y + Q.z * Q.z));
        euler.z = Mathf.Rad2Deg * Mathf.Atan2(siny_cosp, cosy_cosp);
        if (float.IsNaN(euler.x) || float.IsNaN(euler.y) || float.IsNaN(euler.z))
        {
            euler = BackAngle;
        }
        return euler;
    }
    
    ////-----Previous Code for Euler Angles-----//
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
    void MoveForearm(Quaternion LeftForearm, Quaternion RightForearm)
    {
        PlayerForearm[0].localRotation = LeftForearm;//Quaternion.Euler(-x[0], -z[0], y[0]);//Good
        PlayerForearm[1].localRotation = RightForearm;//Quaternion.Euler(-x[1], -z[1], y[1]);
    }

    /* Previous Code for Euler Angles
    if (y[0] < 270.0f && y[0] > 190.0f)
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
    }
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
    */
    void MoveArm(Quaternion LeftArm, Quaternion RightArm)
    {
        PlayerArm[0].localRotation = LeftArm;//Quaternion.Euler(-x[0], -z[0], y[0]);//Good
        PlayerArm[1].localRotation = RightArm;// Quaternion.Euler(-x[1], -z[1], y[1]);
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

    public void _PlayingBack()
    {
        PlayingBack = true;
    }

    public GameObject SubjectDataUI;
    public GameObject PlayBackUI;
    public GameObject Background;
    public Slider Iterations;
    public void StopPlayingBack()
    {
        PlayingBack = false;
        SubjectDataUI.SetActive(true);
        PlayBackUI.SetActive(false);
        Background.SetActive(true);
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

    #region PlayBack System
    public void DoPlayBack()//Do Playback and all Necessary Camera Zooms and Texts
    {
        TimeStampCount = PB.TimeStampCache[(PlayBackToken / 5)].Count - 1;
        if (TimeStampCount != -1)
        {
            PlayingBack = true;
            PlayBackUI.SetActive(true);
            SubjectDataUI.SetActive(false);
            Background.SetActive(false);
            Iterations.maxValue = TimeStampCount;
            Iterations.minValue = 0;
            Iterations.value = 0;
        }
    }
    #endregion
}
