//
//  JBJukeBoxRoomViewController.m
//  JukeBox
//
//  Created by Andrei on 4/6/12.
//  Copyright (c) 2012 Spotify. All rights reserved.
//

#import "JBJukeBoxRoomViewController.h"

@interface JBJukeBoxRoomViewController ()
- (void)bringUpAllPlaylistViewController:(id)sender;
- (void)cancelQueuingASong:(id)sender;
- (void)refreshParseInformation;
@end

@implementation JBJukeBoxRoomViewController

@synthesize jukeboxID;
@synthesize jukeboxObject;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // set the right bar button to "Add new song to queue"
        UIBarButtonItem *addSongToQueueButton = [[UIBarButtonItem alloc] 
                                                 initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                 target:self
                                                 action:@selector(bringUpAllPlaylistViewController:)];
        self.navigationItem.rightBarButtonItem = addSongToQueueButton;
        [addSongToQueueButton release];
        
        // timer for refreshing the parse information
        refreshParseInformationTimer = [NSTimer timerWithTimeInterval:20
                                                               target:self
                                                             selector:@selector(refreshParseInformation)
                                                             userInfo:nil
                                                              repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:refreshParseInformationTimer forMode:NSDefaultRunLoopMode];
        
        // add observer for parse object information
        NSString *keyPathToQueue = [@"jukeboxObject." stringByAppendingString:kAttributeJukeBoxQueue];
        [self addObserver:self
               forKeyPath:keyPathToQueue
                  options:NSKeyValueObservingOptionNew
                  context:nil];
    }
    
    return self;
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"jukeboxObject.queue"];
    
    [jukeboxID release];
    [jukeboxObject release];
    [super dealloc];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    NSLog(@"A keypath has changed: %@", keyPath);
    if ([keyPath isEqualToString:[@"jukeboxObject." stringByAppendingString:kAttributeJukeBoxQueue]])
    {
        NSLog(@"Queue has changed!");
        [self.tableView reloadData];
    }
}

// Brings up the user's playlists, so that the user can start choosing the song to add to the queue
- (void)bringUpAllPlaylistViewController:(id)sender
{    
    JBAllPlaylistsTableViewController *allPlaylistsController = [[JBAllPlaylistsTableViewController alloc] initWithStyle:UITableViewStylePlain];
    allPlaylistsController.jukeboxObject = self.jukeboxObject;
    
    UINavigationController *allPlaylistsNavController = [[UINavigationController alloc] initWithRootViewController:allPlaylistsController];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                     style:UIBarButtonItemStylePlain
                                                                    target:self
                                                                    action:@selector(cancelQueuingASong:)];
    allPlaylistsController.navigationItem.leftBarButtonItem = cancelButton;
    
    [self presentModalViewController:allPlaylistsNavController animated:YES];
    
    [cancelButton release];
    [allPlaylistsController release];
    [allPlaylistsNavController release];
}

- (void)cancelQueuingASong:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self refreshParseInformation];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

// Refresh the information we get from Parse
- (void)refreshParseInformation
{
    // get the currently playing track and the current queue    
    currentQueue = [jukeboxObject objectForKey:kAttributeJukeBoxQueue];
    currentlyPlayingSongId = [jukeboxObject objectForKey:kAttributeJukeBoxCurrentTrack];
    
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            if ([currentQueue lastObject]) return [currentQueue count];
            else return 0;
            break;
        default:
            break;
    }
    
    // Return the number of rows in the section.
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }

    // Configure the cell...
    switch (indexPath.section) {
        case 0:
            if (currentlyPlayingSongId.length > 0)
            {
                SPTrack *currentlyPlayingTrack = [SPTrack trackForTrackURL:[NSURL URLWithString:currentlyPlayingSongId]
                                                                 inSession:[SPSession sharedSession]];
                cell.textLabel.text = currentlyPlayingTrack.name;
                cell.detailTextLabel.text = [JBGeneralHelper artistsNamesCombinedStringFromSpotifyTrack:currentlyPlayingTrack];
            }
            break;
        case 1:
        {
            SPTrack *trackAtLocation = [SPTrack trackForTrackURL:[NSURL URLWithString:[currentQueue objectAtIndex:indexPath.row]] 
                                                       inSession:[SPSession sharedSession]];
            cell.textLabel.text = trackAtLocation.name;
            cell.detailTextLabel.text = [JBGeneralHelper artistsNamesCombinedStringFromSpotifyTrack:trackAtLocation];
            break;
        }
        default:
            break;
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return @"Currently Playing Song";
            break;
        case 1:
            return @"Queue";
            break;
        default:
            break;
    }
    
    return @"";
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

@end
