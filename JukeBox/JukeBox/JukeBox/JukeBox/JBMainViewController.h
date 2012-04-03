//
//  JBMainViewController.h
//  JukeBox
//
//  Created by Andrei on 3/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JBCurrentQueueController.h"
#import "JBAllPlaylistsTableViewController.h"
#if TARGET_OS_IPHONE
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>
#import "CocoaLibSpotify.h"
#else
#import <CoreAudio/CoreAudio.h>
#import <CocoaLibSpotify/CocoaLibSpotify.h>
#endif

@interface JBMainViewController : UIViewController
{
    UIButton *buttonJoin;
    UIButton *buttonSearchAround;
}

@property (nonatomic, assign) IBOutlet UIButton *buttonJoin;
@property (nonatomic, assign) IBOutlet UIButton *buttonSearchAround;

- (IBAction)joinJukeBox:(id)sender;
- (IBAction)showMyPlaylists:(id)sender;

@end
