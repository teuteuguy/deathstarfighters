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
#define shubaccaGetIDsUrl @"http://api.shubacca.com/shu?consumer_key=4a8e628392a504eb746c37e1b0044f0f&sort=id,asc" //2
#define shubaccaGetStatusesForIDUrl(shu,type) [NSString stringWithFormat:@"http://api.shubacca.com/shu/%@/%@?consumer_key=4a8e628392a504eb746c37e1b0044f0f&sort=id,desc&limit=10", shu, [type lowercaseString]] //2

@implementation SHUBaccaConnection {
//    struct {
//        //unsigned int didFinishLoadingItem:1;
//        //unsigned int didFailWithError:1;
//        void doneUpdating;
//    } delegateRespondsTo;
}

@synthesize shus;
@synthesize shuAllMapAnnotations;
@synthesize shuMapAnnotations;
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
        //[self update];
    }
    return self;
}

- (void)setDelegate:(id <SHUBaccaConnectionDelegates>)aDelegate {
    if (delegate != aDelegate) {
        delegate = aDelegate;
        
        //delegateRespondsTo.didFinishLoadingItem = [delegate respondsToSelector:@selector(something:didFinishLoadingItem:)];
        //delegateRespondsTo.didFailWithError = [delegate respondsToSelector:@selector(something:didFailWithError:)];
    }
}

- (void)update {
    NSLog( @"Updating data" );

    dispatch_async( shubaccaQueue, ^{
        NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:shubaccaGetIDsUrl]];
        [self performSelectorOnMainThread:@selector(fetchedIDs:) withObject:data waitUntilDone:YES];
    });
}

- (void)fetchedIDs:(NSData *)responseData {

    NSError * error = Nil;
    
    NSArray * shuArray = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:&error];
    
    if ( error != Nil ) {
        NSLog( @"There was an error trying to retrieve the stuff from the server" );
    } else {
        
        if ( shuMapAnnotations == Nil )
            shuMapAnnotations = [[NSMutableArray alloc] init];
        
        [shuMapAnnotations removeAllObjects];

        if ( shuAllMapAnnotations == Nil )
            shuAllMapAnnotations = [[NSMutableArray alloc] init];
        
        [shuMapAnnotations removeAllObjects];
        
        if ( shuStatuses == Nil )
            shuStatuses = [[NSMutableArray alloc] init];
        
        [shuStatuses removeAllObjects];
        
        if ( shus == Nil )
            shus = [[NSMutableArray alloc] init];
        
        [shus removeAllObjects];
        
        if ( shuRouteOverlays == Nil )
            shuRouteOverlays = [[NSMutableArray alloc] init];
        
        [shuRouteOverlays removeAllObjects];
        
        for( NSDictionary * shu in shuArray ) {
            
            //if ( [[[shu valueForKey:@"virtual"] description] isEqual:@"0"] ) {
                
                NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:shubaccaGetStatusesForIDUrl([[shu valueForKey:@"id"] description], @"status")]];
                NSArray * statusesForShu = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
                
                if ( error != Nil ) {
                    
                    NSLog( @"There was an error trying to retrieve statuses for SHU %i", [[[shu valueForKey:@"id"] description] integerValue] );
                    
                    [shuStatuses addObject:nil];
                
                } else {
                    
                    [shus addObject:shu];
                    
                    [shuStatuses addObject:[[NSArray alloc] initWithArray:statusesForShu]];
                    
                    
                    NSMutableArray * allStatusGPSPointsForCurrentShu = [[NSMutableArray alloc] init];
                    
                    for( NSDictionary * statuses in statusesForShu ) {
                        
                        if ( [statuses valueForKey:@"gps"] != [NSNull null] ) {
                            NSLog(@"Fix = %@", [[[statuses valueForKey:@"gps"] valueForKey:@"fix"] description] );
                            if ( [[[[statuses valueForKey:@"gps"] valueForKey:@"fix"] description] integerValue] > 1 ) {
                                
                                NSLog(@"Status id %i for SHU %i", [[[statuses valueForKey:@"id"] description] integerValue], [[[shu valueForKey:@"id"] description] integerValue]);

                                NSDictionary * tempGPSDictionary = [statuses valueForKey:@"gps"];
                                
                                CLLocationCoordinate2D point = CLLocationCoordinate2DMake([[[tempGPSDictionary valueForKey:@"latitude"] description] floatValue], [[[tempGPSDictionary valueForKey:@"longitude"] description] floatValue]);
                                
                                MKPointAnnotation * tempPointAnnotation = [[MKPointAnnotation alloc] init];
                                tempPointAnnotation.coordinate = point;
                                
                                [allStatusGPSPointsForCurrentShu addObject:tempPointAnnotation];
                            }
                        }
                        
                    }
                    
                    CLLocationCoordinate2D * coordinates = malloc( sizeof( CLLocationCoordinate2D ) * allStatusGPSPointsForCurrentShu.count );
                    //CLLocationCoordinate2D coordinates[ [allStatusGPSPointsForCurrentShu count] ];
                    
                    for ( int i = 0; i < [allStatusGPSPointsForCurrentShu count]; i ++ ) {
                        coordinates[ i ] = [(MKPointAnnotation *)[allStatusGPSPointsForCurrentShu objectAtIndex:i] coordinate];
                    }
                    
                    MKPolyline * routeLine = [MKPolyline polylineWithCoordinates:coordinates count:[allStatusGPSPointsForCurrentShu count]];
                    [shuRouteOverlays addObject:routeLine];
                    free( coordinates );
                    NSLog(@"Added route for SHU %i for route of %i points", [[[shu valueForKey:@"id"] description] integerValue], [allStatusGPSPointsForCurrentShu count]);
                    
                }
                
                CLLocationCoordinate2D zoomLocation;
                NSString * coords = [[shu valueForKey:@"last_known_gps_coordinates"] description];
                
                if ( ! [coords isEqual:[NSNull null]] ) {
                    
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
            //}
            //break;
            
        }
        
//        [map removeAnnotations:[map annotations]];
//        [map addOverlays:_routeOverlays];
//        [map showAnnotations:annotations animated:YES];
        
    }
//    activityView.hidden = true;
    [delegate doneUpdating];
}

@end
