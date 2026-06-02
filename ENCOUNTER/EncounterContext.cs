using Twilight.BattleLog;
using Twilight.Menu;
using Twilight.Party;

namespace Twilight;

/// <summary>
/// Pseudo Dependency Injection that gets passed between classes that need the information
/// </summary>
public sealed class EncounterContext
{
    public required MenuManager Menu { get; init; }
    public required BattleLogManager BattleLog { get; init; }
    public required TurnManager Turn { get; init; }
    public required PartyState Party { get; init; }
    public required EncounterState State { get; init; }
}