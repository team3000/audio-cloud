//
//  ViewController.m
//  WhydTest
//
//  Created by Adrien Guffens on 9/11/13.
//  Copyright (c) 2013 WeMoodz. All rights reserved.
//

#import "ViewController.h"
#import "Track.h"

#import "PlayerView.h"

#import "AudioCloudAPIClient.h"

//INFO: AVPlayer - for audio
#import <AVFoundation/AVPlayer.h>
#import <AVFoundation/AVPlayerItem.h>
#import <AVFoundation/AVAsset.h>

//INFO: MPMoviePlayerController - for video
#import <MediaPlayer/MediaPlayer.h>

//

#import <AFNetworking/AFImageRequestOperation.h>

static NSString *soundcloundClientId = @"4a35610ca12c56aa757a2b3c140215a6";
static BOOL debug = NO;

//INFO: MAIN VIEW CONTROLLER
@interface ViewController ()

@property (nonatomic, strong)Track *currentTrack;
@property (nonatomic, assign)BOOL isPlaying;
@property (nonatomic, assign)int position;

//INFO: here are defined != way of playing a sound

//INFO: video player
@property (strong, nonatomic) MPMoviePlayerController *moviePlayer;

//INFO: Player:
// - Soundclound
@property (nonatomic, strong)AVAudioPlayer *soundcloundPlayer;

//INFO: Player:
// - YouTube
@property (nonatomic, strong)UIWebView *webView;

//INFO:Audio Player
@property (nonatomic, strong)AVPlayer *audioPlayer;
@property (nonatomic, strong)NSTimer *durationTimer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	//INFO: used with MPMoviePlayerController
	AVAudioSession *audioSession = [AVAudioSession sharedInstance];
	[audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
	[audioSession setActive:YES error:nil];
	
	//INFO: setup main track list
	_tracksList = [[NSMutableArray alloc] init];
	
	AudioCloudAPIClient *client = [AudioCloudAPIClient sharedClient];
	
	[client GET:@"media_streams.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
		
		UALogFull(@"%@", responseObject);
		for (NSDictionary *trackDictionary in responseObject) {
			Track *track = [[Track alloc] init];
			track.name = [trackDictionary objectForKey:@"name"];
			track.duration = [[trackDictionary objectForKey:@"duration"] doubleValue];
			track.url = [trackDictionary objectForKey:@"url"];
			track.image = [trackDictionary objectForKey:@"image"];
			track.audio_type_id = [[trackDictionary objectForKey:@"audio_type_id"] intValue];
			[_tracksList addObject:track];
		}
		
		UALogFull(@"tracksList: %@", _tracksList);
		
		_currentTrack = [_tracksList firstObject];
		_isPlaying = NO;
		_position = 0;
		
		[self updateViewForTheCurrentTrack];
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		//TODO: code
		UALogFull(@"%@", [error description]);
	}];
	
	//
	
	
	/*
	 Track *track = [[Track alloc] init];
	 track.name = @"Praise You";
	 track.duration = 100.0;
	 track.url = @"http://api.soundcloud.com/tracks/91121058/stream";
	 track.image = [UIImage imageNamed:@"praise.jpg"];
	 track.type = soundclound;
	 
	 Track *track2 = [[Track alloc] init];
	 track2.name = @"Agoria 50 min Boiler Room Mix at ADE 2012";
	 track2.duration = 100.0;
	 track2.url = @"http://www.youtube.com/embed/l5Qem9SAQZY";//http://www.youtube.com/embed/
	 //	track2.url = @"l5Qem9SAQZY";//http://www.youtube.com/embed/
	 track2.image = [UIImage imageNamed:@"boiler.jpg	"];
	 track2.type = youtube;
	 
	 Track *track3 = [[Track alloc] init];
	 track3.name = @"MKWC";
	 track3.duration = 100.0;
	 track3.url = @"http://api.soundcloud.com/tracks/60716467/stream";
	 track3.image = [UIImage imageNamed:@"mandy.jpg"];
	 track3.type = soundclound;
	 
	 Track *track4 = [[Track alloc] init];
	 track4.name = @"Julian Jeweil - Don't Think (Original Mix)";
	 track4.duration = 100.0;
	 track4.url = @"http://www.youtube.com/embed/O-B46mrOtCM";
	 //	track4.url = @"O-B46mrOtCM";
	 track4.image = [UIImage imageNamed:@"julian.jpg"];
	 track4.type = youtube;
	 
	 
	 [_tracksList addObject:track];
	 [_tracksList addObject:track2];
	 [_tracksList addObject:track3];
	 [_tracksList addObject:track4];
	 */
	
	/*
	 //DEBUG:
	 NSLog(@"%s - tracksList: %@", __PRETTY_FUNCTION__, _tracksList);
	 
	 _currentTrack = track;
	 _isPlaying = NO;
	 _position = 0;
	 
	 [self updateViewForTheCurrentTrack];
	 */
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Slider

