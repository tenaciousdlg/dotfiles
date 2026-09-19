# themes

One palette, applied everywhere, so the editor / terminal / vault stop looking
like three unrelated tools.

`night-owl.json` is the source of truth. It matches
`vscode/settings.json` → `workbench.colorTheme: "Night Owl (No Italics)"`.

| surface | how it consumes this |
|---|---|
| VS Code | already set in `vscode/settings.json` — nothing to do |
| Windows Terminal | paste the object into `schemes[]`, set `colorScheme` on the WSL + PowerShell profiles |
| iTerm2 | `bin/night-owl-iterm` writes a `.itermcolors` to import |
| Obsidian | `vault/.obsidian/snippets/night-owl.css`, enabled in `appearance.json` |
| p10k prompt | already close (dir=31 teal, anchor=39 blue, vcs=76 green) |

Font across all of them: **MesloLGS NF** (p10k needs a Nerd Font for glyphs;
without it the prompt renders as boxes — which is why it looked wrong in WSL
until it was installed).
