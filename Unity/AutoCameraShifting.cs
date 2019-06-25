using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AutoCameraShifting : MonoBehaviour
{
    public DeviceManager DM;
    public PlayerController PC;
    public void CameraShiftFront()
    {
        if (!DM.CameraChangeDone)
        {
            DM.CameraView.value = 1;
            DM.ChangeCameraView();
            DM.CameraChangeDone = true;
        }
    }

    public void CameraShiftBack()
    {
        if (!DM.CameraChangeDone)
        {
            DM.CameraView.value = 0;
            DM.ChangeCameraView();
            DM.CameraChangeDone = true;
        }
    }

    public void CameraShiftRight()
    {
        if (!DM.CameraChangeDone)
        {
            DM.CameraView.value = 2;
            DM.ChangeCameraView();
            DM.CameraChangeDone = true;
        }
    }

    public void CameraShiftLeft()
    {
        if (!DM.CameraChangeDone)
        {
            DM.CameraView.value = 3;
            DM.ChangeCameraView();
            DM.CameraChangeDone = true;
        }
    }

    public void NextActivityIteration()
    {
        PC.ActivityIteration++;
    }
}
