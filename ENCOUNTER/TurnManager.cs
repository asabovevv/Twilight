using Twilight.Menu;

namespace Twilight;

public sealed class TurnManager : IEncounterService
{
    private EncounterContext Context;

    public void Initialize(EncounterContext context)
    {
        Context = context;
    }

    public void StartBattle()
    {
        Context.Menu.ShowMenu(MenuState.FightRun);
        Context.BattleLog.ShowMessage("What will AUBREY and friends do?");
    }

    public void OnSelectFight()
    {
        Context.Menu.ShowMenu(MenuState.Fsst, true);
        Context.Party.SelectFirst();
        Context.BattleLog.ShowMessage($"What will {Context.Party.CurrentSelected.Name.ToUpper()} do?");
    }

    public void OnSelectRun()
    {
        // temporary
        Context.Menu.GetTree().ChangeSceneToFile("res://ROOMS/a_Menus/InitRoom/startup.tscn");
    }

    // index: 0 = Attack, 1 = Skill, 2 = Snack, 3 = Toy
    public void OnSelectAction(int index)
    {
        Context.Menu.SaveLastSelected(Context.Party.CurrentSelected);
        switch (index)
        {
            case 0: // temporary: cycle to the next member
                Context.Party.SelectNext();
                Context.BattleLog.ShowMessage($"What will {Context.Party.CurrentSelected.Name.ToUpper()} do?");
                break;
            case 1: Context.Menu.ShowMenu(MenuState.Skill); break;
            case 2: Context.Menu.ShowMenu(MenuState.Snack); break;
            case 3: Context.Menu.ShowMenu(MenuState.Toy); break;
        }
    }

    public void OnCancel()
    {
        switch (Context.Menu.CurrentState)
        {
            case MenuState.Fsst:
                AudioBridge.PlaySFX("SE_cancel", 0.9f);
                if (Context.Party.Back())
                    Context.BattleLog.ShowMessage($"What will {Context.Party.CurrentSelected.Name.ToUpper()} do?");
                else
                {
                    Context.Menu.ShowMenu(MenuState.FightRun, true);
                    Context.BattleLog.ShowMessage("What will AUBREY and friends do?");
                }
                break;
            case MenuState.Skill:
            case MenuState.Snack:
            case MenuState.Toy:
                AudioBridge.PlaySFX("SE_cancel", 0.9f);
                Context.Menu.ShowMenu(MenuState.Fsst);
                break;
        }
    }
}
