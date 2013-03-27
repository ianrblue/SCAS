//
//  TMNTViewController.m
//  TakeMeNearThere
//
//  Created by Nathan Levine on 3/5/13.
//  Copyright (c) 2013 Nathan Levine. All rights reserved.
//

#import "TMNTViewController.h"
#import "TMNTAPIProcessor.h"
#import "TMNTPlace.h"
#import "PlaceVisited.h"
#import <CoreLocation/CoreLocation.h>
#import "TMNTDetailViewController.h"
#import "TMNTAnnotationTwo.h"
#import "TMNTTableViewController.h"
#import "TMNTBookmarks.h"

//#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

@interface TMNTViewController ()
{
    TMNTAPIProcessor *yelpProcess;
    NSMutableArray *yelpData;
   
    //added by ian for updated searchfield text
    NSString *flickrSearchString;
    NSString *yelpSearchString;
    
    TMNTAPIProcessor *flickrProcess;
    TMNTAPIProcessor *flickrProcess2;
    NSMutableArray *flickrData;
    UIImage *photoImage;
    NSString *nameOfPlace;
    NSString *businessName;
    NSNumber *longnum;
    NSNumber *latnum;
    NSString *zipOfPlace;
    NSString *zipToSegue;
    NSString *stateOfPlace;
    NSString *stateToSegue;
    NSString *addressOfPlace;
    NSString *addressToSegue;
    NSString *phoneOfPlace;
    NSString *phoneToSegue;
    NSString *ratingImageOfPlace;
    NSString *ratingToSegue;
    NSString *thumbnailOfPlace;
    NSString *thumbnailToSegue;
    NSString *cityOfPlace;
    NSString *cityToSegue;
    
    BOOL bookmark;
    PlaceVisited *placeVisited;
    
    NSArray *historyPersistedArray;
    
    //Create a CLLocationManager object which we will use to start updates
    CLLocationManager *myLocationManager;
    //also create a CLLocation instance variable that will hold our current location
    CLLocation *userCurrentLocation;
    
    __weak IBOutlet UISearchBar *searchField;
   
    TMNTDetailViewController *detailViewController;
    TMNTTableViewController *historyTableViewController;
    TMNTBookmarks *bookmarkViewController;
    __weak IBOutlet UIView *mapBlackViewCover;
}
- (IBAction)tapMapGesture:(id)sender;

@end

@implementation TMNTViewController
@synthesize returnedArray, myManagedObjectContext, arrayOfPhotoStrings;

const CGFloat scrollObjHeight	= 240.0;
const CGFloat scrollObjWidth	= 320.0;

#pragma mark -
#pragma mark ViewsDidLoad/Appear/receiveMemWarn
- (void)viewDidLoad
{
    [super viewDidLoad];
    myMapView.frame = CGRectMake(0, 44, 320, 460);
    //location work here
    [self startLocationUpdates];
    //NSLog(@"user location lat in viewdidload is: %f", userCurrentLocation.coordinate.latitude);
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    mapBlackViewCover.alpha = 0;
    [UIView commitAnimations];
   
    //make ourselves the delegate for the coredata stuff
    TMNTAppDelegate *tmntAppDelegate = (TMNTAppDelegate*) [[UIApplication sharedApplication] delegate];
    self.myManagedObjectContext = tmntAppDelegate.myManagedObjectContext;
    
    MKCoordinateSpan spanToCheck =
    {
        .latitudeDelta = 2.3f,
        .longitudeDelta = 2.3f
    };
    
    if (myMapView.region.span.latitudeDelta > spanToCheck.latitudeDelta)//you enter the vc normally
    {
        [self updateMapViewWithNewCenter:userCurrentLocation.coordinate];
    } else //if you are coming back from the detailVC
    {
        CLLocationCoordinate2D pinCoords = CLLocationCoordinate2DMake((CLLocationDegrees)latnum.doubleValue, (CLLocationDegrees)longnum.doubleValue);
        MKCoordinateRegion newRegion = {pinCoords , myMapView.region.span};
        [myMapView setRegion:newRegion animated:YES];
    }
    
    //hide yelpacitvityindicator till it is used
    yelpSearchActivityIndicator.hidesWhenStopped = YES;
    myPageControl.hidesForSinglePage = YES;
    myPageControl.hidden = YES;
    bookmark = NO;
    
    if (![searchField resignFirstResponder]) {
        [searchField resignFirstResponder];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Location Handler
//LOCATION STUFF

- (void)startLocationUpdates
{
    //if we dont have an instantiated clloactionmanager object make one
    if (myLocationManager==nil) {
        myLocationManager = [[CLLocationManager alloc]init];
    }
    myLocationManager.delegate = self;
    
    //get location that is decently close
    myLocationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    
    //update location, firehose of updates, no longer
    //[myLocationManager startMonitoringSignificantLocationChanges];
    [myLocationManager startUpdatingLocation];
}
-(void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error"
                               message:@"Failed to Get Your Location"
                               delegate:nil
                               cancelButtonTitle:@"OK"
                               otherButtonTitles:nil];
    [errorAlert show];
}

//when we get the new location do this
- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation
{
    userCurrentLocation = newLocation;
    
    CLLocationDistance kilometers = [newLocation distanceFromLocation:oldLocation] / 1000;
    if (kilometers > .1)
    {
        [self updateMapViewWithNewCenter:userCurrentLocation.coordinate];
    }
}

#pragma mark -
#pragma mark UX
//UI STUFF
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [myMapView removeAnnotations:myMapView.annotations];
    [self submitYelpSearch];
    [searchBar resignFirstResponder];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    [searchField resignFirstResponder];
}


