//
//  TravelTime.h
//  MetroBarrierFree
//
//  Created by yuta on 2014/10/17.
//  Copyright (c) 2014年 501Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Line;

@interface TravelTime : NSManagedObject

@property (nonatomic, retain) NSString * fromStation;
@property (nonatomic, retain) NSNumber * necessaryTime;
@property (nonatomic, retain) NSString * toStation;
@property (nonatomic, retain) NSString * trainType;
@property (nonatomic, retain) Line *line;

@end
