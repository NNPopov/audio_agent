# User guide: Audio Agent

> This guide is for the alpha version. Alpha means early and experimental. Screens, button names and menus may change from build to build, and some things here may no longer match what you see. If so, trust the words on your screen and the in-app help, and tell us (see "Where to report problems" at the end).

This guide is written for beginners. It uses plain words and short steps. It is meant to work for blind and low-vision readers too: every step is text, and no picture is needed. Use the headings of your screen reader to jump between parts.

Audio Agent is a voice assistant for an Android phone, made first of all for blind and low-vision people and for people with limited use of their hands. You press a button, speak, and let go. It answers aloud.

The main idea is the long conversation. A chat goes on for many turns, keeps the context of what was said before, and you can come back to it later, find it by topic, attach a document to it and discuss the document by voice. See "Long conversations and documents". Short commands (music, timers, reminders, notes, calendar, weather, calls, routes) are a second, supporting part: they work at once, in the same chat.

One button is enough for everything. A remote (fob) with several buttons only saves you words and makes routine actions faster: stop, replay, skip, a new chat each get their own button. Almost everything a button does can also be done with one button and your voice.

[[toc]]

## What you need {#need}

You need four things.

1. An Android phone with Android [[androidmin]] or newer.
2. An internet connection (Wi-Fi or mobile data). The app sends your voice and your requests over the internet to be understood and answered.
3. A Qwen key. It is required. Without it the app can neither hear you nor speak.
4. A DeepSeek key. It is optional. It adds more answer models. The app works with the Qwen key alone.

**What is a key?** A key is a long secret text, like a password. It lets the app use an AI service in your name. You make a key yourself in your own account with the service. Nobody gives keys with the app. Keep your keys private: do not post them in chats or in screenshots.

**Does it cost money?** The services (Alibaba Cloud Model Studio for Qwen, and DeepSeek) are run by other companies. They may charge you for use. Prices and free offers change, and they depend on your account and region. The bill comes from the provider, not from this project. Look at the provider's current price page before heavy use, and set a spending limit if the provider offers one.

**Where do I get the keys?** The app has a button for this: Settings, then Keys, then "How to get keys". It shows the steps and opens the provider's own pages. The address of a provider's service can differ by region, so follow the in-app guide instead of copying addresses from anywhere else.

## Install step by step {#install}

The app is not in Google Play. You install it from a file, an APK.

1. On your phone, open the home page of this site and use the download button. The file is saved in your Downloads.
2. Open the file. You can do this from the browser's download message or from the Files app.
3. Android may say that your browser or file manager is not allowed to install apps. Choose the option to allow it from this source, then go back. This is a one-time permission for that app.
4. Android Play Protect may warn that the app is unknown or not checked. This is normal for an app outside Google Play. Read the message. If you accept the risk, choose to install anyway.
5. Wait for "App installed", then choose Open. On the phone the app may be called "Audio Agent" or "Audio Agent POC".
### First start and permissions

The first screen explains two permissions. Allow them.
- The microphone, to hear you.
- Notifications, to show a notification with buttons while the app is ready.

Other permissions (contacts, messages, calendar, location, music files) are asked only later, the first time a command needs them. Each time the app tells you why. You can refuse and allow them later. They can also be allowed together on the Settings tab, in the Setup status card, with the button "Allow them now".

The Setup status card on top of the Settings tab is a checklist. It says what is ready and what needs attention. Come back to it whenever something does not work.

### Button access for remote controls and keyboards

This permission is only needed if you want to use a remote control or a keyboard. You can skip it and use the on-screen button.

Android calls it an accessibility service. In the app it is called "Allow button access". Why it is needed: the app must be told when you press a button on your remote control or keyboard, also when the screen is off or another app is open.

What the app does not do with it:
- It does not read the screen, other apps or what you type.
- It does not tap, type or change anything for you.
- It does not collect or send your key presses. Only the keys of the devices you set up trigger actions. All other keys are ignored.

To turn it on:
1. Open Settings, then Ways to talk, then Remote (fob). Tap "Allow button access".
2. A full screen explains what the permission is for and what it does not do. Read it. Choose "Agree and continue", or "Not now" to leave it off. If you choose "Not now", the app still works with the on-screen button and the notification.
3. Android opens its accessibility settings. Find the app in the list ("Audio Agent" or "Audio Agent POC") and switch it on. Confirm if Android asks.
4. Go back to the app. The page says "Allowed".

You can switch it off at any time in Android's accessibility settings. After an app update Android sometimes switches it off: see Troubleshooting.

