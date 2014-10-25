//
//  CheckMetoroData.m
//  CreateMetoroData
//
//  Created by yuta on 2014/10/15.
//  Copyright (c) 2014年 501Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "AccessCoreData.h"
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


@interface CheckMetoroData : XCTestCase

@end

@implementation CheckMetoroData

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

/*
- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}
*/

//-----------------------------------------------------------------------------------------------------------
// 多機能トイレマスタテスト
//
// @param										なし
//
// @return			(void)						なし
//-----------------------------------------------------------------------------------------------------------
- (void)testToiletAssitanceMaster {
	NSArray *datas = [self table:ENTITY_TOILET_ASST EntityName:@"多機能トイレマスタ"];
	for (ToiletAssistance  *data in datas) {
		NSLog(@"<<<<<<<<<<<<<<<<<<<< レコード開始 >>>>>>>>>>>>>>>>>>>>");
		NSLog(@"多機能トイレ名      = %@", data.name);
		NSLog(@"多機能トイレキー    = %@", data.code);
		NSLog(@"<<<<<<<<<<<<<<<<<<<< レコード終了 >>>>>>>>>>>>>>>>>>>>\n\n");
	}
}

//-----------------------------------------------------------------------------------------------------------
// 車いす利用可能マスタテスト
//
// @param										なし
//
// @return			(void)						なし
//-----------------------------------------------------------------------------------------------------------
- (void)testAvailableMaster {
	NSArray *datas = [self table:ENTITY_AVAILABLE EntityName:@"車いす利用可能"];
	for (ToiletAssistance  *data in datas) {
		NSLog(@"<<<<<<<<<<<<<<<<<<<< レコード開始 >>>>>>>>>>>>>>>>>>>>");
		NSLog(@"車いす利用可能      = %@", data.name);
		NSLog(@"車いす利用可能キー  = %@", data.code);
		NSLog(@"<<<<<<<<<<<<<<<<<<<< レコード終了 >>>>>>>>>>>>>>>>>>>>\n\n");
	}
}

//-----------------------------------------------------------------------------------------------------------
// 列車方面マスタテスト
//
// @param										なし
//
// @return			(void)						なし
//-----------------------------------------------------------------------------------------------------------
- (void)testDirectionMaster {
	NSArray *datas = [self table:ENTITY_DIRECTION EntityName:@"列車方面"];
	for (Direction  *data in datas) {
		NSLog(@"<<<<<<<<<<<<<<<<<<<< レコード開始 >>>>>>>>>>>>>>>>>>>>");
		NSLog(@"列車方面            = %@", data.name);
		NSLog(@"列車方面キー        = %@", data.code);
		NSLog(@"<<<<<<<<<<<<<<<<<<<< レコード終了 >>>>>>>>>>>>>>>>>>>>\n\n");
	}
}

//-----------------------------------------------------------------------------------------------------------
// 運行会社マスタテスト
//
// @param										なし
//
// @return			(void)						なし
//-----------------------------------------------------------------------------------------------------------
- (void)testOperatorMaster {
	NSArray *datas = [self table:ENTITY_OPERATOR EntityName:@"運行会社"];
	for (Operator  *data in datas) {
		NSLog(@"<<<<<<<<<<<<<<<<<<<< レコード開始 >>>>>>>>>>>>>>>>>>>>");
		NSLog(@"運行会社            = %@", data.name);
		NSLog(@"運行会社キー        = %@", data.code);
		NSLog(@"<<<<<<<<<<<<<<<<<<<< レコード終了 >>>>>>>>>>>>>>>>>>>>\n\n");
	}
}

//-----------------------------------------------------------------------------------------------------------
// 列車種別マスタテスト
//
// @param										なし
//
// @return			(void)						なし
//-----------------------------------------------------------------------------------------------------------
- (void)testTrainTypeMaster {
	NSArray *datas = [self table:ENTITY_TRAIN_TYPE EntityName:@"列車種別"];
	for (Operator  *data in datas) {
		NSLog(@"<<<<<<<<<<<<<<<<<<<< レコード開始 >>>>>>>>>>>>>>>>>>>>");
		NSLog(@"列車種別            = %@", data.name);
		NSLog(@"列車種別キー        = %@", data.code);
		NSLog(@"<<<<<<<<<<<<<<<<<<<< レコード終了 >>>>>>>>>>>>>>>>>>>>\n\n");
	}
}

