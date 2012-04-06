//
//  JBAllPlaylistsTableViewController.h
//  JukeBox
//
//  Created by Andrei on 4/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPSession.h"
#import "SPPlaylist.h"
#import "SPPlaylistContainer.h"
#import "JBAllSongsInPlaylistViewController.h"

@interface JBAllPlaylistsTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>
{
    // I need some sort of an array to hold all the playlists
    SPPlaylistContainer *playlistContainer;
    
    // The JukeBox object to whose queue we are pushing a song
    PFObject *jukeboxObject;
}

@property (nonatomic, retain) PFObject *jukeboxObject;

@end
