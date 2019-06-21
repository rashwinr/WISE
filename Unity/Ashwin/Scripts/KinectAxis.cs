using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Windows.Kinect;
using Joint = Windows.Kinect.Joint;

public class KinectAxis : MonoBehaviour
{
    public BodySourceManager mBodySM;
    public GameObject mJointObject;

    public Vector3 RightShoulderAngle;

    private Dictionary<ulong, GameObject> mBodies = new Dictionary<ulong, GameObject>();
    public List<JointType> _joints = new List<JointType>
    {
        JointType.ShoulderRight,
        JointType.ElbowRight,
        JointType.ShoulderLeft,
        JointType.ElbowLeft,
        JointType.SpineMid,
        JointType.SpineShoulder,
    };
    

    // Update is called once per frame
    void Update()
    {
        #region Get Kinect data
        Body[] data = mBodySM.GetData();
        if (data == null)
        {
            return;
        }

        List<ulong> trackedIds = new List<ulong>();
        foreach (var body in data)
        {
            if (body == null)
            {
                continue;
            }

            if (body.IsTracked)
            {
                trackedIds.Add(body.TrackingId);
            }
        }
        #endregion

        #region Delete Kinect bodies
        List<ulong> knownIds = new List<ulong>(mBodies.Keys);

        // First delete untracked bodies
        foreach (ulong trackingId in knownIds)
        {
            if (!trackedIds.Contains(trackingId))
            {
                Destroy(mBodies[trackingId]);
                mBodies.Remove(trackingId);
            }
        }
        #endregion

        #region Create Kinect bodies
        foreach (var body in data)
        {
            if (body == null)
            {
                continue;
            }

            if (body.IsTracked)
            {
                if (!mBodies.ContainsKey(body.TrackingId))
                {
                    mBodies[body.TrackingId] = CreateBodyObject(body.TrackingId);
                }

                RefreshBodyObject(body, mBodies[body.TrackingId]);
            }
        }
        #endregion


    }

    private GameObject CreateBodyObject(ulong id)
    {
        GameObject body = new GameObject("Body:" + id);

        foreach(JointType joint in _joints)
        {
            GameObject newJoint = Instantiate(mJointObject);
            newJoint.name = joint.ToString();

            newJoint.transform.parent = body.transform;
        }

        return body;
    }

    private void RefreshBodyObject(Body body, GameObject bodyObject)
    {
        foreach(JointType _joint in _joints)
        {
            Joint sourceJonint = body.Joints[_joint];
            Vector3 targetPosition = GetVector3FromJoint(sourceJonint);
            //targetPosition.z = 0;

            Transform jointObject = bodyObject.transform.Find(_joint.ToString());
            jointObject.position = targetPosition;
        }

        Vector3 Spine = GetVector3FromJoint(body.Joints[JointType.SpineShoulder]) - GetVector3FromJoint(body.Joints[JointType.SpineMid]);
        Vector3 Arm = GetVector3FromJoint(body.Joints[JointType.ShoulderRight]) -GetVector3FromJoint(body.Joints[JointType.ElbowRight]);

        Vector3 DotSpineX = new Vector3(Vector3.Dot(Spine, Vector3.right), Vector3.Dot(Spine, Vector3.up), Vector3.Dot(Spine, Vector3.forward));
        RightShoulderAngle.y = Vector3.SignedAngle(Spine, Arm, Vector3.up);
        RightShoulderAngle.z = Vector3.SignedAngle(Spine, Arm, Vector3.forward);
        RightShoulderAngle.x = Vector3.SignedAngle(Spine, Arm, Vector3.right);
    }

    private Vector3 GetVector3FromJoint(Joint joint)
    {
        return new Vector3(joint.Position.X * 10, joint.Position.Y * 10, joint.Position.Z * 10);
    }
}
