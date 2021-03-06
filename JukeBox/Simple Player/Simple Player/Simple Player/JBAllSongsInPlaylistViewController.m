//
//  JBAllSongsInPlaylistViewController.m
//  JukeBox
//
//  Created by Andrei on 4/5/12.
//  Copyright (c) 2012 Spotify. All rights reserved.
//

#import "JBAllSongsInPlaylistViewController.h"

@interface JBAllSongsInPlaylistViewController ()

@end

@implementation JBAllSongsInPlaylistViewController

@synthesize currentPlaylist;
@synthesize jukeboxObject;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [currentPlaylist release];
    [jukeboxObject release];
    [super dealloc];
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[currentPlaylist items] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    SPPlaylistItem *playlistItemAtLocation = [[currentPlaylist items] objectAtIndex:indexPath.row];
    cell.textLabel.text = playlistItemAtLocation.item.name;
    if ([playlistItemAtLocation.item class] == [SPTrack class])
    {
        SPTrack *trackAtLocation = (SPTrack *)playlistItemAtLocation.item;
        cell.detailTextLabel.text = [JBGeneralHelper artistsNamesCombinedStringFromSpotifyTrack:trackAtLocation];
    }
    
    return cell;
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    selectedPlaylistItem = [[currentPlaylist items] objectAtIndex:indexPath.row];
    if ([selectedPlaylistItem.item class] != [SPTrack class])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Can't add item"
                                                        message:@"You can only add songs to the queue of the JukeBox. What you just selected doesn't look like a song"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK, I'll try again"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
        
        selectedPlaylistItem = nil;
        
        return;
    }
    
    NSString *selectedSongTitle = [[[[currentPlaylist items] objectAtIndex:indexPath.row] item] name];
    NSString *title = [NSString stringWithFormat:@"Are you sure you want to add %@ to this JukeBox?", selectedSongTitle];
    UIActionSheet *actionSheetAreYouSure = [[UIActionSheet alloc] initWithTitle:title
                                                                       delegate:self
                                                              cancelButtonTitle:@"No, don't add it!"
                                                         destructiveButtonTitle:@"Yes, add it!"
                                                              otherButtonTitles:nil];
    
    [actionSheetAreYouSure showInView:self.view];
    [actionSheetAreYouSure release];
}


#pragma mark - UIActionSheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            SPTrack *selectedTrack = (SPTrack *)selectedPlaylistItem.item;
            
            // add the song to the current juke box's queue
            NSString *currentSongURL = [NSString stringWithFormat:@"%@", selectedTrack.spotifyURL];
            NSMutableArray *currentQueue = [jukeboxObject objectForKey:kAttributeJukeBoxQueue];
            
            if (!currentQueue)
            {
                currentQueue = [[NSMutableArray alloc] init];
            }
            
            [currentQueue addObject:currentSongURL];
            [jukeboxObject setObject:currentQueue forKey:kAttributeJukeBoxQueue];
            
            NSLog(@"all items in the current queue: %d", [currentQueue count]);
            
            [jukeboxObject saveInBackgroundWithTarget:self selector:@selector(jukeboxObjectSavedWithResult:error:)];
            
            alertViewAddingSongToQueue = [[UIAlertView alloc] initWithTitle:@"Adding Song To Queue"
                                                                    message:@"..."
                                                                   delegate:self
                                                          cancelButtonTitle:nil
                                                          otherButtonTitles:nil];
            
            [alertViewAddingSongToQueue show];
            
            
            NSLog(@"all items in the current queue: %d", [currentQueue count]);

            break;
        }
        case 1:
            // don't add anything
            break;
        default:
            break;
    }
}
             
- (void)jukeboxObjectSavedWithResult:(NSNumber *)result error:(NSError *)error
{
    if (!error)
    {
        NSLog(@"Successfully saved object.");
        [alertViewAddingSongToQueue dismissWithClickedButtonIndex:0 animated:YES];
        [alertViewAddingSongToQueue release];
        alertViewAddingSongToQueue = nil;
        [self dismissModalViewControllerAnimated:YES];
    }
    else {
        NSLog(@"The error: %@", [error description]);
    }
}

@end
