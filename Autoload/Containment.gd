extends Node

#const NONE:Dictionary = {
	#"name": 'NONE'
#}
#
#const ONE:Dictionary = {
	#"name": 'ONE',
	#"containment_reward": [
		#[RESOURCE.TYPE.MONEY, 35]
	#],
	#"required_resources": [ 
		#[RESOURCE.TYPE.STAFF, 3] 
	#]
#}
#
#const TWO:Dictionary = {
	#"name": 'TWO',
	#"containment_reward": [
		#[RESOURCE.MONEY, 50]
	#],
	#"required_resources": [ 
		#[RESOURCE.STAFF, 5] 
	#]	
#}
#
#const reference_data:Dictionary = {
	#SCP.NONE: NONE,
	#SCP.ONE: ONE,
	#SCP.TWO: TWO
#}
#
## ------------------------------------------------------------------------------
#func get_reference_data(item:int) -> Dictionary:
	#return reference_data[item]
## ------------------------------------------------------------------------------	
