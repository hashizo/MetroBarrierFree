//
//  Platform.h
//  MetroBarrierFree
//
//  Created by yuta on 2014/10/17.
//  Copyright (c) 2014年 501Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BarrierFree, Facility, Surrounding, Transfer;

@interface Platform : NSManagedObject

@property (nonatomic, retain) NSNumber * carComposition;
@property (nonatomic, retain) NSNumber * carNumber;
@property (nonatomic, retain) NSString * railDirection;
@property (nonatomic, retain) NSSet *barrierFrees;
@property (nonatomic, retain) Facility *facility;
@property (nonatomic, retain) NSSet *surrounds;
@property (nonatomic, retain) NSSet *transfers;
@end

@interface Platform (CoreDataGeneratedAccessors)

- (void)addBarrierFreesObject:(BarrierFree *)value;
- (void)removeBarrierFreesObject:(BarrierFree *)value;
- (void)addBarrierFrees:(NSSet *)values;
- (void)removeBarrierFrees:(NSSet *)values;

- (void)addSurroundsObject:(Surrounding *)value;
- (void)removeSurroundsObject:(Surrounding *)value;
- (void)addSurrounds:(NSSet *)values;
- (void)removeSurrounds:(NSSet *)values;

- (void)addTransfersObject:(Transfer *)value;
- (void)removeTransfersObject:(Transfer *)value;
- (void)addTransfers:(NSSet *)values;
- (void)removeTransfers:(NSSet *)values;

@end
