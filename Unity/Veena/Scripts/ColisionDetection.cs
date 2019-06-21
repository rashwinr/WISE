using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ColisionDetection : MonoBehaviour
{
    public bool Collision = false;
    private void OnCollisionEnter(Collision collision)
    {
        if (collision.gameObject.tag == "Table")
        {
            Collision = true;
        }
    }
}
