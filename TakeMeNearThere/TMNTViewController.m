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


@interface TMNTViewController ()
{
    TMNTAPIProcessor *yelpProcess;
    NSMutableArray *yelpData;
    
    
    TMNTAPIProcessor *flickrProcess;
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
    
    
    //Create a CLLocationManager object which we will use to start updates
    CLLocationManager *myLocationManager;
    //also create a CLLocation instance variable that will hold our current location
    CLLocation *userCurrentLocation;
    
    __weak IBOutlet UISearchBar *searchField;
   
    TMNTDetailViewController *detailViewController;
    __weak IBOutlet UIView *mapBlackViewCover;
}

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
    
    //location work here
    [self startLocationUpdates];
    NSLog(@"user location lat in viewdidload is: %f", userCurrentLocation.coordinate.latitude);
    //currentLocation = [[TMNTLocationTest alloc] initWithCurrentLocationAndUpdates];
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

    [self updateMapViewWithNewCenter:userCurrentLocation.coordinate];
    
    //hide yelpacitvityindicator till it is used
    yelpSearchActivityIndicator.hidesWhenStopped = YES;
    myPageControl.hidesForSinglePage = YES;
    myPageControl.hidden = YES;
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

#pragma mark -
#pragma mark Yelp
//YELP CALL
//refactor delegate for yelp
- (void)grabYelpArray:(NSArray *)data
{
    yelpData = [self createPlacesArray:data];
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
        place.ratingImage = [placeDictionary valueForKey:@"rating_img_url_small"];
        
        
        [returnedArray addObject:place];
    }
    return returnedArray;
}

-(void)submitYelpSearch
{
    [self expandMapView];
    [yelpSearchActivityIndicator startAnimating];
    //perform yelp api call based on our location
    yelpProcess = [[TMNTAPIProcessor alloc]initWithYelpSearch:searchField.text andLocation:userCurrentLocation];
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
    
    NSLog(@"arrayOfPhotoStrings: %@", arrayOfPhotoStrings);
    return arrayOfPhotoStrings;
}

#pragma mark -
#pragma mark mapview
//MAP STUFF

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
        [view setHighlighted:YES];
    for (UIView *view in myScrollView.subviews)
    {
        [view removeFromSuperview];
    }
    //persist stuff
    [self createPlaceVisitedFromMKAnnotation:view];
    
    //get the lat and long of the yelp place clicked converted into number
    longnum = [NSNumber numberWithFloat:view.annotation.coordinate.longitude];
    latnum = [NSNumber numberWithFloat:view.annotation.coordinate.latitude];
    
    businessName = view.annotation.title;
    zipToSegue = ((TMNTAnnotationTwo*)(view.annotation)).zip;
    
    stateToSegue = ((TMNTAnnotationTwo*)(view.annotation)).state;
    phoneToSegue = ((TMNTAnnotationTwo*)(view.annotation)).phoneNumber;
    addressToSegue = ((TMNTAnnotationTwo*)(view.annotation)).address;
    ratingToSegue = ((TMNTAnnotationTwo*)(view.annotation)).ratingImage;
    
    //get a flickrcall based on the location of the yelp places
    [flickrPicsAcitivityIndicator startAnimating];
    flickrProcess = [[TMNTAPIProcessor alloc]initWithFlickrSearch:searchField.text andLatitude:latnum andLongitude:longnum andRadius:.25];
    [searchField resignFirstResponder];
    flickrProcess.delegate = self;
    [flickrProcess getFlickrJSON];
    
    NSLog(@"sup bro");
}

- (void)updateMapViewWithNewCenter:(CLLocationCoordinate2D)newCoodinate
{
    
    MKCoordinateRegion newRegion = {newCoodinate, myMapView.region.span};
    [myMapView setRegion:newRegion];
}

#pragma mark -
#pragma mark Annotations
//PIN STUFF
-(void)addPinsToMap
{
    //make region our area
    MKCoordinateSpan span =
    {
        .latitudeDelta = 0.01810686f,
        .longitudeDelta = 0.01810686f
    };
    
    MKCoordinateRegion myRegion = {userCurrentLocation.coordinate, span};
    //set region to mapview
    [myMapView setRegion:myRegion];
    
    
    for (int i = 0; i < returnedArray.count; i++)
    {
        CLLocation *locationOfPlace = [[returnedArray objectAtIndex:i] location];
        nameOfPlace = [[returnedArray objectAtIndex:i] name];
        zipOfPlace = [[returnedArray objectAtIndex:i] zip];
        stateOfPlace = [[returnedArray objectAtIndex:i] stateForBusiness];
        addressOfPlace = [[returnedArray objectAtIndex:i] addressForBusiness];
        phoneOfPlace = [[returnedArray objectAtIndex:i] phoneNumber];
        ratingImageOfPlace = [[returnedArray objectAtIndex:i] ratingImage];
        
        
        //coordinate make
        CLLocationCoordinate2D placeCoordinate;
        placeCoordinate.longitude = locationOfPlace.coordinate.longitude;
        placeCoordinate.latitude = locationOfPlace.coordinate.latitude;
        
        //annotation make
        TMNTAnnotationTwo *myAnnotation = [[TMNTAnnotationTwo alloc]initWithPosition:&placeCoordinate
                                                                              andZip:zipOfPlace
                                                                            andState:stateOfPlace
                                                                          andAddress:addressOfPlace
                                                                      andPhoneNumber:phoneOfPlace andRatingImage:ratingImageOfPlace];
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
    
    
    NSLog(@"mapViewForAnnotation: %f", annotation.coordinate.latitude);
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
    [self shrinkMapView];
    //make little bar white. (UI)
    myScrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    
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
    //    myPageControl.currentPage = 0;
    
    
}

-(void)shrinkMapView
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.5];
    myMapView.frame = CGRectMake(0, 44, 320, 220);
    [UIView commitAnimations];
}

-(void)expandMapView
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.5];
    myMapView.frame = CGRectMake(0, 44, 320, 460);
    [UIView commitAnimations];
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

//create person better
-(void) createPlaceVisitedFromMKAnnotation: (MKAnnotationView*)pin
{
    PlaceVisited *placeVisited = [NSEntityDescription insertNewObjectForEntityForName:@"PlaceVisited" inManagedObjectContext:myManagedObjectContext];
   
    NSNumber *longitudenum = [NSNumber numberWithFloat:pin.annotation.coordinate.longitude];
    NSNumber *latitudenum = [NSNumber numberWithFloat:pin.annotation.coordinate.latitude];
    
    placeVisited.latitude = latitudenum;
    placeVisited.longitude = longitudenum;
    placeVisited.title = pin.annotation.title;

    [self saveData];
}

//READ!!!
-(PlaceVisited *)getPlaceVisitedWithName: (NSString*)name
{
    //come back to this badboy
    PlaceVisited *placeVisited ;
    return placeVisited;
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
-(void)deletePlaceVisited: (PlaceVisited*)placeVisited
{
    [self.myManagedObjectContext deleteObject:placeVisited];
    
    [self saveData];
}

//SEGUE STUFF
#pragma mark -
#pragma mark Segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
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
    }
}

@end
