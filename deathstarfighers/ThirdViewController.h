//
//  ThirdViewController.h
//  deathstarfighers
//
//  Created by Timothee Cruse on 08/02/14.
//  Copyright (c) 2014 TC. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SHUBaccaConnection.h"

@interface ThirdViewController : UITableViewController {
    //SHUBaccaConnection  * shubaccaConnection;
    NSMutableArray  * shus;
}

@property (nonatomic, retain) NSMutableArray    * shus;

//@property (nonatomic, retain) SHUBaccaConnection    * shubaccaConnection;

@end
