//
//  MMViewController.m
//  barTalk
//
//  Created by Nathan Levine on 2/6/13.
//  Copyright (c) 2013 Nathan Levine. All rights reserved.
//

#import "MMViewController.h"
#import "MMUITextield.h"

@interface MMViewController ()

{
    MMUITextield *awesomeTextStuff;
}
@end

@implementation MMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //changing the background to black, referencing the instance of the view we are looking at and calling a method called setbackgroundColor, passing it the UIColor class and the color black
    
    [[self view] setBackgroundColor:[UIColor blackColor]];
    
    //initialize our awesomeTextField with cgrectangle
    awesomeTextStuff = [[MMUITextield alloc] initWithFrame:CGRectMake(0, 200, 300, 50)];
    //internet fix for disappearing textbox
    [awesomeTextStuff setDelegate:self];
    
    //add the textfield to our view
	[[self view] addSubview:awesomeTextStuff];
    
    // Do any additional setup after loading the view, typically from a nib.
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
