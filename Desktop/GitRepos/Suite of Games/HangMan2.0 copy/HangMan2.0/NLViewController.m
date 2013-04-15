//
//  NLViewController.m
//  HangMan2.0
//
//  Created by Nathan Levine on 3/12/13.
//  Copyright (c) 2013 Nathan & Nirav incorporated. All rights reserved.
//

#import "NLViewController.h"
#import "Lexicontext.h"
#import "NLWordToDisplay.h"

@interface NLViewController ()
{
    Lexicontext *dictionary;
    NLWordToDisplay *wordToDisplayClass;
    int count;
}

@property (strong, nonatomic) NSString *word;

@end

@implementation NLViewController
@synthesize subview, word;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //make instantiation of nlwordtodisplayclass
    wordToDisplayClass = [[NLWordToDisplay alloc]init];
    
    //start with new game
    [self newGameSetup];
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)letterBtn:(UIButton *)sender
{
    //get the lowercase letter for each button
    NSString *specificLetterOnBtn = [[NSString stringWithFormat:@"%@", sender.titleLabel.text] lowercaseString];
    
    //add a comparison count
    int intForCountComparison = count;
    
    //add guess functionality to buttons
    [self guessCharSeeWhathappens:specificLetterOnBtn];
    [wordDisplaylabel setText:wordToDisplayClass.displayString];
    [countLabel setText:[NSString stringWithFormat:@"Guesses wrong: %i/6",count]];
        
    //hide each button when pressed
    sender.hidden = YES;
    
    //add the animation for correct guess
    if (count == intForCountComparison)
    {
        [UIView animateWithDuration:0.5
                              delay:0.1
                            options: UIViewAnimationOptionCurveEaseInOut
                         animations:^
         {
             self.view.backgroundColor = [UIColor greenColor];
         }
                         completion:^(BOOL finished){
                             self.view.backgroundColor = [UIColor whiteColor];
                         }];
    }
    //add the switch statment for whenyouguess functionality
    [self whenYouGuess];
}

- (IBAction)newGameBtn:(UIButton *)sender
{
    [self newGameSetup];
}

-(void)newGameSetup
{
    //look through the view and grab anything that is hidden and unhide(show) it.
    for (UIView *view in self.view.subviews)
    {
        if ((view.hidden == YES))
        {
            view.hidden = NO;
        }
    }
    //get random word
    dictionary = [Lexicontext sharedDictionary];
    word = [dictionary randomWord];
    
    //get definition of word
    NSString *definition = [dictionary definitionFor:word];
    NSLog(@"definition is: %@",definition);
    
    //take random word and make first array of its individual character strings
    [wordToDisplayClass takeWordStringAndCreateArray:word];
    
    //take first array and make second array and display string
    [wordToDisplayClass takeWordArrayAndCreateDisplayArrayReturningString:wordToDisplayClass.wordTakenForGameArray];
    
    //make label look like dispalystring (dashes)
    [wordDisplaylabel setText:wordToDisplayClass.displayString];
    
    //restart count at zero
    count = 0;
    [countLabel setText:[NSString stringWithFormat:@"Guesses wrong: %i/6",count]];
    
    //set label color back to black if red
    UIColor *black = [UIColor blackColor];
    [wordDisplaylabel setTextColor:black];
    
    //start with picture by adding switch rules
    [self whenYouGuess];

}

-(void)guessCharSeeWhathappens: (NSString*)forChar
{
    [wordToDisplayClass.displayString setString:@""];
    for (int i = 0; i <wordToDisplayClass.wordTakenForGameArray.count; i++)
    {
        NSString *compareString =  [wordToDisplayClass.wordTakenForGameArray objectAtIndex:i];
        
        if ([forChar isEqualToString:compareString])
        {
            [wordToDisplayClass.dashGameArray replaceObjectAtIndex:i withObject:forChar];
        }
        
        NSString *stringToAddToDisplayString = [wordToDisplayClass.dashGameArray objectAtIndex:i];
        [wordToDisplayClass.displayString appendString:[NSString stringWithString:stringToAddToDisplayString]];
    }
    if (([wordToDisplayClass.wordTakenForGameArray containsObject:forChar]) == FALSE) {
        count = count + 1;
    }
}

-(void)whenYouGuess
{
    for (UIView *view in self.view.subviews)
    {
        if ((view.hidden == YES))
        {
        }
        else  if (([wordToDisplayClass.displayString isEqualToString: word]) && count < 6)
        {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle: @"You Win!"
                                  message: @"It turns out that you are Da Best!"
                                  delegate: nil
                                  cancelButtonTitle:@"Oh Yeah!"
                                  otherButtonTitles:nil];
            [alert show];
            
            //and start new game
            [self newGameSetup];
            
        }
    }

    
    UIImage *beginImage = [UIImage imageNamed:@"hang0.gif"];
    UIImage *firstWrongGuessImage = [UIImage imageNamed:@"hang1.gif"];
    UIImage *secondWrongGuessImage = [UIImage imageNamed:@"hang2.gif"];
    UIImage *thirdWrongGuessImage = [UIImage imageNamed:@"hang4.gif"];
    UIImage *fourthWrongGuessImage = [UIImage imageNamed:@"hang6.gif"];
    UIImage *fifthWrongGuessImage = [UIImage imageNamed:@"hang8.gif"];
    UIImage *sixthWrongGuessImage = [UIImage imageNamed:@"hang10.gif"];
    
    
    switch (count) {
        case 0:
            [uiImageView setImage:beginImage];
            break;
        case 1:
            [uiImageView setImage:firstWrongGuessImage];
            break;
        case 2:
            [uiImageView setImage:secondWrongGuessImage];
            break;
        case 3:
            [uiImageView setImage:thirdWrongGuessImage];
            break;
        case 4:
            [uiImageView setImage:fourthWrongGuessImage];
            break;
        case 5:
            [uiImageView setImage:fifthWrongGuessImage];
            break;
        case 6:
            [uiImageView setImage:sixthWrongGuessImage];
            
            //show word and make it red
            NSString *redTextToDisplay = word;
            UIColor *red = [UIColor redColor];
            [wordDisplaylabel setTextColor:red];
            [wordDisplaylabel setText:redTextToDisplay];
            
            //display you lose popup
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle: @"You Lose!"
                                  message: @"It turns out that you are a bad guesser!"
                                  delegate: nil
                                  cancelButtonTitle:@"Not Today!"
                                  otherButtonTitles:nil];
            [alert show];
            break;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
