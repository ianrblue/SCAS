//
//  Card.m
//  TheMostRidiculousAppEVAR
//
//  Created by mmacademy on 3/28/13.
//  Copyright (c) 2013 mmacademy. All rights reserved.
//

#import "CardView.h"

@implementation CardView
{
    NSMutableArray *arrayToAddFlippedCardsTo;
}

@synthesize isFlipped, isSolved, cardColor, CardNumber, randomizedAndDoubledArray, cardCount;

- (id)initWithFrame:(CGRect)frame
{
    //NSLog(@"in initwithframe array is: %@",randomizedAndDoubledArray);
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        self.cardColor = [UIColor greenColor];
        self.CardNumber = 0;
    }
    return self;
}


//Flip animation
-(void)flipCardwithArray: (NSMutableArray *)array
//-(void)flipCardwithArray
{
    int imageIndex = CardNumber - 1;
    if (self.isFlipped == NO)
    {
        [UIView transitionWithView:self
                          duration:0.5f
                           options:UIViewAnimationOptionTransitionFlipFromRight
                        animations:^{
                                        self.backgroundColor = [UIColor colorWithPatternImage:[array objectAtIndex:imageIndex]];
                                        NSLog(@"pic is %@",[array objectAtIndex:imageIndex]);
                                    }
                        completion:^(BOOL finished)
                                    {
                                        self.isFlipped = YES;
                                       // [arrayToAddFlippedCardsTo addObject:[array objectAtIndex:imageIndex]];
                                        //NSLog(@"the objects in the array is a :%@", arrayToAddFlippedCardsTo);
                                        if (self.isSolved == NO)
                                        {
                                        }
                                    }];
    } else if (!self.isSolved == YES)
    {
        //Flip card back to default color (here, green)
        cardColor = [UIColor greenColor];
        [UIView transitionWithView:self
                          duration:0.5f
                           options:UIViewAnimationOptionTransitionFlipFromRight
                        animations:^{
                                        self.backgroundColor = cardColor;
                                    }
                        completion:^(BOOL finished)
                                    {
                                        self.isFlipped = NO;
                                    }];
    }
}

-(void)checkForMatch
{
    for (UIImage *pic in randomizedAndDoubledArray)
    {
        if ([randomizedAndDoubledArray objectAtIndex:CardNumber-1] == pic)
        {
            self.isSolved = YES;
            NSLog(@"you have found a PAIR!");
        }
    }
}


#pragma mark - touch stuff
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //arrayToAddFlippedCardsTo = [[NSMutableArray alloc]initWithObjects:arrayToAddFlippedCardsTo, nil];
    NSLog(@"CARD %d WAS TOUCHED!",self.CardNumber);
    [self flipCardwithArray:randomizedAndDoubledArray];
    int cardFlippedCount = 0;
    if (cardFlippedCount <2)
    {
        cardFlippedCount++;
    } else
    {
        //and set cardcount to zero
        cardFlippedCount = 0;
    }
    
    //    NSSet *allTouches = [event allTouches];
    //    for (UITouch *touch in allTouches)
    //    {
    //        //CGPoint location = [touch locationInView:touch.view];
    //        [self flipCard];
    //
    //    }
}



#pragma mark -- End of document
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