#pragma mark -
#pragma mark Yelp
//YELP CALL
//refactor delegate for yelp
- (void)grabYelpArray:(NSArray *)data
{
    yelpData = [self createPlacesArray:data];
    if (returnedArray.count == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Sorry"
                              message:@"No results found"
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
    [self addPinsToMap];
}

- (NSMutableArray *)createPlacesArray:(NSArray *)placesData
{
    returnedArray = [[NSMutableArray alloc] init];
    
    for (NSDictionary *placeDictionary in placesData)
    {
        float placeLatitude = [[placeDictionary valueForKey:@"latitude"] floatValue];
        float placeLongitude = [[placeDictionary valueForKey:@"longitude"] floatValue];
        CLLocation *placeLocation = [[CLLocation alloc] initWithLatitude:placeLatitude longitude:placeLongitude];
        
        TMNTPlace *place = [[TMNTPlace alloc] init];
        place.name = [placeDictionary valueForKey:@"name"];
        place.location = placeLocation;
        place.dictionaryPlace = placeDictionary;
        place.zip = [placeDictionary valueForKey:@"zip"];
        place.stateForBusiness = [placeDictionary valueForKey:@"state"];
        place.addressForBusiness = [placeDictionary valueForKey:@"address1"];
        place.phoneNumber = [placeDictionary valueForKey:@"phone"];
        place.ratingImage = [placeDictionary valueForKey:@"rating_img_url"];
        place.thumbnail = [placeDictionary valueForKey:@"photo_url"];
        place.city = [placeDictionary valueForKey:@"city"];
        
        [returnedArray addObject:place];
    }
    return returnedArray;
}

-(void)submitYelpSearch
{
    yelpSearchString = [searchField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [yelpSearchActivityIndicator startAnimating];
    //perform yelp api call based on our location
    yelpProcess = [[TMNTAPIProcessor alloc]initWithYelpSearch:yelpSearchString andLocation:userCurrentLocation];
    //NSLog(@"tets%f",currentLocation.coordinate.latitude);
    //set ourselves as the delgeate
    yelpProcess.delegate = self;
    
    //perfom some method
    [yelpProcess getYelpJSON];
}

#pragma mark -
#pragma mark Flickr
//FLICKR CALL

//refactor delegate for flickr
- (void)grabFlickrArray:(NSArray *)data
{
    //grab pictures from flickr
    flickrData = [self grabPhotosArray:data];
}

- (NSMutableArray *)grabPhotosArray: (NSArray *)flickData
{
    //set up array to add photos too
    arrayOfPhotoStrings = [[NSMutableArray alloc] init];
    
    //use Fast enumeration to go through our array of dictionarys taht we get from flikr and pull out the string that we can then make our photo from and add that to the above array
    for (NSDictionary *dictionary in flickData)
    {
        NSString *farmString = [dictionary valueForKey:@"farm"];
        NSString *serverString = [dictionary valueForKey:@"server"];
        NSString *idString = [dictionary valueForKey:@"id"];
        NSString *secretString = [dictionary valueForKey:@"secret"];
        NSString *fullPhotoString = [NSString stringWithFormat:@"http://farm%@.staticflickr.com/%@/%@_%@_n.jpg" ,farmString,serverString, idString, secretString];
        
        NSURL *photoURL;
        photoURL= [NSURL URLWithString:fullPhotoString];
        [arrayOfPhotoStrings addObject:photoURL];
    }

    //after you grab the array run the scroll view setup
    [self scrollViewSetUp];
    
    NSLog(@"arrayOfPhotoStrings = %@", arrayOfPhotoStrings);
    return arrayOfPhotoStrings;
}

#pragma mark -
#pragma mark mapview
//MAP STUFF

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    MKCoordinateRegion newRegion = {view.annotation.coordinate, myMapView.region.span};
    [myMapView setRegion:newRegion animated:YES];
    
    if ([view.annotation isKindOfClass:[MKUserLocation class]])
    {
        nil;
    } else
    {
    
        //
        // Deprecated, map view was coming in at different
        // sizes, now just manually shrink
        //
//        CGRect rect2 = CGRectMake(0, 44, 320, 460);
//        CGRect rect1 = myMapView.frame;
//        CGRect rect = CGRectMake(0, 44, 320, 372);
//        if (CGRectEqualToRect(rect, rect1) || CGRectEqualToRect(rect1, rect2)) {
//            [self shrinkMapView];
//        }
        
        [self shrinkMapView];

        [view setHighlighted:YES];

        for (UIView *view in myScrollView.subviews)
        {
            [view removeFromSuperview];
        }
        //persist stuff
        [self createPlaceVisitedFromMKAnnotation:view];
        
        //testing....
//        TMNTAnnotationTwo *testOne = (TMNTAnnotationTwo*)view;
//        [self testFromTMNTAnnotation:testOne];

        //get the lat and long of the yelp place clicked converted into number
        longnum = [NSNumber numberWithFloat:view.annotation.coordinate.longitude];
        latnum = [NSNumber numberWithFloat:view.annotation.coordinate.latitude];

        businessName = view.annotation.title;
        zipToSegue = ((TMNTAnnotationTwo*)(view.annotation)).zip;

        stateToSegue = ((TMNTAnnotationTwo*)(view.annotation)).state;
        phoneToSegue = ((TMNTAnnotationTwo*)(view.annotation)).phoneNumber;
        addressToSegue = ((TMNTAnnotationTwo*)(view.annotation)).address;
        ratingToSegue = ((TMNTAnnotationTwo*)(view.annotation)).ratingImage;
        thumbnailToSegue = ((TMNTAnnotationTwo*)(view.annotation)).thumbnail;
        cityToSegue = ((TMNTAnnotationTwo*)(view.annotation)).city;

        //get a flickrcall based on the location of the yelp places
        [flickrPicsAcitivityIndicator startAnimating];
       flickrSearchString = [searchField.text stringByReplacingOccurrencesOfString:@" " withString:@"+"];

//        NSString *flickrBusinessName = [businessName stringByReplacingOccurrencesOfString:@" " withString:@"+"];
        
        flickrProcess = [[TMNTAPIProcessor alloc]initWithFlickrSearch:flickrSearchString andLatitude:latnum andLongitude:longnum andRadius:5];
        flickrProcess.delegate = self;
        [flickrProcess getFlickrJSON];
//        if (flickrProcess.flickrPhotosArray.count < 5) {
//            flickrProcess2 = [[TMNTAPIProcessor alloc]initWithFlickrSearch:flickrSearchString andLatitude:latnum andLongitude:longnum andRadius:5];
//            flickrProcess2.delegate = self;
//            [flickrProcess2 getFlickrJSON];
//        } else {
//            flickrProcess.delegate = self;
//            [flickrProcess getFlickrJSON];
//        }
        if (![searchField resignFirstResponder])
        {
            [searchField resignFirstResponder];
        }
        NSLog(@"ANNOTATION SELECTED");
    }
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{
    [self shouldExpandMapView];
    if (![searchField resignFirstResponder])
    {
        [searchField resignFirstResponder];
    }
}

- (void)updateMapViewWithNewCenter:(CLLocationCoordinate2D)newCoodinate
{
    MKCoordinateSpan span =
    {
        .latitudeDelta = 0.01810686f,
        .longitudeDelta = 0.01810686f
    };

    MKCoordinateRegion newRegion = {newCoodinate, span};
    [myMapView setRegion:newRegion];
}

#pragma mark -
#pragma mark Annotations
//PIN STUFF
-(void)addPinsToMap
{
//    //make region our area
//    MKCoordinateSpan span =
//    {
//        .latitudeDelta = 0.01810686f,
//        .longitudeDelta = 0.01810686f
//    };
//    
//    MKCoordinateRegion myRegion = {userCurrentLocation.coordinate, span};
//    //set region to mapview
//    [myMapView setRegion:myRegion];
    [self updateMapViewWithNewCenter:userCurrentLocation.coordinate];
    
    for (int i = 0; i < returnedArray.count; i++)
    {
        CLLocation *locationOfPlace = [[returnedArray objectAtIndex:i] location];
        nameOfPlace = [[returnedArray objectAtIndex:i] name];
        zipOfPlace = [[returnedArray objectAtIndex:i] zip];
        stateOfPlace = [[returnedArray objectAtIndex:i] stateForBusiness];
        addressOfPlace = [[returnedArray objectAtIndex:i] addressForBusiness];
        phoneOfPlace = [[returnedArray objectAtIndex:i] phoneNumber];
        ratingImageOfPlace = [[returnedArray objectAtIndex:i] ratingImage];
        thumbnailOfPlace = [[returnedArray objectAtIndex:i] thumbnail];
        cityOfPlace = [[returnedArray objectAtIndex:i] city];
        
        
        //coordinate make
        CLLocationCoordinate2D placeCoordinate;
        placeCoordinate.longitude = locationOfPlace.coordinate.longitude;
        placeCoordinate.latitude = locationOfPlace.coordinate.latitude;
        
        //annotation make
        TMNTAnnotationTwo *myAnnotation = [[TMNTAnnotationTwo alloc]initWithPosition:&placeCoordinate
                                                                              andZip:zipOfPlace
                                                                            andState:stateOfPlace
                                                                          andAddress:addressOfPlace
                                                                      andPhoneNumber:phoneOfPlace
                                                                      andRatingImage:ratingImageOfPlace
                                                                        andThumbnail:thumbnailOfPlace
                                                                         andBookmark:bookmark andCity:cityOfPlace];
        //MKPointAnnotation *myAnnotation = [[MKPointAnnotation alloc]init];
        myAnnotation.coordinate = placeCoordinate;
        // TMNTAnnotation *myAnnotation = [[TMNTAnnotation alloc] initWithPosition:&placeCoordinate];
        myAnnotation.title = nameOfPlace;
        myAnnotation.zip = zipOfPlace;
        
        //add to map
        [myMapView addAnnotation:myAnnotation];
    }
    [yelpSearchActivityIndicator stopAnimating];
}

-(MKPinAnnotationView*)mapView:(MKMapView*)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    //creating new button, button type diclusure button
    UIButton *detailButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    if ([annotation isKindOfClass:[MKUserLocation class]])
    {
        return nil;
    }
    
    
    //NSLog(@"mapViewForAnnotation: %f", annotation.coordinate.latitude);
    MKPinAnnotationView *annotationView = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"myAnnotation"];
    
    if (annotationView == nil)
    {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                                         reuseIdentifier:@"myAnnotation"];
        annotationView.rightCalloutAccessoryView = detailButton;
    }
    //replace showDetail with segue or whatever you like to make it more functional
    [detailButton addTarget:self action:@selector(pressDisclosureButton) forControlEvents:UIControlEventTouchUpInside];
    
    annotationView.canShowCallout = YES;
    annotationView.enabled = YES;
    
    return annotationView;
}

