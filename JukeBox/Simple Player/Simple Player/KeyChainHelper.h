//
//  KeyChainHelper.h
//
//  Created by Andrei on 2/29/12.
//  Copyright (c) 2012 Andrei Patru. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Security/Security.h>

@interface KeyChainHelper : NSObject

/**
 Creates and saves a new value for the given identifier within the keychain.
 @param 
 value          The value to be added to the keychain
 identifier     The identifier to which this value is attached
 @returns 
 BOOL           YES if successful. NO otherwise
 */
- (BOOL)createKeychainValue:(NSString *)value forIdentifier:(NSString *)identifier;

/**
 Updates an identifier in the keychain with a new value
 @param 
 value          The update value
 identifier     The identifier to which this value is attached
 @returns 
 BOOL           YES if successful. NO otherwise
 */
- (BOOL)updateKeychainValue:(NSString *)value forIdentifier:(NSString *)identifier;

/**
 Deletes an identifier from the keychain
 @param 
 identifier     The identifier which we wish to delete
 @returns 
 BOOL           YES if successful. NO otherwise
 */
- (BOOL)deleteKeychainValueForIdentifier:(NSString *)identifier;

/**
 Searches the keychain for the given identifier
 @param 
 identifier     The identifier we will be looking for in the keychain
 @returns 
 NSData*        Will return the NSData of the value we have found in the keychain. Will return nil
                if nothing is found in the keychain related to the identifier
 */
- (NSData *)searchKeychainCopyMatchingDataForIdentifier:(NSString *)identifier;

@end
