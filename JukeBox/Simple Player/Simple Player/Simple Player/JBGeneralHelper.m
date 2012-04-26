//
//  JBGeneralHelper.m
//  JukeBox
//
//  Created by Andrei on 4/9/12.
//  Copyright (c) 2012 Spotify. All rights reserved.
//

#import "JBGeneralHelper.h"

#define kUserDefaultsUniqueIdentifier   @"uniqueIdentifier"

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

/**
 Checks whether a given NSString object is empty or nil.
 @param 
 theString The given string that will be checked against.
 @returns 
 BOOL Returns YES if the string is empty or nil, NO otherwise
 */
+ (BOOL)stringIsEmptyOrNil:(NSString *)theString
{
    return (theString == (id)[NSNull null] || theString.length == 0);
}

/**
 Makes and returns an unique identifier
 */
+ (NSString *)GetUniqueIdentifier
{
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef thestring = CFUUIDCreateString(NULL, theUUID);
    CFRelease(theUUID);
    return [(NSString *)thestring autorelease];
}

/**
 Because we can no longer the phone's UUID, we have to create one ourselves
 @returns 
 NSString The phone's unique identifier
 */
+ (NSString *)getPhoneUniqueIdentifier
{
    if ([self stringIsEmptyOrNil:[[NSUserDefaults standardUserDefaults] 
                                  stringForKey:kUserDefaultsUniqueIdentifier]])
    {
        // if empty, create one
        NSString *uniqueID = [self GetUniqueIdentifier];
        [[NSUserDefaults standardUserDefaults] setObject:uniqueID
                                                  forKey:kUserDefaultsUniqueIdentifier];
        return uniqueID;
    }
    
    return [[NSUserDefaults standardUserDefaults] stringForKey:kUserDefaultsUniqueIdentifier];
}

@end
