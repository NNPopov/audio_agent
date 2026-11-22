# Audio Agent

**English** | [Русский](README.ru.md)

A voice assistant for Android that works with one button, a Bluetooth remote control or a keyboard. It is made first of all for blind and low-vision people and for people with limited use of their hands or other disabilities, and for anyone who needs to control a phone by voice without touching the screen. It is not a tool for single commands: it holds a long conversation, the chat goes on for many turns and keeps its context, and you can attach a document to a chat and discuss it by voice.

What it can do, all by voice:

- One button is enough: you can talk to the assistant with a single button on a remote, a switch or a key (start a recording, stop, replay the answer). With more buttons you can give each one a function, and every button can do up to six different things (short or long press, once, twice or three times).
- Long conversations that keep their context.
- Documents: attach a text or Markdown document from the clipboard or with Share, then ask about it.
- Music: play by artist, album or track; pause, next, previous, rewind and forward, volume, playlists.
- Chats: start a new chat, go back to the previous one, hear the topics of recent chats, find and open a chat by topic, split a chat. On the screen: delete a chat, copy its brief summary, branch a new chat from a message.
- Timers and reminders (by time or by place), notes and lists.
- Weather, time, news and web search (search and news need a DeepSeek key).
- Calendar, calling a contact, routes and saved places, reading unread text messages aloud.
- Skip the answer that is being spoken, rephrase your last question, light and dark themes.

**Web page and downloads:** https://nnpopov.github.io/audio_agent/ (English and Russian)

**Status: ALPHA.** Earlier than beta. It is experimental software made by one person: expect bugs, missing features and changes without notice, and do not rely on it for anything important or safety-critical. No guarantee of support or updates.

This repository holds the public web page, the privacy policy, the terms and the list of public builds. It contains no app source code.

## Install

Requires Android 12 or newer. The app is not in Google Play.

1. Open the [web page](https://nnpopov.github.io/audio_agent/) (or the Releases page of this repository) and download the APK of the latest alpha build. The page lists the SHA-256 of every build.
2. Open the file on the phone. Android asks to allow installing apps from that source (your browser or file manager): allow it for this install. Play Protect may warn that the app is unknown; that is expected for an app outside Google Play.
3. Open Audio Agent, read the first screens (they explain each permission) and enter your own API keys in Settings.

Step by step, for beginners: the [user guide](https://nnpopov.github.io/audio_agent/guide/) ([по-русски](https://nnpopov.github.io/audio_agent/guide/ru/)).

## You need your own keys

The app has no server of its own and no accounts. It talks directly to AI services (Qwen and DeepSeek) with API keys that you enter yourself, so you need your own keys and your own agreement with those providers; the providers may charge you.

## Data

No server of the developer, no accounts, no analytics, no advertising. Your voice and requests go from your phone straight to the AI providers whose keys you entered. This site makes no requests to third parties. Read the [privacy policy](https://nnpopov.github.io/audio_agent/privacy/).

## Reporting problems

Use the [Issues page](https://github.com/NNPopov/audio_agent/issues) of this repository, or write to nn.popov@gmail.com. Do not post API keys or private recordings.

## License

- The website text and the privacy policy in this repository are licensed under [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/) (credit "Audio Agent" and link to this repository); see [LICENSE](LICENSE).
- The app builds (APKs) are all rights reserved, free for personal use, under the [Terms](TERMS.md) ([по-русски](TERMS.ru.md)). By downloading you accept the Terms.
- The source code is not published: it lives in a separate private repository. Open-sourcing is a possible later decision.

Maintainer notes (how the site is generated and builds are published): [MAINTAINING.md](MAINTAINING.md).
