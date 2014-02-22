//
//  SHUMenuTableViewController.h
//  deathstarfighers
//
//  Created by Timothee Cruse on 08/02/14.
//  Copyright (c) 2014 TC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "SHUBaccaConnection.h"

@interface SHUMenuTableViewController : UITableViewController <SHUBaccaConnectionDelegates>  {
//    NSDictionary  * configItems;
//    NSDictionary * statusItems;
}

@property (nonatomic, retain) UIActivityIndicatorView * activityView;

@property (nonatomic, retain) NSDictionary  * configItems;
@property (nonatomic, retain) NSArray       * statusItems;
//@property (nonatomic, retain) NSDictionary       * statusItems;
@property (strong, nonatomic) NSDictionary  * itemSHU;

@end
