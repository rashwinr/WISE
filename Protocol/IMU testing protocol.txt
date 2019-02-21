# IMU testing protocol

An IMU testing turn-table is built using a goniometer to measure the accuracy of the angle measurements obtained from the IMU sensors. One end of the goniometer is fixed to the table allowing another end of the goniometer to move freely between 0 to 360 degrees. The IMUs soldered to a PCB board are fitted in rectangular 3D printed enclosures, (3D models available in 3D model folder). The IMU enclosures are fixed on the free end of the goniometer for angular movement. The free-end of the goniometer fitted with IMU is restricted for motion about set angles such as (-80, -60, -40, -20, 20, 40, 60, 80) for angle measurement study. The PCB connected with IMUs stream quaternions to the receiver connected to computer for display of angle measurements. A software application using unity3D is developed for streaming the data from receiver through serial communication, convert them to corresponding angle measurements, and display the angle measurements from all the IMUs. 

The software application starts with a user details page where the user can specify relevant information about them such as: subject ID, age group, dexterity, and gender. A start button is present to initialize serial communication and navigate to another page for display of angle measurements. The data being streamed from the IMUs are saved in a text file for further data processing. The nomenclature of the file is defined by the subject ID, time, and date of start of the experiment for easy retrieval and tracking.

The following steps are performed as a protocol for testing of the IMUs:
1.	An executable application generated from the Unity3D is started.
2.	All the PCBs fitted with IMUs are turned on, each have an individual switch.
3.	Stoppers are added at specific locations for specific angles being tested. (E.g. Testing of +80 degrees will require adding stoppers at 0 degrees and 80 degrees.)
4.	The receiver is connected to the computer using USB type-A port.
5.	The user details page is filled with relevant information pertaining to the trial being performed. (E.g. The angle and axis used for testing is entered in the subject ID textbox.)
6.	Click the start button, which redirects the application to another page for display of X, Y, and Z angles of IMUs A, B, C, and D.
7.	The free-end of the goniometer attached with IMUs are moved between desired angle of the trial for measurement. It is repeated to record at least 25 trials, which is also being recorded on a video tape.
8.	The application is enabled with data capture facility and saves it in a text file. 
9.	A matlab script is used to read the text files and extract the measured angles and print them to excel.
10.	 Mean and standard deviation are computed for 20 trials of the measurement.
11.	Plots of the applied angle vs. goniometer measured angle are shown in graph.
12.	The coefficient of determination is used for correlation of the data.
