using Godot;

namespace Twilight.Menu;

public sealed partial class FightRunMenu : Menu
{
	protected override Vector2 OpenPosition => Vector2.Zero;
	protected override Vector2 ClosedPosition => new(0f, 95f);
	
	public override void _Ready()
	{
		Options = ["Fight", "Run"];
		CursorPositions = [new Vector2I(253, 407), new Vector2I(253, 451)];
	}

	protected override void MoveCursor(Vector2I direction)
	{
		int old = CursorIndex;
		CursorIndex = (CursorIndex + direction.Y + Options.Count) % Options.Count;
		UpdateCursor();
		if (old != CursorIndex)
			AudioBridge.PlaySFX("SE_move1", 0.9f);
	}

	protected override void OnSelect()
	{
		CursorSprite.Call("stop_bounce");
		AudioBridge.PlaySFX("SE_select", 0.9f);
		if (CursorIndex == 0)
			Context.Turn.OnSelectFight();
		else
			Context.Turn.OnSelectRun();
	}
}
