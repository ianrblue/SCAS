//
//  RHTripPlannerViewController.m
//  Rushour
//
//  Created by Nathan Levine on 6/13/13.
//  Copyright (c) 2013 Rushour. All rights reserved.
//
static inline BOOL IsObjectEmpty(id thing)
{
    return thing == nil
    || ([thing respondsToSelector:@selector(length)]
        && [(NSData *)thing length] == 0)
    || ([thing respondsToSelector:@selector(count)]
        && [(NSArray *)thing count] == 0)
    || ((NSNull*)thing == [NSNull null]);
}


#import "RHTripPlannerViewController.h"
#import "RHConstants.h"
#import "Route.h"

@interface RHTripPlannerViewController ()
{
    RHPlacesTableViewController *vc;
    RHPlacesTableViewController *vc2;
    Commute *tripToSave;
    Route *route;
}

@end

@implementation RHTripPlannerViewController
@synthesize tableOfPlacesVC, myManagedObjectContext;

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
    
    [self setUpAppearance];
}

-(void)onCancelButtonSelected:(id)sender
{
    BOOL validation = [self validateThatBothALocationAndADestinationHaveBeenSet];
    if (validation) {
        //do nothing proceed with backing
    } else {
        //delete the trip that was going to be saved
        if (tripToSave) {
            [self deleteCommute:tripToSave];
        }
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setUpAppearance
{
    //UI STUFF
    //background color
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
    
    //add back button, so that we can access its method
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                    style:UIBarButtonItemStyleBordered
                                                   target:self
                                                   action:@selector(onCancelButtonSelected:)];
    
    
    
    self.navigationItem.leftBarButtonItem = cancelButton;
}

#pragma mark - Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"startToTable"])
    {
        vc = segue.destinationViewController;
        vc.delegate = self;        
    } else if ([[segue identifier] isEqualToString:@"endToTable"]) {
        vc2 = segue.destinationViewController;
        vc2.delegate = self;
    }
}

#pragma mark - Table View Controller delegate
-(void)addPlaceNameFromTableviewWithPlace:(Place *)place
{
    //instantiate tripToSave if it isnt already (shouldnt be unless you change places)
    if (tripToSave == nil)
    {
        tripToSave = [NSEntityDescription insertNewObjectForEntityForName:@"Commute" inManagedObjectContext:myManagedObjectContext];
    }
    
    if (vc.delegate)
    {
        //set label
        startAddressLabel.text = place.name;
        //set triptosave attributes
        tripToSave.startPlaceName = place.name;
        tripToSave.startPlaceLat = place.latitude;
        tripToSave.startPlaceLong = place.longitude;
        //reset the delegate
        vc.delegate = nil;
    } else if (vc2.delegate) {
        endAddressLabel.text = place.name;
        tripToSave.endPlaceName = place.name;
        tripToSave.endPlaceLat = place.latitude;
        tripToSave.endPlaceLong = place.longitude;
        vc2.delegate = nil;
    }
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
-(void)deleteCommute: (Commute*)commute
{
    [self.myManagedObjectContext deleteObject:commute];
    
    [self saveData];
}

#pragma mark - Actions

- (IBAction)startAddressBtn:(id)sender
{
    //segue is performed
}

- (IBAction)endAddressBtn:(id)sender
{
    //segue is performed
}

- (IBAction)monBtn:(id)sender
{
    [self setLogicForDayActionsWithSender:sender andDay:MONDAY];
}

- (IBAction)tuesBtn:(id)sender
{
    [self setLogicForDayActionsWithSender:sender andDay:TUESDAY];
}

- (IBAction)wedBtn:(id)sender
{
    [self setLogicForDayActionsWithSender:sender andDay:WEDNESDAY];
}

- (IBAction)thursBtn:(id)sender
{
    [self setLogicForDayActionsWithSender:sender andDay:THURSDAY];
}

- (IBAction)friBtn:(id)sender
{
    [self setLogicForDayActionsWithSender:sender andDay:FRIDAY];
}

- (IBAction)satBtn:(id)sender
{
    [self setLogicForDayActionsWithSender:sender andDay:SATURDAY];
}

- (IBAction)sunBtn:(id)sender
{
    [self setLogicForDayActionsWithSender:sender andDay:SUNDAY];
}

- (IBAction)schedBtn:(id)sender
{
    BOOL validation = [self validateThatBothALocationAndADestinationHaveBeenSet];
    if (validation) {
        NSLog(@"start place is: %@ end place is:%@", tripToSave.startPlaceName, tripToSave.endPlaceName);
        //save trip to core data
        [self saveData];
        //get info from google
        [self callGoogleForBusInfo];
        //popviewcontroller back to trip planner
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self popUpALertsToAskUserToFillOutLocations];
    }
    
}

