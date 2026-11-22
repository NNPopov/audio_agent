# Audio Agent: public site and builds

This repository holds the public web page of Audio Agent (a voice assistant for Android) and the list of its public builds. It contains no app source code.

**Status: ALPHA.** Earlier than beta. It is experimental software made by one person: expect bugs, missing features and changes without notice, and do not rely on it for anything important or safety-critical. No guarantee of support or updates.

Audio Agent works with one button, a Bluetooth remote control or a keyboard, so it can be used by blind and low-vision people and by people with limited use of their hands. You speak, it answers aloud and can play music, set timers and reminders, keep notes, check the weather and help you call a contact. It needs your own API keys for Qwen and DeepSeek.

## Install

Requires Android 12 or newer. The app is not in Google Play.

1. Open the project's GitHub Releases page and download the APK of the latest alpha build (the home page of the site links to it, and lists the SHA-256 of every build).
2. Open the file on the phone. Android asks to allow installing apps from that source (your browser or file manager): allow it for this install. Play Protect may warn that the app is unknown; that is expected for an app outside Google Play.
3. Open Audio Agent, read the first screens (they explain each permission) and enter your own API keys in Settings.

## Data

The app has no server of its own, no accounts, no analytics and no advertising. Your voice and requests go from your phone straight to the AI providers whose keys you entered. This site makes no requests to third parties (no CDN, no fonts, no analytics). Read the full [privacy policy](site/policy/en.md) (also on the site at `privacy/`).

## Reporting problems

Use the Issues page of this repository: <https://github.com/NNPopov/audio_agent/issues>. Do not post API keys or private recordings. The contact address is set in one place, `site/config.json` (field `contact`, now `nn.popov@gmail.com`).

## License

- The website text and the privacy policy in this repository are licensed under [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/) (credit "Audio Agent" and link to this repository); see [LICENSE](LICENSE).
- The app builds (APKs, listed in `releases.json`) are all rights reserved, free for personal use, under the [Terms](TERMS.md) ([по-русски](TERMS.ru.md)). By downloading you accept the Terms.
- The source code is not published: it lives in a separate private repository. Open-sourcing is a possible later decision.

---

# For the maintainer

## Layout

| Path | What |
|---|---|
| `index.html`, `en/`, `ru/`, `privacy/`, `terms/`, `assets/` | The generated site (GitHub Pages serves the branch root). Do not edit by hand. |
| `site/config.json` | `contact`, `repo` (`OWNER/REPO` on GitHub), `appName`, minimum Android, how many alpha builds to keep |
| `site/i18n/<code>.json` | All home page texts of one language and the path of its policy file |
| `site/policy/<code>.md` | The privacy policy of that language (copied from the app repo, `docs/privacy-policy*.md`) |
| `LICENSE`, `TERMS.md`, `TERMS.<code>.md` | Licensing notice (CC BY 4.0 for the site text and the policy) and the terms of the app builds. The `TERMS` files are also the source of the `terms/` pages (path in `termsFile` of the i18n json) |
| `site/templates/` | HTML templates: `layout`, `home`, `policy`, `chooser` |
| `site/assets/style.css` | The one stylesheet (light and dark, no external fonts) |
| `releases.json` | The published builds, newest first |
| `builds/` | Local APKs, not committed (see `.gitignore`) |
| `tools/build-site.ps1` | Generates the site |
| `tools/update-releases.ps1` | Adds a build to `releases.json`, applies retention, rebuilds, prints the commands |
| `tools/check-site.ps1` | Checks the generated pages |

All scripts run in Windows PowerShell 5.1 and PowerShell 7 and need nothing installed.

## Commands

```
powershell -File tools/build-site.ps1       # regenerate the pages after any change in site/ or releases.json
powershell -File tools/check-site.ps1       # structure check: headings, skip link, language and policy links, no third-party requests
```

Before the first publish: set `repo` and `contact` in `site/config.json`, run the build, commit. On GitHub: Settings > Pages > deploy from branch `main`, folder `/ (root)`. `.nojekyll` is already there.

## Publishing a build (GitHub Releases)

APK files are not committed to git. Each build is a GitHub Release of its own (flag "pre-release" for alpha), and `releases.json` lists them.

1. In the app repository build the share release APK (`assembleShareRelease`; it must not contain the optional keys).
2. In the app repository run `powershell -File tools/publish-public-build.ps1 -Apk app/app/build/outputs/apk/share/release/app-share-release.apk -Notes "short note"` (add `-Stable` only when you decide that a build is stable; `-Version` is optional). It refuses an APK that contains secrets, copies the APK to `builds/`, updates `releases.json`, prunes, rebuilds the site and prints the `gh release create ...` command.
3. Run the printed `gh release create` command yourself, then commit and push the site (the script prints that too). Nothing is pushed or created by the scripts.

Home pages read `releases.json` in the browser to show the latest alpha and the table (progressive enhancement); without JavaScript they show the same table that the build script wrote into the page.

Retention: the newest 3 alpha builds and every stable build are kept. The script removes older entries from `releases.json` and prints the `gh release delete <tag> --cleanup-tag` commands for them; it never deletes anything itself. Change the number in `site/config.json` (`alphaKeep`).

## Adding a language

Planned, not yet available (no placeholder pages are published): Chinese (`zh`), Ukrainian (`uk`), German (`de`), Spanish (`es`), French (`fr`).

For a language code `xx`:

1. Copy `site/i18n/en.json` to `site/i18n/xx.json`. Translate every string in `t` and `tableLabel`, `policyBack`, `policyNotice` (the line that says the English version is the original, translations are for reference), set `nativeName`, `dir` (`ltr` or `rtl`), `policyFile` (`site/policy/xx.md`) and `policyContactPlaceholder` (the placeholder sentence of that translation, so it can be replaced when the contact is set), `termsFile` (`TERMS.xx.md`), `termsNotice`, and the strings `termsLink`, `licenseLink`, `downloadAccept`, `licenseNote`.
2. Add the translated terms as `TERMS.xx.md` and the translated policy as `site/policy/xx.md`. It uses the same Markdown subset as the English one: `#`, `##`, `###` headings, paragraphs, `- ` lists, pipe tables, `**bold**`, `[text](url)` and bare URLs. A link to `privacy-policy.xx.md` becomes a link to the language page.
3. Run `tools/build-site.ps1` and `tools/check-site.ps1`. Every page then links the new language, and `privacy/` offers it to browsers that prefer it. Commit.

A language is published only when all three files exist; do not add one json without its policy.
