//
//  AccessMetroDataTests.m
//  MetroBarrierFree
//
//  Created by yuta on 2014/10/23.
//  Copyright (c) 2014年 501Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "AccessMetroData.h"

#import "Line.h"
#import "Station.h"
#import "Gate.h"
#import "ToiletAssistance.h"
#import "BarrierFree.h"
#import "Facility.h"
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



@interface AccessMetroDataTests : XCTestCase
@property (nonatomic) AccessMetroData *accessMetroData;
@end

@implementation AccessMetroDataTests

- (void)setUp {
    [super setUp];
	self.accessMetroData = [[AccessMetroData alloc] init];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

//-----------------------------------------------------------------------------------------------------------
// 路線取得テスト
//
// @param										なし
//
// @return			(void)						なし
//-----------------------------------------------------------------------------------------------------------
- (void)testGetLine
{
	NSArray *lines = [_accessMetroData getLine];
	XCTAssertNotNil(lines, @"データ取得失敗");
	for (NSDictionary *line in lines) {
		NSLog(@"取得した路線名 = %@",[line valueForKey:self.accessMetroData.lineName.name]);
	}
}

@end
