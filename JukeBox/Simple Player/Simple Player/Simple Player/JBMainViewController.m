//
//  JBMainViewController.m
//  JukeBox
//
//  Created by Andrei on 3/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "JBMainViewController.h"

@implementation JBMainViewController

@synthesize buttonJoin, buttonSearchAround;
@synthesize textFieldJukeBoxID;

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
    // Search for the juke box and make sure it exists
    PFQuery *query = [PFQuery queryWithClassName:kClassNameJukeBox];
    NSString *roomID = textFieldJukeBoxID.text;
    PFObject *jukeBoxObject = [query getObjectWithId:roomID];
    
    // if we didn't find any room with that ID, return
    // TODO: Add an alert view - inform the user that he has fat fingers and probably typed the address all wrong
    if (!jukeBoxObject) return;
    
    NSString *jukeBoxRoomName = [jukeBoxObject objectForKey:kAttributeJukeBoxName];
    
    JBJukeBoxRoomViewController *jukeBoxRoomController = [[JBJukeBoxRoomViewController alloc] initWithStyle:UITableViewStyleGrouped];
    jukeBoxRoomController.title = jukeBoxRoomName;
    jukeBoxRoomController.jukeboxID = roomID;
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
