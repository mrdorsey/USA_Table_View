//
//  MRDAppDelegate.h
//  USA_Table_View
//
//  Created by Michael Dorsey on 2/11/13.
//  Copyright (c) 2013 Michael Dorsey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MRDStateListViewController.h"

@class MRDViewController;

@interface MRDAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) MRDStateListViewController *stateListTableViewController;

@end
