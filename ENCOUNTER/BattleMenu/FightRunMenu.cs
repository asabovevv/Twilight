using Godot;

namespace Twilight.Menu;

public sealed partial class FightRunMenu : Menu
{
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
		// if (old != CursorIndex)
			// TODO: play sound
	}

	protected override void OnSelect()
	{
		CursorSprite.Call("stop_bounce");
		if (CursorIndex == 0)
		{
			EncounterManager.Instance.OnSelectFight();
		}
		else
		{
			GetTree().ChangeSceneToFile("res://ROOMS/a_Menus/InitRoom/startup.tscn");
		}
	}
}
