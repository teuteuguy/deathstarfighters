//
//  Utils.h
//  deathstarfighers
//
//  Created by Timothee Cruse on 10/02/14.
//  Copyright (c) 2014 TC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface Utils : NSObject

+ (NSString *)intervalInSecsAgo:(NSString *)stringDate;

+ (MKPointAnnotation *)annotationFromGPS:(NSString *)string withTitle:(NSString *)title andSubTitle:(NSString *)subtitle;

@end