#pragma mark -- Logic for button actions
- (BOOL)validateThatBothALocationAndADestinationHaveBeenSet
{
    if ([startAddressLabel.text isEqualToString:@""] || [endAddressLabel.text isEqualToString:@""]) {
        return NO;
    } else {
        return YES;
    }
}

- (void) popUpALertsToAskUserToFillOutLocations
{
    //if one or both of the start and end locations are not set, set up an alert
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Please fill out locations" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    
    if ([startAddressLabel.text isEqualToString:@""] && [endAddressLabel.text isEqualToString:@""]) {
        //if both have not been set
        alert.message = @"Please fill out a start location and end destination";
        [alert show];
        
    } else if ([startAddressLabel.text isEqualToString:@""] && ![endAddressLabel.text isEqualToString:@""]) {
        //if start location has not been set
        alert.message = @"Please fill out a start location";
        [alert show];
        
    } else if (![startAddressLabel.text isEqualToString:@""] && [endAddressLabel.text isEqualToString:@""]) {
        //if start location has not been set
        alert.message = @"Please fill out an end Destination";
        [alert show];
        
    }
}
- (void)setLogicForDayActionsWithSender:(id)sender andDay:(RHDaysOfTheWeekButtons)day
{
    [sender setSelected:([sender isSelected]) ? NO : YES];

    if (tripToSave == nil && [sender isSelected]){
        //if no instantiation of commute make it
        tripToSave = [NSEntityDescription insertNewObjectForEntityForName:@"Commute" inManagedObjectContext:myManagedObjectContext];
        //add bool to it
        [self switchStatementThatSavesADayOfTheWeekToModelWithDay:day andBOOL:YES];
    } else if (tripToSave && [sender isSelected]){
        [self switchStatementThatSavesADayOfTheWeekToModelWithDay:day andBOOL:YES];
    } else if (tripToSave && ![sender isSelected]) {
        [self switchStatementThatSavesADayOfTheWeekToModelWithDay:day andBOOL:NO];
    }

}

- (void)switchStatementThatSavesADayOfTheWeekToModelWithDay:(RHDaysOfTheWeekButtons)day andBOOL:(BOOL)boolToUse
{
    switch (day) {
        case MONDAY:
            tripToSave.monday = [NSNumber numberWithBool:boolToUse];
            break;
        case TUESDAY:
            tripToSave.tueday = [NSNumber numberWithBool:boolToUse];
            break;
        case WEDNESDAY:
            tripToSave.wednesday = [NSNumber numberWithBool:boolToUse];
            break;
        case THURSDAY:
            tripToSave.thursday = [NSNumber numberWithBool:boolToUse];
            break;
        case FRIDAY:
            tripToSave.friday = [NSNumber numberWithBool:boolToUse];
            break;
        case SATURDAY:
            tripToSave.saturday = [NSNumber numberWithBool:boolToUse];
            break;
        case SUNDAY:
            tripToSave.sunday = [NSNumber numberWithBool:boolToUse];
            break;
            
        default:
            break;
    }
}

