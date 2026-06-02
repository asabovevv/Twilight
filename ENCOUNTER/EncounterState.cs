using System;

namespace Twilight;

/// <summary>
/// Handles generic encounter information, such as the party's power and the current phase
/// </summary>
public sealed class EncounterState
{
    public event Action<int> PowerChanged;

    private int _power;
    public int Power
    {
        get => _power;
        set { _power = value; PowerChanged?.Invoke(value); }
    }

    public EncounterState(int startingPower)
    {
        _power = startingPower;
    }
}