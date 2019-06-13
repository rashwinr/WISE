using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Graphs : MonoBehaviour
{
    public Vector3[] Ylimits;
    public Vector3[] Xlimits;
    public Vector3[] GraphPoints;
    public List<Vector3> Points;

    public LineRenderer AxisRenderer;
    public LineRenderer GraphRenderer;
    // Start is called before the first frame update
    void Start()
    {
        Ylimits = new Vector3[2];
        Xlimits = new Vector3[2];
        GraphPoints = new Vector3[30];
        Points = new List<Vector3>();
        AxisRenderer.positionCount = 5;
        Points.Add(Xlimits[0]);
        Points.Add(Xlimits[1]);
        Points.Add(Xlimits[0]);
        Points.Add(Ylimits[0]);
        Points.Add(Ylimits[1]);
    }

    // Update is called once per frame
    void Update()
    {
        Points[0] = Xlimits[0];
        Points[1] = Xlimits[1];
        Points[2] = Xlimits[0];
        Points[3] = Ylimits[0];
        Points[4] = Ylimits[1];

        AxisRenderer.SetPositions(Points.ToArray());
    }
}
