//
//  SHUBaccaConnection.h
//  deathstarfighers
//
//  Created by Timothee Cruse on 08/02/14.
//  Copyright (c) 2014 TC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHUBaccaConnection : NSObject {
    NSString        * TAG;
    NSMutableArray  * shu_status;
}

@property (nonatomic, retain) NSString          * TAG;
@property (nonatomic, retain) NSMutableArray    * shu_status;

+ (id)sharedSHUBaccaConnection;

- (void)update;

@end