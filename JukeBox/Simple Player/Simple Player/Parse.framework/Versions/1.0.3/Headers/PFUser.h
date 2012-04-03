// PFUser.h
// Copyright 2011 Parse, Inc. All rights reserved.

#import <Foundation/Foundation.h>
#import "PFObject.h"
#import "PF_Facebook.h"

/*!
 A Parse Framework User Object that is a local representation of a user persisted to the Parse cloud. This class
 is a subclass of a PFObject, and retains the same functionality of a PFObject, but also extends it with various
 user specific methods, like authentication, signing up, and validation uniqueness.
 */


@interface PFUser : PFObject {
    NSString *password;
    NSString *sessionToken;
    BOOL isNew;
@private
    BOOL isCurrentUser;
}

/** 
 The password for the PFUser. This will not be filled in from the server with
 the password. It is only meant to be set.
 */
@property (nonatomic, retain) NSString *password;

/// The session token for the PFUser. This is set by the server upon successful authentication.
@property (nonatomic, retain) NSString *sessionToken;

/// Whether the PFUser was just created from a request. This is only set after a Facebook login.
@property (readonly, assign) BOOL isNew;

/// The username for the PFUser.
@property (nonatomic, retain) NSString *username;

/// The email for the PFUser.
@property (nonatomic, retain) NSString *email;

/*!
 Initializes a new PFUser object.
 @result Returns a new PFUser object.
 */
- (id)init;

/*!
 Creates a new PFUser object.
 @result Returns a new PFUser object.
 */
+ (PFUser *)user;

/*!
 Gets the currently logged in user from disk and returns an instance of it.
 @result Returns a PFUser that is the currently logged in user. If there is none, returns nil.
 */
+ (PFUser *)currentUser;

/*!
 Makes a request to login a user with specified credentials. Returns an instance
 of the successfully logged in PFUser. This will also cache the user locally so 
 that calls to userFromCurrentUser will use the latest logged in user.
 @param username The username of the user.
 @param password The password of the user.
 @result Returns an instance of the PFUser on success. If login failed for either wrong password or wrong username, returns nil.
 */
+ (PFUser *)logInWithUsername:(NSString *)username
                     password:(NSString *)password;

/*!
 Makes a request to login a user with specified credentials. Returns an
 instance of the successfully logged in PFUser. This will also cache the user 
 locally so that calls to userFromCurrentUser will use the latest logged in user.
 @param username The username of the user.
 @param password The password of the user.
 @param error The error object to set on error.
 @result Returns an instance of the PFUser on success. If login failed for either wrong password or wrong username, returns nil.
 */
+ (PFUser *)logInWithUsername:(NSString *)username
                     password:(NSString *)password
                        error:(NSError **)error;

/*!
 Makes an asynchronous request to login a user with specified credentials.
 Returns an instance of the successfully logged in PFUser. This will also cache 
 the user locally so that calls to userFromCurrentUser will use the latest logged in user.
 @param username The username of the user.
 @param password The password of the user.
 */
+ (void)logInWithUsernameInBackground:(NSString *)username
                             password:(NSString *)password;

/*!
 Makes an asynchronous request to login a user with specified credentials.
 Returns an instance of the successfully logged in PFUser. This will also cache 
 the user locally so that calls to userFromCurrentUser will use the latest logged in user. 
 The selector for the callback should look like: myCallback:(PFUser *)user error:(NSError **)error
 @param username The username of the user.
 @param password The password of the user.
 @param target Target object for the selector.
 @param selector The selector that will be called when the asynchrounous request is complete.
 */
+ (void)logInWithUsernameInBackground:(NSString *)username
                             password:(NSString *)password
                               target:(id)target
                             selector:(SEL)selector;

/*!
 Send a password reset request for a specified email. If a user account exists with that email,
 an email will be sent to that address with instructions on how to reset their password.
 @param email Email of the account to send a reset password request.
 @result Returns true if the reset email request is successful. False if no account was found for the email address.
 */
+ (BOOL)requestPasswordResetForEmail:(NSString *)email;

/*!
 Send a password reset request for a specified email and sets an error object. If a user
 account exists with that email, an email will be sent to that address with instructions 
 on how to reset their password.
 @param email Email of the account to send a reset password request.
 @param error Error object to set on error.
 @result Returns true if the reset email request is successful. False if no account was found for the email address.
 */
+ (BOOL)requestPasswordResetForEmail:(NSString *)email error:(NSError **)error;

/*!
 Send a password reset request asynchronously for a specified email and sets an
 error object. If a user account exists with that email, an email will be sent to 
 that address with instructions on how to reset their password.
 @param email Email of the account to send a reset password request.
 */
+ (void)requestPasswordResetForEmailInBackground:(NSString *)email;

/*!
 Send a password reset request asynchronously for a specified email and sets an error object.
 If a user account exists with that email, an email will be sent to that address with instructions
 on how to reset their password.
 @param email Email of the account to send a reset password request.
 @param target Target object for the selector.
 @param selector The selector that will be called when the asynchronous request is complete. It should have the following signature: (void)callbackWithResult:(NSNumber *)result error:(NSError **)error. error will be nil on success and set if there was an error. [result boolValue] will tell you whether the call succeeded or not.
 */
+ (void)requestPasswordResetForEmailInBackground:(NSString *)email
                                          target:(id)target
                                        selector:(SEL)selector;

/*!
 Logs out the currently logged in user on disk.
 */
+ (void)logOut;

