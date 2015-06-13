//
//  ORViewController.m
//  OrangeOAuth Example
//
//  Created by Ben Rosen on 6/13/15.
//  Copyright © 2015 Context Development. All rights reserved.
//

#import "ORViewController.h"
#import <CARedditOAuth.h>

@interface ORViewController () <CARedditOAuthDelegate>

@end

@implementation ORViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonPressed:(UIButton *)sender {
    // [CARedditOAuth sharedInstance] is the instance you should use.
    CARedditOAuth *redditOAuth = [CARedditOAuth sharedInstance];
    // Client identifier is from the Reddit OAuth API.
    redditOAuth.clientIdentifier = @"RV9IIn94H5YmNQ";
    // Scopes are the permissions you want on this users Reddit account.
    redditOAuth.scopes = @[@"identity"];
    // This is the URL scheme you created earlier.
    redditOAuth.urlScheme = @"com.contextdev.orangeoauth";
    // Set the delegate so that the library can work.
    redditOAuth.delegate = self;
    // This will start the OAuth process.
    [redditOAuth startRedditOAuth];
    /*
     */
}

- (void)redditOAuth:(CARedditOAuth *)redditOAuth presentViewController:(UIViewController *)viewController {
    [self presentViewController:viewController animated:YES completion:nil];
}

- (void)redditOAuth:(CARedditOAuth *)redditOAuth didFinishWithAuthorizationCode:(NSString *)authorizationCode {
    NSLog(@"The authorization code is %@", authorizationCode);
}

@end
