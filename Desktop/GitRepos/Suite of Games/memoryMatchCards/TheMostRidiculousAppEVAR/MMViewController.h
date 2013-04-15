//
//  MMViewController.h
//  TheMostRidiculousAppEVAR
//
//  Created by mmacademy on 3/28/13.
//  Copyright (c) 2013 mmacademy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardView.h"

@interface MMViewController : UIViewController

//scales images to right size for layout
-(UIImage*)scaleToSize:(CGSize)size withImage:(UIImage*)image;

//sets up the cardwidth and height
-(void)setupCardWidthAndHeightConsideringCols:(int)numCols andRows:(int)numRows;



@end
