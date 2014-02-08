//
//  SHUBaccaConnection.m
//  deathstarfighers
//
//  Created by Timothee Cruse on 08/02/14.
//  Copyright (c) 2014 TC. All rights reserved.
//

#import "SHUBaccaConnection.h"


#define shubaccaQueue dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0 ) //1
#define shubaccaGetIDsUrl [NSURL URLWithString:@"http://api.shubacca.com/shu?consumer_key=4a8e628392a504eb746c37e1b0044f0f&fields=id&sort=id,asc"] //2


@implementation SHUBaccaConnection

@synthesize TAG;
@synthesize shu_status;

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
        TAG = @"SHUBacca Connection";
    }
    return self;
}

- (void)dealloc {
    // Should never be called, but just here for clarity really.
}

- (void)getShubaccaIds {
    // http://api.shubacca.com/shu?consumer_key=4a8e628392a504eb746c37e1b0044f0f&sort=id%2Cdesc&fields=id
    [self callShubaccaWithUrl:shubaccaGetIDsUrl
                   andPerform:@selector(fetchedIDs:) ];
    
}

- (void)update {
    NSLog( @"Updating connection" );
    // Create the request.
    [self getShubaccaIds];
}

- (void)callShubaccaWithUrl:(NSURL *)url andPerform:(SEL)aSelector  {
    
    dispatch_async(shubaccaQueue, ^{
        NSData* data = [NSData dataWithContentsOfURL:url];
        [self performSelectorOnMainThread:aSelector withObject:data waitUntilDone:YES];
    });
    
}

- (void)fetchedIDs:(NSData *)responseData {
    //parse out the json data
    NSError * error;
    
    NSArray * responseArray = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:&error];
    
    if ( error != Nil ) {
        NSLog( @"Could not make connection with server" );
    } else {

        if ( shu_status == Nil ) {
            shu_status = [[NSMutableArray alloc] init];
        }
        [shu_status removeAllObjects];
        
        for( NSArray * object in responseArray ) {
            
            NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.shubacca.com/shu/%@/status?consumer_key=4a8e628392a504eb746c37e1b0044f0f&sort=id,desc&limit=2", [object valueForKey:@"id"]]];
            
            NSData* data = [NSData dataWithContentsOfURL:url];
            NSArray * statusArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            
            if ( error != Nil ) {
                NSLog( @"Could not make status connection with server" );
            } else {
                
                NSMutableDictionary * dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                              [object valueForKey:@"id"], @"id",
                                              [[NSArray alloc] initWithArray:statusArray], @"array", nil];
                [shu_status addObject:dict];
                
            }
            
        }
        
        //NSLog( shu_status.description );
        
//        for( NSArray * object in [shu_status valueForKey:@"shu_id"]) {
//            NSLog(object.description);
//        }
        
    }
}


@end
