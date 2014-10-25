//
//  WomenCar.h
//  MetroBarrierFree
//
//  Created by yuta on 2014/10/17.
//  Copyright (c) 2014年 501Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Line;

@interface WomenCar : NSManagedObject

@property (nonatomic, retain) NSNumber * carComposition;
@property (nonatomic, retain) NSNumber * carNumber;
@property (nonatomic, retain) NSString * fromStation;
@property (nonatomic, retain) NSString * operationDay;
@property (nonatomic, retain) NSString * startTime;
@property (nonatomic, retain) NSString * toStation;
@property (nonatomic, retain) NSString * untilTime;
@property (nonatomic, retain) Line *line;

@end
