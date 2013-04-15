//
//  Card.h
//  TheMostRidiculousAppEVAR
//
//  Created by mmacademy on 3/28/13.
//  Copyright (c) 2013 mmacademy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CardView : UIView

//@property(strong, nonatomic) UIImage *backgroundImage;

@property (strong, nonatomic) UIColor *cardColor;
@property (assign, nonatomic) BOOL isFlipped;
@property (assign, nonatomic) BOOL isSolved;
@property (assign, nonatomic) int CardNumber;
@property (assign, nonatomic) int cardCount;
@property (strong, nonatomic) NSMutableArray *randomizedAndDoubledArray;

-(void)flipCardwithArray: (NSMutableArray *)array;

@end
