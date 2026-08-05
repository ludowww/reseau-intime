extends RefCounted

class_name R8CPlayerProjectionPort

const Contracts := preload("res://scripts/unified_runtime/contracts/PlayerProjectionContracts.gd")

const ABSTRACT_PORT := true
const METHOD_NAMES := [
	"supports_projection",
	"open",
	"submit",
	"acknowledge",
	"snapshot",
	"restore",
	"close",
]


## Reports whether this port can project one closed N11 projection target.
func supports_projection(_projection_target: String) -> Dictionary:
	return {"supported": false, "error_code": "NOT_IMPLEMENTED"}


## Opens one validated ProjectionRequest without mutating authored or durable state.
func open(request: Dictionary) -> Dictionary:
	return Contracts.not_implemented_result(request.get("projection_target", "NONE"))


## Receives one validated player ProjectionCommand.
func submit(_command: Dictionary) -> Dictionary:
	return Contracts.not_implemented_result()


## Acknowledges one validated PresentationReceipt.
func acknowledge(_receipt: Dictionary) -> Dictionary:
	return Contracts.not_implemented_result()


## Returns only the port's bounded operational snapshot.
func snapshot() -> Dictionary:
	return {"accepted": false, "snapshot": {}, "error_code": "NOT_IMPLEMENTED"}


## Restores one validated operational snapshot without touching durable state.
func restore(_snapshot: Dictionary) -> Dictionary:
	return {"accepted": false, "error_code": "NOT_IMPLEMENTED"}


## Closes one projection presentation without creating a narrative withdrawal.
func close(_presentation_id: String) -> Dictionary:
	return Contracts.not_implemented_result()
