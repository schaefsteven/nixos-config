# Notes
## Arion
- Motu CueMix is not included (binary too big to commit.) Place the dir at `/home/usr/.config/motu/com.motu.CueMix5-1.0.0`A desktop entry is included, so if electron is installed and the app is in the right spot, it should work.

## Firefox
- Can't set `full-screen-api.ignore-widgets = true` from nix because Firefox doesn't allow it for "stability reasons."
- Can set ui.prefersReducedMotion, but using 1 makes it true instead of 1 which does not work
- Might be able to include userChrome.css, but not trying for now.
- SearchEngines.Default is only supported in ESR for some reason? 


# Todo:
hugo
media player
minecraft
obs
vm support
