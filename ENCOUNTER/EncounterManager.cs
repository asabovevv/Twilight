using Godot;
using System;
using System.Collections.Generic;
using Twilight.Menu;

namespace Twilight;

public partial class EncounterManager : Node
{
	[Export] private Label PowerNum;
	[Export] private Sprite2D PowerBar;
	[Export] private Sprite2D PowerBarDots;
	[Export] private PackedScene BattleStatus;
	[Export] private Node2D PartyRoot;
	[Export] private MenuManager MenuManager;

	// TODO: move these to their own audio manager
	[Export] private AudioStreamPlayer BGM;
	/* TODO: utilize all ten (or more) preallocated SFX players
	 * preallocation prevents constantly creating/destroying nodes
	 * whenever we need to play sfx, which is expensive
	 */
	[Export] private AudioStreamPlayer SFX;

	[Export] public int StartingPower = 3;
	
	public static EncounterManager Instance { get; private set; }

	private List<Control> CurrentParty = [];

	private int _Power = 0;

	/// <summary>
	/// The party's power (energy)
	/// </summary>
	public int Power
	{
		get => _Power;
		private set
		{
			_Power = value;
			PowerNum.Text = $"{value:00}";
			PowerBar.RegionRect = new Rect2(0, (float)Math.Ceiling(Power / 3f) * 45f, PowerBar.RegionRect.Size.X, PowerBar.RegionRect.Size.Y);
			PowerBarDots.Frame = value;
		}
	}

	public override void _EnterTree()
	{
		Instance = this;
	}

	public override void _Ready()
	{
		Power = StartingPower;
		
		for (int i = 0; i < 4; i++)
			SpawnPartyMember(i);
		
		MenuManager.ShowMenu(MenuState.FightRun);
	}
	
	public override void _Process(double delta)
	{
		if (Input.IsActionJustPressed("Cancel"))
		{
			if (MenuManager.CurrentState is MenuState.Fsst)
			{
				MenuManager.ShowMenu(MenuState.FightRun);
				CurrentParty[0].GetChild(4).Call("stop_pulse");
			}
		}
	}

	public void OnSelectFight()
	{
		MenuManager.ShowMenu(MenuState.Fsst);
		CurrentParty[0].GetChild(4).Call("start_pulse");
	}

	private void SpawnPartyMember(int position)
	{
		Control status = BattleStatus.Instantiate<Control>();
		PartyRoot.AddChild(status);
		status.Position = position switch
		{
			0 => new Vector2(14, 305),
			1 => new Vector2(14, 5),
			2 => new Vector2(512, 305),
			3 => new Vector2(512, 5),
			_ => Vector2.Zero
		};
		
		// TODO: remove below. this is all temporary for visual effect
		string name = position switch
		{
			0 => "Aubrey",
			1 => "Sunny",
			2 => "Kel",
			3 => "Hero",
			_ => string.Empty
		};

		Texture2D tex = ResourceLoader.Load<Texture2D>($"res://CHARACTERS/{name}/Portraits/Portrait0.png");
		AtlasTexture texture = new()
		{
			Atlas = tex,
			Region = new Rect2(0, 0, tex.GetWidth() / 3f, tex.GetHeight())
		};
		AnimatedSprite2D profile = status.GetChild<AnimatedSprite2D>(1);
		SpriteFrames frames = new();
		frames.AddFrame("default", texture);
		profile.SpriteFrames = frames;
		
		CurrentParty.Add(status);
	}
}
