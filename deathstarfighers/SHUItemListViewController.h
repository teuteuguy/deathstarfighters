//
//  SHUItemListViewController.h
//  deathstarfighers
//
//  Created by Timothee Cruse on 08/02/14.
//  Copyright (c) 2014 TC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHUItemListViewController : UITableViewController {
    NSMutableArray  * listItems;
}

@property (nonatomic, retain) NSMutableArray    * listItems;


@property (strong, nonatomic) id itemType;
@property (strong, nonatomic) NSDictionary * itemSHU;

@end
