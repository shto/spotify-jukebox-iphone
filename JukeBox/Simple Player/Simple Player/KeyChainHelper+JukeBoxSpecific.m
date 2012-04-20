//
//  KeyChainHelper+JukeBoxSpecific.m
//  JukeBox
//
//  Created by Andrei on 4/20/12.
//  Copyright (c) 2012 Spotify. All rights reserved.
//

#import "KeyChainHelper+JukeBoxSpecific.h"

@implementation KeyChainHelper (JukeBoxSpecific)

- (BOOL)writePasswordToKeyChain:(NSString *)password
{
    BOOL returnValue = NO;
    
    // the tokenID identifier already exists
    if ([self searchKeychainCopyMatchingDataForIdentifier:kKeyChainSpotifyPasswordIdentifier])
    {
        returnValue = [self updateKeychainValue:password forIdentifier:kKeyChainSpotifyPasswordIdentifier];
    }
    else
    {
        returnValue = [self createKeychainValue:password forIdentifier:kKeyChainSpotifyPasswordIdentifier];
    }
    
    return returnValue;
}

- (NSString *)passwordFromKeyChain
{
    NSString *password = nil;
    NSData *tokenData = [self searchKeychainCopyMatchingDataForIdentifier:kKeyChainSpotifyPasswordIdentifier];
    if (tokenData) {
        password = [[NSString alloc] initWithData:tokenData encoding:NSUTF8StringEncoding];
        [tokenData release];
    }
    
    return [password autorelease];
}

@end
