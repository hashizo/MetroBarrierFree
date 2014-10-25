//
//  Line.h
//  MetroBarrierFree
//
//  Created by yuta on 2014/10/17.
//  Copyright (c) 2014年 501Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Station, StationOrder, Transfer, TravelTime, WomenCar;

@interface Line : NSManagedObject

@property (nonatomic, retain) NSString * code;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * operate;
@property (nonatomic, retain) NSString * sameAs;
@property (nonatomic, retain) NSString * ucode;
@property (nonatomic, retain) NSSet *stationOrders;
@property (nonatomic, retain) NSSet *stations;
@property (nonatomic, retain) NSSet *transfers;
@property (nonatomic, retain) NSSet *travelTimes;
@property (nonatomic, retain) NSSet *womenCars;
@end

@interface Line (CoreDataGeneratedAccessors)

- (void)addStationOrdersObject:(StationOrder *)value;
- (void)removeStationOrdersObject:(StationOrder *)value;
- (void)addStationOrders:(NSSet *)values;
- (void)removeStationOrders:(NSSet *)values;

- (void)addStationsObject:(Station *)value;
- (void)removeStationsObject:(Station *)value;
- (void)addStations:(NSSet *)values;
- (void)removeStations:(NSSet *)values;

- (void)addTransfersObject:(Transfer *)value;
- (void)removeTransfersObject:(Transfer *)value;
- (void)addTransfers:(NSSet *)values;
- (void)removeTransfers:(NSSet *)values;

- (void)addTravelTimesObject:(TravelTime *)value;
- (void)removeTravelTimesObject:(TravelTime *)value;
- (void)addTravelTimes:(NSSet *)values;
- (void)removeTravelTimes:(NSSet *)values;

- (void)addWomenCarsObject:(WomenCar *)value;
- (void)removeWomenCarsObject:(WomenCar *)value;
- (void)addWomenCars:(NSSet *)values;
- (void)removeWomenCars:(NSSet *)values;

@end
