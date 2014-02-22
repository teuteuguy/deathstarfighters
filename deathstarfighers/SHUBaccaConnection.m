//
//  SHUBaccaConnection.m
//  deathstarfighers
//
//  Created by Timothee Cruse on 08/02/14.
//  Copyright (c) 2014 TC. All rights reserved.
//

#import "SHUBaccaConnection.h"
#import "Utils.h"


#define shubaccaQueue dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0 ) //1
#define shubaccaGetIDsUrl @"http://api.shubacca.com/shu?consumer_key=4a8e628392a504eb746c37e1b0044f0f&sort=description,asc" //2
#define shubaccaGetStatusesForIDUrl(shu,type) [NSString stringWithFormat:@"http://api.shubacca.com/shu/%@/%@?consumer_key=4a8e628392a504eb746c37e1b0044f0f&sort=id,desc&limit=10", shu, [type lowercaseString]] //2
#define shubaccaGetConfigForIDUrl(shu) [NSString stringWithFormat:@"http://api.shubacca.com/shu/%@/config?consumer_key=4a8e628392a504eb746c37e1b0044f0f&sort=id,desc&limit=1", shu]

@implementation SHUBaccaConnection {
    dispatch_queue_t backgroundQueue;
}

@synthesize connectionTimer;
@synthesize shus;
@synthesize shuAllMapAnnotations;
@synthesize shuMapAnnotations;
@synthesize shuConfigs;
@synthesize shuStatuses;
@synthesize shuRouteOverlays;
@synthesize delegate;

#pragma mark Singleton Methods

+ (id)sharedSHUBaccaConnection {
    static SHUBaccaConnection * sharedSHUBaccaConnection = nil;
    static dispatch_once_t onceToken;

    dispatch_once( &onceToken, ^{
        sharedSHUBaccaConnection = [[self alloc] init];
    });
    return sharedSHUBaccaConnection;
}

- (id)init {
    if (self = [super init]) {
        backgroundQueue = dispatch_queue_create( "com.shubacca.api.bgqueue", NULL );
        [self update];
    }
    return self;
}

- (void)timerTicked:(NSTimer*)timer {
    NSLog( @"Timer" );
    [self update];
}

- (void)setDelegate:(id <SHUBaccaConnectionDelegates>)aDelegate {
    if (delegate != aDelegate) {
        delegate = aDelegate;
        
    }
}

- (void)update {

    NSLog( @"SHUBaccaConnection: Updating data" );
    [delegate updating];
    
//    dispatch_async( shubaccaQueue, ^{
//        NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:shubaccaGetIDsUrl]];
//        if ( data != nil ) {
//            [self fetchedIDs:data];
//        }
//        dispatch_async(dispatch_get_main_queue(), ^{
//            NSLog( @"SHUBaccaConnection: doneUpdating" );
//            [delegate doneUpdating]; // 2
//            connectionTimer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(timerTicked:) userInfo:nil repeats:NO];
//        });
//    });


    dispatch_async( backgroundQueue, ^(void) {
        [self fetchSHUs];
        
        NSLog( @"SHUBaccaConnection: Setting timer" );
        dispatch_async(dispatch_get_main_queue(), ^{
            [delegate doneUpdating];
            connectionTimer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(timerTicked:) userInfo:nil repeats:NO];
        });
    });
    
}

- (void)fetchSHUs {
    NSError * error = Nil;
    
    NSLog( @"SHUBaccaConnection: Fetching SHUs" );
    
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:shubaccaGetIDsUrl]];

    if ( data == nil ) {
        NSLog( @"SHUBaccaConnection: Failed to get SHUs" );
    } else {
        NSArray * shuArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        
        if ( error != Nil ) {
            NSLog( @"SHUBaccaConnection: There was an error trying to retrieve the SHU JSON from the server" );
        } else {
            NSLog( @"SHUBaccaConnection: Retrieved SHU JSON from the server: %i shus to analyze", [shuArray count] );
            
            if ( shus == Nil )
                shus = [[NSMutableArray alloc] init];
            [shus removeAllObjects];
            
            if ( shuMapAnnotations == Nil )
                shuMapAnnotations = [[NSMutableArray alloc] init];
            [shuMapAnnotations removeAllObjects];
            
            if ( shuConfigs == Nil )
                shuConfigs = [[NSMutableArray alloc] init];
            
            [shuConfigs removeAllObjects];
            
            for( NSMutableDictionary * shu in shuArray ) {

                
                int shu_id = [[[shu valueForKey:@"id"] description] integerValue];
                
                MKPointAnnotation * point = [Utils annotationFromGPS:[[shu valueForKey:@"last_known_gps_coordinates"] description]
                                                           withTitle:[[shu valueForKey:@"description"] description]
                                                         andSubTitle:[[shu valueForKey:@"last_known_gps_datetime"] description] ];
                
                if ( point == NULL ) {
                    [shuMapAnnotations addObject: [NSNull null] ];
                } else {
                    [shuMapAnnotations addObject: point ];
                }
                
                [shus addObject:shu];
                int shu_index = [shus count] - 1;

                NSLog( @"SHUBaccaConnection: Found SHU %i stored at index %i", shu_id, shu_index );
                
                //dispatch_async( dispatch_queue_create( "com.shubacca.api.bgqueue_menu", NULL ), ^(void) {
                //    [self fetchConfigForShu:[[shu valueForKey:@"id"] description]];
                    [delegate foundSHUWithID:shu_id atIndex:shu_index];
                //});
                
            }
        }
    }
    
}

