//
//  KeyChainHelper+JukeBoxSpecific.h
//  JukeBox
//
//  Created by Andrei on 4/20/12.
//  Copyright (c) 2012 Spotify. All rights reserved.
//

#import "KeyChainHelper.h"

#define kKeyChainSpotifyPasswordIdentifier      @"spotifyPassword"

@interface KeyChainHelper (JukeBoxSpecific)

- (BOOL)writePasswordToKeyChain:(NSString *)password;
- (NSString *)passwordFromKeyChain;

@end
