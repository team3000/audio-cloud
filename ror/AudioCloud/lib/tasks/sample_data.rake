namespace :db do
	desc "Fill audio cloud database with sample data"
	task populate: :environment do
		make_media_streams
	end
end

def make_media_streams

	1.times do
		MediaStream.create!({
			name: "DK III",
			duration: 6354,
			url: "http://api.soundcloud.com/tracks/112638475/stream?client_id=4a35610ca12c56aa757a2b3c140215a6",
			permalink_url: "https://soundcloud.com/dusty-kid-official/dk-iii",
			download_url: "http://api.soundcloud.com/tracks/112638475/download",
			image_url: "http://i1.sndcdn.com/avatars-000055293402-affc20-large.jpg?3eddc42",
			detail: "DK III\r\n\r\n1.Crepuscolaris  (0.00)\r\n2.Far  (5.46)\r\n3.Sandalyon (12.44)\r\n4.Raww Oohmm (26.59)\r\n5.He Won't Let You In (30.56)\r\n\r\n- Leather Bears Cinematic Suite -\r\n6.Level I : Doom (36.08)\r\n7.Level II : Flames (42.38)\r\n8.Level III : Pandemonium (47.23)\r\n9.Level IV : Darkroom (52.17)\r\n10.Level V : Exit 12 (57.22)\r\n\r\n               -\r\n\r\n11. Flashback (1:01:14)\r\n12.Yota Wave (1:04:12)\r\n13.Antares (1:11:56)\r\n14.In The Wood (1:17:25)\r\n15.Prelude (1:23:50)\r\n16. Omega Y (1:27:52)\r\n17.Omega X (1:30:04)\r\n18. Escape (1:34:51)\r\n19.Idklip (1:40:31)\r\n20. Ending (1:45:54)\r\n",
			media_type: 1
			})
	end

	1.times do
		MediaStream.create!({
			name: "Ringo (Short SoundCloud Edit)",
			duration: 260281,
			url: "http://api.soundcloud.com/tracks/107279870/stream?client_id=4a35610ca12c56aa757a2b3c140215a6",
			permalink_url: "https://soundcloud.com/joris-voorn/ringo",
			download_url: "",
			image_url: "http://i1.sndcdn.com/artworks-000056236790-dbqdnc-large.jpg?3eddc42",
			detail: "1,5 years after first playing this at my birthday in Studio 80, Amsterdam.\r\nHere is Ringo!\r\n\r\nhttp://www.youtube.com/watch?v=gpzb2LWO35M",
			media_type: 1
			})
	end

	1.times do
		MediaStream.create!({
			name: "Critical Taste v.s. Vico Roots - Open Air (<3 Berlin edit)",
			duration: 401356,
			url: "http://api.soundcloud.com/tracks/92183486/stream?client_id=4a35610ca12c56aa757a2b3c140215a6",
			permalink_url: "https://soundcloud.com/critical-taste/critical-taste-v-s-vico-roots",
			download_url: "",
			image_url: "http://i1.sndcdn.com/artworks-000048017251-9s73uv-large.jpg?3eddc42",
			detail: "Let the summer begin !!!!!\r\n",
			media_type: 1
			})
	end


end
