//---------------------------------------------------------------------------------------------------------------
//  CreateMetoroCoreData.h
//  CreateMetoroData
//	メトロのコアデータ作成クラス
//
//  Created by yuta on 2014/10/03.
//  Copyright (c) 2014年 501Software. All rights reserved.
//---------------------------------------------------------------------------------------------------------------
//#import <Foundation/Foundation.h>
#import "AccessCoreData.h"
#import "Line.h"
#import "Station.h"
#import "Gate.h"
#import "Facility.h"
#import "BarrierFree.h"
#import "Available.h"
#import "ServiceDetail.h"
#import "Platform.h"
#import "Direction.h"
#import "Transfer.h"
#import "Operator.h"
#import "Surrounding.h"
#import "StationOrder.h"
#import "TrainType.h"
#import "TravelTime.h"
#import "WomenCar.h"



@interface CreateMetoroCoreData : AccessCoreData

- (BOOL)createMasterToiletAssistance;
- (BOOL)createMasterAvailable;
- (BOOL)createMasterDirection;
- (BOOL)createMasterOperator;
- (BOOL)createMasterTrainType;



- (BOOL)createLineData;
- (BOOL)createStationData;
- (BOOL)createGateData;
- (BOOL)createFacilityData;


@end
