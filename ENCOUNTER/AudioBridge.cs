using Godot;

namespace Twilight;

// since we can't directly access GDScript autoloads from C#, neatly wrap the calls in a bridge class
public partial class AudioBridge : Node
{
    private static Node Audio;

    public override void _Ready()
    {
        Audio = GetNode<Node>("/root/Audio");
    }

    public static void PlaySFX(string name, float volume = 1f, float pitch = 1f)
    {
        Audio.Call("play_sfx", name, volume, pitch);
    }

    public static void PlayBGM(string name, float volume = 1f, float pitch = 1f)
    {
        Audio.Call("play_bgm", name, volume, pitch);
    }
}