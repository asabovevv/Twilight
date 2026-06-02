using System.Collections.Generic;
using Godot;

namespace Twilight.Party;

public partial class PartyView : Node2D, IEncounterService
{
    [Export] private PackedScene BattleStatus;

    private readonly List<Control> Statuses = [];
    private EncounterContext Context;

    public void Initialize(EncounterContext ctx)
    {
        Context = ctx;
        Spawn(ctx.Party);
        ctx.Party.SelectionChanged += OnSelectionChanged;
    }

    private void Spawn(PartyState party)
    {
        for (int i = 0; i < party.Members.Count; i++)
        {
            Control status = BattleStatus.Instantiate<Control>();
            AddChild(status);
            status.Position = i switch
            {
                0 => new Vector2(14, 305),
                1 => new Vector2(14, 5),
                2 => new Vector2(512, 305),
                3 => new Vector2(512, 5),
                _ => Vector2.Zero
            };
            ApplyPortrait(status, party.Members[i].Name);
            Statuses.Add(status);
        }
    }

    // temporary for mockup
    private void ApplyPortrait(Control status, string name)
    {
        Texture2D tex = ResourceLoader.Load<Texture2D>($"res://CHARACTERS/{name}/Portraits/Portrait0.png");
        AtlasTexture texture = new()
        {
            Atlas = tex,
            Region = new Rect2(0, 0, tex.GetWidth() / 3f, tex.GetHeight())
        };
        SpriteFrames frames = new();
        frames.AddFrame("default", texture);
        status.GetChild<AnimatedSprite2D>(1).SpriteFrames = frames;
    }

    private void OnSelectionChanged(int oldIndex, int newIndex)
    {
        if (oldIndex >= 0) StopPulse(oldIndex);
        if (newIndex >= 0) StartPulse(newIndex);
    }

    private void StartPulse(int i)
    {
        // temporary: child selection
        BattleStatusSelectPulse pulse = Statuses[i].GetChild<BattleStatusSelectPulse>(4);
        pulse.StartPulse();
    }

    private void StopPulse(int i)
    {
        // temporary: child selection
        BattleStatusSelectPulse pulse = Statuses[i].GetChild<BattleStatusSelectPulse>(4);
        pulse.StopPulse();
    }

    public override void _ExitTree()
    {
        if (Context is not null)
            Context.Party.SelectionChanged -= OnSelectionChanged;
    }
}
