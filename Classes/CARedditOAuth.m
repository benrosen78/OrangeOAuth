//
//  CARedditOAuth.m
//  Reddit iOS Oauth
//
//  Created by Ben Rosen on 6/7/15.
//  Copyright (c) 2015 Context Development. All rights reserved.
//

#import "CARedditOAuth.h"
#import "CAWebViewController.h"

@interface CARedditOAuth ()

@property (strong, nonatomic) UINavigationController *navigationController;

@property (strong, nonatomic) NSString *uniqueString;

@end

@implementation CARedditOAuth

+ (instancetype)sharedInstance {
    static dispatch_once_t dl = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&dl, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

- (void)startRedditOAuth {
    _uniqueString = [[NSUUID UUID] UUIDString];
    
    NSString *urlString = [NSString stringWithFormat:@"https://ssl.reddit.com/api/v1/authorize?client_id=%@&response_type=code&state=%@&redirect_uri=%@://response&duration=permanent&scope=%@", _clientIdentifier, _uniqueString, _urlScheme, [_scopes componentsJoinedByString:@","]];
    
    NSURL *authorizationURL = [NSURL URLWithString:urlString];

    self.navigationController = [[UINavigationController alloc] initWithRootViewController:[[CAWebViewController alloc] initWithURL:authorizationURL]];
    
    [self.delegate redditOAuth:self presentViewController:self.navigationController];
}

- (BOOL)recievedURL:(NSURL *)url {
    if ([url.scheme isEqualToString:self.urlScheme]) {

        NSArray *queryParams = [url.query componentsSeparatedByString:@"&"];
        NSArray *codeParam = [queryParams filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF BEGINSWITH %@", @"code="]];
        NSArray *stateParam = [queryParams filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF BEGINSWITH %@", @"state="]];
        
        NSString *codeQuery = codeParam[0];
        NSString *stateQuery = stateParam[0];
        
        NSString *code = [codeQuery stringByReplacingOccurrencesOfString:@"code=" withString:@""];
        NSString *state = [stateQuery stringByReplacingOccurrencesOfString:@"state=" withString:@""];
        
        if ([state isEqualToString:_uniqueString]) {
            [self.delegate redditOAuth:self didFinishWithAuthorizationCode:code];
            [_navigationController dismissViewControllerAnimated:YES completion:nil];
        }
        return YES;
    }
    return NO;
}

@end
