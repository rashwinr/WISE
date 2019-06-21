using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.IO.Ports;


public class PickupDropTrigger : MonoBehaviour {
    SerialPort sp;
    string Line;

    private void Start()
    {
        sp = new SerialPort("COM9", 9600);
        sp.Open();

    }

    private void Update()
    {
        sp.BaseStream.Flush();
        Line = "";
        Line = sp.ReadLine();
        print(Line);
    }
}
