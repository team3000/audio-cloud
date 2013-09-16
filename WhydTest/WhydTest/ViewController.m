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

//INFO: AVPlayer - for audio
#import <AVFoundation/AVPlayer.h>
#import <AVFoundation/AVPlayerItem.h>
#import <AVFoundation/AVAsset.h>

//INFO: MPMoviePlayerController - for video
#import <MediaPlayer/MediaPlayer.h>

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
	
	//
	
	self.tracksList = [[NSMutableArray alloc] init];
	
	Track *track = [[Track alloc] init];
	track.name = @"Praise You";
	track.duration = 100.0;
	track.url = @"http://api.soundcloud.com/tracks/91121058/stream";
	track.image = [UIImage imageNamed:@"praise.jpg"];
	track.type = soundclound;
	
	Track *track2 = [[Track alloc] init];
	track2.name = @"Agoria 50 min Boiler Room Mix at ADE 2012";
	track2.duration = 100.0;
	track2.url = @"http://www.youtube.com/embed/l5Qem9SAQZY";
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
	track4.image = [UIImage imageNamed:@"julian.jpg"];
	track4.type = youtube;
	
	
	[self.tracksList addObject:track];
	[self.tracksList addObject:track2];
	[self.tracksList addObject:track3];
	[self.tracksList addObject:track4];
	
	//DEBUG:
	NSLog(@"%s - tracksList: %@", __PRETTY_FUNCTION__, self.tracksList);
	
	self.currentTrack = track;
	self.isPlaying = NO;
	self.position = 0;
	
	[self updateViewForTheCurrentTrack];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Slider

- (void)syncScrubber
{
    CMTime playerDuration = [self playerItemDuration];//self.audioPlayer.currentItem.duration;
    if (CMTIME_IS_INVALID(playerDuration)) {
        self.durationSlider.minimumValue = 0.0;
        return;
    }
	
    double duration = CMTimeGetSeconds(playerDuration);
    if (isfinite(duration) && (duration > 0)) {
        float minValue = [self.durationSlider minimumValue];
        float maxValue = [self.durationSlider maximumValue];
        double time = CMTimeGetSeconds([self.audioPlayer currentTime]);
        [self.durationSlider setValue:(maxValue - minValue) * time / duration + minValue];
    }
}
//
- (CMTime)playerItemDuration {
    AVPlayerItem *thePlayerItem = [self.audioPlayer currentItem];
    if (thePlayerItem.status == AVPlayerItemStatusReadyToPlay) {
        return ([self.audioPlayer.currentItem duration]);
    }
	
    return(kCMTimeInvalid);
}

#pragma mark - UI

- (void)updateViewForTheCurrentTrack {
	//INFO: getting the track
	self.currentTrack = [self.tracksList objectAtIndex:self.position];
	NSLog(@"%s | self.currentTrack: %@ at position: %d", __PRETTY_FUNCTION__, self.currentTrack, self.position);
    
	//INFO: setting up informations ---> do it on the main thread
	{
		self.nameLabel.text = self.currentTrack.name;
		
		NSString *buttonTitle = (self.isPlaying == YES ? @"Pause" : @"Play");
		[self.playPauseButton setTitle:buttonTitle forState:UIControlStateNormal];
		
		UIColor *backgroundColor = nil;
		switch (self.currentTrack.type) {
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
			[self.durationSlider setTintColor:backgroundColor];
			[self.prevButton setTintColor:backgroundColor];
			[self.nextButton setTintColor:backgroundColor];
			[self.playPauseButton setTintColor:backgroundColor];
			//INFO: set image
			[self.playerView setBackgroundColor:[UIColor colorWithPatternImage:self.currentTrack.image]];
		});
	}
}

- (void)pauseCurrentTrack {
	switch (self.currentTrack.type) {
        case soundclound:
        {
			[self.audioPlayer pause];
			
			//INFO: debug
			if (debug == YES) {
				CMTime duration = self.audioPlayer.currentItem.duration; //INFO: total time
				NSUInteger dTotalSeconds = CMTimeGetSeconds(duration);
				
				NSUInteger dHours = floor(dTotalSeconds / 3600);
				NSUInteger dMinutes = floor(dTotalSeconds % 3600 / 60);
				NSUInteger dSeconds = floor(dTotalSeconds % 3600 % 60);
				
				NSString *videoDurationText = [NSString stringWithFormat:@"%i:%02i:%02i",dHours, dMinutes, dSeconds];
				
				NSLog(@"%s | Description of currentTime: %@", __PRETTY_FUNCTION__, videoDurationText);
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
	
    switch (self.currentTrack.type) {
        case soundclound:
        {
			//INFO: setup soundclound sound
            NSString *urlString = [NSString stringWithFormat:@"%@?client_id=%@", self.currentTrack.url, soundcloundClientId];
			
			NSURL *url = [NSURL URLWithString:urlString];
			
			self.audioPlayer = [AVPlayer playerWithURL:url];
			[self.audioPlayer setAllowsExternalPlayback:YES];
			
			[self.audioPlayer addObserver:self forKeyPath:@"status" options:0 context:nil];
			[self.audioPlayer addObserver:self forKeyPath:@"end" options:AVPlayerItemDidPlayToEndTimeNotification context:nil];
			
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
				self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.playerView.bounds.size.width, self.playerView.bounds.size.height)];
				self.webView.delegate = self;
				[self.webView setBackgroundColor:[UIColor clearColor]];
				//TODO: do a custom UIWebView class if selected way of doing
				
				[self.playerView addSubview:self.webView];
				
				[self embedYouTubeInWebView:self.currentTrack.url theWebView:self.webView];
				
			}
			if (NO)//INFO: MPMoviePlayerController
			{
				NSURL *movieURL = [NSURL URLWithString:self.currentTrack.url];
				_moviePlayer =  [[MPMoviePlayerController alloc]
								 initWithContentURL:movieURL];
				
				[[NSNotificationCenter defaultCenter] addObserver:self
														 selector:@selector(moviePlayBackDidFinish:)
															 name:MPMoviePlayerPlaybackDidFinishNotification
														   object:_moviePlayer];
				
				_moviePlayer.controlStyle = MPMovieControlStyleEmbedded;
				_moviePlayer.movieSourceType = MPMovieSourceTypeStreaming;
				_moviePlayer.shouldAutoplay = YES;
				[self.playerView addSubview:_moviePlayer.view];
				//			[_moviePlayer setFullscreen:NO animated:YES];
			}
			
			if (NO)//INFO: AVPlayer
			{
				NSURL *movieURL = [NSURL URLWithString:self.currentTrack.url];
				AVPlayer *avPlayer = [AVPlayer playerWithURL:movieURL];
				//					avPlayer prerollAtRate:<#(float)#> completionHandler:<#^(BOOL finished)completionHandler#>
				
				AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:avPlayer];
				avPlayer.actionAtItemEnd = AVPlayerActionAtItemEndNone;
				layer.frame = CGRectMake(0, 0, self.playerView.bounds.size.width, self.playerView.bounds.size.height);
				[self.view.layer addSublayer:layer];
				
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
        if (self.audioPlayer.status == AVPlayerStatusReadyToPlay) {
            [self.audioPlayer play];
			
			self.durationTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(syncScrubber) userInfo:nil repeats:YES];
        }
		else if (self.audioPlayer.status == AVPlayerStatusFailed) {
			NSLog(@"%s - ERROR", __PRETTY_FUNCTION__);
		}
    }
}

