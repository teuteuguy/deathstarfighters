//
//  FirstViewController.m
//  deathstarfighers
//
//  Created by Timothee Cruse on 08/02/14.
//  Copyright (c) 2014 TC. All rights reserved.
//

#import "FirstViewController.h"
#import "SHUBaccaConnection.h"
#import "Utils.h"

#define METERS_PER_MILE 1609.344


#define shubaccaQueue1 dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0 ) //1
#define shubaccaGetIDsUrl @"http://api.shubacca.com/shu?consumer_key=4a8e628392a504eb746c37e1b0044f0f&sort=id,desc" //2
#define shubaccaGetStatusesForIDUrl(shu,type) [NSString stringWithFormat:@"http://api.shubacca.com/shu/%@/%@?consumer_key=4a8e628392a504eb746c37e1b0044f0f&sort=id,desc&limit=10", shu, [type lowercaseString]] //2

@interface FirstViewController ()

@end

@implementation FirstViewController

@synthesize annotations;
@synthesize activityView;
@synthesize map;
@synthesize mappoints;

@synthesize updateTimer;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillAppear:(BOOL)animated {
    
    [[SHUBaccaConnection sharedSHUBaccaConnection] setDelegate:self];
    
    [[SHUBaccaConnection sharedSHUBaccaConnection] update];
}

- (void)updating {
    activityView.hidden = false;
    
    if ( annotations == nil )
        annotations = [[NSMutableArray alloc] init];
    [annotations removeAllObjects];
    
//    [map removeAnnotations:[map annotations]];
    
}

- (void)foundSHUWithID:(NSInteger)id atIndex:(NSInteger)index {
    
    MKPointAnnotation * point = [[[SHUBaccaConnection sharedSHUBaccaConnection] shuMapAnnotations] objectAtIndex:index];
    
    if ( [point isEqual:[NSNull null]] ) {
        
    } else {
        
        if ( [[[[[[SHUBaccaConnection sharedSHUBaccaConnection] shus] objectAtIndex:index] valueForKey:@"virtual"] description] isEqual:@"0"] ) {
            [annotations addObject:point];
            
//            [map addAnnotation: point];
//            [map showAnnotations:[map annotations] animated:YES];
            
        }
    }
    
}

- (void)timerTicked:(NSTimer*)timer {
    NSLog( @"Map: Timer" );
    [[SHUBaccaConnection sharedSHUBaccaConnection] update];
}


- (void)doneUpdating {
    //[map removeOverlays:[[SHUBaccaConnection sharedSHUBaccaConnection] shuRouteOverlays]];
    //[[SHUBaccaConnection sharedSHUBaccaConnection] setDelegate:self];
    //[map removeAnnotations:[map annotations]];
    //NSArray * routeOverlays = [[SHUBaccaConnection sharedSHUBaccaConnection] shuRouteOverlays];
    //NSArray * annotations = [[SHUBaccaConnection sharedSHUBaccaConnection] shuMapAnnotations];
    //[map addOverlays:routeOverlays];
    //[map showAnnotations:annotations animated:YES];
    
    [map removeAnnotations:[map annotations]];
    [map showAnnotations:annotations animated:YES];
    
    NSLog(@"Map Done Updating");
    activityView.hidden = true;
    
    updateTimer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(timerTicked:) userInfo:nil repeats:NO];
}

