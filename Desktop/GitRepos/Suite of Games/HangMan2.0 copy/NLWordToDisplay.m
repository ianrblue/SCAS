//
//  NLWordToDisplay.m
//  HangMan2.0
//
//  Created by Nathan Levine on 3/13/13.
//  Copyright (c) 2013 Nathan & Nirav incorporated. All rights reserved.
//

#import "NLWordToDisplay.h"

@implementation NLWordToDisplay
@synthesize displayString, wordTakenForGameArray, dashGameArray;

-(NSMutableArray*)takeWordStringAndCreateArray: (NSString*)word
{
    lengthOfWord = word.length;
    wordTakenForGameArray = [[NSMutableArray alloc]initWithCapacity:lengthOfWord];
    
    for (int i =0; i<lengthOfWord; i++)
    {
        NSString *singleCharacter  = [NSString stringWithFormat:@"%c", [word characterAtIndex:i]];
        [wordTakenForGameArray addObject:singleCharacter];
    }
    return wordTakenForGameArray;
}

-(NSMutableString*)takeWordArrayAndCreateDisplayArrayReturningString: (NSMutableArray *)wordArray
{
    wordArray = [[NSMutableArray alloc] initWithCapacity:lengthOfWord];
    dashGameArray   = wordArray;
    displayString = [NSMutableString stringWithCapacity:lengthOfWord];

    NSString *dash = @"-";
    NSString *dashWithSpace = @"- ";
    NSString *spaceString = @" ";
    for (int i = 0; i < lengthOfWord; i++)
    {
        NSString *stringToTestForSpace = [NSString stringWithFormat:@"%@", [wordTakenForGameArray objectAtIndex:i]];
        //if the string has a space in it return a space to the array
        if ([stringToTestForSpace isEqualToString:spaceString])
        {
            [dashGameArray addObject:spaceString];
        }
        //if the string has a dash in it return a space to the array
        else if ([stringToTestForSpace isEqualToString:dash])
        {
            [dashGameArray addObject:spaceString];
        }
        //if the string has a character (string) in it return a dash to the array
        else
        {
            [dashGameArray addObject:dashWithSpace];
        }
        
        NSString *charStringToAddToDisplayString = [wordArray objectAtIndex:i];
        [displayString appendString:[NSString stringWithString:charStringToAddToDisplayString]];
    }
    return displayString;
}


@end