- (void)playerItemDidReachEnd:(NSNotification *)notification {
	[self nextHandler:nil];
	//[self.audioPlayer seekToTime:kCMTimeZero];
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
	NSLog(@"%s %@", __PRETTY_FUNCTION__, [webView description]);
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
	NSLog(@"%s %@", __PRETTY_FUNCTION__, [webView description]);
}

- (void)embedYouTubeInWebView:(NSString*)url theWebView:(UIWebView *)aWebView {
	NSLog(@"%s %@", __PRETTY_FUNCTION__, [aWebView description]);
	
	NSString *embedHTML  = [NSString stringWithFormat:@"\
							<html>\
							<head>\
							<style type=\"text/css\">\
							iframe {}\
							body {background-color:#000; margin:0;}\
							</style>\
							</head>\
							<body>\
							<iframe width=\"%0.0f\" height=\"%0.0f\" src=\"%@\" frameborder=\"0\"></iframe>\
							</body>\
							</html>", aWebView.frame.size.width, aWebView.frame.size.height, url];
	
	NSString* html = [NSString stringWithFormat:embedHTML, url, aWebView.frame.size.width, aWebView.frame.size.height];
	
	NSLog(@"%s | html: %@", __PRETTY_FUNCTION__, html);
	
	[aWebView loadHTMLString:html baseURL:nil];
}

#pragma mark - Handlers

- (IBAction)prevHandler:(id)sender {
	[self stop];

	//INFO: setting prev sound to play
	self.position = ((self.position - 1) < 0) ? ([self.tracksList count] - 1) : self.position - 1;
	NSLog(@"%s | self.position: %d", __PRETTY_FUNCTION__, self.position);
	
	[self updateViewForTheCurrentTrack];
	
	if (self.isPlaying == YES) {
		[self playCurrentTrack];
	}
	
}

- (IBAction)playPauseHandler:(id)sender {
	if (self.isPlaying == NO) {
		self.isPlaying = YES;
		
		[self updateViewForTheCurrentTrack];
		[self playCurrentTrack];
		
	}
	else {
		//TODO: pause [OK]
		
		[self pauseCurrentTrack];
		self.isPlaying = NO;
		[self updateViewForTheCurrentTrack];
	}
}

- (IBAction)nextHandler:(id)sender {
	[self stop];
	
	//INFO: setting next sound to play
	self.position = (self.position + 1) >= [self.tracksList count] ? 0 : self.position + 1;
	NSLog(@"%s | self.position: %d", __PRETTY_FUNCTION__, self.position);
	
	[self updateViewForTheCurrentTrack];
	
	if (self.isPlaying == YES) {
		[self playCurrentTrack];
	}
	
}

- (void)stop {
	//INFO: to test latter ->
	
	dispatch_async(dispatch_get_main_queue(), ^{
		[self.durationTimer invalidate];
		self.durationTimer = nil;
		self.durationSlider.value = 0;
	});
	
	if (self.currentTrack.type == soundclound) {
		[self.audioPlayer pause];
//		[self.audioPlayer cancelPendingPrerolls];
	}
	else if (self.currentTrack.type == youtube) {
		[self.webView removeFromSuperview];
	}

}

- (IBAction)valueSliderChangedHandler:(id)sender {
	[self.durationTimer invalidate];
}

- (IBAction)touchDragInsideSliderHandler:(id)sender {
	NSLog(@"OLA");
	NSLog(@"%s - durationSlider: %f", __PRETTY_FUNCTION__, self.durationSlider.value);
	[self.durationTimer invalidate];
}

- (IBAction)touchUpInsideSliderHandler:(id)sender {
	double trackDuration = CMTimeGetSeconds([self.audioPlayer currentItem].duration);
	CMTime duration = CMTimeMakeWithSeconds(self.durationSlider.value * trackDuration, 1);
	[self.audioPlayer seekToTime:duration];
	
	self.durationTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(syncScrubber) userInfo:nil repeats:YES];
}

@end
