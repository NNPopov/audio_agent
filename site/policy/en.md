# Privacy policy: Audio Agent

Last updated: 2026-11-22. Русская версия: [privacy-policy.ru.md](privacy-policy.ru.md).

Audio Agent is a voice assistant for Android. You press a button, speak, and the assistant answers aloud and can run actions such as music, timers, reminders, notes and calls. This policy says in plain words what the app handles, where it goes and how you delete it.

## The short version

- The app has **no server of its own**. The developer does not receive your voice, your text, your chats or your settings.
- The app has **no accounts, no analytics, no advertising and no tracking** of any kind.
- To answer you, the app sends your **voice recording and the text of your requests** directly from your phone to the AI providers whose keys you entered (Qwen and DeepSeek). The keys are yours, and so is your agreement with those providers.
- Everything else (chats, reminders, notes, playlists, settings, the event log) stays **on your phone** until you delete it.

## What the app handles and where it goes

### Sent to the AI providers you chose

The app needs your own API keys for these services; without them it does not work. It talks to the providers directly over HTTPS.

| What | Sent to | Why |
|---|---|---|
| Your voice recording (a short audio clip; long recordings in pieces) | Qwen speech recognition (Alibaba Cloud Model Studio) | To turn speech into text |
| The text of your request, the earlier messages of the chat that the model needs as context, short summaries of the chat, text or documents you attached or shared into the app, and the results of the actions the assistant ran for you (see "Optional device data") | The language model you selected: Qwen or DeepSeek | To write the answer and to decide which action to run |
| The text of the answer to be spoken (in short pieces) | Qwen speech synthesis (Alibaba Cloud Model Studio) | To turn the answer into audio |
| Short search words, when you ask for facts or news that need the internet | DeepSeek search (with your key); for news also Google News (RSS, no key) | To find current information |
| A city or place name, when you ask for the weather, a route, or a reminder at a place | Open-Meteo (geocoding and forecast) and Photon by Komoot (OpenStreetMap data); no key | To find the coordinates of that place and the forecast |

Notes:

- The providers receive these requests together with your internet address, as any internet service does. What a provider does with the data is governed by that provider's own terms and privacy policy, not by this one: Alibaba Cloud (https://www.alibabacloud.com/help/en/legal), DeepSeek (https://www.deepseek.com/), Open-Meteo (https://open-meteo.com/en/terms), Photon by Komoot (https://photon.komoot.io/), Google (https://policies.google.com/privacy). Please read them before you use the app.
- A recording leaves your phone only after you finish speaking (button released or tapped again). The app does not listen while you are not recording.
- The app never sends the coordinates of your phone to any provider. A place reminder compares your position with a saved place on the phone only.

### Optional device data the assistant reads when you ask

Android asks for your permission first. The data is used only when you ask for the matching thing by voice. What the assistant reads is passed to the language model above so that it can answer you.

- **Calendar** (read and add events): the events of the day you ask about are sent to the language model; a new event is written to your calendar.
- **Contacts**: used to find a person you name and open the dialer. The name you said and, if several contacts match, the matching names go to the language model. The phone number is not sent: the dialer opens and you press call yourself.
- **Location**: used only for reminders tied to a place and for "save this place". The position stays on the phone. In the Google Play version place reminders work only while the app is open on the screen.
- **Messages (SMS), only in the version that is not distributed through Google Play**: a digest of unread messages with digits and codes hidden is sent to the language model when you ask for it. The Google Play version has no access to your messages.
- **Music on the phone**: the app reads the list of audio files on your phone to play them. A track or playlist name you say is part of your request.

### Stored only on your phone

Chats and their messages, audio of the latest spoken answers, recordings of your latest requests (the newest 30 are kept, older ones are deleted automatically), reminders, notes and lists, saved places (name and coordinates), playlists and play history, documents you attached, token counters, settings, remote-control profiles and the event log. Your API keys are stored in the app's private storage on the phone. App data is excluded from Android backup.

The **event log** is a diagnostic text file on the phone. By default it is brief: it records what happened (for example "request accepted, 54 characters"), not what you said, names or error messages. A detailed level exists as an option you can switch on yourself for troubleshooting. The log keeps about the last 300 lines and is rotated by size. It never leaves the phone unless you press "Share log" and send it yourself; you see what is sent before it goes anywhere.

If you save the audio of a chat to your music library ("save chat audio"), the files go to the folder Music/AudioAgent on your phone. They are ordinary files that stay until you delete them.

### Report an answer

The long-press menu of an assistant answer has "Report this answer". It builds a text from that answer (and, if you tick the box, your question before it), the app version and the model name, and shows it to you. Only when you press Send does it go to your mail app or the Android share sheet, and you choose the recipient. The app sends nothing by itself.

## The accessibility service

Audio Agent uses Android's accessibility feature to receive the presses of your remote control, the keys of a keyboard and the accessibility button on the screen. This lets you control music and ask the assistant without touching the screen, also when the screen is off or another app is open. It is made for people who cannot easily use a touch screen, such as blind and low-vision users and people with limited use of their hands, and for hands-free use.

It does not read the screen, other apps or what you type. It does not tap, type or change anything for you. It does not collect your key presses or send them anywhere: only the keys of the devices you set up in the app trigger actions, all other keys are ignored. Before Android's accessibility settings open, the app shows a full-screen explanation and asks for your agreement. You can switch the permission off at any time in Android's accessibility settings and withdraw your agreement in the app.

## Permissions and why

| Permission | Why |
|---|---|
| Microphone | Recording your request, only while you record. A notification shows that the app is ready; the microphone is used only during a recording. |
| Internet | Reaching the providers listed above. |
| Notifications | The notification of the running service, reminders and the player. |
| Calendar, Contacts, Location | The optional features above, only when you ask. |
| Music and audio files | Playing your music. |
| Bluetooth | Using a connected Bluetooth headset for recording and sound. |
| Foreground service, wake lock, vibration | Keeping the app ready for the remote while the screen is off, playing music, and firing reminders and timers on time. |

## How long data is kept and how to delete it

- The developer holds none of your data, so there is nothing to delete on a server. The providers keep data under their own rules; see their policies and your accounts with them.
- Delete chats, notes, reminders, playlists and saved places inside the app.
- Delete everything the app stores: Android Settings > Apps > Audio Agent > Storage > Clear data, or uninstall the app. Files you saved to Music/AudioAgent are separate; delete them in your file manager.
- Revoke a permission at any time in Android Settings > Apps > Audio Agent > Permissions.
- To stop using a provider, delete its key in the app and revoke the key in the provider's console.

## Children

The app is not directed at children under 13 and is not meant to be used by them. It does not knowingly collect their data. The app has no accounts and the developer has no server, so there is nothing for a parent to request from the developer; a parent can delete the data on the phone as described above.

## Security

All traffic to the providers uses HTTPS. Your keys stay in the app's private storage and are not written to the event log. Nothing is sold or shared with advertisers.

## Changes to this policy

When the app changes what it handles, this policy is updated and the "Last updated" date changes. The current version is the one at the address linked from the app (Settings > Help and feedback > Privacy policy).

## Contact

Questions about this policy: nn.popov@gmail.com.
