//
//  ServiceDetail.h
//  MetroBarrierFree
//
//  Created by yuta on 2014/10/17.
//  Copyright (c) 2014年 501Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BarrierFree;

@interface ServiceDetail : NSManagedObject

@property (nonatomic, retain) NSString * direction;
@property (nonatomic, retain) NSString * endTime;
@property (nonatomic, retain) NSString * operationDay;
@property (nonatomic, retain) NSString * startTime;
@property (nonatomic, retain) BarrierFree *barrierFree;

@end
