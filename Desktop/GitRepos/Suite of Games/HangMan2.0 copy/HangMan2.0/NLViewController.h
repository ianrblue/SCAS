//
//  NLViewController.h
//  HangMan2.0
//
//  Created by Nathan Levine on 3/12/13.
//  Copyright (c) 2013 Nathan & Nirav incorporated. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NLViewController : UIViewController
{
    __weak IBOutlet UILabel *countLabel;
    IBOutlet UILabel *wordDisplaylabel;
    __weak IBOutlet UIImageView *uiImageView;
}

@property (strong, nonatomic) IBOutlet UIView *subview;

- (IBAction)letterBtn:(UIButton *)sender;
- (IBAction)newGameBtn:(UIButton *)sender;



-(void)guessCharSeeWhathappens: (NSString*)forChar;
-(void)newGameSetup;
-(void)whenYouGuess;

@end
