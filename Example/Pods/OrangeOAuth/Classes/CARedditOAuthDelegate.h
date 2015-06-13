//
//  CARedditOAuthDelegate.h
//  Reddit iOS Oauth
//
//  Created by Ben Rosen on 6/7/15.
//  Copyright (c) 2015 Context Development. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CARedditOAuth;

@protocol CARedditOAuthDelegate <NSObject>

@required

/**
 * Helper method used by CARedditOAuth to push view controller for OAuth.
 */

- (void)redditOAuth:(CARedditOAuth *)redditOAuth presentViewController:(UIViewController *)viewController;

/**
 * Completion method with authorization code provided by Reddit OAuth API.
 */

- (void)redditOAuth:(CARedditOAuth *)redditOAuth didFinishWithAuthorizationCode:(NSString *)authorizationCode;

@end