//- (void)fetchedIDs:(NSData *)responseData {
//    //parse out the json data
//    NSError * error;
//    
//    NSArray * shuArray = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:&error];
//    
//    if ( error != Nil ) {
//        NSLog( @"Could not make connection with server" );
//    } else {
//        
//        NSMutableArray * annotations = [[NSMutableArray alloc] init];
//        
//        for( NSDictionary * shu in shuArray ) {
//            
//            if ( [[[shu valueForKey:@"virtual"] description] isEqual:@"0"] ) {
//            
//                NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:shubaccaGetStatusesForIDUrl((NSString *)[shu valueForKey:@"id"], @"status")]];
//                NSArray * statusesForShu = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
//                
//                if ( error != Nil ) {
//                    NSLog( @"Could not make connection with server" );
//                } else {
//                    
//                    NSMutableArray * allPointsForCurrentShu = [[NSMutableArray alloc] init];
//                    
//                    for( NSDictionary * statuses in statusesForShu ) {
//                        
//                        if ( ! [[[statuses valueForKey:@"gps"] description] isEqual:[NSNull null]] ) {
//                            if ( ! [[[[statuses valueForKey:@"gps"] valueForKey:@"fix"] description] isEqual:[NSNull null]] ) {
//                                
//                                NSDictionary * tempDictionary = [statuses valueForKey:@"gps"];
//                                
//                                CLLocationCoordinate2D point = CLLocationCoordinate2DMake([[[tempDictionary valueForKey:@"latitude"] description] floatValue], [[[tempDictionary valueForKey:@"longitude"] description] floatValue]);
//                                
//                                MKPointAnnotation * temp = [[MKPointAnnotation alloc] init];
//                                temp.coordinate = point;
//                                
//                                [allPointsForCurrentShu addObject:temp];
//                            }
//                        }
//                    }
//                    
//                    
//                    CLLocationCoordinate2D coordinates[ [allPointsForCurrentShu count] ];
//                    
//                    for ( int i = 0; i < [allPointsForCurrentShu count]; i ++ ) {
//                        coordinates[ i ] = [(MKPointAnnotation *)[allPointsForCurrentShu objectAtIndex:i] coordinate];
//                    }
//                    
//                    MKPolyline * routeLine = [MKPolyline polylineWithCoordinates:coordinates count:[allPointsForCurrentShu count]];
//                    
//                    [_routeOverlays addObject:routeLine];
//                    
//                }
//                
//                CLLocationCoordinate2D zoomLocation;
//                NSString * coords = (NSString *)[shu valueForKey:@"last_known_gps_coordinates"];
//            
//                if ( ! [coords isEqual:[NSNull null]] ) {
//            
//                    NSArray * strings = [coords componentsSeparatedByString:@","];
//                    zoomLocation.latitude = [(NSNumber *)[strings objectAtIndex:0] floatValue];
//                    zoomLocation.longitude= [(NSNumber *)[strings objectAtIndex:1] floatValue];
//            
//                    MKPointAnnotation * point = [[MKPointAnnotation alloc] init];
//                    point.coordinate = zoomLocation;
//                    point.title = [shu valueForKey:@"description"];
//            
//                    point.subtitle = [Utils intervalInSecsAgo:[shu valueForKey:@"last_known_gps_datetime"]];
//                    
//                    [annotations addObject:point];
//                    
//                }
//            }
//            
//        }
//        
//        [map removeAnnotations:[map annotations]];
//        [map addOverlays:_routeOverlays];
//        [map showAnnotations:annotations animated:YES];
//
//    }
//    activityView.hidden = true;
//
//}


- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id)overlay {
    MKPolylineRenderer * renderer = [[MKPolylineRenderer alloc] initWithPolyline:overlay];
    renderer.strokeColor = [UIColor redColor];
    renderer.lineWidth = 4.0;
    return  renderer;
}


- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
//    if (view.annotation == self.customAnnotation) {
//        if (self.calloutAnnotation == nil) {
//            self.calloutAnnotation = [[CalloutMapAnnotation alloc] initWithLatitude:view.annotation.coordinate.latitude
//                                                                       andLongitude:view.annotation.coordinate.longitude];
//        } else {
//            self.calloutAnnotation.latitude = view.annotation.coordinate.latitude;
//            self.calloutAnnotation.longitude = view.annotation.coordinate.longitude;
//        }
//        [self.mapView addAnnotation:self.calloutAnnotation];
//        self.selectedAnnotationView = view;
//    }
}
- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
//    if (self.calloutAnnotation && view.annotation == self.customAnnotation) {
//        [self.mapView removeAnnotation: self.calloutAnnotation];
//    }
}


//-(MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
//    MKPinAnnotationView *MyPin=[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"current"];
//    //MyPin.pinColor = MKPinAnnotationColorPurple;
//    
//    UIButton *advertButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
//    [advertButton addTarget:self action:@selector(button:) forControlEvents:UIControlEventTouchUpInside];
//    
//    /*MyPin.rightCalloutAccessoryView = advertButton;
//     MyPin.draggable = YES;
//     
//     MyPin.animatesDrop=TRUE;
//     MyPin.canShowCallout = YES;*/
//    MyPin.highlighted = NO;
//    MyPin.image = [UIImage imageNamed:@"myCustomPinImage"];
//    
//    return MyPin;
//}

