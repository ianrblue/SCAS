//
//  NNViewController.m
//  CoPairCoreData
//
//  Created by Nathan Levine on 3/12/13.
//  Copyright (c) 2013 Nathan & Nirav incorporated. All rights reserved.
//

#import "NNViewController.h"
#import "NNAppDelegate.h"
#import "Peoples.h"


@interface NNViewController ()

@end

@implementation NNViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)createRecordBtn:(id)sender
{
    NSManagedObject *peoples = [NSEntityDescription insertNewObjectForEntityForName:@"Peoples" inManagedObjectContext:_MACH_BOOLEAN_H_]
}

- (IBAction)fetchRecordBtn:(id)sender
{

}
@end
