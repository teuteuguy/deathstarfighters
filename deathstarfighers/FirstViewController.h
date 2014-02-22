//
//  FirstViewController.h
//  deathstarfighers
//
//  Created by Timothee Cruse on 08/02/14.
//  Copyright (c) 2014 TC. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <MapKit/MapKit.h>
#import "SHUBaccaConnection.h"

@interface FirstViewController : UIViewController <MKMapViewDelegate, SHUBaccaConnectionDelegates> {

    UIActivityIndicatorView     * activityView;
    //UIView                      * activityView;
    MKMapView                   * map;
}

@property (strong, nonatomic)           NSMutableArray              * annotations;

@property (strong, nonatomic) IBOutlet  UIActivityIndicatorView     * activityView;
@property (strong, nonatomic) IBOutlet  MKMapView                   * map;

@property (strong, nonatomic)           NSMutableArray              * routeOverlays;
@property (strong, nonatomic)           NSMutableArray              * mappoints;

@end
