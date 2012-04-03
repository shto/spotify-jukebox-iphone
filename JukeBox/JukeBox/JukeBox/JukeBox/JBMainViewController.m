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
    // TODO: Add logic here to search for the juke box and make sure it exists
    // For now, just continue to the next view
    
    JBCurrentQueueController *currentQueueController = [[JBCurrentQueueController alloc] initWithStyle:UITableViewStyleGrouped];
    currentQueueController.title = @"Current Queue";
    [self.navigationController pushViewController:currentQueueController animated:YES];
    [currentQueueController release];
}

- (IBAction)showMyPlaylists:(id)sender
{
    JBAllPlaylistsTableViewController *allPlaylists = [[JBAllPlaylistsTableViewController alloc] initWithStyle:UITableViewStylePlain];
    [self.navigationController pushViewController:allPlaylists animated:YES];
}

@end
