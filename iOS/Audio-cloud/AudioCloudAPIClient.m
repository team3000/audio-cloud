//
//  AudioCloudAPIClient.m
//  Audio-cloud
//
//  Created by Adrien Guffens on 10/3/13.
//  Copyright (c) 2013 Team3000. All rights reserved.
//

#import "AudioCloudAPIClient.h"
#import <AFNetworking/AFSecurityPolicy.h>

static NSString * const AFAppDotNetAPIBaseURLString = @"http://audio-cloud.herokuapp.com/";

@implementation AudioCloudAPIClient

+ (instancetype)sharedClient {
    static AudioCloudAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
		UALogFull(@"");
        _sharedClient = [[AudioCloudAPIClient alloc] initWithBaseURL:[NSURL URLWithString:AFAppDotNetAPIBaseURLString]];
        //[_sharedClient setSecurityPolicy:[AFSecurityPolicy policyWithPinningMode:AFSSLPinningModePublicKey]];
    });
    
    return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url {
	self = [super initWithBaseURL:url];
	if (self) {
		UALogFull(@"url: %@", [url description]);
	}
	return self;
}

- (AFHTTPRequestOperation *)HTTPRequestOperationWithRequest:(NSURLRequest *)request
                                                    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
	
	UALogFull(@"url: %@", [request description]);
	
	AFHTTPRequestOperation *requestOperation = [super HTTPRequestOperationWithRequest:request success:success failure:failure];
	return requestOperation;
}

- (NSURLSessionDataTask *)SUBSCRIBE:(NSString *)URLString
						 parameters:(NSDictionary *)parameters
							success:(void (^)(NSURLSessionDataTask *, id))success
							failure:(void (^)(NSError *))failure {
	return nil;
}


/*
 
 - (NSURLSessionDataTask *)HEAD:(NSString *)URLString
 parameters:(NSDictionary *)parameters
 success:(void (^)(NSURLSessionDataTask *))success
 failure:(void (^)(NSError *))failure {
 return nil;
 }
 
 - (NSURLSessionDataTask *)POST:(NSString *)URLString
 parameters:(NSDictionary *)parameters
 success:(void (^)(NSURLSessionDataTask *, id))success
 failure:(void (^)(NSError *))failure {
 return nil;
 }
 
 - (NSURLSessionDataTask *)POST:(NSString *)URLString
 parameters:(NSDictionary *)parameters
 constructingBodyWithBlock:(void (^)(id <AFMultipartFormData>))block
 success:(void (^)(NSURLSessionDataTask *, id))success
 failure:(void (^)(NSError *))failure {
 return nil;
 }
 
 - (NSURLSessionDataTask *)PUT:(NSString *)URLString
 parameters:(NSDictionary *)parameters
 success:(void (^)(NSURLSessionDataTask *))success
 failure:(void (^)(NSError *))failure {
 return nil;
 }
 
 - (NSURLSessionDataTask *)PATCH:(NSString *)URLString
 parameters:(NSDictionary *)parameters
 success:(void (^)(NSURLSessionDataTask *))success
 failure:(void (^)(NSError *))failure {
 return nil;
 }
 
 - (NSURLSessionDataTask *)DELETE:(NSString *)URLString
 parameters:(NSDictionary *)parameters
 success:(void (^)(NSURLSessionDataTask *))success
 failure:(void (^)(NSError *))failure {
 return nil;
 }
 */

@end
