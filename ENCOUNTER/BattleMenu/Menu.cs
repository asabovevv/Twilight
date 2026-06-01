using System.Collections.Generic;
using Godot;

namespace Twilight.Menu;

public abstract partial class Menu : Node2D
{
	[Export] protected Sprite2D CursorSprite;
	protected List<string> Options = [];
	protected List<Vector2I> CursorPositions = [];
	public int CursorIndex { get; protected set; } = 0;

	public void OnInput(Vector2I direction)
	{
		if (direction == Vector2I.Zero)
			OnSelect();
		else
			MoveCursor(direction);
	}
	
	protected virtual void MoveCursor(Vector2I direction) {}

	protected virtual void UpdateCursor()
	{
		CursorSprite.Position = CursorPositions[CursorIndex];
	}
	
	protected abstract void OnSelect();
	
	public virtual void OnOpen() 
	{
		CursorIndex = 0;
		Show();
		CursorSprite.Call("start_bounce");
		UpdateCursor();
	}

	public virtual void OnClose()
	{
		Hide();
	}
}
