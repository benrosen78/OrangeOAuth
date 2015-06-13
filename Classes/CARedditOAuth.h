//
//  CARedditOAuth.h
//  Reddit iOS Oauth
//
//  Created by Ben Rosen on 6/7/15.
//  Copyright (c) 2015 Context Development. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CARedditOAuthDelegate.h"

/**
 * Singleton class used to start Reddit OAuth.
 */

@interface CARedditOAuth : NSObject

/**
 * The delegate used to finish the OAuth and help it.
 */

@property (nonatomic, weak) id<CARedditOAuthDelegate>delegate;

/**
 * Identifier given by Reddit OAuth API online. Must be set for OAuth to work.
 */

@property (strong, nonatomic) NSString *clientIdentifier;

/**
 * URL scheme that will recieve the secret code from the Reddit OAuth API. Must be set for OAuth to work.
 */

@property (strong, nonatomic) NSString *urlScheme;

/**
 * An array of strings (scopes) that give the developer certain permissions to the user's account. As of writing, the scopes are: identity, edit, flair, history, modconfig, modflair, modlog, modposts, modwiki, mysubreddits, privatemessages, read, report, save, submit, subscribe, vote, wikiedit, wikiread. Available at https://github.com/reddit/reddit/wiki/oauth2#authorization in the scope chart. Must be set for OAuth to work.
 */

@property (strong, nonatomic) NSArray *scopes;

+ (instancetype)sharedInstance;

/**
 * Method that will do everything for you with the OAuth. Above properties are required for this to work properly.
 */

- (void)startRedditOAuth;

- (BOOL)recievedURL:(NSURL *)url;

@end