- (void)syncScrubber
{
    CMTime playerDuration = [self playerItemDuration];//_audioPlayer.currentItem.duration;
    if (CMTIME_IS_INVALID(playerDuration)) {
        _durationSlider.minimumValue = 0.0;
        return;
    }
	
    double duration = CMTimeGetSeconds(playerDuration);
    if (isfinite(duration) && (duration > 0)) {
        float minValue = [_durationSlider minimumValue];
        float maxValue = [_durationSlider maximumValue];
        double time = CMTimeGetSeconds([_audioPlayer currentTime]);
        [_durationSlider setValue:(maxValue - minValue) * time / duration + minValue];
    }
}
//
- (CMTime)playerItemDuration {
    AVPlayerItem *thePlayerItem = [_audioPlayer currentItem];
    if (thePlayerItem.status == AVPlayerItemStatusReadyToPlay) {
        return ([_audioPlayer.currentItem duration]);
    }
	
    return(kCMTimeInvalid);
}

#pragma mark - UI

- (void)updateViewForTheCurrentTrack {
	//INFO: getting the track
	_currentTrack = [_tracksList objectAtIndex:_position];
	UALogFull(@"_currentTrack: %@ at position: %d", _currentTrack, _position);
    
	//INFO: setting up informations ---> do it on the main thread
	{
		_nameLabel.text = _currentTrack.name;
		
		NSString *buttonTitle = (_isPlaying == YES ? @"Pause" : @"Play");
		[_playPauseButton setTitle:buttonTitle forState:UIControlStateNormal];
		
		UIColor *backgroundColor = nil;
		switch (_currentTrack.audio_type_id) {
			case soundclound:
			{
				backgroundColor = [UIColor colorWithRed:254.0 / 255.0 green:70.0 / 255.0 blue:0.0 / 255.0 alpha:1.0];
			}
				break;
			case youtube:
			{
				backgroundColor = [UIColor colorWithRed:197.0 / 255.0 green:26.0 / 255.0 blue:32.0 / 255.0 alpha:1.0];
			}
				break;
			case other:
			{
				backgroundColor = [UIColor whiteColor];
			}
				break;
				
			default:
				break;
		}
		//INFO: update UI on main thread
		dispatch_async(dispatch_get_main_queue(), ^{
			[self.view setBackgroundColor:backgroundColor];
			[_durationSlider setTintColor:backgroundColor];
			[_prevButton setTintColor:backgroundColor];
			[_nextButton setTintColor:backgroundColor];
			[_playPauseButton setTintColor:backgroundColor];

			//INFO: set image
			NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_currentTrack.image]];

			[[AFImageRequestOperation imageRequestOperationWithRequest:request success:^(UIImage *image) {
				[_playerView setBackgroundColor:[UIColor colorWithPatternImage:image]];
			}] start];
		});
		
	}
}

