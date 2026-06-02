using System.Collections.Generic;
using Godot;

namespace Twilight.BattleLog;

public partial class BattleLogManager : Node, IEncounterService
{
    [Signal]
    public delegate void FinishedLoggingEventHandler();

    [Export] private PackedScene LogLine;
    [Export] private RichTextLabel ImmediateLabel;

    private readonly Queue<string> MessageQueue = [];
    private readonly Queue<string> LineQueue = [];
    private readonly List<Control> ActiveLines = [];
    
    private EncounterContext Context;

    public void Initialize(EncounterContext ctx)
    {
        Context = ctx;
    }
    
    public void ShowMessage(string message)
    {
        ImmediateLabel.Text = message;
    }

    public void ClearAndShowMessage(string message)
    {
        ClearBattleLog();
        ShowMessage(message);
    }

    public void ClearBattleLog()
    {
        MessageQueue.Clear();
        LineQueue.Clear();
        ActiveLines.ForEach(x => x.QueueFree());
        ActiveLines.Clear();
        ImmediateLabel.Text = "";
    }
}