//
//  TMNTBookmarks.m
//  TakeMeNearThere
//
//  Created by Ian Blue on 3/23/13.
//  Copyright (c) 2013 Heroes in a Half Shell. All rights reserved.
//

#import "TMNTBookmarks.h"
#import "TMNTAppDelegate.h"
#import <CoreData/CoreData.h>
#import "PlaceVisited.h"
#import "TMNTSecondVC.h"

@interface TMNTBookmarks ()
{
    NSArray *bookmarkArray;
    TMNTSecondVC *secondViewController;
}

@end

@implementation TMNTBookmarks

@synthesize myManagedObjectContext2, placeVisted, historyPersistedArray1;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"BOOOOOKMARKKKKKKKSSSS");
    bookmarkArray = [self fetchBookmarks];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//core data fetch for bookmarked businesses
-(NSArray*) fetchBookmarks
{
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"PlaceVisited" inManagedObjectContext:self.myManagedObjectContext2];
    NSFetchRequest * fetchRequest = [[NSFetchRequest alloc]init];
    NSFetchedResultsController * fetchResultsController;
    
    //Now customize your search! We'd want to switch this to see if isBookmarked == true
    NSArray * sortDescriptors = [[NSArray alloc] initWithObjects:nil];
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"isBookmarked == %@", [NSNumber numberWithBool:YES]];
    NSError *searchError;

    [fetchRequest setSortDescriptors:sortDescriptors];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setEntity:entityDescription];
    fetchResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.myManagedObjectContext2 sectionNameKeyPath:nil cacheName:nil];
    
    [fetchResultsController performFetch:&searchError];
    //Something about making the arrays equal size or some shit. Gawd.
    //This will update your display array with your fetch results
    bookmarkArray = fetchResultsController.fetchedObjects;
    
    return fetchResultsController.fetchedObjects;
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
    if (bookmarkArray == nil)
    {
        return 0;
    }
    else
    {
        return bookmarkArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *customCell = [tableView dequeueReusableCellWithIdentifier:@"bookmarkCellIdentifier"];
    
    // Configure the cell...
    PlaceVisited *place = [bookmarkArray objectAtIndex:[indexPath row]];
    NSString *placeName = place.title;
    //    NSLog(@"%@",placeName);
    //    placeTitleLabel.text = placeName;
    
    UIView * titleViewToLabel = [customCell viewWithTag:101];
    UILabel *titleLabel = (UILabel *) titleViewToLabel;
    titleLabel.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:12];
    titleLabel.text = placeName;
    
    
    return customCell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        BOOL bookmark = NO;
        placeVisted = [bookmarkArray objectAtIndex:indexPath.row];
        placeVisted.isBookmarked = [NSNumber numberWithBool:bookmark];
        NSError *error;
        if (![myManagedObjectContext2 save:&error])
        {
            NSLog(@"failed to save error: %@", [error userInfo]);
        }
        bookmarkArray = [self fetchBookmarks];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [tableView reloadData];
    }   
   // else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
   // }
}


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
     */
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"bookmarksToSecondDetail"])
    {
        
    }
}
@end
