using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Camera_Movement : MonoBehaviour {

    public GameObject Player;
	// Use this for initialization
	void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {
        Vector3 desiredPosition = new Vector3(Player.transform.position.x + 3.0f, 0f, 0f);
        Vector3 smoothedPosition = Vector3.Lerp(transform.position, desiredPosition, 0.125f);// * Time.deltaTime);
        transform.position = new Vector3(smoothedPosition.x, 6.84f, -20.6f);
	}
}
