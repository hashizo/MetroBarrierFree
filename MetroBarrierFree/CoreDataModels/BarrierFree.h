//
//  BarrierFree.h
//  MetroBarrierFree
//
//  Created by yuta on 2014/10/17.
//  Copyright (c) 2014年 501Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Facility, Platform, ServiceDetail, ToiletAssistance;

@interface BarrierFree : NSManagedObject

@property (nonatomic, retain) NSString * available;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * locatedArea;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * placeName;
@property (nonatomic, retain) NSString * remark;
@property (nonatomic, retain) NSString * sameAs;
@property (nonatomic, retain) NSString * ucode;
@property (nonatomic, retain) Facility *facility;
@property (nonatomic, retain) NSSet *platforms;
@property (nonatomic, retain) NSSet *serviceDetails;
@property (nonatomic, retain) NSSet *toiletAssistances;
@end

@interface BarrierFree (CoreDataGeneratedAccessors)

- (void)addPlatformsObject:(Platform *)value;
- (void)removePlatformsObject:(Platform *)value;
- (void)addPlatforms:(NSSet *)values;
- (void)removePlatforms:(NSSet *)values;

- (void)addServiceDetailsObject:(ServiceDetail *)value;
- (void)removeServiceDetailsObject:(ServiceDetail *)value;
- (void)addServiceDetails:(NSSet *)values;
- (void)removeServiceDetails:(NSSet *)values;

- (void)addToiletAssistancesObject:(ToiletAssistance *)value;
- (void)removeToiletAssistancesObject:(ToiletAssistance *)value;
- (void)addToiletAssistances:(NSSet *)values;
- (void)removeToiletAssistances:(NSSet *)values;

@end
