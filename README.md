# OrangeOAuth

Orangered's dead-simple drop-in Reddit OAuth library. This library was made to provide some much-needed simplification to Reddit OAuth usage. OrangeOAuth provides a sleek and straightforward solution for both OAuth and OnePassword support, all contained within its own attractive web view controller. This library was created from and made to conform to [Reddit's official specifications](https://github.com/reddit/reddit/wiki/OAuth2-iOS-Example).

## Installation

The easiest way to install OrangeOAuth is from Cocoapods. In your Podfile, add the line: `pod 'OrangeOAuth'. Feel free to `try` as well, using the detailed example project.

If you would like to do it manually, simply add in the files `CARedditOAuth.h`, `CARedditOAuth.m`, `CARedditOAuthDelegate.h`, `CAWebViewController.h`, `CAWebViewController.m` and the resources found [here](Resources).

## Usage

OrangeOAuth's usage was designed to keep it as simple as possible, however, there is a good deal of preparation required to get Reddit and your application ready. In order to set up your application for OAuth, follow the steps below for both Reddit and your iOS client.

### Web

Go to [Reddit's website under apps.](https://www.reddit.com/prefs/apps/) Then, create an application. Enter the name, check installed app, and for redirect_uri, enter your bundle identifier with `://response` after it. For me, it would be `com.contextdev.orangeoauth://response`. 
![](https://raw.githubusercontent.com/contextapps/OrangeOAuth/master/Screenshots/screenshot1.png)

Once you have saved the app, you should see it like this:

![](https://raw.githubusercontent.com/contextapps/OrangeOAuth/master/Screenshots/screenshot2.png)
Right under "installed app" is your client identifier. This is important for the upcoming steps so remember it.

### iOS

Start out by importing the file needed for OrangeOAuth in your App Delegate.

    #import <CARedditOAuth.h>
    
Then, put this code in your App Delegate. When the URL scheme is run, this will let my code do the rest for you, manually.

    - (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
        return [[CARedditOAuth sharedInstance] recievedURL:url];
    }

Once you have done this, open the file that you will actually be presenting the OAuth view controller.
In this file,  import the necessary file.

    #import <CARedditOAuth.h>

Conform to the protocol `CARedditOAuthDelegate`.
Now, when you want to push the Reddit view controller, run the following code:

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

The client identifier should be the identifier you got earlier when setting up your app on Reddit's website. The scopes should be an array of strings that are permissions you are requesting. You can see all the scopes [on Reddit's Github wiki.](https://github.com/reddit/reddit/wiki/oauth2#authorization) The URL scheme should be your bundle identifier. The delegate should most likely be set to `self`.

In the class you set your delegate to, you must implement the following methods:

    - (void)redditOAuth:(CARedditOAuth *)redditOAuth presentViewController:(UIViewController *)viewController {
        [self presentViewController:viewController animated:YES completion:nil];
    }
    
    - (void)redditOAuth:(CARedditOAuth *)redditOAuth didFinishWithAuthorizationCode:(NSString *)authorizationCode {
        NSLog(@"The authorization code is %@", authorizationCode);
    }

In the first method, you need to show the view controller provided, weather it is presenting it, pushing it, or something else. In the second method, you receive your authorization code in Reddit which means that the OAuth process is done.

Now, add a URL type in the project under the `info` tab. Make the Identifier and the URL scheme your bundle identifier. This is _crucial_ to your OAuth process working.
![](https://raw.githubusercontent.com/contextapps/OrangeOAuth/master/Screenshots/screenshot3.png)
> **Note:** URL schemes in iOS 9

> - URL schemes in iOS 9 are changed. Apple has made them more secure. 
> - Talked about in [this article](http://awkwardhare.com/post/121196006730/quick-take-on-ios-9-url-scheme-changes) and [in this WWDC session. ](https://developer.apple.com/videos/wwdc/2015/?id=703)
> - If you are deploying your app in iOS 9, in the Info.plist add the key `LSApplicationQueriesSchemes` as an array and put `org-appextension-feature-password-management` and your bundle identifier in the array.

## That's it!

The delegate methods will be called, and you will receive the OAuth code from Reddit. Your next steps are up to you! You can see what you can do with the authorization code [on Reddit's OAuth wiki.](https://github.com/reddit/reddit/wiki/oauth2#token-retrieval-code-flow)

## Author

Context Apps, [https://github.com/contextapps](https://github.com/contextapps)
Ben Rosen, [benrosen78@gmail.com](mailto:benrosen78@gmail.com)

## License

	OrangeOAuth: Orangered's dead-simple drop-in Reddit OAuth library.
	Copyright (C) 2015 Context Apps
	
	The MIT License (MIT)     
     	Permission is hereby granted, free of charge, to any person obtaining a copy
     	of this software and associated documentation files (the "Software"), to deal
     	in the Software without restriction, including without limitation the rights
     	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
     	copies of the Software, and to permit persons to whom the Software is
     	furnished to do so, subject to the following conditions:
     
     	The above copyright notice and this permission notice shall be included in all
     	copies or substantial portions of the Software.
     
     	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
     	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
     	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
     	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
     	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
     	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
     	SOFTWARE.
  
