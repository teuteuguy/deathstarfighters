//
//  SHUMenuTableViewController.h
//  deathstarfighers
//
//  Created by Timothee Cruse on 08/02/14.
//  Copyright (c) 2014 TC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface SHUMenuTableViewController : UITableViewController {
    NSDictionary  * configItems;
    NSDictionary * statusItems;
}

@property (nonatomic, retain) NSDictionary * configItems;
@property (nonatomic, retain) NSDictionary * statusItems;

@property (strong, nonatomic) NSDictionary * itemSHU;

@end