//-----------------------------------------------------------------------------------------------------------
// 駅テーブルテスト
//
// @param										なし
//
// @return			(void)						なし
//-----------------------------------------------------------------------------------------------------------
- (void)testStationTable {
	AccessCoreData *accessCoreData =  [[AccessCoreData alloc] initEmptyCoreData];
	NSInteger count = [accessCoreData getDataCount:ENTITY_STATION];
	NSLog(@"駅テーブルデータ件数 = %ld", (long)count);
	XCTAssertNotEqual(count, 0, @"駅テーブルデータがない");

	NSArray *staions = [accessCoreData  getData:ENTITY_STATION Conditions:nil Sorts:nil];
	for (Station  *station in staions) {
		NSLog(@"<<<<<<<<<<<<<<<<<<<< レコード開始 >>>>>>>>>>>>>>>>>>>>");		// 区切り
		NSLog(@"駅名       = %@", station.name);								// 駅名
		NSLog(@"駅コード   = %@", station.code);								// 駅コード
		NSLog(@"路線名     = %@", station.line.name);							// 路線名
		NSLog(@"固有識別子 = %@", station.ucode);								// 固有識別子(ucode)
		NSLog(@"固有識別子 = %@", station.sameAs);								// 固有識別子
		NSLog(@"生成時刻   = %@", station.date);								// 生成時刻(ISO8601 日付時刻形式)
		NSLog(@"経度       = %@", station.lon);									// 経度
		NSLog(@"緯度       = %@", station.lat);									// 緯度
		NSLog(@"管理会社   = %@", station.operator);							// 管理会社
		for (Gate *gate in station.gates) {
			NSLog(@"出入口     = %@", gate.name);								// 出入口
		}
		NSLog(@"<<<<<<<<<<<<<<<<<<<< レコード終了 >>>>>>>>>>>>>>>>>>>>\n\n");	// 区切り
	}
	XCTAssertNotEqual([staions count], 0, @"路線テーブルデータがない");
}

//-----------------------------------------------------------------------------------------------------------
// 路線テーブルテスト
//
// @param										なし
//
// @return			(void)						なし
//-----------------------------------------------------------------------------------------------------------
- (void) testLineTable {
	AccessCoreData *accessCoreData =  [[AccessCoreData alloc] initEmptyCoreData];
	NSInteger count = [accessCoreData getDataCount:ENTITY_LINE];
	NSLog(@"路線テーブルデータ件数 = %ld", (long)count);
	XCTAssertNotEqual(count, 0, @"路線テーブルデータがない");

	NSArray *lines = [accessCoreData  getData:ENTITY_LINE Conditions:nil Sorts:nil];
	for (Line  *line in lines) {
		NSLog(@"<<<<<<<<<<<<<<<<<<<< レコード開始 >>>>>>>>>>>>>>>>>>>>");		// 区切り
		NSLog(@"運行系統名 = %@", line.name);									// 運行系統名
		NSLog(@"路線コード = %@", line.code);									// 路線コード
		NSLog(@"運行会社   = %@", line.operate);								// 運行会社
		NSLog(@"固有識別子 = %@", line.ucode);									// 固有識別子(ucode)
		NSLog(@"固有識別子 = %@", line.sameAs);									// 固有識別子
		NSLog(@"生成時刻   = %@", line.date);									// 生成時刻(ISO8601 日付時刻形式)
		// 駅情報
		NSLog(@"駅数       = %ld", (long)[line.stations count]);				// 駅数
		XCTAssertNotEqual([line.stations count], 0, @"駅情報がない");
		for (Station  *station in line.stations) {
			NSLog(@"駅名       = %@", station.name);							// 駅名
		}
		NSLog(@"<<<<<<<<<<<<<<<<<<<< レコード終了 >>>>>>>>>>>>>>>>>>>>\n\n");	// 区切り
	}
	XCTAssertNotEqual([lines count], 0, @"路線テーブルデータがない");
}

