//
//  TMNTViewController.m
//  TakeMeNearThere
//
//  Created by Nathan Levine on 3/5/13.
//  Copyright (c) 2013 Nathan Levine. All rights reserved.
//

#import "TMNTViewController.h"
#import "TMNTLocationTest.h"
#import "TMNTAPIProcessor.h"
#import "TMNTPlace.h"
#import "TMNTAnnotation.h"
#import "PlaceVisited.h"
#import <CoreLocation/CoreLocation.h>


@interface TMNTViewController ()
{
    TMNTAPIProcessor *yelpProcess;
    NSMutableArray *yelpData;
    TMNTLocationTest *mobileMakersLocation;
    
    TMNTAPIProcessor *flickrProcess;
    NSMutableArray *flickrData;
    
    UIImage *photoImage;
}
@end

@implementation TMNTViewController
@synthesize returnedArray, myManagedObjectContext, arrayOfPhotoStrings;

const CGFloat scrollObjHeight	= 200.0;
const CGFloat scrollObjWidth	= 280.0;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //make ourselves the delegate for the coredata stuff
    TMNTAppDelegate *tmntAppDelegate = (TMNTAppDelegate*) [[UIApplication sharedApplication] delegate];
     self.myManagedObjectContext = tmntAppDelegate.myManagedObjectContext;
    
    //get our location
    mobileMakersLocation = [[TMNTLocationTest alloc] init];
    
    //perform yelp api call based on our location
    yelpProcess = [[TMNTAPIProcessor alloc]initWithYelpSearch:@"pizza" andLocation:mobileMakersLocation];
    
    //set ourselves as the delgeate
    yelpProcess.delegate = self;

    //perfom some method
    [yelpProcess getYelpJSON];
    
    //start with hidden page control
    //[myPageControl setHidden:YES];
    
}
//refactor delegate for yelp
- (void)grabYelpArray:(NSArray *)data
{
    yelpData = [self createPlacesArray:data];
    [self addPinsToMap];
}
//refactor delegate for flickr
- (void)grabFlickrArray:(NSArray *)data
{
    //grab pictures from flickr
    flickrData = [self grabPhotosArray:data];
}

- (NSMutableArray *)grabPhotosArray: (NSArray *)flickData
{
    arrayOfPhotoStrings = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < flickData.count; i++)
    {
        NSDictionary *actualPhotoDictionary = [flickData objectAtIndex:i];
        NSString *farmString = [actualPhotoDictionary valueForKey:@"farm"];
        NSString *serverString = [actualPhotoDictionary valueForKey:@"server"];
        NSString *idString = [actualPhotoDictionary valueForKey:@"id"];
        NSString *secretString = [actualPhotoDictionary valueForKey:@"secret"];
        NSString *fullPhotoString = [NSString stringWithFormat:@"http://farm%@.staticflickr.com/%@/%@_%@_n.jpg" ,farmString,serverString, idString, secretString];
        
        NSURL *photoURL;
        photoURL= [NSURL URLWithString:fullPhotoString];
        
        [arrayOfPhotoStrings addObject:photoURL];
    }

    
//    for (NSDictionary *dictionary in flickData)
//    {
//        NSString *farmString = [flickData valueForKey:@"farm"];
//        NSString *serverString = [flickData valueForKey:@"server"];
//        NSString *idString = [flickData valueForKey:@"id"];
//        NSString *secretString = [flickData valueForKey:@"secret"];
//        NSString *fullPhotoString = [NSString stringWithFormat:@"http://farm%@.staticflickr.com/%@/%@_%@_n.jpg" ,farmString,serverString, idString, secretString];
//        
//        NSURL *photoURL;
//        photoURL= [NSURL URLWithString:fullPhotoString];
//        
//        [testArray addObject:fullPhotoString];
//    }
    return arrayOfPhotoStrings;
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
        [returnedArray addObject:place];
    }
    return returnedArray;
}

