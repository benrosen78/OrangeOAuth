//
//  CAWebViewController.h
//  Reddit iOS Oauth
//
//  Created by Ben Rosen on 6/11/15.
//  Copyright © 2015 Context Development. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CAWebViewController : UIViewController

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil NS_UNAVAILABLE;

/**
 * Only way to initialize a CAWebViewController properly. Give an NSURL.
 */

- (instancetype)initWithURL:(NSURL *)url;

@end
