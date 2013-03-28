//
//  TMNTAPIProcessor.m
//  TakeMeNearThere
//
//  Created by Nathan Levine on 3/5/13.
//  Copyright (c) 2013 Nathan Levine. All rights reserved.
//

#import "TMNTAPIProcessor.h"
#import <YelpKit/YelpKit.h>
#import <CoreLocation/CoreLocation.h>

@implementation TMNTAPIProcessor

@synthesize stringAPICall,flickrPhotosArray,yelpBusinessesArray;


//api method call for flickr
- (TMNTAPIProcessor*)initWithFlickrKey:(NSString*)key Search:(NSString*)search andLatitude:(NSNumber*)latitude andLongitude: (NSNumber *)longitude andRadius: (float)radius
{

//previously used flickr url
//http://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=bd02a7a94fbe1f4c40a1661af4cb7bbe&tags=%@&format=json&nojsoncallback=1&lat=%@&lon=%@&radius=%f&extras=geo&per_page=5
    
    stringAPICall = [NSString stringWithFormat:@"http://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=%@&tags=%@&sort=&lat=%@&lon=%@&radius=%f&extras=geo&per_page=5&format=json&nojsoncallback=1",key, search, latitude, longitude, radius];
    NSLog(@"%@",stringAPICall);
    return self;
}

//api method call for yelp
- (TMNTAPIProcessor*)initWithYelpSearch:(NSString*)search andLocation:(CLLocation*)userLocation andKey: (NSString *)key
{
    stringAPICall = [NSString stringWithFormat:@"http://api.yelp.com/business_review_search?term=%@&lat=%f&long=%f&radius=.2&limit=10&ywsid=%@",search, userLocation.coordinate.latitude, userLocation.coordinate.longitude, key];
    return self;
}

//method calll for returing the dicitionaries that we are getting from the api calls
- (void) getFlickrJSON
{
    NSURLRequest* flickrRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:stringAPICall]];
    
    //not needed because it is the default
    //flickrRequest.HTTPMethod = @"GET";
    
    [NSURLConnection sendAsynchronousRequest:flickrRequest
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^ void (NSURLResponse* myResponse, NSData* myData, NSError* theirError)
     {
         [self setArrayOfDictsFromFlickrJSONWithResponse:myResponse andData:myData andError:theirError];
         [self.delegate grabFlickrArray:flickrPhotosArray];
     }];
}

- (void)setArrayOfDictsFromFlickrJSONWithResponse:(NSURLResponse*)myResponse andData:(NSData*)myData andError:(NSError*)theirError
{
    
    if (theirError)
    {
        NSLog(@"Flickr Error: %@", [theirError description]);
    }
    else
    {
        NSError *jsonError;
        NSDictionary *myJSONDictionary = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:myData
                                                                                         options:NSJSONReadingAllowFragments
                                                                                           error:&jsonError];
        
        flickrPhotosArray = [[myJSONDictionary valueForKey:@"photos"] valueForKey:@"photo"];
    }
}

- (void)getYelpJSON
{
    YKURL *yelpURL = [YKURL URLString:stringAPICall];
    [YKJSONRequest requestWithURL:yelpURL
                      finishBlock:^ void (id myData)
     {
         [self setUpYelpVenuesWithData:myData];
         [self.delegate grabYelpArray:yelpBusinessesArray];
     }
                        failBlock:^ void (YKHTTPError *error)
     {
         if (error)
         {
             NSLog(@"Error using Yelp: %@", [error description]);
         }
     }];
}

-(void) setUpYelpVenuesWithData: (id)data
{
    NSDictionary *myYelpVenues = (NSDictionary *)data;
    yelpBusinessesArray = [myYelpVenues valueForKey:@"businesses"];
}
@end