-(void)addPinsToMap
{
    //make region our area
    MKCoordinateSpan span =
    {
        .latitudeDelta = 0.01810686f,
        .longitudeDelta = 0.01810686f
    };
    
    MKCoordinateRegion myRegion = {mobileMakersLocation.coordinate, span};
    //set region to mapview
    [myMapView setRegion:myRegion];
    
    
    for (int i = 0; i < returnedArray.count; i++)
    {
        CLLocation *locationOfPlace = [[returnedArray objectAtIndex:i] location];
        NSString *nameOfPlace = [[returnedArray objectAtIndex:i] name];
        
        //coordinate make
        CLLocationCoordinate2D placeCoordinate;
        placeCoordinate.longitude = locationOfPlace.coordinate.longitude;
        placeCoordinate.latitude = locationOfPlace.coordinate.latitude;
        
        //annotation make
        TMNTAnnotation *myAnnotation = [[TMNTAnnotation alloc] initWithPosition:&placeCoordinate];
        myAnnotation.title = nameOfPlace;
        
        //add to map
        [myMapView addAnnotation:myAnnotation];
        
        //get notification when pin is clicked
    }
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    [view setHighlighted:YES];
//    for (UIView *view in myScrollView.subviews)
//    {
//        [view removeFromSuperview];
//    }
    //persist stuff
    [self createPlaceVisitedFromMKAnnotation:view];
    
    //get the lat and long of the yelp place clicked converted into number
    NSNumber *longnum = [NSNumber numberWithFloat:view.annotation.coordinate.longitude];
    NSNumber *latnum = [NSNumber numberWithFloat:view.annotation.coordinate.latitude];
    
    //get a flickrcall based on the location of the yelp places
    flickrProcess = [[TMNTAPIProcessor alloc]initWithFlickrSearch:@"pizza" andLatitude:latnum andLongitude:longnum];
    flickrProcess.delegate = self;
    [flickrProcess getFlickrJSON];
    
    [self scrollViewSetUp];
 
    
}

 
-(void)scrollViewSetUp
{
    //allow for the number of images as we have
    const NSUInteger numImages	= arrayOfPhotoStrings.count;
    
    myScrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    
    for (NSURL *url in arrayOfPhotoStrings)
    {
        NSData *photoData = [NSData dataWithContentsOfURL:url];
        photoImage = [UIImage imageWithData:photoData];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:photoImage];
   
    
    NSUInteger i;
	NSLog(@"IMHEREEEEE%@", arrayOfPhotoStrings);
    for (i = 1; i < numImages; i++)
	{
       
		// setup each frame to a default height and width, it will be properly placed when we call "updateScrollList"
		CGRect rect = imageView.frame;
		rect.size.height = scrollObjHeight;
		rect.size.width = scrollObjWidth;
		imageView.frame = rect;
		imageView.tag = i;	// tag our images for later use when we place them in serial fashion
		[myScrollView addSubview:imageView];
	}
	}
	[self layoutScrollImages];	// now place the photos i

}

- (void)layoutScrollImages
{

	const NSUInteger numImages	= arrayOfPhotoStrings.count;
    
    UIImageView *view = nil;
	
    NSArray *subviews = [myScrollView subviews];
    
	// reposition all image subviews in a horizontal serial fashion
	CGFloat xOrigin = 0;
	for (view in subviews)
	{
		if ([view isKindOfClass:[UIImageView class]] && view.tag > 0)
		{
			CGRect frame = view.frame;
			frame.origin = CGPointMake(xOrigin, 0);
			view.frame = frame;
			
			xOrigin += (scrollObjWidth);
		}
	}
	
	// set the content size so it can be scrollable
	[myScrollView setContentSize:CGSizeMake((numImages * scrollObjWidth), [myScrollView bounds].size.height)];
    
    myPageControl.numberOfPages = arrayOfPhotoStrings.count -1;
    myPageControl.currentPage = 0;
    
    [myScrollView addSubview:myPageControl];
    
}



//
//CRUDS IS BELOW
//

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
   
    NSNumber *longnum = [NSNumber numberWithFloat:pin.annotation.coordinate.longitude];
    NSNumber *latnum = [NSNumber numberWithFloat:pin.annotation.coordinate.latitude];
    
    placeVisited.latitude = latnum;
    placeVisited.longitude = longnum;
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

//
//add a fetch here
//


- (IBAction)clickPageControl:(id)sender
{
    int page = myPageControl.currentPage;
    CGRect frame = myScrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [myScrollView scrollRectToVisible:frame animated:YES];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int page = myScrollView.contentOffset.x / myScrollView.frame.size.width;
    myPageControl.currentPage = page;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