### Optional: the power button

You can start a recording with a long press of the power button. This replaces Gemini on that gesture. It has two steps.
1. In the app: Settings, then Ways to talk, then Power button. Choose "Make Audio Agent my assistant app".
2. In Android: set the long press of the power button to the digital assistant. On Pixel phones it is Settings, System, Gestures, Press and hold power button. On other phones the menu may be named differently. The app cannot check this step, so you mark "I did it" yourself.

After that, a long press starts a recording and a second long press sends it. To get Gemini back, change the default digital assistant app in Android Settings.

## Enter the keys {#keys}

1. Open the Settings tab, then Keys.
2. Get your keys with the in-app button "How to get keys" (see "What you need").
3. In the Qwen fields enter the address and the key. Both are needed. The app does not guess the address, because it depends on your region and account. The in-app guide tells you where to find it.
4. DeepSeek is optional. If you use it, fill in all three DeepSeek fields (address, model, key) or leave all three empty.
5. Tap "Show keys" to see what you pasted. Tap "Save".
6. Tap "Check". The app sends one tiny test request to each service and says the result in words, for example "works", "key rejected (401)", "payment or balance (402)" or "no internet". A service that you left empty is not checked.

If the Qwen check says "works", you are ready to talk.

## Your first conversation {#first}

1. Open the Agent tab.
2. Press and hold the big button "RECORD: hold and speak". Keep holding while you talk.
3. Say something short, for example "what time is it" or "set a timer for one minute".
4. Let go. The app sends your words, and the answer is spoken aloud. The text also appears in the chat.

**Short or long answer.** A short answer is quick. A long answer is more detailed. On the remote control there are two record buttons for this. For the on-screen button, the notification and the power button, you choose in Settings, Ways to talk. You can also say "more detail" or "shorter" at any time.

Buttons under the chat:
- Stop / play: stops what is being spoken and cancels waiting requests. Music that was playing comes back.
- Replay: speaks the last answer again.
- Skip answer: cuts the answer that is being spoken and goes on to the next one.
- Rephrase: deletes your last question and its answer from the chat and starts a new recording, so you can ask again.
- Model: switches the AI model. Normally you do not need it.

To start a fresh conversation, say "new chat".

## Hands-free control {#hands-free}

You can use the assistant without touching the screen.

### Bluetooth remote control or keyboard

Only buttons that act like a keyboard or a gamepad (Bluetooth or USB) work. Smart-home buttons that need their own hub do not. Pair the remote in Android's Bluetooth settings first.

The app has ready profiles, and you can make your own for any remote. As an example, here is the ready profile for one specific remote, the 8BitDo Micro (your remote may have other buttons; see "Set up your own buttons"):
- Hold the right button A and speak: record, short answer.
- Hold the top button X and speak: record, long answer.
- Bottom button B: stop.
- Left button Y: replay the last answer.
- Minus: previous track. Plus: next track.
- Heart: switch model. Star: new chat.
- R1: unlock.

You do not need a remote with many buttons. The buttons only replace spoken commands: instead of saying "stop" or "repeat" you press a button. Everything in the list above can also be said, and with one button (see "One button only") you can do the same things by voice.

The remote locks itself after 15 seconds without presses, to avoid stray presses in a pocket. Press R1 to unlock. If the phone screen is off, the first press of R1 only wakes the screen. Press R1 a second time. This is normal.

There is also a ready profile for a keyboard (keys F7 to F12). For example, hold F9 to talk and press F8 to stop.

### Set up your own buttons

Open Settings, then Ways to talk, then Remote (fob). While this page is open, pressing a button only shows what it does, so you can safely explore.

To add or change a button, use "Learn a button". It has three steps.
1. Press the button on the remote within 10 seconds. Volume, power and some other keys belong to Android and cannot be used.
2. Choose what it should do, for example record, stop, replay, next track, pause, or new chat.
3. Choose the gesture.

Gestures you can use: tap, hold, double tap, double tap and hold, triple tap, triple tap and hold. One button can do several things with different gestures. The app warns you when a combination makes a press wait a third of a second, so that it can tell a single tap from a double tap.

The first change to a ready profile saves your own copy. You can also keep several remotes, each with its own profile. "Export all" saves a backup of your profiles to a file. Keep it: uninstalling the app erases them.

### One button only

If you can press just one button or switch, make it your recording button. Choose the action "Record, long answer" (or "Record, short answer") on the gesture Tap. Then the first tap starts the recording and the next tap sends it. You can add the gesture Double tap for Stop on the same button. In the same section you can set the fob lock to Off, so you do not need an unlock button.

