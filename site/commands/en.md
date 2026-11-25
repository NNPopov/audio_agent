# Voice commands for Audio Agent

This page answers one question: what can you say. The phrases are examples, the meaning matters more than the exact words. If a phrase is not on the list, try it anyway: the AI model understands free speech.

[[toc]]

## How commands work {#how}

There are two paths. Every group below says which one its phrases take.

**Runs at once, without the model.** The phone recognises short phrases itself and runs them in a fraction of a second. The whole phrase must match. The recording must be no longer than about 4.5 seconds, or no longer than 8 words. "Please" and filler words such as "okay" or "well" are not counted, wherever they are in the phrase. If the phone does not recognise a phrase as a command (it is longer, worded differently or has a correction), nothing is lost: it goes to the AI model (LLM) on its own, which carries out the request.

**Through the model.** The AI model understands everything else. It accepts free wording, long sentences and corrections on the way, for example: "set a timer for ten, no, better for fifteen minutes". The answer takes a few seconds.

The screen language does not matter. English and Russian phrases always work, and the answer comes in the language of your phrase. A phrase that mixes two languages ("play next трек") goes to the model.

**Service exchanges.** Short requests such as the weather, the time, a timer, reminders, music and chat control are marked as commands. They are not kept in the brief summary and the memory of the chat, and they are deleted after a day. To keep such an exchange in the chat, add "and put this in the chat" to the phrase.

## Chats and memory {#chats}

### New and previous chat

**Runs at once, without the model.**
- "New chat."
- "New chat, tell me about Kafka." The question goes straight into the new chat, of any length.
- "Previous chat." The app opens it and names it.
- "Read the topics of recent chats." Reads five titles.
- "Save the chat audio as material."

### Find a chat and search past chats

**Through the model.**
- "Find the chat about Kafka." Then "open chat" and its name.
- "What did we decide about the signing key?" "In which chat did I talk about Docker?" The search looks at your own words, the chat titles and the brief summaries, not at the assistant's answers. It reads up to three results at a time, up to 15 in all.
- "Split the chat, the last three questions into a new chat." "Split the chat from where we started talking about Docker."

**Right after a search, without the model.** These phrases work only right after a search, for up to 10 minutes and until you say something else.
- "Show more." "More." Reads the next three.
- "Previous results." One page back.
- "Read the results again." The same page once more.
- Each result sounds like this: "First: chat title, November 12", and at the end how many are left.
- "Open the second one." "Open the second chat." Opens a chat from those just read.

### Change of topic

**Runs at once, without the model.** When the talk drifts to another subject, the assistant offers once to start a new chat. Agree with "yes, open a new chat" or "yes, I agree". A bare "yes" is not enough. Answer soon after the offer.

### Memory about you

**Through the model.**
- "Remember that I already published the privacy policy." "Don't explain Docker to me."
- "Forget number 3." "Forget that I know the privacy policy."
- "Forget everything." The app asks once, answer "yes".
- "Turn memory off." "Turn memory on."

**Runs at once, without the model.**
- "What do you remember about me?" "What is in your memory?" Reads the list with numbers.

### Documents and connected services

**Through the model.**
- When a document is attached to the chat: "Which section covers the double charge?" "What is in chapter five?"
- MCP services that you added in Settings: "Which services are connected?" "Connect the transcriber." "Disconnect the transcriber." "Disconnect all."

## The answer {#answer}

**Runs at once, without the model.**
- "More detail." For the whole chat. "Shorter."
- "Repeat." "Say that again." Repeats the last answer.
- "Skip the answer." "Skip the recording." "Stop reading." Cuts the spoken answer, the next one follows.
- "Stop." "Stop the playback." "Stop the playback, please." Stops everything that sounds: the answer and the music. The music queue is kept.
- "Rephrase my last question." Deletes the last question with its answer so that you can ask it again.
- "Switch to Qwen." "Switch to DeepSeek." "Switch to the thinking model." The model for this chat.

## Music {#music}

The music files must be on the phone.

### Choose and build a queue

**Through the model.**
- "Play Metallica." "Play Los Van Van." Say "the whole list" or "a selection" to build a queue by artist.
- "Shuffle."
- "Add Metallica to the queue." "Add the playlist Road to the queue." The music does not stop.
- "Play track five."
- "Restore the previous queue." When a queue was replaced by a new one, the old one is kept.
- "What did I listen to yesterday?" "Play what I listened to this morning."

### Player controls

**Runs at once, without the model.**
- "Next track." "Skip the song."
- "Previous track."
- "Pause." "Resume."
- "Stop the music." The queue, the track and the place are kept: "Resume" plays on from the same place.
- "Play music." Works only if there is a queue.
- "Clear the queue." The only voice command that empties the queue. On the Player tab, "Clear" does the same.
- "Skip ahead 30 seconds." "Rewind 2 minutes." "Rewind half a minute."
- "What's playing?"
- "Louder." "A bit quieter." "Volume 50 percent." "Max volume."

### Playlists

**Through the model.**
- "Save this as the playlist Road."
- "Play the playlist Road." "What playlists do I have?"
- "Delete the playlist Road." The app asks you to confirm.

## Time, timer, reminders, calendar {#time}

### Time and timer

**Runs at once, without the model.** When you say the phrase in the standard way.
- "What time is it?"
- "Set a timer for ten minutes." "Timer for an hour and a half."
- "How much time is left on the timer?" "Cancel the timer."

**Through the model.** Any other wording and corrections, for example: "set a timer for ten, no, better for fifteen minutes".

### Reminders and alarm

**Through the model.**
- "Remind me tomorrow at ten to call the bank."
- "Remind me when I am at the shop to buy milk." A reminder by place.
- "What reminders do I have?" "Delete the reminder about the bank."
- "Wake me at seven thirty."

### Calendar

**Through the model.**
- "What do I have in my calendar tomorrow?"
- "Schedule a meeting on Friday at 3 pm." Say "mark it as free" if the time should stay free.

## Messages, calls, routes, notes, weather and news {#more}

Everything in this section goes **through the model**.

### Messages (SMS)

- "Check unread messages and read them."
- "What came from Correos?" "Messages for the last three days."
- "Read the last message." "The last three messages." "The last from SEUR."
- "Read message 4." "Read it again."

Phone numbers, codes, links and long numbers are hidden on the phone before the text goes to the model.

### Calls and routes

- "Call mom." "Dial Ivan." The dialer opens, you press call yourself.
- "Let's go home." "Build a route to work." "How to walk to the station?" The maps open.
- "Remember this place as pediatrician." "What places do I have?" "Delete the place pediatrician."

### Notes and lists

- "Add milk to the shopping list." "Write a note: call the bank."
- "What is on the shopping list?" "Cross out milk." "Clear the shopping list."

### Weather and news

- "What is the weather in Madrid?"
- "Find news about ..." Web search works with a DeepSeek key.

## What is not a command {#not}

- "More" turns the search results only right after a search. At any other time such a phrase goes to the model.
- "Stop", "next" and "repeat" without the word "results" keep their usual meaning: stop everything, next track, repeat the answer. They do not turn the search results.
- The single word "back" is not a command. Say "previous track" or "previous results".
- A phrase with an extra word or a track name ("next track Metallica") goes to the model. So does a phrase of more than 8 words when the recording also lasts longer than 4.5 seconds.

If the phone does not recognise a command, nothing is lost: the phrase goes to the model, and it usually copes.

The full guide: [user guide](../../guide/en/).