-(void)pressDisclosureButton
{
    [self performSegueWithIdentifier:@"annotationToDetail" sender:self];
}

#pragma mark -
#pragma mark ScrollView
//SCROLLVIEW STUFF & PAGECNTROL
-(void)scrollViewSetUp
{
    //unhide pagecontrol
    myPageControl.hidden = NO;
    
    //set the number of objects in the array as the number of pictures
    const NSUInteger numImages	= arrayOfPhotoStrings.count;
    [myScrollView setContentSize:CGSizeMake((numImages * scrollObjWidth),   [myScrollView bounds].size.height)];
    
    
    CGFloat xOrigin = 0.0f;
    
    //using fast enumeration take every URL we bring over and convert it to an image and then add that image to the imageview
    for (NSURL *url in arrayOfPhotoStrings)
    {
        NSData *photoData = [NSData dataWithContentsOfURL:url];
        photoImage = [UIImage imageWithData:photoData];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:photoImage];
        
        // setup each frame to a default height and width
        
        CGRect rect = imageView.frame;
        rect.origin = CGPointMake(xOrigin, 0);
        rect.size.height = scrollObjHeight;
        rect.size.width = scrollObjWidth;
        [myScrollView addSubview:imageView];
        
        imageView.frame = rect;
        
        //imageView.frame = CGRectOffset(imageView.frame, xOrigin, 0.0);
        xOrigin += scrollObjWidth;
        
        //NSLog(@"IMHEREEEEE%@", arrayOfPhotoStrings);
        
    }
    [flickrPicsAcitivityIndicator stopAnimating];
    //    [myScrollView addSubview:myPageControl];
    myPageControl.numberOfPages = arrayOfPhotoStrings.count;
    myPageControl.currentPage = 0;
    [myScrollView setContentOffset:CGPointMake(0,0) animated:NO];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int page = myScrollView.contentOffset.x / myScrollView.frame.size.width;
    myPageControl.currentPage = page;
}

