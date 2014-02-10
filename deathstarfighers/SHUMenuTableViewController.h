//
//  SHUMenuTableViewController.h
//  deathstarfighers
//
//  Created by Timothee Cruse on 08/02/14.
//  Copyright (c) 2014 TC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHUMenuTableViewController : UITableViewController {
    NSMutableArray  * configItems;
}

@property (nonatomic, retain) NSMutableArray    * configItems;

@property (strong, nonatomic) NSDictionary * itemSHU;

@end
