//
//  ThirdViewController.h
//  deathstarfighers
//
//  Created by Timothee Cruse on 08/02/14.
//  Copyright (c) 2014 TC. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SHUBaccaConnection.h"

@interface ThirdViewController : UITableViewController <SHUBaccaConnectionDelegates> {
    NSArray * shus;
    NSArray * shuConfigs;
    NSArray * shuStatuses;
    
    UIActivityIndicatorView * activityView;
}


@property (nonatomic, retain) NSArray * shus;
@property (nonatomic, retain) NSArray * shuConfigs;
@property (nonatomic, retain) NSArray * shuStatuses;

@property (nonatomic, retain) UIActivityIndicatorView * activityView;

@end
