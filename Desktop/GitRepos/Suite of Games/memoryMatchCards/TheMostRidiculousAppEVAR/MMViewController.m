//
//  MMViewController.m
//  TheMostRidiculousAppEVAR
//
//  Created by mmacademy on 3/28/13.
//  Copyright (c) 2013 mmacademy. All rights reserved.
//

#import "MMViewController.h"
#import "CardView.h"

@interface MMViewController ()
{
    //BOOL flipped;
    //CardView *gameCard;
    
    CGFloat cardWidth;
    CGFloat cardHeight;
    CGFloat cardMargin;
    
    NSMutableArray *picArray;
}

@end

@implementation MMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //setup cardwidth and height
    [self setupCardWidthAndHeightConsideringCols:6 andRows:6];
    
    if (picArray == nil)
    {
        // Create images
        UIImage *imageNate = [UIImage imageNamed:@"nate(me).jpg"];
        UIImage *imageAdamL = [UIImage imageNamed:@"adamLupu.jpg"];
        UIImage *imageAHaun = [UIImage imageNamed:@"AHaun"];
        UIImage *imageBrandon = [UIImage imageNamed:@"BrandonPass.png"];
        UIImage *imageDavid = [UIImage imageNamed:@"Dave.png"];
        UIImage *imageDon = [UIImage imageNamed:@"Don.png"];
        UIImage *imageDTeng = [UIImage imageNamed:@"Dteng.png"];
        UIImage *imageDylan = [UIImage imageNamed:@"Dylan.png"];
        UIImage *imageEmily = [UIImage imageNamed:@"Emily.png"];
        UIImage *imageIanBlue = [UIImage imageNamed:@"IanBlue.png"];
        UIImage *imageJamie = [UIImage imageNamed:@"Jamie.png"];
        UIImage *imageMike = [UIImage imageNamed:@"mikeSchaub.png"];
        UIImage *imageNirav = [UIImage imageNamed:@"Nirav.png"];
        UIImage *imagePaul = [UIImage imageNamed:@"Paul.png"];
        UIImage *imageRoss = [UIImage imageNamed:@"Ross.png"];
        UIImage *imageSpawrks = [UIImage imageNamed:@"Spawrks.png"];
        UIImage *imageStriker = [UIImage imageNamed:@"Striker.png"];
        UIImage *imageZanette = [UIImage imageNamed:@"Zanette.png"];
        
        // Scale the images
        UIImage *scaledNate = [self scaleToSize:CGSizeMake(cardWidth, cardHeight) withImage:imageNate];
        UIImage *scaledAdamL = [self scaleToSize:CGSizeMake(cardWidth, cardHeight) withImage:imageAdamL];
        UIImage *scaledAdamH = [self scaleToSize:CGSizeMake(cardWidth, cardHeight) withImage:imageAHaun];
        UIImage *scaledBrandon = [self scaleToSize:CGSizeMake(cardWidth, cardHeight) withImage:imageBrandon];
        UIImage *scaledDavid = [self scaleToSize:CGSizeMake(cardWidth, cardHeight) withImage:imageDavid];
        UIImage *scaledDon = [self scaleToSize:CGSizeMake(cardWidth, cardHeight) withImage:imageDon];
        UIImage *scaledDTeng = [self scaleToSize:CGSizeMake(cardWidth, cardHeight) withImage:imageDTeng];
        UIImage *scaledDylan = [self scaleToSize:CGSizeMake(cardWidth, cardHeight) withImage:imageDylan];
        UIImage *scaledEmily = [self scaleToSize:CGSizeMake(cardWidth, cardHeight) withImage:imageEmily];
        UIImage *scaledIan = [self scaleToSize:CGSizeMake(cardWidth, cardHeight) withImage:imageIanBlue];
        UIImage *scaledJamie = [self scaleToSize:CGSizeMake(cardWidth, cardHeight) withImage:imageJamie];
        UIImage *scaledMike = [self scaleToSize:CGSizeMake(cardWidth, cardHeight) withImage:imageMike];
        UIImage *scaledNirav = [self scaleToSize:CGSizeMake(cardWidth, cardHeight) withImage:imageNirav];
        UIImage *scaledPaul = [self scaleToSize:CGSizeMake(cardWidth, cardHeight) withImage:imagePaul];
        UIImage *scaledRoss = [self scaleToSize:CGSizeMake(cardWidth, cardHeight) withImage:imageRoss];
        UIImage *scaledSpawrks = [self scaleToSize:CGSizeMake(cardWidth, cardHeight) withImage:imageSpawrks];
        UIImage *scaledStriker = [self scaleToSize:CGSizeMake(cardWidth, cardHeight) withImage:imageStriker];
        UIImage *scaledZanette = [self scaleToSize:CGSizeMake(cardWidth, cardHeight) withImage:imageZanette];
        
        //add pics to array...twice
        picArray = [[NSMutableArray alloc]initWithObjects:scaledNate, scaledAdamL, scaledAdamH, scaledBrandon,scaledDavid, scaledDon, scaledDTeng, scaledDylan, scaledEmily, scaledIan, scaledJamie, scaledMike, scaledNirav, scaledPaul, scaledRoss, scaledSpawrks, scaledStriker, scaledZanette, scaledNate, scaledAdamL, scaledAdamH, scaledBrandon,scaledDavid, scaledDon, scaledDTeng, scaledDylan, scaledEmily, scaledIan, scaledJamie, scaledMike, scaledNirav, scaledPaul, scaledRoss, scaledSpawrks, scaledStriker, scaledZanette,  nil];
        
                //double your array
        //?????????????????
        //[picArray addObjectsFromArray:picArray];
        
        //randomize your array
        for (int i = 0; i < picArray.count; i++)
        {
            int randInt = (arc4random() % (picArray.count - i)) + i;
            [picArray exchangeObjectAtIndex:i withObjectAtIndex:randInt];
        }
        
        NSLog(@"array is: %@ array count is: %i", picArray, picArray.count);
    }
    
    //setup layout
    [self setupLayoutWithColumns:6 Rows:6];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



