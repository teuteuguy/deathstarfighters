//
//  SHUStatusTableViewController.h
//  deathstarfighers
//
//  Created by Timothee Cruse on 08/02/14.
//  Copyright (c) 2014 TC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHUStatusTableViewController : UITableViewController {
    NSMutableArray  * shus;
}

@property (strong, nonatomic) id detailItem;

@property (nonatomic, retain) NSMutableArray    * statuses;


@end
