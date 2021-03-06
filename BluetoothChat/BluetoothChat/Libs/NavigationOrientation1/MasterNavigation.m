//
//  MasterNavigation.m
//  VFFPlatformiOS
//
//  Created by Duc Nguyen on 10/24/13.
//  Copyright (c) 2013 Vuong Nguyen. All rights reserved.
//

#import "MasterNavigation.h"

@interface MasterNavigation ()

@end

@implementation MasterNavigation


-(BOOL) shouldAutorotate
{
    if (Bool_UserDefaults(@"Orientations"))
    {
        return YES;
    }
    return NO;
    
}


- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    if (Bool_UserDefaults(@"Orientations"))
    {
        return UIInterfaceOrientationMaskAll;
    }
    return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown;
    
}

-(BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    if (Bool_UserDefaults(@"Orientations"))
    {
        return (UIInterfaceOrientationPortrait | UIInterfaceOrientationPortraitUpsideDown | UIInterfaceOrientationLandscapeLeft | UIInterfaceOrientationLandscapeRight);
    }
    return (UIInterfaceOrientationPortrait | UIInterfaceOrientationPortraitUpsideDown);
    
    
}


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

@end
