//
//  JBJukeBoxRoomViewController.h
//  JukeBox
//
//  Created by Andrei on 4/6/12.
//  Copyright (c) 2012 Spotify. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JBAllPlaylistsTableViewController.h"

@interface JBJukeBoxRoomViewController : UITableViewController
{
    NSString *jukeboxID;
    PFObject *jukeboxObject;
    
    NSMutableArray *currentQueue;
    NSString *currentlyPlayingSongId;
    
    NSTimer *refreshParseInformationTimer;
}

@property (nonatomic, retain) NSString *jukeboxID;
@property (nonatomic, retain) PFObject *jukeboxObject;

@end