- (IBAction)clickPageControl:(id)sender
{
    int page = myPageControl.currentPage;
    CGRect frame = myScrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [myScrollView scrollRectToVisible:frame animated:YES];
}

#pragma mark -
#pragma mark Animation
//Animation Stuff

-(void)shouldExpandMapView
{
    if (myMapView.selectedAnnotations.count == 0)
    {
            [self performSelector:@selector(expandMapView) withObject:nil afterDelay:0.2];
    }
}

-(void)shrinkMapView
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.25];
    //myMapView.frame = CGRectMake(0, 44, 320, 220);

//    if( IS_IPHONE_5 )
//    {mapViewHeightContraint.constant = 220;}
//    else
//    {mapViewHeightContraint.constant = 100;}
    mapViewHeightContraint.constant = 220;
    
    [myMapView layoutIfNeeded];

    [UIView commitAnimations];
    //[[self navigationController] setNavigationBarHidden:YES animated:YES];
}

-(void)expandMapView
{
    if (myMapView.selectedAnnotations.count == 0)
    {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.25];
//    myMapView.frame = CGRectMake(0, 44, 320, 460);
        
    mapViewHeightContraint.constant = 460;
    [myMapView layoutIfNeeded];
        
    [UIView commitAnimations];
    //[[self navigationController] setNavigationBarHidden:NO animated:YES];
    }
}