#pragma mark - GOOGLE API

- (void)callGoogleForBusInfo
{
    // CLLocationCoordinate2D origin = CLLocationCoordinate2DMake([tripToSave.startPlaceLat doubleValue], [tripToSave.startPlaceLong doubleValue]);
    // CLLocationCoordinate2D destination = CLLocationCoordinate2DMake([tripToSave.endPlaceLat doubleValue], [tripToSave.endPlaceLong doubleValue]);
    NSString *origin = [NSString stringWithFormat:@"%f,%f",[tripToSave.startPlaceLat doubleValue],[tripToSave.startPlaceLong doubleValue]];
    NSString *destination = [NSString stringWithFormat:@"%f,%f",[tripToSave.endPlaceLat doubleValue],[tripToSave.endPlaceLong doubleValue]];
    
    NSString *apiString = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/directions/json?origin=%@&destination=%@&sensor=true&departure_time=%d&mode=transit", origin, destination,((int)[[NSDate  date] timeIntervalSince1970])];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:apiString]];
    
    //not needed because it is the default
    //request.HTTPMethod = @"GET";
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^ void (NSURLResponse* myResponse, NSData* myData, NSError* theirError)
     {
         if (theirError)
         {
             NSLog(@"%@", theirError.localizedDescription);
         } else {
             NSError *error;
             id jsonRawData = [NSJSONSerialization JSONObjectWithData:myData
                                                              options:NSJSONReadingAllowFragments
                                                                error:&error];
             
             [self parseThroughReturnedDictionaryAndSaveInfoToCommuteWithDictionary:jsonRawData];
             
         }
     }];
}

- (void)parseThroughReturnedDictionaryAndSaveInfoToCommuteWithDictionary: (NSDictionary*)dict
{
    //get the array of legs
    NSArray *arrayOfRoute = [[[dict valueForKey:@"routes"] objectAtIndex:0] valueForKey:@"legs"];
    
    //get the total duration (in seconds)
    int totalDuration = (int)[[arrayOfRoute valueForKey:@"duration"] valueForKey:@"value"];
    tripToSave.totalTime = [NSNumber numberWithInt:totalDuration];

    //get the route info
    NSMutableArray *arrayOfRoutesForUsToSave = [NSMutableArray new];
    for (NSDictionary *legDict in [[arrayOfRoute valueForKey:@"steps"] objectAtIndex:0] ) {
        if ([[legDict valueForKey:@"travel_mode"] isEqualToString:@"TRANSIT"]) {
            if (route == nil)
            {
                route = [NSEntityDescription insertNewObjectForEntityForName:@"Route" inManagedObjectContext:myManagedObjectContext];
            }
            if (!IsObjectEmpty([[[legDict valueForKey:@"transit_details"] valueForKey:@"line"] valueForKey:@"color"])) {
                route.color = [[[legDict valueForKey:@"transit_details"] valueForKey:@"line"] valueForKey:@"color"];
                route.name = [[[legDict valueForKey:@"transit_details"] valueForKey:@"line"] valueForKey:@"name"];
            } else {
                route.name = [[[legDict valueForKey:@"transit_details"] valueForKey:@"line"] valueForKey:@"short_name"];
            }
            route.startStopName = [[[legDict valueForKey:@"transit_details"] valueForKey:@"departure_stop"] valueForKey:@"name"];
            route.endStopName = [[[legDict valueForKey:@"transit_details"] valueForKey:@"arrival_stop"] valueForKey:@"name"];
            route.instructions = [legDict valueForKey:@"html_instructions"];
            [arrayOfRoutesForUsToSave addObject:route];
        
        }
    }
    if (arrayOfRoutesForUsToSave.count > 0) {
        tripToSave.routes = [NSSet setWithArray:arrayOfRoutesForUsToSave];
        [self saveData];
    }
    
    
}




@end
