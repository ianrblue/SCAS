//
//  RHPlacesTableViewController.m
//  Rushour
//
//  Created by Nathan Levine on 6/16/13.
//  Copyright (c) 2013 Rushour. All rights reserved.
//

#import "RHPlacesTableViewController.h"
#import "RHAppDelegate.h"
#import "Place.h"

@interface RHPlacesTableViewController ()
{
    NSArray *myPlacesArray;
}

@end

@implementation RHPlacesTableViewController
@synthesize myManagedObjectContext, delegate;

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
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //pass the context
    RHAppDelegate *appDelegate = (RHAppDelegate *)[[UIApplication sharedApplication]delegate];
    self.myManagedObjectContext = [appDelegate managedObjectContext];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //update our tableview array of data to reflect the new change
    myPlacesArray = [self getSavedPlaces];
    
    //reload tableview
    [self.tableView reloadData];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return myPlacesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    //get the place for the row
    Place *place = [myPlacesArray objectAtIndex:indexPath.row];

    // Configure the cell...
    cell.textLabel.text = place.name;
    cell.detailTextLabel.text = place.address;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.

    //grab the place to be sent to trip planner
    Place *placeToPass = [myPlacesArray objectAtIndex:indexPath.row];
    
    //call the delegate method and send over place
    [self.delegate addPlaceNameFromTableviewWithPlace:placeToPass];
    
    //deselect the row
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //popviewcontroller back to trip planner
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark Core Data (CRUDS)
//SAVE!!!
-(void)saveData
{
    NSError *error;
    if (![myManagedObjectContext save:&error])
    {
        NSLog(@"failed to save error: %@", [error userInfo]);
    }
}

//DELETE!!!
-(void)deletePlace: (Place*)place
{
    [self.myManagedObjectContext deleteObject:place];
    
    [self saveData];
}

-(NSArray *) getSavedPlaces
{
    //setting up the fetch
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Place"
                                                         inManagedObjectContext:self.myManagedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    NSFetchedResultsController *fetchResultsController;
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects: nil];
    NSError *sadnessError;
    
    //actually setting up the fetch
    [fetchRequest setSortDescriptors:sortDescriptors];
    [fetchRequest setEntity:entityDescription];
    fetchResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                 managedObjectContext:myManagedObjectContext
                                                                   sectionNameKeyPath:nil
                                                                            cacheName:nil];
    [fetchResultsController performFetch:&sadnessError];
    
    return fetchResultsController.fetchedObjects;
}


@end
