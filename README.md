
# Table of Contents

1.  [Installation](#orgbfc52c0)
2.  [Features](#org5f94ae5)
    1.  [Syntax highlighting](#orgad84104)
    2.  [Special Character Insertion](#org69ad36b)
    3.  [Audio Playback](#org51c23a6)
        1.  [Shortcuts](#org8c9c265)
3.  [More Information](#org70b5368)


<a id="orgbfc52c0"></a>

# Installation

Clone the git repo and add to following to your `init.el`:

    (load-file "/path/to/clan-mode.el")
    (add-to-list 'auto-mode-alist '("\\.cha" . clan-mode))

with your path. 

The first line installs clan-mode. The second line auto-loads `clan-mode` when you open a `*.cha` file

Then, either `eval-buffer` your `init.el` or restart Emacs for the changes to take effect.


<a id="org5f94ae5"></a>

# Features


<a id="orgad84104"></a>

## Syntax highlighting

`clan-mode` supports header syntax highlighting for `@Item` headers. It highlights speakers of the form `*Name:` and it highlights the timestamps in `•12345_67890•`.


<a id="org69ad36b"></a>

## Special Character Insertion

`clan-mode` adds a menu option called "Clan-Mode" which has the major Jeffersonian transcription symbols. It also has CLAN-style keyboard shortcuts for these symbols. The keyboard shortcuts can be found in the Clan-Mode menu.

The "•" symbol is bound to `C-o`.

To ensure that these symbols load properly, you can use [CAFont](http://dali.talkbank.org/clan/CAfont.otf). To load CAFont into Emacs, add the following to your `init.el`:

    (set-frame-font "CAFont 14")

where 14 is the size that you prefer. Alternatively, use `M-x set-frame-font`.


<a id="org51c23a6"></a>

## Audio Playback

`clan-mode` supports audio playback through `ffplay`, part of the [`ffmpeg`](https://ffmpeg.org/) package. Please ensure that `ffplay` is in your `PATH` in order to support audio playback.

The audio is linked to the file specified by the `@Media` tag in the clan file. 


<a id="org8c9c265"></a>

### Shortcuts

-   `C-c l` Plays the section of the audio file between the timestamps of turn at the point.
-   `C-c p` Plays the audio file beginning at the start of the turn at the point.
-   `C-c s` Stops any audio playing.


<a id="org70b5368"></a>

# More Information

The CLAN manual can be found [here](https://talkbank.org/manuals/CLAN.pdf). A guide to CLAN can be found [here](https://talkbank.org/manuals/Clin-CLAN.pdf). While `clan-mode` does not implement all of these features, they are the standard sources for the `.cha` schema.

