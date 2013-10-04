//
//  Track.m
//  WhydTest
//
//  Created by Adrien Guffens on 9/11/13.
//  Copyright (c) 2013 WeMoodz. All rights reserved.
//

#import "Track.h"

@implementation Track

- (id)init {
	self = [super init];
	if (self != nil) {
		_position = 0;
		_duration = 0;
		_name = @"No name";
		_url = @"";
		_audio_type_id = other;
	}
	return self;
}

- (NSString *)description {
	return [NSString stringWithFormat:@"_position: %d | _duration: %f | _name: %@ | _url: %@ | _image: %@ | audio_type_id: %d", _position, _duration, _name, _url, _image, _audio_type_id];
}

@end