- (void)pauseCurrentTrack {
	switch (_currentTrack.audio_type_id) {
        case soundclound:
        {
			[_audioPlayer pause];
			
			//INFO: debug
			if (debug == YES) {
				CMTime duration = _audioPlayer.currentItem.duration; //INFO: total time
				NSUInteger dTotalSeconds = CMTimeGetSeconds(duration);
				
				NSUInteger dHours = floor(dTotalSeconds / 3600);
				NSUInteger dMinutes = floor(dTotalSeconds % 3600 / 60);
				NSUInteger dSeconds = floor(dTotalSeconds % 3600 % 60);
				
				NSString *durationText = [NSString stringWithFormat:@"%i:%02i:%02i", dHours, dMinutes, dSeconds];
				
				UALogFull(@"durationText: %@", durationText);
			}
		}
			break;
		case youtube:
		{
			//TODO: do the job ;)
		}
			break;
		case other:
		{
			break;
		}
			
		default:
			break;
	}
}

- (void)playCurrentTrack {
	
    switch (_currentTrack.audio_type_id) {
        case soundclound:
        {
			//INFO: setup soundclound sound
            NSString *urlString = [NSString stringWithFormat:@"%@?client_id=%@", _currentTrack.url, soundcloundClientId];
			
			NSURL *url = [NSURL URLWithString:urlString];
			
			_audioPlayer = [AVPlayer playerWithURL:url];
			[_audioPlayer setAllowsExternalPlayback:YES];
			
			[_audioPlayer addObserver:self forKeyPath:@"status" options:0 context:nil];
			[_audioPlayer addObserver:self forKeyPath:@"end" options:AVPlayerItemDidPlayToEndTimeNotification context:nil];
			
			[[NSNotificationCenter defaultCenter]
			 addObserver:self
			 selector:@selector(playerItemDidReachEnd:)
			 name:AVPlayerItemDidPlayToEndTimeNotification
			 object:nil];
			
	        break;
		}
			
        case youtube:
        {
			
			if (YES)//INFO: Embed in WebView
			{
				_webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, _playerView.bounds.size.width, _playerView.bounds.size.height)];
				_webView.delegate = self;
				[_webView setBackgroundColor:[UIColor clearColor]];
				//TODO: do a custom UIWebView class if selected way of doing
				
				[_playerView addSubview:_webView];
				
				[self embedYouTubeInWebView:_currentTrack.url theWebView:_webView];
				
			}
			if (NO)//INFO: MPMoviePlayerController
			{
				NSURL *movieURL = [NSURL URLWithString:_currentTrack.url];
				_moviePlayer =  [[MPMoviePlayerController alloc]
								 initWithContentURL:movieURL];
				
				[[NSNotificationCenter defaultCenter] addObserver:self
														 selector:@selector(moviePlayBackDidFinish:)
															 name:MPMoviePlayerPlaybackDidFinishNotification
														   object:_moviePlayer];
				
				_moviePlayer.controlStyle = MPMovieControlStyleEmbedded;
				_moviePlayer.movieSourceType = MPMovieSourceTypeStreaming;
				_moviePlayer.shouldAutoplay = YES;
				[_playerView addSubview:_moviePlayer.view];
				//			[_moviePlayer setFullscreen:NO animated:YES];
			}
			
			if (NO)//INFO: AVPlayer
			{
				NSURL *movieURL = [NSURL URLWithString:_currentTrack.url];
				AVPlayer *avPlayer = [AVPlayer playerWithURL:movieURL];
				
				AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:avPlayer];
				avPlayer.actionAtItemEnd = AVPlayerActionAtItemEndNone;
				layer.frame = CGRectMake(0, 0, _playerView.bounds.size.width, _playerView.bounds.size.height);
				[_view.layer addSublayer:layer];
				
				[avPlayer play];
			}
			
			break;
		}
		case other:
		{
			break;
		}
			
		default:
			break;
	}
	
}

#pragma mark - AVPlayer

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"status"]) {
        if (_audioPlayer.status == AVPlayerStatusReadyToPlay) {
            [_audioPlayer play];
			
			_durationTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(syncScrubber) userInfo:nil repeats:YES];
        }
		else if (_audioPlayer.status == AVPlayerStatusFailed) {
			UALogFull(@"");
		}
    }
}

