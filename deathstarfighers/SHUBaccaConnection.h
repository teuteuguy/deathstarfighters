//
//  SHUBaccaConnection.h
//  deathstarfighers
//
//  Created by Timothee Cruse on 08/02/14.
//  Copyright (c) 2014 TC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@protocol SHUBaccaConnectionDelegates <NSObject>

- (void)updating;
- (void)doneUpdating;

@end

@interface SHUBaccaConnection : NSObject

@property (nonatomic, weak) id <SHUBaccaConnectionDelegates> delegate;

@property (nonatomic, retain) NSTimer               * connectionTimer;

@property (nonatomic, retain) NSMutableArray        * shus;
@property (nonatomic, retain) NSMutableArray        * shuAllMapAnnotations;
@property (nonatomic, retain) NSMutableArray        * shuMapAnnotations;
@property (nonatomic, retain) NSMutableArray        * shuConfigs;
@property (nonatomic, retain) NSMutableArray        * shuStatuses;
@property (strong, nonatomic) NSMutableArray        * shuRouteOverlays;

+ (id)sharedSHUBaccaConnection;

- (void)update;

@end