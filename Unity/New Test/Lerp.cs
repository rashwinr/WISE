using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Lerp : MonoBehaviour
{

    // Transforms to act as start and end markers for the journey.
    public Transform startMarker;
    public Transform endMarker;

    // Movement speed in units/sec.
    public float speed = 1.0F;

    // Time when the movement started.
    private float startTime;

    // Total distance between the markers.
    private float journeyLength;

    float timer;

    void Start()
    {
        // Keep a note of the time the movement started.
        startTime = Time.time;

        // Calculate the journey length.
        journeyLength = Vector3.Distance(startMarker.position, endMarker.position);
        timer = 0f;
        //StartCoroutine("WaitTimer");
    }
    // Follows the target position like with a spring

    private void Update()
    {
        timer += Time.deltaTime;
        float distCovered = (Time.time - startTime) * speed;

        // Fraction of journey completed = current distance divided by total distance.
        float fracJourney = distCovered / journeyLength;
        if (timer > 0.2f)
        {
            
            startMarker.position = transform.position;
            // Set our position as a fraction of the distance between the markers.
            
            timer = 0f;
        }

        transform.position = Vector3.Lerp(startMarker.position, endMarker.position, fracJourney);
    }

    IEnumerator WaitTimer()
    {
        while (true)
        {

            // Distance moved = time * speed.
            float distCovered = (Time.time - startTime) * speed;

            // Fraction of journey completed = current distance divided by total distance.
            float fracJourney = distCovered / journeyLength;

            // Set our position as a fraction of the distance between the markers.
            transform.position = Vector3.Lerp(startMarker.position, endMarker.position, fracJourney);
            yield return new WaitForEndOfFrame();
        }
        }
}