- (void)fetchConfigForShu:(NSString *)shu_id {
    NSError * error = Nil;
    
    NSLog( @"SHUBaccaConnection: Fetching Config" );
    
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:shubaccaGetConfigForIDUrl(shu_id)]];
    
    if ( data == nil ) {
        NSLog( @"SHUBaccaConnection: Failed to get Config" );
    } else {
        NSArray * configArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        
        if ( error != Nil ) {
            NSLog( @"SHUBaccaConnection: There was an error trying to retrieve the SHU JSON from the server" );
        } else {
            NSLog( @"SHUBaccaConnection: Retrieved Config from the server: %i fields to analyze", [configArray count] );
            
            
            [shuConfigs addObject:[[NSMutableDictionary alloc] initWithDictionary:[configArray objectAtIndex:0]]];
            
        }
    }
    
}


- (void)fetchedIDs:(NSData *)responseData {

    NSError * error = Nil;
    
    NSArray * shuArray = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:&error];
    
    if ( error != Nil ) {
        NSLog( @"SHUBaccaConnection: There was an error trying to retrieve the stuff from the server" );
    } else {
        
        if ( shuMapAnnotations == Nil )
            shuMapAnnotations = [[NSMutableArray alloc] init];
        
        [shuMapAnnotations removeAllObjects];

        if ( shuAllMapAnnotations == Nil )
            shuAllMapAnnotations = [[NSMutableArray alloc] init];
        
        [shuMapAnnotations removeAllObjects];
        
        if ( shuConfigs == Nil )
            shuConfigs = [[NSMutableArray alloc] init];
        
        [shuConfigs removeAllObjects];

        if ( shuStatuses == Nil )
            shuStatuses = [[NSMutableArray alloc] init];
        
        [shuStatuses removeAllObjects];
        
        if ( shus == Nil )
            shus = [[NSMutableArray alloc] init];
        
        [shus removeAllObjects];
        
        if ( shuRouteOverlays == Nil )
            shuRouteOverlays = [[NSMutableArray alloc] init];
        
        [shuRouteOverlays removeAllObjects];
        
        [delegate updating];
        
        NSLog( @"SHUBaccaConnection: Cleared all buffers" );
        NSLog( @"SHUBaccaConnection: %i shus to analyze", [shuArray count] );

        for( NSDictionary * shu in shuArray ) {
            
            //if ( [[[shu valueForKey:@"virtual"] description] isEqual:@"0"] ) {
            
            NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:shubaccaGetConfigForIDUrl([[shu valueForKey:@"id"] description])]];

            if ( data != nil ) {
            
                NSArray * configForShu = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
                
                NSLog( @"SHUBaccaConnection: For shu %@ found %i config", [[shu valueForKey:@"id"] description], [configForShu count] );
            
                if ( error != Nil && [configForShu count] == 1 ) {
                    
                    NSLog( @"SHUBaccaConnection: There was an error trying to retrieve statuses for SHU %i", [[[shu valueForKey:@"id"] description] integerValue] );
                    
                    [shuConfigs addObject:nil];
                    
                } else {

                    [shus addObject:shu];
                    [shuConfigs addObject:configForShu[0]];
                    
                    //NSLog( @"SHUBaccaConnection: Added %@ to shus", [shu description] );
                    //NSLog( @"SHUBaccaConnection: Added %@ to shuConfigs", [configForShu[0] description] );
                
                    data = [NSData dataWithContentsOfURL:[NSURL URLWithString:shubaccaGetStatusesForIDUrl([[shu valueForKey:@"id"] description], @"status")]];
                    
                    if ( data != nil ) {
                    
                        NSArray * statusesForShu = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
                        
                        NSLog( @"SHUBaccaConnection: For shu %@ found %i statuses", [[shu valueForKey:@"id"] description], [statusesForShu count] );
                        
                        if ( error != Nil ) {
                            
                            NSLog( @"SHUBaccaConnection: There was an error trying to retrieve statuses for SHU %i", [[[shu valueForKey:@"id"] description] integerValue] );
                            
                            [shuStatuses addObject:nil];
                        
                        } else {
                            
                            [shuStatuses addObject:[[NSArray alloc] initWithArray:statusesForShu]];
                            
                            NSMutableArray * allStatusGPSPointsForCurrentShu = [[NSMutableArray alloc] init];
                            
                            for( NSDictionary * statuses in statusesForShu ) {
                                
                                if ( [statuses valueForKey:@"gps"] != [NSNull null] ) {
                                    
                                    NSLog( @"SHUBaccaConnection: For shu %@ parsing gps coords", [[shu valueForKey:@"id"] description] );
                                    //NSLog(@"Fix = %@", [[[statuses valueForKey:@"gps"] valueForKey:@"fix"] description] );
                                    
                                    if ( [[[[statuses valueForKey:@"gps"] valueForKey:@"fix"] description] integerValue] > 1 ) {
                                        
                                        //NSLog(@"Status id %i for SHU %i", [[[statuses valueForKey:@"id"] description] integerValue], [[[shu valueForKey:@"id"] description] integerValue]);

                                        NSDictionary * tempGPSDictionary = [statuses valueForKey:@"gps"];
                                        
                                        CLLocationCoordinate2D point = CLLocationCoordinate2DMake([[[tempGPSDictionary valueForKey:@"latitude"] description] floatValue], [[[tempGPSDictionary valueForKey:@"longitude"] description] floatValue]);
                                        
                                        MKPointAnnotation * tempPointAnnotation = [[MKPointAnnotation alloc] init];
                                        tempPointAnnotation.coordinate = point;
                                        
                                        [allStatusGPSPointsForCurrentShu addObject:tempPointAnnotation];
                                    }
                                }
                                
                            }
                            
                            if ( allStatusGPSPointsForCurrentShu.count > 1 ) {
                            
                                NSLog( @"SHUBaccaConnection: allStatusGPSPointsForCurrentShu.count > 1" );
                                
                                CLLocationCoordinate2D * coordinates = malloc( sizeof( CLLocationCoordinate2D ) * allStatusGPSPointsForCurrentShu.count );
                                //CLLocationCoordinate2D coordinates[ [allStatusGPSPointsForCurrentShu count] ];
                            
                                for ( int i = 0; i < allStatusGPSPointsForCurrentShu.count; i ++ ) {
                                    coordinates[ i ] = [(MKPointAnnotation *)[allStatusGPSPointsForCurrentShu objectAtIndex:i] coordinate];
                                }
                            
                                MKPolyline * routeLine = [MKPolyline polylineWithCoordinates:coordinates count:[allStatusGPSPointsForCurrentShu count]];
                                [shuRouteOverlays addObject:routeLine];
                                free( coordinates );
                                //NSLog(@"Added route for SHU %i for route of %i points", [[[shu valueForKey:@"id"] description] integerValue], [allStatusGPSPointsForCurrentShu count]);
                            }
                            
                        }
                        
                        NSLog( @"SHUBaccaConnection: For shu %@ creating an annotation", [[shu valueForKey:@"id"] description] );
                        
                        CLLocationCoordinate2D zoomLocation;
                        NSString * coords = [[shu valueForKey:@"last_known_gps_coordinates"] description];
                        
                        NSLog( @"SHUBaccaConnection: For shu %@ This should not show", [[shu valueForKey:@"id"] description] );
                        
                        if ( ! [coords isEqual:@"<null>"] ) {
                            
                            NSArray * strings = [coords componentsSeparatedByString:@","];
                            zoomLocation.latitude = [(NSNumber *)[strings objectAtIndex:0] floatValue];
                            zoomLocation.longitude= [(NSNumber *)[strings objectAtIndex:1] floatValue];
                            
                            MKPointAnnotation * point = [[MKPointAnnotation alloc] init];
                            point.coordinate = zoomLocation;
                            point.title = [shu valueForKey:@"description"];
                            
                            point.subtitle = [Utils intervalInSecsAgo:[[shu valueForKey:@"last_known_gps_datetime"] description]];
                            
                            [shuAllMapAnnotations addObject:point];

                            if ( [[[shu valueForKey:@"virtual"] description] isEqual:@"0"] )
                                [shuMapAnnotations addObject:point];
                            
                        }
                        
                        NSLog( @"SHUBaccaConnection: For shu %@ done", [[shu valueForKey:@"id"] description] );
                    }
                //}
                //break;
                
                }
            }
        }
        
//        [map removeAnnotations:[map annotations]];
//        [map addOverlays:_routeOverlays];
//        [map showAnnotations:annotations animated:YES];
        
    }
//    activityView.hidden = true;
//    [delegate doneUpdating];
}

@end