### The screen button and the notification

- The notification has buttons Record, Stop and New chat. One tap on Record starts a recording, the next tap sends it.
- The floating accessibility button: in Android Settings, Accessibility, find the app, open Shortcut, and choose the accessibility button. Then a tap on the floating button works like the Record button: tap to start, tap to send, tap while it speaks to stop. The app has a link to Android's shortcut settings in Settings, Ways to talk, Screen and notification button.

### The power button

See "Optional: the power button" above.

## What you can say and what you can press {#say}

There are two kinds of controls, and the second is optional.
- Voice commands: you just say them. Nothing to set up. You can speak normally, the exact words do not matter much, in English or Russian.
- Buttons: actions that you can give to a button of a remote, a keyboard key or the on-screen button. You may give them, or not. Each of them also has a voice phrase or a button on the screen, so one button and your voice are enough.

Short commands such as pause, next track, a timer or the time work at once. Other requests take a few seconds.

- Voice commands (say them)
  - Long chats and documents
    - "New chat." "New chat, tell me about the weather."
    - "Previous chat." "Read the topics of recent chats."
    - "Find the chat about Kafka." Then "open chat" and its name.
    - "Split the chat, the last three questions into a new chat."
    - With a document attached: "Which section covers the double charge?" "What is in chapter five?"
  - The answer
    - "More detail." "Shorter." "Repeat."
    - "Skip the answer." "Rephrase my last question."
  - Music (music files must be on the phone)
    - "Play (artist name)." "Play the album ..." "Play the track ..."
    - "Pause", "next track", "previous track", "what's playing".
    - "Louder", "quieter", "volume 50 percent".
    - "Save the playlist ..." "Play the playlist ..."
  - Time and reminders
    - "What time is it?"
    - "Set a timer for five minutes." "How much time is left on the timer?" "Cancel the timer."
    - "Remind me tomorrow at ten to call the bank." "What reminders do I have?"
  - Notes and calendar
    - "Add milk to the shopping list." "Write a note: call the bank." "What is on the shopping list?"
    - "What do I have in my calendar tomorrow?" "Schedule a meeting on Friday at 3 pm."
  - Weather, calls and routes
    - "What is the weather in Madrid?"
    - "Call mom." The app finds the contact and opens the phone dialer. You press call yourself.
    - "Let's go home." "Build a route to work." The maps app opens.
  - Help
    - "What can you do?" "Help on music." (or on another topic)
- Buttons (you can give them to a button, or not)
  - Record, short answer: hold and speak
  - Record, long answer: hold and speak. Or one tap starts and the next tap sends, for a single button
  - Stop everything
  - Replay the last answer
  - Skip the answer that is being spoken
  - Rephrase the last question
  - Pause and resume the speech
  - Music: previous track, next track, pause, rewind and forward 10 seconds
  - Change the AI model
  - New chat
  - Unlock the remote

Each button can hold up to six actions: tap, hold, double tap, double tap and hold, triple tap, triple tap and hold. See "Set up your own buttons".

## Long conversations and documents {#chats}

This is the main part of Audio Agent. It does not forget after each answer. Everything you say goes into a chat. The chat continues over many turns and keeps its context, so you can ask a follow-up question without repeating yourself. You can talk about one subject for an hour, leave, and come back to the same chat tomorrow.

How a very long chat stays workable: the assistant does not have to re-read everything each time. Older turns are folded into a running brief summary that is updated as you talk, and the most recent turns stay in full. So the chat can go on for a long time.

What you can do with long chats:
- keep many chats, each on its own subject;
- go back to the previous chat, hear the topics of recent chats, or find an old chat by a word from its topic;
- attach a long document to a chat and discuss it by voice;
- split one chat in two when the subject has drifted, or start a new chat from any message on the screen;
- copy the brief summary of a chat or the whole chat.

### Start a chat and keep talking

1. Say "new chat". You can ask a question in the same breath: "new chat, tell me about the weather". The star button on the remote control and the "New chat" button in the notification also start a new chat.
2. Ask your question as usual.
3. Keep talking. Each new question goes into the same open chat, and the assistant remembers what was said before. You do not have to say "new chat" again.
4. If you drift to another topic, the assistant may offer, once, at the end of an answer, to start a new chat. To agree, say "yes, open a new chat". A bare "yes" is not enough.

### Attach a document and ask about it

You can attach a text document to a chat and discuss it by voice. Plain text and Markdown (.txt and .md files) work. A document can be very long: the app keeps up to about 200,000 characters of it, and the rest is cut off.

