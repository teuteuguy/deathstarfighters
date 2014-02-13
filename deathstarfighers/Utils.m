//
//  Utils.m
//  deathstarfighers
//
//  Created by Timothee Cruse on 10/02/14.
//  Copyright (c) 2014 TC. All rights reserved.
//

#import "Utils.h"

@implementation Utils

+ (NSString *)intervalInSecsAgo:(NSString *)stringDate {
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"SGT"]];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    if ( ! [stringDate isEqual:[NSNull null]] ) {
        NSDate * now = [NSDate date];
        //NSLog([stringDate description]);
        NSDate * then = [formatter dateFromString: stringDate];
        
        int interval = (int)[now timeIntervalSinceDate:then];

        if ( interval < 60 ) {
            return [NSString stringWithFormat:@"%.02is ago", interval];
        } else if ( interval < 60 * 60 ) {
            return [NSString stringWithFormat:@"%.02im:%.02i ago", (int)(interval / 60), (interval % 60) ];
        } else if ( interval < 60 * 60 * 24 ) {
            return [NSString stringWithFormat:@"%.02i:%.02i:%.02i ago", (int)(interval / 3600), (int)((interval % 3600) / 60), (interval % 60) ];
        } else {
            return [NSString stringWithFormat:@"%id %.02i:%.02i:%.02i ago", (int)(interval / (3600 * 24)), (int)((interval % (3600 * 24)) / 3600), (int)((interval % 3600) / 60), (interval % 60) ];
        }        
    }
    return [NSString stringWithFormat:@"Error"];
}

@end