/*!
 Whether the user is an authenticated object for the device. An authenticated PFUser is one that is obtained via
 a signUp or logIn method. An authenticated object is required in order to save (with altered values) or delete it.
 @result Returns whether the user is authenticated.
 */
- (BOOL)isAuthenticated;

/*!
 Signs up the user. Make sure that password and username are set. This will also enforce that the username isn't already taken. 
 @result Returns true if the sign up was successful.
 */
- (BOOL)signUp;

/*!
 Signs up the user. Make sure that password and username are set. This will also enforce that the username isn't already taken.
 @param error Error object to set on error. 
 @result Returns whether the sign up was successful.
 */
- (BOOL)signUp:(NSError **)error;

/*!
 Signs up the user asynchronously. Make sure that password and username are set. This will also enforce that the username isn't already taken.
 */
- (void)signUpInBackground;

/*!
 Signs up the user asynchronously. Make sure that password and username are set. This will also enforce that the username isn't already taken.
 @param target Target object for the selector.
 @param selector The selector that will be called when the asynchrounous request is complete. It should have the following signature: (void)callbackWithResult:(NSNumber *)result error:(NSError **)error. error will be nil on success and set if there was an error. [result boolValue] will tell you whether the call succeeded or not.
 */
- (void)signUpInBackgroundWithTarget:(id)target selector:(SEL)selector;

/*!
 Makes an asynchronous request to log in a user with specified credentials.
 Returns an instance of the successfully logged in PFUser. This will also cache 
 the user locally so that calls to userFromCurrentUser will use the latest logged in user. 
 @param username The username of the user.
 @param password The password of the user.
 @param block The block to execute. The block should have the following argument signature: (PFUser *user, NSError *error) 
 */
+ (void)logInWithUsernameInBackground:(NSString *)username
                             password:(NSString *)password
                                block:(PFUserResultBlock)block;

/*!
 Send a password reset request asynchronously for a specified email.
 If a user account exists with that email, an email will be sent to that address with instructions
 on how to reset their password.
 @param email Email of the account to send a reset password request.
 @param block The block to execute. The block should have the following argument signature: (BOOL succeeded, NSError *error) 
 */
+ (void)requestPasswordResetForEmailInBackground:(NSString *)email block:(PFBooleanResultBlock)block;

/*!
 Signs up the user asynchronously. Make sure that password and username are set. This will also enforce that the username isn't already taken.
 @param block The block to execute. The block should have the following argument signature: (BOOL succeeded, NSError *error) 
 */
- (void)signUpInBackgroundWithBlock:(PFBooleanResultBlock)block;


/*!
 Enables automatic creation of anonymous users.  After calling this method, [PFUser currentUser] will always have a value.
 The user will only be created on the server once the user has been saved, or once an object with a relation to that user or
 an ACL that refers to the user has been saved.
 */
+ (void)enableAutomaticUser;

/*!
 Deprecated.  Please see [PFFacebookUtils isLinkedWithUser:]
 */
- (BOOL)hasFacebook __attribute__ ((deprecated));

/*!
 Deprecated. Please see [PFFacebookUtils facebook].
 */
+ (PF_Facebook *)facebook __attribute__ ((deprecated));

/*!
 Deprecated. Please see [PFFacebookUtils facebookWithDelegate:].
 */
+ (PF_Facebook *)facebookWithDelegate:(id<PF_FBSessionDelegate>)delegate __attribute__ ((deprecated));

/*!
 Deprecated. Please see [PFFacebookUtils logInWithPermissions:target:selector:].
 */
+ (void)logInWithFacebook:(NSArray *)permissions target:(id)target selector:(SEL)selector __attribute__ ((deprecated));

/*!
 Deprecated. Please see [PFFacebookUtils linkUser:permissions:target:selector:].
 */
- (void)linkToFacebook:(NSArray *)permissions target:(id)target selector:(SEL)selector __attribute__ ((deprecated));

/*!
 Deprecated. Please see [PFFacebookUtils unlinkUser:].
 */
- (BOOL)unlinkFromFacebook __attribute__ ((deprecated));

/*!
 Deprecated. Please see [PFFacebookUtils unlinkUser:error:].
 */
- (BOOL)unlinkFromFacebookWithError:(NSError **)error __attribute__ ((deprecated));

/*!
 Deprecated. Please see [PFFacebookUtils unlinkUserInBackground:target:selector:].
 */
- (void)unlinkFromFacebookInBackgroundWithTarget:(id)target selector:(SEL)selector __attribute__ ((deprecated));

/*!
 Deprecated. Please see [PFFacebookUtils logInWithPermissions:block:].
 */
+ (void)logInWithFacebook:(NSArray *)permissions block:(PFUserResultBlock)block __attribute__ ((deprecated));

/*!
 Deprecated. Please see [PFFacebookUtils linkUser:permissions:block:].
 */
- (void)linkToFacebook:(NSArray *)permissions block:(PFBooleanResultBlock)block __attribute__ ((deprecated));

/*!
 Deprecated. Please see [PFFacebookUtils unlinkUserInBackground:block:].
 */
- (void)unlinkFromFacebookWithBlock:(PFBooleanResultBlock)block __attribute__ ((deprecated));

/*!
 Deprecated. Please see PF_Facebook.accessToken
 */
- (NSString *)facebookAccessToken __attribute__ ((deprecated));
/*!
 Deprecated. Please see PF_Facebook.expirationDate
 */
- (NSDate *)facebookExpirationDate __attribute__ ((deprecated));
/*!
 Deprecated. Please use PF_Facebook to make a graph call to "me"
 */
- (NSString *)facebookId __attribute__ ((deprecated));


@end