//-----------------------------------------------------------------------------------------------------------
// 駅順序テーブルテスト
//
// @param										なし
//
// @return			(void)						なし
//-----------------------------------------------------------------------------------------------------------
- (void) testStationOrderTable {
	NSArray *datas = [self table:ENTITY_STATION_ORDER EntityName:@"駅順序テーブル"];
	for (StationOrder *data in datas) {
		NSLog(@"<<<<<<<<<<<<<<<<<<<< レコード開始 >>>>>>>>>>>>>>>>>>>>");
		NSLog(@"駅順序              = %@", data.order);
		NSLog(@"駅コード            = %@", data.code);
		NSLog(@"路線名              = %@", ((Line *)data.line).name);
		NSLog(@"<<<<<<<<<<<<<<<<<<<< レコード終了 >>>>>>>>>>>>>>>>>>>>\n\n");
	}
}

//-----------------------------------------------------------------------------------------------------------
// 駅間の標準所要時間情報テーブルテスト
//
// @param										なし
//
// @return			(void)						なし
//-----------------------------------------------------------------------------------------------------------
- (void) testTravelTimeTable {
	NSArray *datas = [self table:ENTITY_TRAVEL_TIME EntityName:@"駅間の標準所要時間情報テーブル"];
	for (TravelTime *data in datas) {
		NSLog(@"<<<<<<<<<<<<<<<<<<<< レコード開始 >>>>>>>>>>>>>>>>>>>>");
		NSLog(@"駅間の起点          = %@", data.fromStation);
		NSLog(@"駅間の終点          = %@", data.toStation);
		NSLog(@"駅間の所要時間（分）= %@", data.necessaryTime);
		NSLog(@"列車種別            = %@", data.trainType);
		NSLog(@"路線名              = %@", ((Line *)data.line).name);
		NSLog(@"<<<<<<<<<<<<<<<<<<<< レコード終了 >>>>>>>>>>>>>>>>>>>>\n\n");
	}
}

//-----------------------------------------------------------------------------------------------------------
// 女性専用車両情報テーブルテスト
//
// @param										なし
//
// @return			(void)						なし
//-----------------------------------------------------------------------------------------------------------
- (void) testWomenCarTable {
	NSArray *datas = [self table:ENTITY_WOMEN_CAR EntityName:@"女性専用車両情報テーブル"];
	for (WomenCar *data in datas) {
		NSLog(@"<<<<<<<<<<<<<<<<<<<< レコード開始 >>>>>>>>>>>>>>>>>>>>");
		NSLog(@"女性専用車両開始駅  = %@", data.fromStation);
		NSLog(@"女性専用車両終了駅  = %@", data.toStation);
		NSLog(@"女性専用車両実施曜日= %@", data.operationDay);
		NSLog(@"女性専用車両開始時間= %@", data.startTime);
		NSLog(@"女性専用車両終了時間= %@", data.untilTime);
		NSLog(@"車両編成数          = %@", data.carComposition);
		NSLog(@"女性専用車両車番号  = %@", data.carNumber);
		NSLog(@"路線名              = %@", ((Line *)data.line).name);
		NSLog(@"<<<<<<<<<<<<<<<<<<<< レコード終了 >>>>>>>>>>>>>>>>>>>>\n\n");
	}
}

//-----------------------------------------------------------------------------------------------------------
// 出入口テーブルテスト
//
// @param										なし
//
// @return			(void)						なし
//-----------------------------------------------------------------------------------------------------------
- (void)testGateTable {
	AccessCoreData *accessCoreData =  [[AccessCoreData alloc] initEmptyCoreData];
	NSInteger count = [accessCoreData getDataCount:ENTITY_GATE];
	NSLog(@"出入口テーブルデータ件数 = %ld", (long)count);
	XCTAssertNotEqual(count, 0, @"出入口テーブルデータがない");

	NSArray *gates = [accessCoreData  getData:ENTITY_GATE Conditions:nil Sorts:nil];
	for (Gate  *gate in gates) {
		NSLog(@"<<<<<<<<<<<<<<<<<<<< レコード開始 >>>>>>>>>>>>>>>>>>>>");		// 区切り
		NSLog(@"駅名       = %@", gate.station.name);							// 駅名
		NSLog(@"出入口名   = %@", gate.name);									// 出入口名
		NSLog(@"地物の階数 = %@", gate.floor);									// 地物の階数
		NSLog(@"固有識別子 = %@", gate.ucode);									// 固有識別子(ucode)
		NSLog(@"経度       = %@", gate.lon);									// 経度
		NSLog(@"緯度       = %@", gate.lat);									// 緯度
		NSLog(@"<<<<<<<<<<<<<<<<<<<< レコード終了 >>>>>>>>>>>>>>>>>>>>\n\n");	// 区切り
	}
	XCTAssertNotEqual([gates count], 0, @"出入口テーブルデータがない");
}

