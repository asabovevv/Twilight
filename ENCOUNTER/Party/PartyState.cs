using System;
using System.Collections.Generic;

namespace Twilight.Party;

/// <summary>
/// Handles the current state of the party, as well as things like turn order
/// </summary>
public sealed class PartyState
{
    public IReadOnlyList<PartyMember> Members { get; }
    public int Count => Members.Count;

    public int CurrentSelectedIndex { get; private set; } = -1;
    public PartyMember CurrentSelected => CurrentSelectedIndex >= 0 ? Members[CurrentSelectedIndex] : null;

    /// <summary>Fires (oldIndex, newIndex) whenever the selected member changes.</summary>
    public event Action<int, int> SelectionChanged;

    public PartyState(List<PartyMember> members)
    {
        Members = members;
    }

    public void SelectFirst() => SetSelection(0);

    // temporary behavior: cycles to the next member
    public void SelectNext() => SetSelection(CurrentSelectedIndex < 0 ? 0 : (CurrentSelectedIndex + 1) % Count);

    public bool Back()
    {
        if (CurrentSelectedIndex < 0)
            return false;
        SetSelection(CurrentSelectedIndex - 1);   // emits; -1 clears the pulse in PartyView
        return CurrentSelectedIndex >= 0;
    }

    private void SetSelection(int index)
    {
        int old = CurrentSelectedIndex;
        CurrentSelectedIndex = index;
        SelectionChanged?.Invoke(old, index);
    }
}
