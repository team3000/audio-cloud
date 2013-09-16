//
//  ViewController.h
//  WhydTest
//
//  Created by Adrien Guffens on 9/11/13.
//  Copyright (c) 2013 WeMoodz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
//#import "AudioPlayerView.h"

@class PlayerView;

@interface ViewController : UIViewController <AVAudioPlayerDelegate, UIWebViewDelegate>

//INFO: Music List
@property (nonatomic, strong)NSMutableArray *tracksList;

//-------------

//INFO: UI
@property (weak, nonatomic) IBOutlet PlayerView *playerView;

//INFO: Player informations
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;

//-------------

//INFO: Controls
@property (strong, nonatomic) IBOutlet UIButton *prevButton;
@property (strong, nonatomic) IBOutlet UIButton *playPauseButton;
@property (strong, nonatomic) IBOutlet UIButton *nextButton;

@property (strong, nonatomic) IBOutlet UISlider *durationSlider;

//INFO: handler
- (IBAction)prevHandler:(id)sender;
- (IBAction)playPauseHandler:(id)sender;
- (IBAction)nextHandler:(id)sender;

- (IBAction)valueSliderChangedHandler:(id)sender;

- (IBAction)touchDragInsideSliderHandler:(id)sender;
- (IBAction)touchUpInsideSliderHandler:(id)sender;

@end
