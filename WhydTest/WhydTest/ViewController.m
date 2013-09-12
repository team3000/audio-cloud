//
//  ViewController.m
//  WhydTest
//
//  Created by Adrien Guffens on 9/11/13.
//  Copyright (c) 2013 WeMoodz. All rights reserved.
//

#import "ViewController.h"
#import "Track.h"

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
//#import <SCRequest.h>
#import "PlayerView.h"

static NSString *soundcloundClientId = @"4a35610ca12c56aa757a2b3c140215a6";

//INFO: MAIN VIEW CONTROLLER
@interface ViewController ()

@property (nonatomic, strong)Track *currentTrack;
@property (nonatomic, assign)BOOL isPlaying;
@property (nonatomic, assign)int position;

//INFO: Player:
// -Soundclound
@property (nonatomic, strong)AVAudioPlayer *soundcloundPlayer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.tracksList = [[NSMutableArray alloc] init];
	
	Track *track = [[Track alloc] init];
	track.name = @"Praise You";
	track.duration = 100.0;
	track.url = @"";
	track.type = soundclound;
	
	Track *track2 = [[Track alloc] init];
	track2.name = @"Forever Dolphin Love";
	track2.duration = 100.0;
	track2.url = @"http://www.youtube.com/embed/OSAsuy_UwO8";
	track2.type = youtube;
	
	Track *track3 = [[Track alloc] init];
	track3.name = @"MKWC";
	track3.duration = 100.0;
	track3.url = @"";
	track3.type = soundclound;
	
	
	[self.tracksList addObject:track];
	[self.tracksList addObject:track2];
	[self.tracksList addObject:track3];
	
	//DEBUG:
	NSLog(@"%s - tracksList: %@", __PRETTY_FUNCTION__, self.tracksList);
	
	self.currentTrack = nil;
	self.isPlaying = NO;
	self.position = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI

- (void)updateViewForTheCurrentTrack {
	//INFO: getting the track
	self.currentTrack = [self.tracksList objectAtIndex:self.position];
    
	//INFO: setting up informations ---> do it on the main thread
	{
		self.nameLabel.text = self.currentTrack.name;
		
		NSString *buttonTitle = (self.isPlaying == NO ? @"Pause" : @"Play");
		[self.playPauseButton setTitle:buttonTitle forState:UIControlStateNormal];
		
	}
}

- (void) playCurrentTrack {
    
    switch (self.currentTrack.type) {
        case soundclound:
        {
            NSString *urlString = [NSString stringWithFormat:@"%@?client_id=%@", self.currentTrack.url, soundcloundClientId];
            
            break;
        }
            
        case youtube:
        {
            UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.playerView.frame.size.width, self.playerView.frame.size.height)];
            webView.delegate = self;
            //TODO: do a custom UIWebView class
            
            [self.playerView addSubview:webView];
            
            
            [self embedYouTubeInWebView:self.currentTrack.url theWebView:webView];

            
            
            
            break;
        }
        case other:
        {
            break;
        }
            
        default:
            break;
    }
	
    
	/*
     
	 */
}

#pragma mark - UIWebView

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"%s %@", __PRETTY_FUNCTION__, [webView description]);
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"%s %@", __PRETTY_FUNCTION__, [webView description]);
}

- (void)embedYouTubeInWebView:(NSString*)url theWebView:(UIWebView *)aWebView {
    NSLog(@"%s %@", __PRETTY_FUNCTION__, [aWebView description]);
    NSString *embedHTML = @"\
    <html><head>\
    <style type=\"text/css\">\
    body {\
    background-color: transparent;\
    color: white;\
    }\
    </style>\
    </head><body style=\"margin:0\">\
    <embed id=\"yt\" src=\"%@\" type=\"application/x-shockwave-flash\" \
    width=\"%0.0f\" height=\"%0.0f\"></embed>\
    </body></html>";
    
    NSString* html = [NSString stringWithFormat:embedHTML, url, aWebView.frame.size.width, aWebView.frame.size.height];
    
    [aWebView loadHTMLString:html baseURL:nil];
}

#pragma mark - Handlers

- (IBAction)prevHandler:(id)sender {
	//INFO: setting prev sound to play
	self.position = ((self.position - 1) < 0) ? ([self.tracksList count] - 1) : self.position - 1;
	[self updateViewForTheCurrentTrack];
}

- (IBAction)playPauseHandler:(id)sender {
	if (self.isPlaying == NO) {
		self.isPlaying = YES;
		
		[self updateViewForTheCurrentTrack];
        
	}
	else {
		//TODO: pause
		self.isPlaying = NO;
		[self updateViewForTheCurrentTrack];
	}
}

- (IBAction)nextHandler:(id)sender {
	//INFO: setting next sound to play
	self.position = (self.position + 1) >= [self.tracksList count] ? 0 : self.position + 1;
    
	[self updateViewForTheCurrentTrack];
}

- (IBAction)valueSliderChangedHandler:(id)sender {
	NSLog(@"%s - mainSlider: %f", __PRETTY_FUNCTION__, self.mainSlider.value);
}

@end
