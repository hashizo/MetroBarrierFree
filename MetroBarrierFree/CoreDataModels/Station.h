//
//  Station.h
//  MetroBarrierFree
//
//  Created by yuta on 2014/10/17.
//  Copyright (c) 2014年 501Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Facility, Gate, Line;

@interface Station : NSManagedObject

@property (nonatomic, retain) NSString * code;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * lat;
@property (nonatomic, retain) NSNumber * lon;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * operator;
@property (nonatomic, retain) NSString * sameAs;
@property (nonatomic, retain) NSString * ucode;
@property (nonatomic, retain) NSSet *facilitys;
@property (nonatomic, retain) NSSet *gates;
@property (nonatomic, retain) Line *line;
@end

@interface Station (CoreDataGeneratedAccessors)

- (void)addFacilitysObject:(Facility *)value;
- (void)removeFacilitysObject:(Facility *)value;
- (void)addFacilitys:(NSSet *)values;
- (void)removeFacilitys:(NSSet *)values;

- (void)addGatesObject:(Gate *)value;
- (void)removeGatesObject:(Gate *)value;
- (void)addGates:(NSSet *)values;
- (void)removeGates:(NSSet *)values;

@end
