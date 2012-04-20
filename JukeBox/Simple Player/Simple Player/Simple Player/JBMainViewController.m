//
//  JBMainViewController.m
//  JukeBox
//
//  Created by Andrei on 3/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "JBMainViewController.h"

@interface JBMainViewController (PrivateMethods)
- (void)openUpJukeBoxRoom:(PFObject *)jukeBoxObject;
@end

@implementation JBMainViewController

@synthesize buttonJoin, buttonSearchAround;
@synthesize textFieldJukeBoxID;
@synthesize indicatorQueryingForJukeBox;

- (id)init
{
    self = [super initWithNibName:@"JBMainView" bundle:nil];
    if (self) {
        
    }
    
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - IBActions

- (IBAction)joinJukeBox:(id)sender
{
    // TODO: Start an indicator here
    
    // Search for the juke box and make sure it exists
    PFQuery *query = [PFQuery queryWithClassName:kClassNameJukeBox];
    NSString *roomID = textFieldJukeBoxID.text;
    
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber * theNumber = [f numberFromString:roomID];
    [f release];
    
    if (theNumber)
    {
        [query whereKey:kAttributeJukeBoxJukeBoxID equalTo:theNumber];
        [indicatorQueryingForJukeBox startAnimating];
        
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            [indicatorQueryingForJukeBox stopAnimating];
            
            if (!error) {
                // The find succeeded.
                NSLog(@"Successfully retrieved %d scores.", objects.count);
                if (objects.count > 0) 
                {
                    [self openUpJukeBoxRoom:[objects objectAtIndex:0]];
                }
                else {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"No Juke Box found"
                                                                        message:@"There was no JukeBox with that ID found"
                                                                       delegate:nil
                                                              cancelButtonTitle:@"OK"
                                                              otherButtonTitles:nil];
                    
                    [alertView show];
                    [alertView release];
                }
            } else {
                // Log details of the failure
                NSLog(@"Error: %@ %@", error, [error userInfo]);
                NSString *message = [NSString stringWithFormat:@"Whoops, an error occured: %@ %@", error, [error userInfo]];
                UIAlertView *alertView = [[UIAlertView alloc] 
                                          initWithTitle:@"An error has occured"
                                                message:message
                                                delegate:nil
                                          cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
                
                [alertView show];
                [alertView release];

            }
        }];
    }
}

/* Opens up the Juke Box room */
- (void)openUpJukeBoxRoom:(PFObject *)jukeBoxObject
{
    NSString *jukeBoxRoomName = [jukeBoxObject objectForKey:kAttributeJukeBoxName];
    
    JBJukeBoxRoomViewController *jukeBoxRoomController = [[JBJukeBoxRoomViewController alloc] initWithStyle:UITableViewStyleGrouped];
    jukeBoxRoomController.title = jukeBoxRoomName;
    jukeBoxRoomController.jukeboxID = textFieldJukeBoxID.text;
    jukeBoxRoomController.jukeboxObject = jukeBoxObject;
    
    [self.navigationController pushViewController:jukeBoxRoomController animated:YES];
    [jukeBoxRoomController release];
}

- (IBAction)showMyPlaylists:(id)sender
{
    JBAllPlaylistsTableViewController *allPlaylists = [[JBAllPlaylistsTableViewController alloc] initWithStyle:UITableViewStylePlain];
    [self.navigationController pushViewController:allPlaylists animated:YES];
}

@end
