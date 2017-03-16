//
//  ViewModel.m
//  RequestCaching
//
//  Created by Martin Berger on 3/16/17.
//  Copyright © 2017 heavydebugging.inc. All rights reserved.
//

#import "ViewModel.h"
#import "Reachability.h"

@interface ViewModel() <NSURLSessionDelegate, NSURLSessionTaskDelegate>
@property(nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSString* text;
@property (nonatomic, strong) Reachability* internet;
@end

@implementation ViewModel

- (id)init {
    if (self = [super init]) {
        [self setup];
        return self;
    }
    return nil;
}

- (void)setup {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    self.session = session;
    
    self.internet = [Reachability reachabilityForInternetConnection];
    [self.internet startNotifier];
}

- (void)download {
    NSURL *url = [NSURL URLWithString:@"http://httpbin.org/get?data=happy"];
    
    NSURLRequestCachePolicy cachePolicy = NSURLRequestUseProtocolCachePolicy;
    NetworkStatus networkStatus = [self.internet currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        cachePolicy = NSURLRequestReturnCacheDataDontLoad;
    }
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:cachePolicy timeoutInterval:30];
    request.HTTPMethod = @"GET";
    
    NSURLSessionDataTask *task = [self.session dataTaskWithRequest:request];
    [task resume];
}

#pragma mark - NSURLSessionDelegate

- (void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(nullable NSError *)error {
    NSLog(@"%s", __FUNCTION__);
}

#pragma mark - NSURLSessionTaskDelegate

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    NSLog(@"%s", __FUNCTION__);
    //NSHTTPURLResponse *response = task.response;
    
    if (error) {
        NSLog(@"%@", error.debugDescription);
    }
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    NSLog(@"%s", __FUNCTION__);
    NSError *error = nil;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    if (error) {
        NSLog(@"%@", error.debugDescription);
    }
    NSString *text = json[@"args"][@"data"];
    NSLog(@"received text: %@", text);
    
    self.text = text;
    
    if ([self.delegate respondsToSelector:@selector(viewModelDidFinish:text:)]) {
        [self.delegate viewModelDidFinish:self text:text];
    }
}

@end
