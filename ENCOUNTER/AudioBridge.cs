using Godot;

namespace Twilight;

// since we can't directly access GDScript autoloads from C#, neatly wrap the calls in a bridge class
public static class AudioBridge
{
    private static Node _audio;
    private static Node Audio => _audio ??= Engine.GetMainLoop() is SceneTree tree ? tree.Root.GetNode("Audio") : null;
    private static readonly StringName PlaySFXMethod = new("play_sfx");
    private static readonly StringName PlayBGMMethod = new("play_bgm");

    public static void PlaySFX(string name, float volume = 1f, float pitch = 1f)
    {
        Audio.Call(PlaySFXMethod, name, volume, pitch);
    }

    public static void PlayBGM(string name, float volume = 1f, float pitch = 1f)
    {
        Audio.Call(PlayBGMMethod, name, volume, pitch);
    }
}
