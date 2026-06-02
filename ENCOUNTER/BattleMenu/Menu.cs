using System.Collections.Generic;
using Godot;

namespace Twilight.Menu;

public abstract partial class Menu : Control
{
	[Export] protected Sprite2D CursorSprite;
	protected List<string> Options = [];
	protected List<Vector2I> CursorPositions = [];
	public int CursorIndex { get; protected set; } = 0;
	protected Tween Tween;

	protected EncounterContext Context { get; private set; }
	public void Bind(EncounterContext ctx) => Context = ctx;

	protected abstract Vector2 OpenPosition { get; }
	protected abstract Vector2 ClosedPosition { get; }

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

	public virtual void OnOpen(SelectionMemory memory)
	{
		CursorIndex = 0;
		Show();
		CursorSprite.Call("start_bounce");
		UpdateCursor();
	}

	// TODO: this isn't great in my opinion. the open/close mechanic for menus should be improved
	protected virtual bool ShouldCloseVisually(MenuState newState)
	{
		return true;
	}

	public void MoveUp(bool immediate)
	{
		Visible = true;
		Tween?.Kill();
		if (immediate)
			Position = OpenPosition;
		else
		{
			Tween = CreateTween();
			Tween.TweenProperty(this, "position", OpenPosition, 0.2f).SetTrans(Tween.TransitionType.Sine);
		}
	}

	public void MoveDown(MenuState newState, bool immediate)
	{
		if (ShouldCloseVisually(newState))
		{
			Tween?.Kill();
			if (immediate)
			{
				Position = ClosedPosition;
				Visible = false;
			}
			else
			{
				Tween = CreateTween();
				Tween.TweenProperty(this, "position", ClosedPosition, 0.2f).SetTrans(Tween.TransitionType.Sine);
				Tween.TweenCallback(Callable.From(() => Visible = false));
			}
		}
	}
}
