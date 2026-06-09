@abstract class_name Effect

## Composable unit of skill/item behavior
# TODO: encounter context won't be available in the overworld
# branching out to execute_battle and execute_overworld may be nececessary
@abstract func execute(user : Actor, target : Actor, ctx : EncounterContext) -> void
