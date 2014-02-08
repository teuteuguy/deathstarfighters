//
//  SHUDetailViewController.h
//  deathstarfighers
//
//  Created by Timothee Cruse on 09/02/14.
//  Copyright (c) 2014 TC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface SHUDetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    MKMapView   * map;
    UITableView * tableView;
}

@property (strong, nonatomic) NSDictionary * itemDetail;
@property (strong, nonatomic) NSDictionary * itemSHU;

@property (strong, nonatomic) IBOutlet UITableView * tableView;
@property (strong, nonatomic) IBOutlet MKMapView * map;


@end
