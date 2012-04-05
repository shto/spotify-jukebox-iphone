//
//  JBAllSongsInPlaylistViewController.h
//  JukeBox
//
//  Created by Andrei on 4/5/12.
//  Copyright (c) 2012 Spotify. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPPlaylist.h"
#import "SPPlaylistItem.h"
#import "SPTrack.h"
#import "SPArtist.h"

@interface JBAllSongsInPlaylistViewController : UITableViewController
{
    SPPlaylist *currentPlaylist;
}

@property (nonatomic, retain) SPPlaylist *currentPlaylist;

@end
