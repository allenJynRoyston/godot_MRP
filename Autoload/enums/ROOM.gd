@tool
extends Node

#enum PLACEMENT {
	#SURFACE = 0, 
	#B1 = 1, 
	#B2 = 2, 
	#B3 = 3, 
	#B4 = 4, 
	#B5 = 5,
	#
	#RING_A = 0, 
	#RING_B = 1,
	#RING_C = 2,
	#
	#R1 = 0, 
	#R2 = 1, 
	#R3 = 2, 
	#R4 = 3, 
	#R5 = 4
#}

enum EMERGENCY_MODES { NORMAL, CAUTION, WARNING, DANGER }

#enum TYPE { 
	#DIRECTORS_OFFICE, HQ, AQUISITION_DEPARTMENT,
	#R_AND_D_LAB, CONSTRUCTION_YARD,
	#BARRICKS, DORMITORY, HOLDING_CELLS,
	#ENGINEERING_BAY, 
	## 
	#HR_DEPARTMENT, HUME_DETECTOR,
	## BEFORE AN SCP CAN BE CONTAINED, IT HAS TO BE IN A 
	## ROOM THAT CAN CONTAIN IT
	#CONTAINMENT_CELL,
#}

enum CATEGORY {
	STANDARD, CONTAINMENT, SPECIAL
}
