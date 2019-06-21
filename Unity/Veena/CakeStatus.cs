using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CakeStatus : MonoBehaviour {

    public int Process;
    public bool Processing;
    // Use this for initialization
    private void Start()
    {
        Process = 0;
    }
    public void ProcessEnd()
    {
        Processing = false;
    }

}
