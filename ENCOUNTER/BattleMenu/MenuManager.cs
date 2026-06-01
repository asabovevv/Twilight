using System.Collections.Generic;
using Godot;

namespace Twilight.Menu;

public partial class MenuManager : Node
{
    [Export] private FightRunMenu FightRunMenu;
    [Export] private FSSTMenu FsstMenu;

    public MenuState CurrentState { get; private set; } = MenuState.None;
    private Menu CurrentMenu;

    private Dictionary<MenuState, Menu> Menus;

    public override void _EnterTree()
    {
        Menus = new Dictionary<MenuState, Menu>
        {
            { MenuState.FightRun, FightRunMenu },
            { MenuState.Fsst, FsstMenu },
        };
    }

    public override void _Process(double delta)
    {
        if (CurrentState is MenuState.None) 
            return;
        if (Input.IsActionJustPressed("Confirm"))
            CurrentMenu.OnInput(Vector2I.Zero);
        if (Input.IsActionJustPressed("Up"))
            CurrentMenu.OnInput(Vector2I.Up);
        else if (Input.IsActionJustPressed("Down"))
            CurrentMenu.OnInput(Vector2I.Down);
        else if (Input.IsActionJustPressed("Left"))
            CurrentMenu.OnInput(Vector2I.Left);
        else if (Input.IsActionJustPressed("Right"))
            CurrentMenu.OnInput(Vector2I.Right);
    }

    public void ShowMenu(MenuState state)
    {
        CurrentState = state;
        if (CurrentState is MenuState.None)
        {
            CurrentMenu = null;
        }
        
        CurrentMenu?.OnClose();
        CurrentMenu = Menus[CurrentState];
        CurrentMenu.OnOpen();
    }
    
}