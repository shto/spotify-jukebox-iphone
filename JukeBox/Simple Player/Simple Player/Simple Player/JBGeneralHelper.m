//
//  JBGeneralHelper.m
//  JukeBox
//
//  Created by Andrei on 4/9/12.
//  Copyright (c) 2012 Spotify. All rights reserved.
//

#import "JBGeneralHelper.h"

@implementation JBGeneralHelper

+ (NSString *)artistsNamesCombinedStringFromSpotifyTrack:(SPTrack *)theTrack
{
    NSArray *allArtistsOfTrack = theTrack.artists;
    
    NSString *artistsNameCombined = @"";
    if ([allArtistsOfTrack count] == 1)
    {
        artistsNameCombined = [[allArtistsOfTrack objectAtIndex:0] name];
    }
    else 
    {
        NSMutableArray *arrayOfArtistNames = [[NSMutableArray alloc] init];
        for (SPArtist *artist in allArtistsOfTrack) {
            [arrayOfArtistNames addObject:artist.name];
        }
        
        artistsNameCombined = [arrayOfArtistNames componentsJoinedByString:@","];
        [arrayOfArtistNames release];
    }
    
    return artistsNameCombined;
}

@end
