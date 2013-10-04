//
//  Track.h
//  WhydTest
//
//  Created by Adrien Guffens on 9/11/13.
//  Copyright (c) 2013 WeMoodz. All rights reserved.
//

#import <Foundation/Foundation.h>

//INFO: may do subclassing for each kind of track
enum track_type {
	soundclound,
	youtube,
	other
};

@interface Track : NSObject

@property (nonatomic, strong)NSString *name;
@property (nonatomic, assign)double duration;//INFO: in seconds
@property (nonatomic, strong)NSString *url;
@property (nonatomic, assign)int audio_type_id;//INFO: bad type but will work
@property (nonatomic, assign)int position;
@property (nonatomic, strong)NSString *image;

@end