//IMAGE STUFF
-(UIImage*)scaleToSize:(CGSize)size withImage:(UIImage *)image
{
    // Create a bitmap graphics context
    // This will also set it as the current context
    UIGraphicsBeginImageContext(size);
    
    // Draw the scaled image in the current context
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    // Create a new image from current context
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // Pop the current context from the stack
    UIGraphicsEndImageContext();
    
    // Return our new scaled image
    return scaledImage;
}

-(void)setupCardWidthAndHeightConsideringCols:(int)numCols andRows:(int)numRows
{
    //setup card pieces
    int xPadding = 5;
    cardWidth = (self.view.frame.size.width / numCols) - xPadding;
    
    int yPadding = 5;
    cardHeight = (self.view.frame.size.height / numRows) - yPadding;
}

-(void)setupLayoutWithColumns:(int)numCols Rows:(int)numRows
{
    //setup cardcount
    int numOfCards = numRows * numCols;
    
    //setup card pieces
    int xPadding = 5;
    //cardWidth = (self.view.frame.size.width / numCols) - xPadding;
    
    int yPadding = 5;
    //cardHeight = (self.view.frame.size.height / numRows) - yPadding;
                 
    //NSLog(@"card width: %f, card height: %f",cardWidth, cardHeight);
    
    cardMargin = xPadding /2;
    
    CGFloat x, y;
    
    int startingValue = cardMargin;
    x = y = startingValue;
    int i = 1;
    while (y < self.view.frame.size.height)
    {
        while(x < self.view.frame.size.width)
        {
           CardView* aCard = [[CardView alloc] init];
            
            //Place card
            aCard.frame = CGRectMake(x, y, cardWidth, cardHeight);
            aCard.randomizedAndDoubledArray = picArray;
            aCard.cardCount = numOfCards;
            [self.view addSubview:aCard];
            
            //setup additional card properties
            aCard.backgroundColor = aCard.cardColor;
            aCard.CardNumber = i;
            i++;
            
            x += (cardWidth + xPadding);
            //NSLog(@"x = %f", x);
        }

        x = startingValue;
        y += (cardHeight + yPadding);
        //NSLog(@"y = %f", y);
    }
}



@end
