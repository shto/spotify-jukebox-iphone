//
//  PPasswordGiver.h
//  JukeBox
//
//  Created by Andrei on 4/20/12.
//  Copyright (c) 2012 Spotify. All rights reserved.
//

#import <Foundation/Foundation.h>

// Implemented by objects that can return a password
@protocol PPasswordGiver <NSObject>

- (NSString *)getPassword;

@end
