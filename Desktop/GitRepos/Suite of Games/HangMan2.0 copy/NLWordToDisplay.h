//
//  NLWordToDisplay.h
//  HangMan2.0
//
//  Created by Nathan Levine on 3/13/13.
//  Copyright (c) 2013 Nathan & Nirav incorporated. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NLWordToDisplay : NSObject
{
    int lengthOfWord;
}

@property (strong, nonatomic) NSMutableArray *wordTakenForGameArray;
@property (strong, nonatomic) NSMutableArray *dashGameArray;
@property (strong, nonatomic) NSMutableString *displayString;

-(NSMutableArray*)takeWordStringAndCreateArray: (NSString*)word;

-(NSMutableString*)takeWordArrayAndCreateDisplayArrayReturningString: (NSMutableArray *)wordArray;

@end
