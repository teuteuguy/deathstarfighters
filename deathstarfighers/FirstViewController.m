//
//  FirstViewController.m
//  deathstarfighers
//
//  Created by Timothee Cruse on 08/02/14.
//  Copyright (c) 2014 TC. All rights reserved.
//

#import "FirstViewController.h"

#define METERS_PER_MILE 1609.344


#define shubaccaQueue1 dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0 ) //1
#define shubaccaGetIDsUrl @"http://api.shubacca.com/shu?consumer_key=4a8e628392a504eb746c37e1b0044f0f&sort=id,desc" //2
#define shubaccaGetStatusesForIDUrl(shu,type) [NSString stringWithFormat:@"http://api.shubacca.com/shu/%@/%@?consumer_key=4a8e628392a504eb746c37e1b0044f0f&sort=id,desc&limit=1", shu, [type lowercaseString]] //2

@interface FirstViewController ()

@end

@implementation FirstViewController

@synthesize map;

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
    dispatch_async(shubaccaQueue1, ^{
        NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:shubaccaGetIDsUrl]];
        [self performSelectorOnMainThread:@selector(fetchedIDs:) withObject:data waitUntilDone:YES];
    });
//    // 1
//    CLLocationCoordinate2D zoomLocation;
//    NSDictionary * dict = [self.itemDetail valueForKey:@"gps"];
//    int fix = [(NSNumber *)[dict valueForKey:@"fix"] integerValue];
//    if ( fix > 1 ) {
//        zoomLocation.latitude = [(NSNumber *)[dict valueForKey:@"latitude"] floatValue];
//        zoomLocation.longitude= [(NSNumber *)[dict valueForKey:@"longitude"] floatValue];
//        
//        MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
//        point.coordinate = zoomLocation;
//        point.title = [self.itemSHU valueForKey:@"description"];
//        point.subtitle = @"I'm here!!!";
//        
//        
//        // 2
//        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 1.0*METERS_PER_MILE, 1.0*METERS_PER_MILE);
//        
//        // 3
//        [map setRegion:viewRegion animated:YES];
//        [map addAnnotation:point];
//        [map selectAnnotation:point animated:NO];
//    }
}


- (void)fetchedIDs:(NSData *)responseData {
    //parse out the json data
    NSError * error;
    
    NSArray * responseArray = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:&error];
    
    if ( error != Nil ) {
        NSLog( @"Could not make connection with server" );
    } else {
        
        NSMutableArray * annotations = [[NSMutableArray alloc] init];
        
        for( NSDictionary * object in responseArray ) {
            
            CLLocationCoordinate2D zoomLocation;
            NSString * coords = (NSString *)[object valueForKey:@"last_known_gps_coordinates"];
            NSArray * strings = [coords componentsSeparatedByString:@","];
            zoomLocation.latitude = [(NSNumber *)[strings objectAtIndex:0] floatValue];
            zoomLocation.longitude= [(NSNumber *)[strings objectAtIndex:1] floatValue];
            
            MKPointAnnotation * point = [[MKPointAnnotation alloc] init];
            point.coordinate = zoomLocation;
            point.title = [object valueForKey:@"description"];
            
            NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
            [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"SGT"]];
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            int interval = (int)[[NSDate date] timeIntervalSinceDate:[formatter dateFromString: [object valueForKey:@"last_known_gps_datetime"]]];
            if ( interval < 60 ) {
                point.subtitle = [NSString stringWithFormat:@"%.02is ago", interval];
            } else if ( interval < 60 * 60 ) {
                point.subtitle = [NSString stringWithFormat:@"%.02im:%.02i ago", (int)(interval / 60), (interval % 60) ];
            } else if ( interval < 60 * 60 * 24 ) {
                point.subtitle = [NSString stringWithFormat:@"%.02i:%.02i:%.02i ago", (int)(interval / 3600), (int)((interval % 3600) / 60), (interval % 60) ];
            } else {
                point.subtitle = [NSString stringWithFormat:@"%id %.02i:%.02i:%.02i ago", (int)(interval / (3600 * 24)), (int)((interval % (3600 * 24)) / 3600), (int)((interval % 3600) / 60), (interval % 60) ];
            }
            
            
            //point.subtitle = [object valueForKey:@"last_known_gps_datetime"];
            
            //[map addAnnotation:point];
            
            [annotations addObject:point];
            
        }
        [map removeAnnotations:[map annotations]];
        [map showAnnotations:annotations animated:YES];
    }
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

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
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
