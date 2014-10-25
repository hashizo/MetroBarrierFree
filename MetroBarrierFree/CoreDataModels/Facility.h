//
//  Facility.h
//  MetroBarrierFree
//
//  Created by yuta on 2014/10/17.
//  Copyright (c) 2014年 501Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BarrierFree, Platform, Station;

@interface Facility : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * sameAs;
@property (nonatomic, retain) NSString * ucode;
@property (nonatomic, retain) NSSet *barrierFrees;
@property (nonatomic, retain) NSSet *platforms;
@property (nonatomic, retain) Station *station;
@end

@interface Facility (CoreDataGeneratedAccessors)

- (void)addBarrierFreesObject:(BarrierFree *)value;
- (void)removeBarrierFreesObject:(BarrierFree *)value;
- (void)addBarrierFrees:(NSSet *)values;
- (void)removeBarrierFrees:(NSSet *)values;

- (void)addPlatformsObject:(Platform *)value;
- (void)removePlatformsObject:(Platform *)value;
- (void)addPlatforms:(NSSet *)values;
- (void)removePlatforms:(NSSet *)values;

@end
