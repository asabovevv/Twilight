class_name GameDataRegistry

var _items : Dictionary[String, Variant]

## Registers a new item in the registry. Will push an error if the [param id] is already defined.
func register(id : String, item : Variant):
	if _items.has(id):
		push_error("Registry already has ID %s defined." % id)
		return
	_items[id] = item

## Retrieves an item from the registry. Will return [code]null[/code] if no item is defined.
func try_get(id : String) -> Variant:
	var result = _items.get(id, null)
	if !result:
		push_error("Registry does not have a definition for ID %s." % id)
	return result

## Checks if an item is in the registry.
func has(id : String) -> bool:
	return _items.has(id)

## Retrieves all items from the registry as an [Array].
func all() -> Array:
	return _items.values()

## The number of items in the registry.
func count() -> int:
	return _items.size()