//
//CRUDS IS BELOW
//
#pragma mark -
#pragma mark Core Data
//SAVE!!!
-(void)saveData
{
    NSError *error;
    if (![myManagedObjectContext save:&error])
    {
        NSLog(@"failed to save error: %@", [error userInfo]);
    }
}

//-(void) testFromTMNTAnnotation:(TMNTAnnotationTwo*)pin
//{
//        Test *test = [NSEntityDescription insertNewObjectForEntityForName:@"Test" inManagedObjectContext:myManagedObjectContext];
//    test.zipCode = pin.zip;
//}

//create person better
-(void) createPlaceVisitedFromMKAnnotation: (MKAnnotationView*)pin
{
    placeVisited = [NSEntityDescription insertNewObjectForEntityForName:@"PlaceVisited" inManagedObjectContext:myManagedObjectContext];
   
    NSNumber *longitudenum = [NSNumber numberWithFloat:pin.annotation.coordinate.longitude];
    NSNumber *latitudenum = [NSNumber numberWithFloat:pin.annotation.coordinate.latitude];
    
    placeVisited.latitude = latitudenum;
    placeVisited.longitude = longitudenum;
    placeVisited.title = pin.annotation.title;
    placeVisited.zipCode = ((TMNTAnnotationTwo *)pin.annotation).zip;
    placeVisited.thumbnailURL = ((TMNTAnnotationTwo *)pin.annotation).thumbnail;
    placeVisited.address = ((TMNTAnnotationTwo *)pin.annotation).address;
    placeVisited.phone = ((TMNTAnnotationTwo *)pin.annotation).phoneNumber;
    placeVisited.state = ((TMNTAnnotationTwo *)pin.annotation).state;
    placeVisited.ratingURL = ((TMNTAnnotationTwo *)pin.annotation).ratingImage;
    placeVisited.isBookmarked = [NSNumber numberWithBool:bookmark];
    placeVisited.city = ((TMNTAnnotationTwo *)pin.annotation).city;
    
    //placeVisited.viewDate = ((TMNTAnnotationTwo *)pin.annotation).SOMETHING;

    [self saveData];
}

