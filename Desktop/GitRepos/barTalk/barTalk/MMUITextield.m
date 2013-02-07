//
//  MMUITextield.m
//  barTalk
//
//  Created by Nathan Levine on 2/6/13.
//  Copyright (c) 2013 Nathan Levine. All rights reserved.
//

#import "MMUITextield.h"

@implementation MMUITextield
-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setTextColor:[UIColor whiteColor]];
        [self setBorderStyle:UITextBorderStyleNone];
        [self setFont:[UIFont systemFontOfSize:42]];
        [self setPlaceholder:@"Enter Awesome Text here"];
        [self setReturnKeyType:UIReturnKeyDone];
        return self;
    }
    return nil;
}
@end