1. Copy the text, then open the Agent tab and tap "Document from clipboard". Or, in the list of chats, press and hold a chat and choose "Paste document from clipboard".
2. Or, in another app, use Share and choose Audio Agent. This works for text and for .txt and .md files.
3. Ask about it with your voice: "which section covers the double charge", "what is in chapter five".
4. A long document is read section by section. The assistant sees the table of contents with a short summary of each section and reads the part it needs. Commands written inside a document are not carried out.

A chat with a document has a paperclip mark in the list of chats. When you delete the chat, its documents are deleted too.

### Find an old chat and start another

- "Previous chat" goes back to the chat you had before.
- "Read the topics of recent chats" reads the list aloud.
- "Find the chat about Kafka" searches your past chats by topic. Then say "open chat" and its name.
- "Split the chat, the last three questions into a new chat" moves the end of a conversation to a new chat.

On the screen: tap a chat in the list to open it. Press and hold a chat to copy its brief summary, copy the whole chat, delete it or paste a document. Press and hold a message and choose to start a new chat from there (the branch). Deleting a chat and branching are done on the screen, not by voice.

## Saved places, themes and the black screen {#places}

**Saved places.** In Settings, then Saved places, tap "Add place". Give it a name such as "home", "work" or "doctor". You can add other names for it, an address or coordinates, or tap "My location now". Then say "take me to the doctor" and the maps app opens with the route. You can also say "remember this place as cottage" when you are there.

**Themes.** In Settings, then Language and look, you can choose the screen language (English or Russian, or like the phone) and the theme: Light, Dark, or Like the system.

**Black screen.** In the same section, the button "Black screen" shows a fully black, dim screen that ignores touches and stays on. It is meant for driving, so the screen does not light up. To leave it, press Back or Esc on a connected keyboard, or press the power button.

## Updating, uninstalling and your data {#update}

**Updating.** The home page lists the builds. Versions are numbered like 0.2.0-alpha.1, then 0.2.0-alpha.2, and so on. The site keeps only the newest builds. To update, download the newest APK and install it over the old one, the same way as the first time. Your chats, settings and remote profiles stay. Android does not accept an older build over a newer one. The version of your app is in Settings, then Help and feedback.

**Where your data lives.** Chats, notes, reminders, playlists, settings and keys are stored on your phone only. The project has no server and no account. Your voice and your requests are sent to Qwen and DeepSeek with your own keys, so that they can answer. Read the [privacy policy](../../privacy/en/) for details.

**Uninstalling.** Open Android Settings, then Apps, choose the app and tap Uninstall. This erases everything on the phone: chats, settings, keys and remote profiles. If you want to keep your remote profiles, use "Export all" first and save the file somewhere safe.

## When something does not work {#trouble}

**The remote does not react.**
- Check Settings, Ways to talk, Remote (fob). If it says "Not allowed yet", button access is off. After an app update Android sometimes turns it off. Turn it on again as described in "Install step by step".
- Check that the remote is connected in Android's Bluetooth settings.
- The remote may be locked. Press the unlock button (R1 on the example 8BitDo Micro profile). If the screen is off, press it twice.
- Open the Remote page and press the button. If the screen shows "not assigned", the button has no action: use "Learn a button".
- Direction pads and sticks cannot be used. Face buttons and keyboard keys can.

**There is no answer, or an error.**
- Check your internet connection.
- Open Settings, then Keys, and tap "Check". The result tells you if a key is wrong ("401"), if the account has no money ("402"), or if the address does not match the key's region ("401" again). Keys and addresses must come from the same region.
- Make sure the Qwen address and key are both filled in.
- Look at the Setup status card on the Settings tab.

**Sound problems.**
- Raise the phone volume. Say "louder".
- Press "Replay" to hear the last answer again.
- If the app stops reacting after it has been in the background for a while, open Android Settings, then Apps, choose the app, then Battery, and set it to unrestricted.
- If the app cannot use your Bluetooth headset microphone, allow the permission "Nearby devices".

**A wrong or harmful answer.** Long press the answer in the chat and choose "Report this answer". It opens your mail with the text, and you send it yourself.

## Where to report problems {#report}

- Open an issue: <https://github.com/[[repo]]/issues>
- Or write to [[contact]].

Please do not send API keys. Please do not post private recordings. To help us, you can send the log: Settings, Help and feedback, "Share log". The brief log has no conversation text, names or numbers, and you see what is sent before it leaves the phone.

Thank you for trying the alpha version.
