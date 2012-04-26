//
//  Simple_PlayerAppDelegate.m
//  Simple Player
//
//  Created by Daniel Kennett on 10/3/11.
/*
 Copyright (c) 2011, Spotify AB
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 * Redistributions of source code must retain the above copyright
 notice, this list of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright
 notice, this list of conditions and the following disclaimer in the
 documentation and/or other materials provided with the distribution.
 * Neither the name of Spotify AB nor the names of its contributors may 
 be used to endorse or promote products derived from this software 
 without specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL SPOTIFY AB BE LIABLE FOR ANY DIRECT, INDIRECT,
 INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT 
 LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, 
 OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
 OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
 ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "JukeBoxAppDelegate.h"

#define TESTING 1

@interface JukeBoxAppDelegate (PrivateMethods)

-(void)showLogin;
- (void)NSLogAllPlaylists;

@end

@implementation JukeBoxAppDelegate

@synthesize window = _window;
@synthesize mainViewController = _mainViewController;
@synthesize sharedSession;
@synthesize buttonJoin;
@synthesize buttonSearchAround;
@synthesize navigationController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Parse setApplicationId:@"L6g7AozXjr5TQ06YtuTXjSs15NZwfYiRnDnaeAn9" 
                  clientKey:@"huqTuw04XCuGe3rxVlkhvkD2PH805UemWkUVoYNM"];
    
    [TestFlight takeOff:@"174465ff5413478e4defb14e0e7f6004_MTE1MjQwMjAxMS0wNy0yMiAwMzowMDo0NS4zNzE0NjE"];
    #ifdef TESTING
        
        [TestFlight setDeviceIdentifier:[JBGeneralHelper getPhoneUniqueIdentifier]];
    #endif
    
	// Override point for customization after application launch.
	[self.window makeKeyAndVisible];
	
	[SPSession initializeSharedSessionWithApplicationKey:[NSData dataWithBytes:&g_appkey length:g_appkey_size] 
											   userAgent:@"com.spotify.SimplePlayer-iOS"
												   error:nil];
    
    JBMainViewController *jbMainViewController = [[JBMainViewController alloc] init];
    UINavigationController *mainNavigationController = [[UINavigationController alloc] 
                                                        initWithRootViewController:jbMainViewController];
    self.window.rootViewController = mainNavigationController;
    [mainNavigationController release];
    [jbMainViewController release];    

	sharedSession = [SPSession sharedSession];
	[sharedSession setDelegate:self];
    [self addObserver:self 
           forKeyPath:@"sharedSession.userPlaylists.loaded" 
              options:NSKeyValueObservingOptionNew 
              context:nil];
        
    KeyChainHelper *tempKeyChainHelper = [[KeyChainHelper alloc] init];
//    [[NSUserDefaults standardUserDefaults] setObject:@"1110745591" forKey:kUserDefaultsUsernameKey];
    NSString *username = [[NSUserDefaults standardUserDefaults] stringForKey:kUserDefaultsUsernameKey];
    NSString *password = [tempKeyChainHelper passwordFromKeyChain];
    
    [self showLogin];
	
    if ([JBGeneralHelper stringIsEmptyOrNil:username] || [JBGeneralHelper stringIsEmptyOrNil:password])
    {
    }
    else {
        // perform login if credentials are available
        [loginViewController performLoginWithUsername:username andPassword:password];
    }
    
    [tempKeyChainHelper release];
    username = @"";
    password = @"";
	
    return YES;
}

-(void)showLogin {
    loginViewController = [[SPLoginViewController alloc] init];
	[self.window.rootViewController presentModalViewController:loginViewController
											   animated:NO];
}

/* 
 * FIXME: Figure out why the loaded property from the userplaylists does not really work correctly
 * Right now, it will turn to 1 (loaded) before the playlists are totally loaded.
 */
- (void)observeValueForKeyPath:(NSString *)keyPath 
                      ofObject:(id)object 
                        change:(NSDictionary *)change 
                       context:(void *)context {
    if ([keyPath isEqualToString:@"sharedSession.userPlaylists.loaded"]) 
    {
        NSLog(@"The change: %@", change);
        if ([[change valueForKey:NSKeyValueChangeNewKey] class] != [NSNull class])
        {
            BOOL newBoolValue = [[change valueForKey:NSKeyValueChangeNewKey] boolValue];
            NSLog(@"New bool value: %d", newBoolValue);
            if (newBoolValue) [self NSLogAllPlaylists];
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)NSLogAllPlaylists
{
    NSLog(@"All playlists: %@", sharedSession.userPlaylists);
}

- (void)applicationWillResignActive:(UIApplication *)application
{
	/*
	 Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	 Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
	 */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	/*
	 Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
	 If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	 */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	/*
	 Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
	 */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	/*
	 Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	 */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	/*
	 Called when the application is about to terminate.
	 Save data if appropriate.
	 See also applicationDidEnterBackground:.
	 */
	
	[[SPSession sharedSession] logout];
}

#pragma mark -
#pragma mark SPSessionDelegate Methods

-(void)sessionDidLoginSuccessfully:(SPSession *)aSession; {    
    if ([self.window.rootViewController.modalViewController 
         respondsToSelector:@selector(getPassword)])
    {
        NSString *thePassword = [self.window.rootViewController.modalViewController getPassword];
        KeyChainHelper *keyChainHelper = [[KeyChainHelper alloc] init];
        [keyChainHelper writePasswordToKeyChain:thePassword];
        [keyChainHelper release];
    }
    
	// Invoked by SPSession after a successful login
	[self.window.rootViewController dismissModalViewControllerAnimated:YES];
    
    [loginViewController release];
}

-(void)session:(SPSession *)aSession didFailToLoginWithError:(NSError *)error; {
    
	// Invoked by SPSession after a failed login.

	// Forward to the login view controller
	if ([self.mainViewController.modalViewController respondsToSelector:_cmd])
		[self.mainViewController.modalViewController performSelector:_cmd withObject:aSession withObject:error];
}

-(void)sessionDidLogOut:(SPSession *)aSession; {}
-(void)session:(SPSession *)aSession didEncounterNetworkError:(NSError *)error; {}
-(void)session:(SPSession *)aSession didLogMessage:(NSString *)aMessage; {}
-(void)sessionDidChangeMetadata:(SPSession *)aSession; {}

-(void)session:(SPSession *)aSession recievedMessageForUser:(NSString *)aMessage; {
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message from Spotify"
													message:aMessage
												   delegate:nil
										  cancelButtonTitle:@"OK"
										  otherButtonTitles:nil];
	[[alert autorelease] show];
}

- (void)dealloc {
	
	[self removeObserver:self forKeyPath:@"currentTrack.name"];
	[self removeObserver:self forKeyPath:@"currentTrack.artists"];
	[self removeObserver:self forKeyPath:@"currentTrack.album.cover.image"];
	[self removeObserver:self forKeyPath:@"playbackManager.trackPosition"];
	
	[_window release];
	[_mainViewController release];
    [super dealloc];
}

@end
