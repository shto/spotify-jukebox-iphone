//
//  JBAllSongsInPlaylistViewController.h
//  JukeBox
//
//  Created by Andrei on 4/5/12.
//  Copyright (c) 2012 Spotify. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "SPPlaylist.h"
#import "SPPlaylistItem.h"
#import "SPTrack.h"
#import "SPArtist.h"

@interface JBAllSongsInPlaylistViewController : UITableViewController <UIActionSheetDelegate>
{
    SPPlaylist *currentPlaylist;
    PFObject *jukeboxObject;
}

@property (nonatomic, retain) SPPlaylist *currentPlaylist;
@property (nonatomic, retain) PFObject *jukeboxObject;

@end