- (void)annotationButton:(id)sender {
    
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    //MKPinAnnotationView * mypin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"current"];
    //mypin.pinColor = MKPinAnnotationColorRed;
    
    //UIButton * advertButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    //[advertButton addTarget:self action:@selector(annotationButton:) forControlEvents:UIControlEventTouchUpInside];
    //mypin.rightCalloutAccessoryView = advertButton;
    
    //mypin.animatesDrop = TRUE;
    //mypin.canShowCallout = YES;
    //mypin.highlighted = NO;
//    mypin.image
    MKAnnotationView * mypin = (MKAnnotationView *)[map dequeueReusableAnnotationViewWithIdentifier:@"current"];
    if ( mypin == nil ) {
        
        mypin = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"current"];
        //mypin = [[MKAnnotationView alloc] initWithFrame:CGRectMake(0, 0, 25, 10)];
        mypin.frame = CGRectMake(0, 0, 50, 25);
        
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 25)];
        imageView.tag = 1;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.clipsToBounds = YES;
        imageView.image = [UIImage imageNamed:@"blue_car_103.png"];
        
        [mypin addSubview:imageView];
        
//        UIProgressView * progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 25, 50, 5)];
//        progressView.tag = 2;
//        progressView.progress = 0;
//        progressView.progressTintColor = [UIColor redColor];
//        
//        [mypin addSubview:progressView];
        
        mypin.canShowCallout = YES;
        
    }
    
//    NSArray * strings = [[annotation title] componentsSeparatedByString:@": "];
//    //MKPointAnnotation * temp = (MKPointAnnotation *)annotation;
//    //float progress = 0;
//    //((UIProgressView *)[mypin viewWithTag:2]).progress = progress;
//    ((UIProgressView *)[mypin viewWithTag:2]).hidden = YES;
//    
//    if ( strings.count == 2 ) {
//        //temp.title = [strings objectAtIndex:0];
//        //progress = [(NSNumber *)[strings objectAtIndex:1] floatValue] / 100;
//        
//        dispatch_async( dispatch_queue_create( "com.shubacca.api.bgqueue_status_for_map", NULL ), ^(void) {
//            
//            NSArray * tempArray = [[SHUBaccaConnection sharedSHUBaccaConnection] fetchLastStatusForId:[[strings objectAtIndex:0] integerValue]];
//            
//            if ( tempArray != nil ) {
//                
//                NSLog(@"Map: viewForAnnotation: found last status update for SHU %@", [strings objectAtIndex:0]);
//
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    float progress = [[[[tempArray objectAtIndex:0] valueForKey:@"fuel_battery_state"] description] floatValue];
//                    ((UIProgressView *)[mypin viewWithTag:2]).progress = progress / 100;
//                    if ( progress < 50 ) {
//                        ((UIProgressView *)[mypin viewWithTag:2]).progressTintColor = [UIColor redColor];
//                        ((UIProgressView *)[mypin viewWithTag:2]).hidden = NO;
////                    } else {
////                        ((UIProgressView *)[mypin viewWithTag:2]).tintColor = [UIColor greenColor];
//                    }
//                });
//                
//                //point.subtitle = [point.subtitle stringByAppendingString:[NSString stringWithFormat:@";%f", [[[[tempArray objectAtIndex:0] valueForKey:@"fuel_battery_state"] description] floatValue]]];
//            }
//            
//        });
//    }
    
    
    
    mypin.annotation = annotation;
    
    return mypin;
    
//    if (annotation == self.calloutAnnotation) {
//        CalloutMapAnnotationView *calloutMapAnnotationView = (CalloutMapAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:@"CalloutAnnotation"];
//        if (!calloutMapAnnotationView) {
//            calloutMapAnnotationView = [[[CalloutMapAnnotationView alloc] initWithAnnotation:annotation
//                                                                             reuseIdentifier:@"CalloutAnnotation"] autorelease];
//        }
//        calloutMapAnnotationView.parentAnnotationView = self.selectedAnnotationView;
//        calloutMapAnnotationView.mapView = self.mapView;
//        return calloutMapAnnotationView;
//    } else if (annotation == self.customAnnotation) {
//        MKPinAnnotationView *annotationView = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation
//                                                                               reuseIdentifier:@"CustomAnnotation"] autorelease];
//        annotationView.canShowCallout = NO;
//        annotationView.pinColor = MKPinAnnotationColorGreen;
//        return annotationView;
//    } else if (annotation == self.normalAnnotation) {
//        MKPinAnnotationView *annotationView = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation
//                                                                               reuseIdentifier:@"NormalAnnotation"] autorelease];
//        annotationView.canShowCallout = YES;
//        annotationView.pinColor = MKPinAnnotationColorPurple;
//        return annotationView;
//    }
    
    return nil;
}


@end
