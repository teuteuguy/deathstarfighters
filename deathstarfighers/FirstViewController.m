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
    dispatch_async(shubaccaQueue1, ^{
        NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:shubaccaGetIDsUrl]];
        [self performSelectorOnMainThread:@selector(fetchedIDs:) withObject:data waitUntilDone:YES];
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillAppear:(BOOL)animated {
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
            
            MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
            point.coordinate = zoomLocation;
            point.title = [object valueForKey:@"description"];
            point.subtitle = [object valueForKey:@"last_known_gps_datetime"];
            
            [map addAnnotation:point];
            
            [annotations addObject:point];
            
        }
        [map showAnnotations:annotations animated:YES];
    }
}



@end
