using Godot;

namespace Twilight.Menu;

public sealed partial class ItemMenu : Menu
{
    private Vector2I GridSize = new(2, 2);

    protected override Vector2 OpenPosition => new(142f, 378f); 
    protected override Vector2 ClosedPosition => new(142f, 482f);

    public override void _Ready()
    {
        CursorPositions = [new Vector2I(20, 43)];
    }
    
    protected override void MoveCursor(Vector2I direction)
    {
        // TODO: implement
    }

    protected override void OnSelect()
    {
        // TODO: implement
    }
}