//-----------------------------------------------------------------------------------------------------------
// 施設テーブルテスト
//
// @param										なし
//
// @return			(void)						なし
//-----------------------------------------------------------------------------------------------------------
- (void)testFacilityTable {
	NSArray *datas = [self table:ENTITY_FACILITY EntityName:@"施設テーブル"];
	for (Facility *data in datas) {
		NSLog(@"<<<<<<<<<<<<<<<<<<<< レコード開始 >>>>>>>>>>>>>>>>>>>>");
		NSLog(@"駅名                = %@", ((Station *)(data.station)).name);
		NSLog(@"固有識別子(ucode)   = %@", data.ucode);
		NSLog(@"固有識別子          = %@", data.sameAs);
		NSLog(@"生成時刻            = %@", data.date);
		NSLog(@"<<<<<<<<<<<<<<<<<<<< レコード終了 >>>>>>>>>>>>>>>>>>>>\n\n");
	}
}

//-----------------------------------------------------------------------------------------------------------
// バリアフリーテーブルテスト
//
// @param										なし
//
// @return			(void)						なし
//-----------------------------------------------------------------------------------------------------------
- (void)testToiletBarrierFree {
	NSArray *datas = [self table:ENTITY_BARRIER EntityName:@"バリアフリーテーブル"];
	for (BarrierFree  *data in datas) {
		NSLog(@"<<<<<<<<<<<<<<<<<<<< レコード開始 >>>>>>>>>>>>>>>>>>>>");
		NSLog(@"施設名   　　　　   = %@", data.name);
		NSLog(@"施設の設置場所      = %@", data.placeName);
		NSLog(@"改札内／改札外      = %@", data.locatedArea);
		NSLog(@"補足事項            = %@", data.remark);
		for (ToiletAssistance *toilet in data.toiletAssistances) {
			NSLog(@"トイレ情報          = %@", toilet.name);
		}
		for (ServiceDetail *service in data.serviceDetails) {
			NSLog(@"利用曜日          = %@", service.operationDay);
			NSLog(@"開始時間          = %@", service.startTime);
			NSLog(@"終了時間          = %@", service.endTime);
			NSLog(@"エスカレータ方向  = %@", service.direction);
		}
		NSLog(@"固有識別子(ucode)   = %@", data.ucode);
		NSLog(@"固有識別子          = %@", data.sameAs);
		NSLog(@"施設情報            = %@", ((Facility *)(data.facility)).sameAs);
		NSLog(@"<<<<<<<<<<<<<<<<<<<< レコード終了 >>>>>>>>>>>>>>>>>>>>\n\n");
	}
}

//-----------------------------------------------------------------------------------------------------------
// バリアフリー利用詳細テーブルテスト
//
// @param										なし
//
// @return			(void)						なし
//-----------------------------------------------------------------------------------------------------------
- (void)testServiceDetail {
	NSArray *datas = [self table:ENTITY_SERVICE EntityName:@"バリアフリー利用詳細テーブル"];
	for (ServiceDetail *data in datas) {
		NSLog(@"<<<<<<<<<<<<<<<<<<<< レコード開始 >>>>>>>>>>>>>>>>>>>>");
		NSLog(@"利用曜日   　　　　 = %@", data.operationDay);
		NSLog(@"開始時間            = %@", data.startTime);
		NSLog(@"終了時間            = %@", data.endTime);
		NSLog(@"エスカレーター方向  = %@", data.direction);
		NSLog(@"バリアフリー施設名  = %@", ((BarrierFree *)(data.barrierFree)).name);
		NSLog(@"<<<<<<<<<<<<<<<<<<<< レコード終了 >>>>>>>>>>>>>>>>>>>>\n\n");
	}
}

