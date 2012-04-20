//
//  KeyChainHelper.m
//
//  Created by Andrei on 2/29/12.
//  Copyright (c) 2012 Andrei Patru. All rights reserved.
//

#import "KeyChainHelper.h"

static NSString *serviceName = @"com.andreipatru.jukebox";
static KeyChainHelper *_sharedKeyChainHelper = nil;

@interface KeyChainHelper (PrivateMethods)

- (NSMutableDictionary *)newSearchDictionaryWithIdentifier:(NSString *)identifier;

@end

@implementation KeyChainHelper

+ (KeyChainHelper *)defaultKeyChainHelper
{
    if (!_sharedKeyChainHelper)
    {
        _sharedKeyChainHelper = [[KeyChainHelper alloc] init];
    }
    
    return _sharedKeyChainHelper;
}

- (id)init {
    self = [super init];
    if (self) {
    }
    return self;
}

// identifier - "Password", "LicenceKey", "TokenID"
- (NSMutableDictionary *)newSearchDictionaryWithIdentifier:(NSString *)identifier {
    NSMutableDictionary *searchDictionary = [[NSMutableDictionary alloc] init];  
	
    [searchDictionary setObject:(id)kSecClassGenericPassword forKey:(id)kSecClass];
	
    NSData *encodedIdentifier = [identifier dataUsingEncoding:NSUTF8StringEncoding];
    
    /* a label used to identify the keychain item - e.g. "Password", "LicenceKey", "TokenID"
       not the actual value of the password!
     */
    [searchDictionary setObject:encodedIdentifier forKey:(id)kSecAttrGeneric];
    
    /* the combination of account and service should be unique */
    [searchDictionary setObject:encodedIdentifier forKey:(id)kSecAttrAccount];
    [searchDictionary setObject:serviceName forKey:(id)kSecAttrService];
	
    return searchDictionary; 
}

#pragma mark - CRUD

- (BOOL)createKeychainValue:(NSString *)value forIdentifier:(NSString *)identifier {
    NSMutableDictionary *dictionary = [self newSearchDictionaryWithIdentifier:identifier];
    
    NSData *passwordData = [value dataUsingEncoding:NSUTF8StringEncoding];
    [dictionary setObject:passwordData forKey:(id)kSecValueData];
	
    OSStatus status = SecItemAdd((CFDictionaryRef)dictionary, NULL);
    [dictionary release];
	
    if (status == errSecSuccess) {
        return YES;
    }
    
    return NO;
}

- (BOOL)updateKeychainValue:(NSString *)value forIdentifier:(NSString *)identifier {
    
    NSMutableDictionary *searchDictionary = [self newSearchDictionaryWithIdentifier:identifier];
    NSMutableDictionary *updateDictionary = [[NSMutableDictionary alloc] init];
    NSData *passwordData = [value dataUsingEncoding:NSUTF8StringEncoding];
    [updateDictionary setObject:passwordData forKey:(id)kSecValueData];
	
    OSStatus status = SecItemUpdate((CFDictionaryRef)searchDictionary,
                                    (CFDictionaryRef)updateDictionary);
    
    [searchDictionary release];
    [updateDictionary release];
	
    if (status == errSecSuccess) {
        return YES;
    }
    return NO;
}

- (BOOL)deleteKeychainValueForIdentifier:(NSString *)identifier {
    NSMutableDictionary *searchDictionary = [self newSearchDictionaryWithIdentifier:identifier];
    OSStatus status = SecItemDelete((CFDictionaryRef)searchDictionary);
    [searchDictionary release];
    
    if (status == errSecSuccess) {
        return YES;
    }
    
    return NO;
}

- (NSData *)searchKeychainCopyMatchingDataForIdentifier:(NSString *)identifier {
    NSMutableDictionary *searchDictionary = [self newSearchDictionaryWithIdentifier:identifier];
	
    // Add search attributes - search only for one
    [searchDictionary setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
	
    // Add search return types
    [searchDictionary setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
	
    NSData *result = nil;
    SecItemCopyMatching((CFDictionaryRef)searchDictionary, (CFTypeRef *)&result);
	
    [searchDictionary release];
    return result;
}

@end
