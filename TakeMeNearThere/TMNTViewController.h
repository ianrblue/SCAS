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
}
- (IBAction)clickPageControl:(id)sender;

@property (strong, nonatomic) NSMutableArray *returnedArray;
@property (strong, nonatomic) NSMutableArray *arrayOfPhotoStrings;
@property NSManagedObjectContext *myManagedObjectContext;


- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view;

- (void)addPinsToMap;

@end


