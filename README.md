# VR-movement-tracking
VR headset and controller movement tracking in Godot

This plugin is to: to track the users head and arm movement and it can measure VR Jitter.

![image](https://user-images.githubusercontent.com/71565433/236815091-01326921-bf25-4b3c-bcd8-f273f6b06b53.png)


How to use:
- It can be added to the scene as a new node.
- It is needed to fill the External script variables.
- ![image](https://user-images.githubusercontent.com/71565433/236815679-15561aa6-0581-4dfb-9bec-d285c4b044e0.png)
- The data is being saved in the "res://addons/movement_tracker/Data/" folder.
- The ouptut is a USER_counter_DATE.txt file.
- The Jitter is calculated by Standard Deviation. The deviation of the position of VR glasses and controllers in physical and virtual space can be measured.

Created in the BioTech Research Center at Óbuda University.
