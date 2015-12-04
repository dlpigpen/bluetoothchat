//
//  TabbarController.m
//  VideoYoutube
//
//  Created by Duc Nguyen on 6/8/15.
//  Copyright (c) 2015 Duc Nguyen. All rights reserved.
//

#import "TabbarController.h"
#import "MasterNavigation.h"

@interface TabbarController ()


@end

@implementation TabbarController

- (void)viewDidLoad {
    
    [self hiddenTitleBarItem];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) hiddenTitleBarItem
{
    for(UITabBarItem * tabBarItem in self.tabBar.items){
        tabBarItem.title = @"";
        tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
        
    }
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
