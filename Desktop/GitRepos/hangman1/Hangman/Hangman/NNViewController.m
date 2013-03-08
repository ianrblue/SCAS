//
//  NNViewController.m
//  Hangman
//
//  Created by Nathan Levine on 3/8/13.
//  Copyright (c) 2013 Nathan & Nirav incorporated. All rights reserved.
//

#import "NNViewController.h"
#import "Lexicontext.h"

@interface NNViewController ()

@end

@implementation NNViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    Lexicontext *dictionary = [Lexicontext sharedDictionary];
    NSString*word = [dictionary randomWord];
    NSString *definition = [dictionary definitionFor:@"auguring"];
    NSLog(@"random word is: %@", definition);
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
