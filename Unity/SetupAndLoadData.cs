using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class SetupAndLoadData : MonoBehaviour
{
    public string TimeStamp;
    public string ActivityName;
    public string Path;
    public Playback RA;
    public PlayerController PC;
    private GameObject DeviceManager;
    private GameObject Player;
    public Text Text1;
    public Text Text2;
    public int Token = -1;
    public GameObject LoadingUI;

    private void Awake()
    {
        DeviceManager = GameObject.FindGameObjectWithTag("DeviceManager");
        Player = GameObject.FindGameObjectWithTag("Player");
        RA = DeviceManager.GetComponent<Playback>();
        PC = Player.GetComponent<PlayerController>();
    }
    public void LoadingTextReferenceDataDone()
    {
        Text1.text = ActivityName;
        Text2.text = TimeStamp;
    }

    public void LoadFile()
    {
        LoadingUI.SetActive(true);
        if(Token == -1)
        {
            Token = RA.LoadFile(Path);
        }
        SendTokenToPlayer();
        //StartCoroutine("WaitTime");
    }

    /*IEnumerator WaitTime()
    {
        yield return new WaitForSeconds(0.1f);
        SendTokenToPlayer();
    }*/
    public void SendTokenToPlayer()//Sends Token to PlayerController and starts playing
    {
        PC.PlayBackToken = Token;
        PC.DoPlayBack();
        LoadingUI.SetActive(false);
    }
}
