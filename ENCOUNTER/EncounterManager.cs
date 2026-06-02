using Godot;
using Twilight.BattleLog;
using Twilight.Menu;
using Twilight.Party;

namespace Twilight;

public partial class EncounterManager : Node
{
	[Export] private MenuManager MenuManager;
	[Export] private BattleLogManager BattleLogManager;
	[Export] private PartyView PartyView;
	[Export] private PowerBarView PowerBar;

	[Export] public int StartingPower = 3;

	public override void _Ready()
	{
		EncounterState state = new(StartingPower);
		// temporary, this will eventually pull stats etc.
		PartyState party = new([
			new PartyMember { Name = "Aubrey" },
			new PartyMember { Name = "Sunny" },
			new PartyMember { Name = "Kel" },
			new PartyMember { Name = "Hero" },
		]);
		TurnManager turn = new();
		EncounterContext ctx = new()
		{
			Menu = MenuManager,
			BattleLog = BattleLogManager,
			Turn = turn,
			Party = party,
			State = state
		};

		MenuManager.Initialize(ctx);
		BattleLogManager.Initialize(ctx);
		PartyView.Initialize(ctx);
		PowerBar.Initialize(ctx);
		turn.Initialize(ctx);

		turn.StartBattle();
	}
}
