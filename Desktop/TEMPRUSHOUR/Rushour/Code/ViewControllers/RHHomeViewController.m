//
//  RHHomeViewController.m
//  Rushour
//
//  Created by Nathan Levine on 5/30/13.
//  Copyright (c) 2013 Rushour. All rights reserved.
//

#import "RHHomeViewController.h"

@interface RHHomeViewController ()
{
    NSArray *myCommutesArray;
    RHTripInfoViewController *tripInfoVC;
}

@end

@implementation RHHomeViewController
@synthesize myManagedObjectContext;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //pass the context
    RHAppDelegate *appDelegate = (RHAppDelegate *)[[UIApplication sharedApplication]delegate];
    self.myManagedObjectContext = [appDelegate managedObjectContext];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //update our tableview array of data to reflect the new change
    myCommutesArray = [self getSavedCommutes];
    
    //reload tableview
    [mainTableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (IBAction)plusAction:(id)sender {
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
    return myCommutesArray.count;
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
    Commute *commute = [myCommutesArray objectAtIndex:indexPath.row];
    
    // Configure the cell...
    cell.textLabel.text = [NSString stringWithFormat:@"%@ to %@",commute.startPlaceName, commute.endPlaceName];
    cell.detailTextLabel.text = [self getSubtitleTextForCommute:commute];
    Route *test =  [[(NSSet*)commute.routes allObjects] objectAtIndex:0];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    
    //deselect the row
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -- set up table rows
- (NSString*)getSubtitleTextForCommute: (Commute*)commute
{
    NSMutableArray *arrayOfSavedDays = [NSMutableArray new];
    if ([commute.monday intValue] == [[NSNumber numberWithBool:YES] intValue]) {
        [arrayOfSavedDays addObject:@"Mon"];
    }
    if ([commute.tueday intValue] == [[NSNumber numberWithBool:YES] intValue]) {
        [arrayOfSavedDays addObject:@"Tue"];
    }
    if ([commute.wednesday intValue] == [[NSNumber numberWithBool:YES] intValue]) {
        [arrayOfSavedDays addObject:@"Wed"];
    }
    if ([commute.thursday intValue] == [[NSNumber numberWithBool:YES] intValue]) {
        [arrayOfSavedDays addObject:@"Thur"];
    }
    if ([commute.friday intValue] == [[NSNumber numberWithBool:YES] intValue]) {
        [arrayOfSavedDays addObject:@"Fri"];
    }
    if ([commute.saturday intValue] == [[NSNumber numberWithBool:YES] intValue]) {
        [arrayOfSavedDays addObject:@"Sat"];
    }
    if ([commute.sunday intValue] == [[NSNumber numberWithBool:YES] intValue]) {
        [arrayOfSavedDays addObject:@"Sun"];
    }
    
    NSString *subtitleString = [arrayOfSavedDays componentsJoinedByString:@", "];
    
    return subtitleString;
}
#pragma mark - Segue stuff
//called right before segue
//- (BOOL) shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
//{
//    NSIndexPath *indexPath = mainTableView.indexPathForSelectedRow;
//    
//}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = mainTableView.indexPathForSelectedRow;
    

    
    if ([segue.identifier isEqualToString:@"cellToTripInfo"])
    {
        //grab the place to be sent to trip planner
        Commute *commuteSelected = [myCommutesArray objectAtIndex:(NSInteger)[indexPath row]];
        tripInfoVC = segue.destinationViewController;
        tripInfoVC.commute = commuteSelected;
    }
}

#pragma mark - Core Data (CRUDS)
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
-(void)deleteCommute: (Commute*)commute
{
    [self.myManagedObjectContext deleteObject:commute];
    
    [self saveData];
}

//fetch
-(NSArray *) getSavedCommutes
{
    //setting up the fetch
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Commute"
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
