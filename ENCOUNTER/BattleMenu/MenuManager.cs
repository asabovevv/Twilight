using System.Collections.Generic;
using System.Linq;
using Godot;
using Twilight.Party;

namespace Twilight.Menu;

public partial class MenuManager : Node, IEncounterService
{
	[Export] private FightRunMenu FightRunMenu;
	[Export] private FSSTMenu FsstMenu;
	[Export] private SkillMenu SkillMenu;
	[Export] private ItemMenu SnackMenu;
	[Export] private ItemMenu ToyMenu;

	public MenuState CurrentState { get; private set; } = MenuState.None;
	private Menu CurrentMenu;

	private Dictionary<MenuState, Menu> Menus;
	private Dictionary<PartyMember, SelectionMemory> LastSelected = [];

	private EncounterContext Context;
	
	// TODO: selection memory

	public override void _EnterTree()
	{
		Menus = new Dictionary<MenuState, Menu>
		{
			{ MenuState.FightRun, FightRunMenu },
			{ MenuState.Fsst, FsstMenu },
			{ MenuState.Skill, SkillMenu },
			{ MenuState.Snack, SnackMenu },
			{ MenuState.Toy, ToyMenu }
		};
	}

	public void Initialize(EncounterContext ctx)
	{
		Context = ctx;
		foreach (var (_, menu) in Menus)
			menu.Bind(ctx);
	}

	public override void _Process(double delta)
	{
		if (CurrentState is MenuState.None)
			return;
		if (Input.IsActionJustPressed("Cancel"))
		{
			Context.Turn.OnCancel();
			return;
		}
		if (Input.IsActionJustPressed("Confirm"))
			CurrentMenu.OnInput(Vector2I.Zero);
		else if (Input.IsActionJustPressed("Up"))
			CurrentMenu.OnInput(Vector2I.Up);
		else if (Input.IsActionJustPressed("Down"))
			CurrentMenu.OnInput(Vector2I.Down);
		else if (Input.IsActionJustPressed("Left"))
			CurrentMenu.OnInput(Vector2I.Left);
		else if (Input.IsActionJustPressed("Right"))
			CurrentMenu.OnInput(Vector2I.Right);
	}

	public void ShowMenu(MenuState state, bool immediate = false, bool ignoreMemory = false)
	{
		CurrentState = state;
		if (CurrentState is MenuState.None)
		{
			foreach (Menu open in Menus.Values.Where(x => x.Visible))
				open.MoveDown(state, immediate);
			CurrentMenu = null;
			return;
		}

		CurrentMenu?.MoveDown(state, immediate);
		CurrentMenu = Menus[CurrentState];
		PartyMember current = Context.Party.CurrentSelected;
		if (ignoreMemory)
			CurrentMenu.OnOpen(new SelectionMemory(CurrentState, CurrentMenu.CursorIndex));
		else if (current != null && LastSelected.TryGetValue(current, out SelectionMemory selected))
			CurrentMenu.OnOpen(selected);
		else
			CurrentMenu.OnOpen(new SelectionMemory(CurrentState, 0));
		CurrentMenu.MoveUp(immediate);
	}

	public void SaveLastSelected(PartyMember member)
	{
		LastSelected[member] = new SelectionMemory(CurrentState, CurrentMenu.CursorIndex);
	}
	
	public void ClearLastSelected()
	{
		LastSelected.Clear();
	}
}
