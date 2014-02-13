//
//  FirstViewController.h
//  deathstarfighers
//
//  Created by Timothee Cruse on 08/02/14.
//  Copyright (c) 2014 TC. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <MapKit/MapKit.h>

@interface FirstViewController : UIViewController <MKMapViewDelegate> {
    UIView          * activityView;
    MKMapView       * map;
}

@property (strong, nonatomic) IBOutlet  UIView          * activityView;
@property (strong, nonatomic) IBOutlet  MKMapView       * map;

@property (strong, nonatomic)           NSMutableArray  * routeOverlays;
@property (strong, nonatomic)           NSMutableArray  * mappoints;

@end
