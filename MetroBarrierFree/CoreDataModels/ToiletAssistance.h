//
//  ToiletAssistance.h
//  MetroBarrierFree
//
//  Created by yuta on 2014/10/17.
//  Copyright (c) 2014年 501Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BarrierFree;

@interface ToiletAssistance : NSManagedObject

@property (nonatomic, retain) NSString * code;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *barrierFrees;
@end

@interface ToiletAssistance (CoreDataGeneratedAccessors)

- (void)addBarrierFreesObject:(BarrierFree *)value;
- (void)removeBarrierFreesObject:(BarrierFree *)value;
- (void)addBarrierFrees:(NSSet *)values;
- (void)removeBarrierFrees:(NSSet *)values;

@end
