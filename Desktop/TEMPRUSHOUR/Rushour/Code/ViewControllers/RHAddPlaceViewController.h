//
//  RHAddPlaceViewController.h
//  Rushour
//
//  Created by Nathan Levine on 6/16/13.
//  Copyright (c) 2013 Rushour. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "RHPlaceAnnotation.h"    

@interface RHAddPlaceViewController : UIViewController <MKMapViewDelegate, UITextFieldDelegate, CLLocationManagerDelegate>
{
    __weak IBOutlet MKMapView *myMapView;
    __weak IBOutlet UITextField *nameTextField;
    __weak IBOutlet UITextField *addressTextField;
    CLGeocoder *geoCoder;
    CLLocationManager *userLocationManager;
    CLLocationCoordinate2D placeCoord;
    MKCoordinateSpan mapSpan;
    RHPlaceAnnotation *resultAnnotation;
}
- (IBAction)findBtn:(id)sender;
- (IBAction)saveBtn:(id)sender;

@property (nonatomic,strong) NSManagedObjectContext* myManagedObjectContext;




@end
