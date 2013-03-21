//
//  TMNTViewController.h
//  TakeMeNearThere
//
//  Created by Nathan Levine on 3/5/13.
//  Copyright (c) 2013 Nathan Levine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TMNTDataSourceDelegate.h"
#import <MapKit/MapKit.h>
#import "TMNTAppDelegate.h"


@interface TMNTViewController : UIViewController <TMNTDataSourceDelegate, UITableViewDataSource, UITableViewDelegate, MKMapViewDelegate, UIScrollViewDelegate, UISearchBarDelegate, CLLocationManagerDelegate>
{
    __weak IBOutlet MKMapView *myMapView;
    __weak IBOutlet UIScrollView *myScrollView;
    __weak IBOutlet UIPageControl *myPageControl;
    __weak IBOutlet UIActivityIndicatorView *yelpSearchActivityIndicator;
    __weak IBOutlet UIActivityIndicatorView *flickrPicsAcitivityIndicator;
}

@property (strong, nonatomic) NSMutableArray *returnedArray;
@property (strong, nonatomic) NSMutableArray *arrayOfPhotoStrings;
@property NSManagedObjectContext *myManagedObjectContext;


//LOCATION STUFF
- (void)startLocationUpdates;
-(void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error;

//UI STUFF
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar;


//YELP CALL
- (void)grabYelpArray:(NSArray *)data;
- (NSMutableArray *)createPlacesArray:(NSArray *)placesData;
-(void)submitYelpSearch;

//FLICKR CALL
- (void)grabFlickrArray:(NSArray *)data;
- (NSMutableArray *)grabPhotosArray: (NSArray *)flickData;


//MAP STUFF
- (void)updateMapViewWithNewCenter:(CLLocationCoordinate2D)newCoodinate;
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view;

//PIN STUFF

-(MKPinAnnotationView*)mapView:(MKMapView*)mapView viewForAnnotation:(id<MKAnnotation>)annotation;
-(void)pressDisclosureButton;
- (void)addPinsToMap;

//SCROLLVIEW STUFF & PAGECNTROL
-(void)scrollViewSetUp;
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;
- (IBAction)clickPageControl:(id)sender;


//SEQUE STUFF
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender;


//CRUDS - for core data
-(void)saveData;
-(void) createPlaceVisitedFromMKAnnotation: (MKAnnotationView*)pin;
//-(PlaceVisited *)getPlaceVisitedWithName: (NSString*)name;
//-(void)updatePlaceVisited: (PlaceVisited*)placeVisited withPhotoURL: (NSString*)photoURL;
//-(void)deletePlaceVisited: (PlaceVisited*)placeVisited;


@end


