using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MeshGeneration : MonoBehaviour
{
    List<Vector3> vertices;
    List<Vector2> uv;
    List<int> triangles;
    public Transform Target;
    float dist;
    int[] Near;
    public int VerSize;
    Mesh mesh;
    MeshFilter MF;

    // Start is called before the first frame update
    void Start()
    {
        vertices = new List<Vector3>();
        //uv = new List<Vector2>();
        triangles = new List<int>();
        Near = new int[2];
        mesh = new Mesh();
        VerSize = 0;
        MF = GetComponent<MeshFilter>();
    }

    void Update()
    {
        if (Input.GetKeyDown(KeyCode.Space))
        {
            if (VerSize < 2)
            {
                vertices.Add(Target.position);
                VerSize = VerSize + 1;
            }
            else
            {
                NewVertex();
                mesh.vertices = vertices.ToArray();
                //mesh.uv = uv.ToArray();
                mesh.triangles = triangles.ToArray();
            }
        }
    }

    void NewVertex()
    {
        VerSize = VerSize + 1;
        CheckNearVer();
        Triangles();
        MF.mesh = mesh;
    }

    void Triangles()
    {
        triangles.Add(Near[0]);
        triangles.Add(Near[1]);
        triangles.Add(vertices.Count-1);
        triangles.Add(Near[1]);
        triangles.Add(Near[0]);
        triangles.Add(vertices.Count - 1);
    }

    void CheckNearVer()
    {
        float LeastDist = float.MaxValue;
        float LeastDist2 = float.MaxValue;
        int i = 0;
        int s = 0;
        bool first2dvertex = true;
        foreach (var vertex in vertices)
        {
            if(Target.position.x == vertex.x)
            {
                s = s + 1;
            }
            if (Target.position.y == vertex.y)
            {
                s = s + 1;
            }
            if (Target.position.z == vertex.z)
            {
                s = s + 1;
            }

            if (first2dvertex || s < 2)
            {
                dist = (vertex - Target.position).sqrMagnitude;
                if (dist < LeastDist)
                {
                    LeastDist = dist;
                    Near[0] = i;
                }
                else if (dist < LeastDist2)
                {
                    LeastDist2 = dist;
                    Near[1] = i;
                }
                i = i + 1;
                Debug.Log(dist);
            }
            if (s > 1)
            {
                first2dvertex = false;
            }
            s = 0;
        }
        vertices.Add(Target.position);
        Debug.Log("\n");
        //PrintVertex();
    }

    void PrintVertex()
    {
        Debug.Log("\n");
        foreach(var ver in triangles)
        {
            Debug.Log(ver);
        }
    }

}
