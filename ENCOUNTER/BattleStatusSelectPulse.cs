using Godot;

namespace Twilight;

/// <summary>
/// Handles the pulse effect whenever a party member is selecting their action
/// </summary>
public partial class BattleStatusSelectPulse : Sprite2D
{
    [Export] private float Duration = 0.5f;
    [Export] private float Delay = 0.5f;
    
    private Tween Tween;

    public override void _Ready()
    {
        Tween = CreateTween();
        Tween.Pause();
        Tween.SetTrans(Tween.TransitionType.Sine);
        Tween.TweenProperty(this, "modulate:a", 1f, Duration);
        Tween.TweenProperty(this, "modulate:a", 0f, Duration);
        Tween.TweenInterval(Delay);
        Tween.SetLoops();
    }

    /// <summary>
    /// Starts the pulse effect and shows the node
    /// </summary>
    public void StartPulse()
    {
        Tween.Play();
        Show();
    }

    /// <summary>
    /// Stops the pulse effect and hides the node
    /// </summary>
    public void StopPulse()
    {
        Tween.Stop();
        Hide();
    }
}