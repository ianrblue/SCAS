//
//  TMNTSecondVC.m
//  TakeMeNearThere
//
//  Created by Ian Blue on 3/24/13.
//  Copyright (c) 2013 Heroes in a Half Shell. All rights reserved.
//

#import "TMNTSecondVC.h"

@interface TMNTSecondVC ()
{
    __weak IBOutlet UINavigationItem *navBar;
    __weak IBOutlet UILabel *phoneLabel;
    __weak IBOutlet UIImageView *thumbnailImageView;
    __weak IBOutlet UIImageView *ratingImageView;
    __weak IBOutlet UILabel *zipLabel;
    __weak IBOutlet UILabel *stateLabel;
    __weak IBOutlet UILabel *addressLabel;
}
- (IBAction)phoneBtn:(UIButton *)sender;
- (IBAction)directionsBtn:(UIButton *)sender;

@end

@implementation TMNTSecondVC

@synthesize placeVisited;

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

    navBar.title = placeVisited.title;
    //format the phone string
    NSString *firstThreeCharsPhone = [placeVisited.phone substringToIndex:3];
    NSString *lastSevenCharsPhone = [placeVisited.phone substringFromIndex:3];
    NSString *midThreeCharsPhone = [lastSevenCharsPhone substringToIndex:3];
    NSString *lastFourCharsPhone = [placeVisited.phone substringFromIndex:6];
    NSString *formattedPhone = [NSString stringWithFormat:@"(%@) %@-%@",firstThreeCharsPhone, midThreeCharsPhone, lastFourCharsPhone];
    phoneLabel.text = formattedPhone;
    zipLabel.text = placeVisited.zipCode;
    addressLabel.text = placeVisited.address;
    stateLabel.text = placeVisited.state;
    
    NSURL *urlStringForRating = [NSURL URLWithString:placeVisited.ratingURL];
    UIImage *ratingImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:urlStringForRating]];
    [ratingImageView setImage:ratingImage];
    
    NSURL *urlStringForThumbnail = [NSURL URLWithString:placeVisited.thumbnailURL];
    UIImage *thumbnailImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:urlStringForThumbnail]];
    [thumbnailImageView setImage:thumbnailImage];

}

//-(void)setDetailItem
//{
//    if (<#condition#>)
//    {
//        <#statements#>
//    }
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)phoneBtn:(id)sender {
}

- (IBAction)directionsBtn:(UIButton *)sender {
}
@end
