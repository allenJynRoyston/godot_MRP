extends AppWrapper

@onready var LoadingComponent:PanelContainer = $LoadingComponent
@onready var StoreComponent:PanelContainer = $StoreComponent
@onready var PauseContainer:PanelContainer = $PauseContainer
@onready var TransitionScreen:Control = $TransitionScreen

# ------------------------------------------------------------------------------
func _ready() -> void:
	# events
	StoreComponent.onBackToDesktop = func() -> void:
		await pause()
		GBL.find_node(REFS.OS_LAYOUT).return_to_desktop()
	
	StoreComponent.onMakePurchase = func(uid:String, cost:int) -> void:
		events.make_purchase.call(uid, cost)
		StoreComponent.purchased = events.fetch_purchases.call()
		
	# fetch purchased
	StoreComponent.purchased = events.fetch_purchases.call()
	
func start(fast_load:bool) -> void:
	LoadingComponent.loading_text = str(details.title).to_upper()
	await LoadingComponent.start(fast_load)
	await TransitionScreen.start(0.7, true)

	# start app
	StoreComponent.start()
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func quit(skip_close:bool = false) -> void:
	events.close.call()
	queue_free()
	
func on_taskbar_is_open_update(state:bool) -> void:
	await pause() if state else await unpause()

func pause() -> void:
	if !is_paused:
		is_paused = true
		await StoreComponent.pause()
		if is_visible_in_tree():
			PauseContainer.background_image = U.get_viewport_texture(GBL.find_node(REFS.MAIN_ACTIVE_VIEWPORT))	
		PauseContainer.show()
		StoreComponent.hide()
	#
func unpause() -> void:
	if is_paused:
		is_paused = false
		PauseContainer.hide()
		StoreComponent.show()
		await U.set_timeout(0.3)
		StoreComponent.unpause()
# ------------------------------------------------------------------------------
