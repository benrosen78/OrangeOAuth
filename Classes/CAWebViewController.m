//
//  CAWebViewController.m
//  Reddit iOS Oauth
//
//  Created by Ben Rosen on 6/11/15.
//  Copyright © 2015 Context Development. All rights reserved.
//

#import "CAWebViewController.h"
#import <OnePasswordExtension/OnePasswordExtension.h>

@interface CAWebViewController () <UIWebViewDelegate>

@property (strong, nonatomic) UIWebView *webView;

@property (strong, nonatomic) NSURL *url;

@property (strong, nonatomic) UIBarButtonItem *backButton, *forwardButton;

@end

@implementation CAWebViewController

- (id)initWithURL:(NSURL *)url {
    if (self = [super init]) {
        _url = url;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // This is the UIWebView. Configure it, load in the URL, then add in the constraints.
    
    _webView = [[UIWebView alloc] init];
    _webView.delegate = self;
    [_webView loadRequest:[NSURLRequest requestWithURL:_url]];
    _webView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_webView];
    
    NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:_webView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0];
    NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:_webView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0];
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:_webView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0];
    NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:_webView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0];
    [self.view addConstraints:@[leftConstraint, rightConstraint, topConstraint, bottomConstraint]];
    
    // We will be using the UINavigationController toolbar, so unhide it.
    
    self.navigationController.toolbarHidden = NO;
    
    // Configure back buttons. Back and forward and buttons are properties because we need to access them later throughout the code, while the rest of them don't need to be accessed ever again.
    
    _backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"leftarrow"] style:UIBarButtonItemStyleDone target:self action:@selector(backPressed:)];
    _forwardButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"rightarrow"] style:UIBarButtonItemStyleDone target:self action:@selector(forwardPressed:)];
    
    // Create more buttons. The variable flexibleItem allows us to space out the items in the UIToolbar.
    
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(sharePressed:)];
    UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshPressed:)];

    // Make a mutable array of buttons. It is mutable because we may need to add a 1Password button IF the extension says the user has 1Password installed. If the user has 1Password installed, we add the button and the flexibleItem again for proper spacing.
    
    NSMutableArray *toolbarItems = [NSMutableArray arrayWithArray:@[_backButton, flexibleItem, _forwardButton, flexibleItem, refreshButton, flexibleItem, shareButton]];
    if ([[OnePasswordExtension sharedExtension] isAppExtensionAvailable]) {
        UIBarButtonItem *onePasswordItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"onepassword-toolbar"] style:UIBarButtonItemStyleDone target:self action:@selector(onePasswordPressed:)];
        [toolbarItems addObjectsFromArray:@[flexibleItem, onePasswordItem]];
    }
    
    // Set the toolbar items.
    
    self.toolbarItems = toolbarItems;
    
    // Make sure the buttons are enabled/disabled properly.
    
    [self updateButtonStates];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)refreshPressed:(UIBarButtonItem *)sender {
    [_webView loadRequest:[NSURLRequest requestWithURL:_url]];
}

// Delegate method when the web page starts to load: set the title to Loading... the whole time it is loading.

- (void)webViewDidStartLoad:(nonnull UIWebView *)webView {
    self.title = @"Loading...";
}

// Delegate method when the web page finishes loading: update our URL property, make the title the title of the webpage. Update the button states so they are enabled/disabled properly.

- (void)webViewDidFinishLoad:(nonnull UIWebView *)webView {
    self.url = webView.request.URL;
    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    [self updateButtonStates];
}

- (void)backPressed:(UIBarButtonItem *)sender {
    // Back button. Go back on web page.
    [_webView goBack];
}

- (void)forwardPressed:(UIBarButtonItem *)sender {
    // Forward button. Go forward on web page.
    [_webView goForward];
}

- (void)onePasswordPressed:(UIButton *)sender {
    // One password extension when the button is pressed. Load in 1Password into the web view so the user can enter their password.
    [[OnePasswordExtension sharedExtension] fillLoginIntoWebView:self.webView forViewController:self sender:sender completion:nil];
}

- (void)sharePressed:(UIButton *)sender {
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[_url] applicationActivities:nil];
    [self presentViewController:activityViewController animated:YES completion:nil];
}

// Make sure the buttons are only enabled if the user should be able to press them.
- (void)updateButtonStates {
    _backButton.enabled = _webView.canGoBack;
    _forwardButton.enabled = _webView.canGoForward;
}

// This is the button in the navigation controller. Dismiss the navigation controller we made.
- (void)cancelPressed:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
