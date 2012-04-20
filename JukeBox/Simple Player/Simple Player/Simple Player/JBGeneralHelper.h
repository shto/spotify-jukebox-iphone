//
//  JBGeneralHelper.h
//  JukeBox
//
//  Created by Andrei on 4/9/12.
//  Copyright (c) 2012 Spotify. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPTrack.h"
#import "SPArtist.h"

@interface JBGeneralHelper : NSObject

+ (NSString *)artistsNamesCombinedStringFromSpotifyTrack:(SPTrack *)theTrack;

@end
