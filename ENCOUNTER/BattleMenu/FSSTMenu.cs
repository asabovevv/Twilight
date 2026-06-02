using System;
using Godot;

namespace Twilight.Menu;

public sealed partial class FSSTMenu : Menu
{
	private Vector2I GridSize = new(2, 2);
	protected override Vector2 OpenPosition => Vector2.Zero;
	protected override Vector2 ClosedPosition => new(0f, 95f);
	
	public override void _Ready()
	{
		Options = ["Attack", "Skill", "Snack", "Toy"];
		CursorPositions = [new Vector2I(170, 405), new Vector2I(350, 405), new Vector2I(170, 450), new Vector2I(350, 450)];
	}

	public override void OnOpen(SelectionMemory memory)
	{
		CursorIndex = memory.SavedIndex;
		CursorSprite.Call("start_bounce");
		UpdateCursor();
		Show();
	}

	protected override void MoveCursor(Vector2I direction)
	{
		int old = CursorIndex;
		if (direction == Vector2.Left)
			CursorIndex = Math.Max(CursorIndex - 1, 0);
		else if (direction == Vector2.Right)
			CursorIndex = Math.Min(CursorIndex + 1, CursorPositions.Count - 1);
		else if (direction == Vector2.Up)
		{
			if (CursorIndex > 1)
				CursorIndex -= 2;
		}
		else if (direction == Vector2.Down)
		{
			if (CursorIndex < 2)
				CursorIndex += 2;
		}
		UpdateCursor();
		if (old != CursorIndex)
			AudioBridge.PlaySFX("SE_move1", 0.9f);
	}

	protected override void OnSelect()
	{
		AudioBridge.PlaySFX("SE_select", 0.9f);
		Context.Turn.OnSelectAction(CursorIndex);
	}

	protected override bool ShouldCloseVisually(MenuState newState)
	{
		return newState is MenuState.FightRun or MenuState.None or MenuState.Fsst;
	}
}
