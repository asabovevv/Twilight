using System;
using Godot;

namespace Twilight;

public partial class PowerBarView : Node2D, IEncounterService
{
    [Export] private Label PowerNum;
    [Export] private Sprite2D PowerBar;
    [Export] private Sprite2D PowerBarDots;

    private EncounterContext Context;

    public void Initialize(EncounterContext context)
    {
        Context = context;
        Update(context.State.Power);
        context.State.PowerChanged += Update;
    }

    private void Update(int value)
    {
        PowerNum.Text = $"{value:00}";
        PowerBar.RegionRect = new Rect2(0, (float)Math.Ceiling(value / 3f) * 45f, PowerBar.RegionRect.Size.X, PowerBar.RegionRect.Size.Y);
        PowerBarDots.Frame = value;
    }

    public override void _ExitTree()
    {
        if (Context is not null)
            Context.State.PowerChanged -= Update;
    }
}