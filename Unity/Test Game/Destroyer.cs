using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Destroyer : MonoBehaviour {

    private float timer;// Use this for initialization
	void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {
        timer += Time.deltaTime;
        if(timer > 10.0f)
        {
            Destroy(this.gameObject);
        }
    }

    private void OnCollisionEnter(Collision col)
    {
        if(col.gameObject.tag == "Floor")
        {
            Destroy(this.gameObject);
        }
    }
}
