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
		self.position = 0;
		self.duration = 0;
		self.name = @"No name";
		self.url = @"";
		self.type = other;
	}
	return self;
}

@end