//-----------------------------------------------------------------------------------------------------------
// プラットホーム情報テーブルテスト
//
// @param										なし
//
// @return			(void)						なし
//-----------------------------------------------------------------------------------------------------------
- (void)testPlatform {
	NSArray *datas = [self table:ENTITY_PLATFORM EntityName:@"プラットホーム情報テーブル"];
	for (Platform *data in datas) {
		NSLog(@"<<<<<<<<<<<<<<<<<<<< レコード開始 >>>>>>>>>>>>>>>>>>>>");
		NSLog(@"車両編成数   　　　= %@", data.carComposition);
		NSLog(@"車両の号車番号     = %@", data.carNumber);
		NSLog(@"列車の方面         = %@", data.railDirection);
		NSLog(@"駅名               = %@", ((Station *)(data.facility.station)).name);
		for (BarrierFree *barrierFree in data.barrierFrees) {
			NSLog(@"最寄のバリアフリー = %@", barrierFree.name);
		}
		NSLog(@"<<<<<<<<<<<<<<<<<<<< レコード終了 >>>>>>>>>>>>>>>>>>>>\n\n");
	}
}

//-----------------------------------------------------------------------------------------------------------
// 乗換情報テーブルテスト
//
// @param										なし
//
// @return			(void)						なし
//-----------------------------------------------------------------------------------------------------------
- (void)testTransfer {
	NSArray *datas = [self table:ENTITY_TRANSFER EntityName:@"乗換情報テーブル"];
	for (Transfer *data in datas) {
		NSLog(@"<<<<<<<<<<<<<<<<<<<< レコード開始 >>>>>>>>>>>>>>>>>>>>");
		NSLog(@"乗換路線           = %@", data.railway);
		NSLog(@"乗換路線名         = %@", ((Line *)data.line).name);
		NSLog(@"乗換路線会社       = %@", ((Line *)data.line).operate);
		NSLog(@"列車方面           = %@", data.railDirection);
		NSLog(@"所要時間           = %@", data.necessaryTime);
		NSLog(@"車両編成数   　　　= %@", ((Platform *)data.platform).carComposition);
		NSLog(@"車両の号車番号     = %@", ((Platform *)data.platform).carNumber);
		NSLog(@"列車の方面         = %@", ((Platform *)data.platform).railDirection);
		NSLog(@"駅名               = %@", ((Station *)((Facility *)((Platform *)data.platform).facility).station).name);
		NSLog(@"<<<<<<<<<<<<<<<<<<<< レコード終了 >>>>>>>>>>>>>>>>>>>>\n\n");
	}
}

//-----------------------------------------------------------------------------------------------------------
// 改札外の最寄り施設情報テーブルテスト
//
// @param										なし
//
// @return			(void)						なし
//-----------------------------------------------------------------------------------------------------------
- (void)testSurrounding {
	NSArray *datas = [self table:ENTITY_SURROUND EntityName:@"改札外の最寄り施設情報テーブル"];
	for (Surrounding *data in datas) {
		NSLog(@"<<<<<<<<<<<<<<<<<<<< レコード開始 >>>>>>>>>>>>>>>>>>>>");
		NSLog(@"施設名線           = %@", data.name);
		NSLog(@"車両編成数   　　　= %@", ((Platform *)data.platform).carComposition);
		NSLog(@"車両の号車番号     = %@", ((Platform *)data.platform).carNumber);
		NSLog(@"列車の方面         = %@", ((Platform *)data.platform).railDirection);
		NSLog(@"駅名               = %@", ((Station *)((Facility *)((Platform *)data.platform).facility).station).name);
		NSLog(@"<<<<<<<<<<<<<<<<<<<< レコード終了 >>>>>>>>>>>>>>>>>>>>\n\n");
	}
}

//-----------------------------------------------------------------------------------------------------------
// テーブルテスト
//
// @param			(NSString *)entity			エンティティ
//					(NSString *)name			エンティティ日本語名
//
// @return			(NSArray *)					テーブルデータ
//-----------------------------------------------------------------------------------------------------------
- (NSArray *)table:(NSString *)entity EntityName:(NSString *)name{
	AccessCoreData *accessCoreData =  [[AccessCoreData alloc] initBundleSqliteCoreData];
	NSInteger count = [accessCoreData getDataCount:entity];
	NSLog(@"%@データ件数 = %ld", name, (long)count);
	XCTAssertNotEqual(count, 0, @"テーブルデータがない");
	return [accessCoreData  getData:entity Conditions:nil Sorts:nil];
}



@end