- (void)playerItemDidReachEnd:(NSNotification *)notification {
	[self nextHandler:nil];
	//[_audioPlayer seekToTime:kCMTimeZero];
}


#pragma mark - VideoPlayer delegate

- (void)moviePlayBackDidFinish:(NSNotification*)notification {
	MPMoviePlayerController *player = [notification object];
	[[NSNotificationCenter defaultCenter]
	 removeObserver:self
	 name:MPMoviePlayerPlaybackDidFinishNotification
	 object:player];
	
	if ([player respondsToSelector:@selector(setFullscreen:animated:)]) {
		[player.view removeFromSuperview];
	}
}

#pragma mark - UIWebView delegate

- (void)webViewDidFinishLoad:(UIWebView *)webView {
	//	if (debug == YES)
	UALogFull(@"");
	
	/*
	 // add function to page:
	 NSString * js = @"function onYouTubePlayerReady(playerId) { \
	 ytplayer = document.getElementById('myytplayer'); \
	 }}" ;
	 
	 [webView stringByEvaluatingJavaScriptFromString:js];
	 
	 js = @"function play() { \
	 if (ytplayer) { \
	 ytplayer.playVideo(); \
	 }}";
	 [webView stringByEvaluatingJavaScriptFromString:js];
	 // execute newly added function:
	 NSString * result = [ webView stringByEvaluatingJavaScriptFromString:@"play();"] ;
	 NSLog(@"result=\"%@\"", result) ;
	 */
	NSString * result = [ webView stringByEvaluatingJavaScriptFromString:@"player.playVideo();"] ;
    UALogFull(@"result=\"%@\"", result) ;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
		UALogFull(@"%@", [webView description]);
}

- (void)embedYouTubeInWebView:(NSString*)url theWebView:(UIWebView *)aWebView {
	UALogFull(@"%@", [aWebView description]);
	/*
	 NSString *embedHTML  = [NSString stringWithFormat:@"\
	 <html>\
	 <head>\
	 <style type=\"text/css\">\
	 o {}\
	 body {background-color:#000; margin:0;}\
	 </style>\
	 </head>\
	 <body>\
	 <iframe width=\"%0.0f\" height=\"%0.0f\" src=\"%@\" frameborder=\"0\"></iframe>\
	 </body>\
	 </html>", aWebView.frame.size.width, aWebView.frame.size.height, url];
	 
	 NSString* html = [NSString stringWithFormat:embedHTML, url, aWebView.frame.size.width, aWebView.frame.size.height];
	 
	 if (debug == YES)
	 NSLog(@"%s | html: %@", __PRETTY_FUNCTION__, html);
	 
	 [aWebView loadHTMLString:html baseURL:nil];
	 */
	aWebView.allowsInlineMediaPlayback = YES;
	if (YES)
	{//INFO: with iframe
		NSString *htmlString = @"<html><head> \
		<meta name = \"viewport\" content = \"initial-scale = 1.0, user-scalable = no, width = \"%0.0f\" /></head> \
		<body> \
		<iframe webkit-playsinline width=\"%0.0f\" height=\"%0.0f\" src=\"\%@?version=3&playsinline=1&autoplay=1&controls=0&enablejsapi=1\" frameborder=\"0\"></iframe> \
		</body></html>";//enablejsapi=1&playerapiid=ytplayer
		
		
		NSString* html = [NSString stringWithFormat:htmlString, aWebView.bounds.size.width, aWebView.bounds.size.width, aWebView.bounds.size.height, _currentTrack.url];
		UALogFull(@"html: %@", html);
		
		aWebView.mediaPlaybackRequiresUserAction = NO;
		[aWebView loadHTMLString:html baseURL:nil]; //baseURL:[NSURL URLWithString:_currentTrack.url]];
		if (NO) {
			NSString *tmpDir = NSTemporaryDirectory();
			NSString *tmpFile = [tmpDir
								 stringByAppendingPathComponent: @"video.html"];
			[html writeToFile: tmpFile atomically:TRUE
					 encoding: NSUTF8StringEncoding error:NULL];
			[aWebView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:tmpFile isDirectory:NO]]];
		}
	}
	//
	
	if (NO)
	{//INFO: test with a file
		NSString *htmlFile = [[NSBundle mainBundle] pathForResource:@"youtube" ofType:@"html"];
		NSString *htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
		
		NSString* html = [NSString stringWithFormat:htmlString, aWebView.frame.size.height, aWebView.frame.size.width, _currentTrack.url, _currentTrack.url];
		
		
		UALogFull(@"html: %@", html);
		[aWebView loadHTMLString:html baseURL:nil];
		
		
		/*
		 NSData *htmlData = [NSData dataWithContentsOfFile:html];
		 
		 
		 [aWebView loadData:htmlData MIMEType:@"text/html" textEncodingName:@"UTF-8" baseURL:nil];
		 */
	}
	
	if (NO)
	{//INFO: test with a file
		NSString *htmlFile = [[NSBundle mainBundle] pathForResource:@"yt3" ofType:@"html"];
		NSString *htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
		
		NSString* html = [NSString stringWithFormat:htmlString, aWebView.frame.size.width, aWebView.frame.size.height, aWebView.frame.size.width, aWebView.frame.size.height, _currentTrack.url];
		
		
		UALogFull(@"html: %@", html);
		[aWebView loadHTMLString:html baseURL:nil];
		
	}
	
	
	
	
}