//READ!!!
-(PlaceVisited *)getPlaceVisitedWithName: (NSString*)name
{
    //come back to this badboy
    PlaceVisited *placeVisited1 ;
    return placeVisited1;
}

//UPDATE!!!
//-(void)updatePlaceVisited: (PlaceVisited*)placeVisited withPhotoURL: (NSString*)photoURL
//{
//    //[person setValue:photoURL forKey:@"photoURL"];  SAME AS
//   // [placeVisited setPhotoURL:@"photoURL"];
//    
//    [self saveData];
//}

//DELETE!!!
-(void)deletePlaceVisited: (PlaceVisited*)placeVisited1
{
    [self.myManagedObjectContext deleteObject:placeVisited1];
    
    [self saveData];
}

-(NSArray*)getPersistedData
{
    //setting up the fetch
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"PlaceVisited"
                                                         inManagedObjectContext:self.myManagedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    NSFetchedResultsController *fetchResultsController;
    
    //manipulate the fetch
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects: nil];
    //    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"name contains[c] '%@'", myCustomSearchText]];
    NSError *sadnessError;
    //
    //    if ([myCustomSearchText isEqualToString:@""])
    //    {
    //        predicate = nil;
    //    }
    //
    //actually setting up the fetch
    [fetchRequest setSortDescriptors:sortDescriptors];
    [fetchRequest setEntity:entityDescription];
    //[fetchRequest setPredicate:predicate];
    fetchResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                 managedObjectContext:myManagedObjectContext
                                                                   sectionNameKeyPath:nil
                                                                            cacheName:nil];
    [fetchResultsController performFetch:&sadnessError];
    
    return fetchResultsController.fetchedObjects;
}

//received the data?



//SEGUE STUFF
#pragma mark -
#pragma mark Segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    historyPersistedArray = [self getPersistedData];
    
    if ([segue.identifier isEqualToString:@"annotationToDetail"])
    {
        detailViewController = [segue destinationViewController];
        detailViewController.businessNameForLabel = businessName;
        detailViewController.businessLat = latnum;
        detailViewController.businessLong = longnum;
        detailViewController.businessZip = zipToSegue;
        detailViewController.businessState = stateToSegue;
        detailViewController.businessPhoneNumber = phoneToSegue;
        detailViewController.businessImageRating = ratingToSegue;
        detailViewController.businessAddress = addressToSegue;
        detailViewController.businessThumbnail = thumbnailToSegue;
        detailViewController.userLocation = userCurrentLocation;
        detailViewController.myManagedObjectContext = myManagedObjectContext;
        detailViewController.persistedData = historyPersistedArray;
        detailViewController.placevisted = placeVisited;
        detailViewController.businessCity = cityToSegue;
    }
    
    if ([segue.identifier isEqualToString:@"annotationToTable"])
    {
        UITabBarController* tbc = [segue destinationViewController];
        historyTableViewController = (TMNTTableViewController *)[[tbc customizableViewControllers] objectAtIndex:1];
        historyTableViewController.myManagedObjectContext1 = myManagedObjectContext;
        historyTableViewController.historyPersistedArray1 = historyPersistedArray;
        //historyTableViewController.placeVisted = placeVisited;
        
        bookmarkViewController = (TMNTBookmarks *)[[tbc customizableViewControllers] objectAtIndex:0];
        bookmarkViewController.myManagedObjectContext2 = myManagedObjectContext;
        bookmarkViewController.placeVisted = placeVisited;
        bookmarkViewController.historyPersistedArray1 = historyPersistedArray;
    }
}


- (IBAction)tapMapGesture:(id)sender
{
    if (![searchField resignFirstResponder])
    {
        [searchField resignFirstResponder];
    }
}
@end
