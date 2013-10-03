Audio cloud
===========


Is a player which aims to play:
- Soundclound
- Youtube
- Others
Services.



////////////////////////////////////////////



iOS
====


To test it, fill in **ViewController.m** your SoundClound client ID.
`static NSString *soundcloundClientId = @"";` (line 22)


Back end
========

Here is describe how to get the audio feed

- Media Stream feed:
``curl -X GET http://audio-cloud.herokuapp.com/media_streams.json --header "Content-Type:application/json"``

- Media Stream returns:
```
[
 {
	name: "III - Dusty kid",
	duration: 6354,
	url: "http://api.soundcloud.com/tracks/112638475/stream?client_id=4a35610ca12c56aa757a2b3c140215a6",
	image: "http://i1.sndcdn.com/avatars-000055293402-affc20-large.jpg?3eddc42",
	audio_type_id: 0
 }
]
```
- Media Object:
  + name: media name
  + duration: media duration in seconds
  + url: media stream url
  + image: image url
  + audio_type_id: soundcloud = 0,
	       	   youtube = 1


------------------------