#pragma mark - Handlers

- (IBAction)prevHandler:(id)sender {
	[self stop];
	
	//INFO: setting prev sound to play
	_position = ((_position - 1) < 0) ? ([_tracksList count] - 1) : _position - 1;
	if (debug == YES)
		UALogFull(@"_position: %d", _position);
	
	[self updateViewForTheCurrentTrack];
	
	if (_isPlaying == YES) {
		[self playCurrentTrack];
	}
	
}

- (IBAction)playPauseHandler:(id)sender {
	if (_isPlaying == NO) {
		_isPlaying = YES;
		
		[self updateViewForTheCurrentTrack];
		[self playCurrentTrack];
		
	}
	else {
		//TODO: pause [OK]
		
		[self pauseCurrentTrack];
		_isPlaying = NO;
		[self updateViewForTheCurrentTrack];
	}
}

- (IBAction)nextHandler:(id)sender {
	[self stop];
	
	//INFO: setting next sound to play
	_position = (_position + 1) >= [_tracksList count] ? 0 : _position + 1;
	if (debug == YES)
		UALogFull(@"_position: %d", _position);
	
	[self updateViewForTheCurrentTrack];
	
	if (_isPlaying == YES) {
		[self playCurrentTrack];
	}
	
}

- (void)stop {
	//INFO: to test latter ->
	
	dispatch_async(dispatch_get_main_queue(), ^{
		[_durationTimer invalidate];
		_durationTimer = nil;
		_durationSlider.value = 0;
	});
	
	if (_currentTrack.audio_type_id == soundclound) {
		[_audioPlayer pause];
	}
	else if (_currentTrack.audio_type_id == youtube) {
		[_webView removeFromSuperview];
	}
	
}

- (IBAction)valueSliderChangedHandler:(id)sender {
	[_durationTimer invalidate];
}

- (IBAction)touchDragInsideSliderHandler:(id)sender {
	UALogFull(@"durationSlider: %f", _durationSlider.value);
	[_durationTimer invalidate];
}

- (IBAction)touchUpInsideSliderHandler:(id)sender {
	double trackDuration = CMTimeGetSeconds([_audioPlayer currentItem].duration);
	CMTime duration = CMTimeMakeWithSeconds(_durationSlider.value * trackDuration, 1);
	[_audioPlayer seekToTime:duration];
	
	_durationTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(syncScrubber) userInfo:nil repeats:YES];
}

@end
