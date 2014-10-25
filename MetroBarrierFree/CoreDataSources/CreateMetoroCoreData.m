//---------------------------------------------------------------------------------------------------------------
//  CreateMetoroCoreData.m
//  CreateMetoroData
//	メトロのコアデータ作成クラス
//
//  Created by yuta on 2014/10/03.
//  Copyright (c) 2014年 501Software. All rights reserved.
//---------------------------------------------------------------------------------------------------------------
#import "CreateMetoroCoreData.h"

@implementation CreateMetoroCoreData

//---------------------------------------------------------------------------------------------------------------
// updateLineData
//
// 路線情報を更新する
// CoreDataに存在しない場合は新規作成，存在する場合は生成時刻を確認して更新
//
// param		なし
//
// return		void
//---------------------------------------------------------------------------------------------------------------
- (BOOL)createLineData {
	// メトロオープンデータ路線情報取得
	NSArray *datas = [self getMetoroData:QUERY_DATA_RAILWAY];
//	NSLog(@"路線情報件数（%d）",[datas count]);
	for(NSDictionary *data in datas) {
		// CoreDataより路線情報取得
		NSString 	*ucode = [data objectForKey:KEY_ID];								// 固有識別子(ucode)
		NSString 	*conditions =[NSString stringWithFormat:@"%@ = '%@'", ATRBT_UCODE, ucode];
		NSArray 	*lines = [self  getData:ENTITY_LINE Conditions:conditions Sorts:nil];
		// １件取得の場合
		if ([lines count] == 1) {
			Line *line = lines[0];
			// 更新日付が異なる場合はUPDATEする
			if (![line.date isEqual:[self convIsoDate:[data objectForKey:KEY_DATE]]]) {
				// 路線情報を編集しCoreDataに登録する
				if (![self updateLineData:line dicLine:data]){
					return NO;
				}
			}
		}
		// 取得件数がない場合は新規作成
		else if ([lines count] == 0) {
			// 路線情報の空レコード生成
			Line *line = [NSEntityDescription insertNewObjectForEntityForName:ENTITY_LINE
													   inManagedObjectContext:self.managedObjectContext];
			// 路線情報を編集しCoreDataに登録する
			if (![self updateLineData:line dicLine:data]){
				return NO;
			}
		}
		// 取得データが複数件の場合はエラーとする
		else {
			NSLog(@"updateLineData 更新エラー：データが複数件あります");
			continue;
		}
	}
	NSLog(@"<<<<<<<<<<<<<<<<<<<< 路線情報処理終了 >>>>>>>>>>>>>>>>>>>>");
	return YES;
}

//---------------------------------------------------------------------------------------------------------------
// editLineData
//
// 路線情報を編集しCoreDataに登録する
//
// param		(Line *)line							路線レコード
//				(NSDictionary*)data						メトロオープンデータ路線情報
//
// return		(NSArray *)								取得データ
//---------------------------------------------------------------------------------------------------------------
- (BOOL)updateLineData:(Line *)line dicLine:(NSDictionary*)data
{
	//-----------------------------------------------------------------------------------------------------------
	// 路線情報を編集しCoreDataに登録する
	//-----------------------------------------------------------------------------------------------------------
	if (![self editLineData:line dicLine:data]){
		return NO;
	}
	//-----------------------------------------------------------------------------------------------------------
	// 駅の順序情報を削除する
	//-----------------------------------------------------------------------------------------------------------
	if (![self deleteStationOrderData:line]){
		return NO;
	}
	//-----------------------------------------------------------------------------------------------------------
	// 駅間の標準所要時間情報を削除する
	//-----------------------------------------------------------------------------------------------------------
	if (![self deleteTravelTimeData:line]){
		return NO;
	}
	//-----------------------------------------------------------------------------------------------------------
	// 女性専用車両情報を削除する
	//-----------------------------------------------------------------------------------------------------------
	if (![self deleteWomenCarData:line]){
		return NO;
	}
	//-----------------------------------------------------------------------------------------------------------
	// 駅の順序情報を登録する
	//-----------------------------------------------------------------------------------------------------------
	NSArray *stationOrders 	= [data objectForKey:KEY_STATION_ORDER];				// 駅の順序情報
	for (NSDictionary *stationOrder in stationOrders) {
		if (![self editStationOrderData:stationOrder Line:line]){
			return NO;
		}
	}
	//-----------------------------------------------------------------------------------------------------------
	// 駅間の標準所要時間情報を登録する
	//-----------------------------------------------------------------------------------------------------------
	NSArray *travelTimes 	= [data objectForKey:KEY_TRAVEL_TIME];					// 駅間の標準所要時間情報
	for (NSDictionary *travelTime in travelTimes) {
		if (![self editTravelTimeData:travelTime Line:line]){
			return NO;
		}
	}
	//-----------------------------------------------------------------------------------------------------------
	// 女性専用車両情報を登録する
	//-----------------------------------------------------------------------------------------------------------
	NSArray *arraywomenCars 	= [data objectForKey:KEY_WOMEN_CAR];					// 女性専用車両情報
	for (NSArray *womenCars in arraywomenCars) {
		for (NSDictionary *womenCar in womenCars) {
			if (![self editWomenCarData:womenCar Line:line]){
				return NO;
			}
		}
	}
	return YES;
}

//---------------------------------------------------------------------------------------------------------------
// editLineData
//
// 路線メイン情報を編集しCoreDataに登録する
//
// param		(Line *)line							路線レコード
//				(NSDictionary*)data						メトロオープンデータ路線情報
//
// return		(NSArray *)								取得データ
//---------------------------------------------------------------------------------------------------------------
- (BOOL)editLineData:(Line *)line dicLine:(NSDictionary*)data
{
	// 路線情報編集
	line.name 		= [data objectForKey:KEY_TITLE];						// 運行系統名
	line.code 		= [data objectForKey:KEY_LINE_CODE];					// 路線コード
	// 運行会社取得
	NSString 	*conditions = [NSString stringWithFormat:@"%@ = '%@'",
							   				ATRBT_OPERATOR_CODE, [data objectForKey:KEY_OPERATOR]];
	NSArray  	*operators = [self getData:ENTITY_OPERATOR Conditions:conditions Sorts:nil];
	if ([operators count] != 1) {
		NSLog(@"運行会社情報異常（%@）", [data objectForKey:KEY_OPERATOR]);
	}
	else {
		line.operate		= ((Operator *)operators[0]).name;				// 運行会社
	}
	line.ucode 		= [data objectForKey:KEY_ID];							// 固有識別子(ucode)
	line.sameAs 	= [data objectForKey:KEY_SAME_AS];						// 固有識別子
	line.date 		= [self convIsoDate:[data objectForKey:KEY_DATE]];		// 生成時刻
	// 路線情報更新
	NSError *error = Nil;
	if(![self.managedObjectContext save:&error]){
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		return NO;
	}
	return YES;
}

//---------------------------------------------------------------------------------------------------------------
// editStationOrderData
//
// 駅順序情報を編集しCoreDataに登録する
//
// param		(NSDictionary*)data						メトロオープンデータ路線情報
// 				(Line *)line							路線情報
//
// return		(BOOL)
//---------------------------------------------------------------------------------------------------------------
- (BOOL)editStationOrderData:(NSDictionary*)data Line:(Line *)line
{
//	static int cnt = 0;
//	cnt++;
//	NSLog(@"駅順序情報件数（%d）",cnt);
	// 駅順序情報の空レコード生成
	StationOrder *stationOrder = [NSEntityDescription insertNewObjectForEntityForName:ENTITY_STATION_ORDER
															   inManagedObjectContext:self.managedObjectContext];
	// 駅順序情報編集
	stationOrder.order 		= [data objectForKey:KEY_INDEX];						// 順序
	stationOrder.code 		= [data objectForKey:KEY_STATION];						// 駅コード
	stationOrder.line 		= line;													// 路線情報
	// 駅順序情報更新
	NSError *error = Nil;
	if(![self.managedObjectContext save:&error]){
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		return NO;
	}
	return YES;
}

//---------------------------------------------------------------------------------------------------------------
// deleteStationOrderData
//
// 駅順序情報を削除する
//
// param		(Line *)line							路線情報
//
// return		(BOOL)
//---------------------------------------------------------------------------------------------------------------
- (BOOL)deleteStationOrderData:(Line *)line
{
	NSString *conditions =[NSString stringWithFormat:@"%@.%@ = '%@'",
						   ATRBT_ORDER_LINE, ATRBT_LINE_UCODE, line.ucode];
	if (![self deleteData:ENTITY_STATION_ORDER Conditions:conditions]) {
		return NO;
	}
	return YES;
}

//---------------------------------------------------------------------------------------------------------------
// editTravelTimeData
//
// 駅間の標準所要時間情報を編集しCoreDataに登録する
//
// param		(NSDictionary*)data						メトロオープンデータ路線情報
// 				(Line *)line							路線情報
//
// return		(BOOL)
//---------------------------------------------------------------------------------------------------------------
- (BOOL)editTravelTimeData:(NSDictionary*)data Line:(Line *)line
{
//	static int cnt = 0;
//	cnt++;
//	NSLog(@"駅間の標準所要時間情報件数（%d）",cnt);
	// 駅間の標準所要時間情報の空レコード生成
	TravelTime *travelTime = [NSEntityDescription insertNewObjectForEntityForName:ENTITY_TRAVEL_TIME
															   inManagedObjectContext:self.managedObjectContext];
	// 駅間の標準所要時間情報編集
	travelTime.fromStation		= [data objectForKey:KEY_FROM_STATION];				// 駅間の起点
	travelTime.toStation		= [data objectForKey:KEY_TO_STATION];				// 駅間の終点
	travelTime.necessaryTime	= [data objectForKey:KEY_NECESSARY_TIME];			// 駅間の所要時間（分）
	// 列車種別
	travelTime.trainType		= [self getTrainTypeName:[data objectForKey:KEY_TRAIN_TYPE]];
	travelTime.line 			= line;												// 路線情報
	// 駅間の標準所要時間情報更新
	NSError *error = Nil;
	if(![self.managedObjectContext save:&error]){
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		return NO;
	}
	return YES;
}

//---------------------------------------------------------------------------------------------------------------
// deleteTravelTimeData
//
// 駅間の標準所要時間情報を削除する
//
// param		(Line *)line							路線情報
//
// return		(BOOL)
//---------------------------------------------------------------------------------------------------------------
- (BOOL)deleteTravelTimeData:(Line *)line
{
	NSString *conditions =[NSString stringWithFormat:@"%@.%@ = '%@'",
						   ATRBT_TRAVEL_LINE, ATRBT_LINE_UCODE, line.ucode];
	if (![self deleteData:ENTITY_TRAVEL_TIME Conditions:conditions]) {
		return NO;
	}
	return YES;
}

//---------------------------------------------------------------------------------------------------------------
// editWomenCarData
//
// 女性専用車両情報を編集しCoreDataに登録する
//
// param		(NSDictionary*)data						メトロオープンデータ路線情報
// 				(Line *)line							路線情報
//
// return		(BOOL)
//---------------------------------------------------------------------------------------------------------------
- (BOOL)editWomenCarData:(NSDictionary*)data Line:(Line *)line
{
//	static int cnt = 0;
//	cnt++;
//	NSLog(@"女性専用車両情報件数（%d）",cnt);
	// 女性専用車両情報の空レコード生成
	WomenCar *womenCar = [NSEntityDescription insertNewObjectForEntityForName:ENTITY_WOMEN_CAR
														   inManagedObjectContext:self.managedObjectContext];
	// 女性専用車両情報編集
	womenCar.fromStation		= [data objectForKey:KEY_FROM_STATION];				// 女性専用車両開始駅
	womenCar.toStation			= [data objectForKey:KEY_TO_STATION];				// 女性専用車両終了駅
	womenCar.operationDay 		= [data objectForKey:KEY_OPERATION_DAY];			// 女性専用車両実施曜日
	womenCar.startTime			= [data objectForKey:KEY_WOMEN_START];				// 女性専用車両開始時間
	womenCar.untilTime			= [data objectForKey:KEY_WOMEN_UNTIL];				// 女性専用車両終了時間
	womenCar.carComposition		= [data objectForKey:KEY_CAR_COMPOS];				// 車両編成数
	womenCar.carNumber			= [data objectForKey:KEY_CAR_NUM];					// 女性専用車両実施車両号
	womenCar.line 				= line;												// 路線情報
	// 女性専用車両実施車両号車番号
//	for (NSString *carNumber in [data objectForKey:KEY_CAR_NUM]) {
//		womenCar.carNumber = [womenCar.carNumber stringByAppendingString:carNumber];
//		womenCar.carNumber = [womenCar.carNumber stringByAppendingString:@","];
//	}
//	womenCar.carNumber = [womenCar.carNumber substringToIndex:[womenCar.carNumber length]-1];
	// 女性専用車両情報更新
	NSError *error = Nil;
	if(![self.managedObjectContext save:&error]){
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		return NO;
	}
	return YES;
}

//---------------------------------------------------------------------------------------------------------------
// deleteWomenCarData
//
// 女性専用車両情報を削除する
//
// param		(Line *)line							路線情報
//
// return		(BOOL)
//---------------------------------------------------------------------------------------------------------------
- (BOOL)deleteWomenCarData:(Line *)line
{
	NSString *conditions =[NSString stringWithFormat:@"%@.%@ = '%@'",
						   ATRBT_WOMEN_LINE, ATRBT_LINE_UCODE, line.ucode];
	if (![self deleteData:ENTITY_WOMEN_CAR Conditions:conditions]) {
		return NO;
	}
	return YES;
}

//---------------------------------------------------------------------------------------------------------------
// createStationData
//
// 駅情報を更新する
// CoreDataに存在しない場合は新規作成，存在する場合は生成時刻を確認して更新
//
// param		なし
//
// return		void
//---------------------------------------------------------------------------------------------------------------
- (BOOL)createStationData
{
	//-----------------------------------------------------------------------------------------------------------
	// メトロオープンデータ駅情報取得
	//-----------------------------------------------------------------------------------------------------------
	NSArray *datas = [self getMetoroData:QUERY_DATA_STATION];
	for(NSDictionary *data in datas) {
		//-------------------------------------------------------------------------------------------------------
		// CoreDataより駅情報取得
		//-------------------------------------------------------------------------------------------------------
		NSString *ucode 		= [data objectForKey:KEY_ID];		// 固有識別子(ucode)
		NSString *conditions	= [NSString stringWithFormat:@" %@ = '%@'", ATRBT_UCODE, ucode];
		NSArray  *stations 		= [self getData:ENTITY_STATION Conditions:conditions Sorts:nil];
		//-------------------------------------------------------------------------------------------------------
		// 取得件数がない場合は新規作成
		//-------------------------------------------------------------------------------------------------------
		if ([stations count] == 0) {
			// 路線情報の空レコード生成
			Station *station = [NSEntityDescription insertNewObjectForEntityForName:ENTITY_STATION
															 inManagedObjectContext:self.managedObjectContext];
			// 路線情報を編集しCoreDataに登録する
			if (![self editStationData:station dicLine:data]){
				return NO;
			}
		}
		//-------------------------------------------------------------------------------------------------------
		// １件取得の場合
		//-------------------------------------------------------------------------------------------------------
		else if ([stations count] == 1) {
			Station *station = stations[0];
			// 更新日付が異なる場合はUPDATEする
			if (![station.date isEqual:[self convIsoDate:[data objectForKey:KEY_DATE]]]) {
				// 路線情報を編集しCoreDataに登録する
				if (![self editStationData:station dicLine:data]){
					return NO;
				}
			}
		}
		//-------------------------------------------------------------------------------------------------------
		// 取得データが複数件の場合はエラーとする
		//-------------------------------------------------------------------------------------------------------
		else {
			NSLog(@"updateStationData 更新エラー：データが複数件あります");
			continue;
		}
	}
	NSLog(@"<<<<<<<<<<<<<<<<<<<< 駅情報処理終了 >>>>>>>>>>>>>>>>>>>>");
	return YES;
}

//---------------------------------------------------------------------------------------------------------------
// editStationData
//
// 駅情報を編集しCoreDataに登録する
//
// param		(Station *)station						駅レコード
//				(NSDictionary*)data						メトロオープンデータ駅情報
//
// return		(NSArray *)								取得データ
//---------------------------------------------------------------------------------------------------------------
- (BOOL)editStationData:(Station *)station dicLine:(NSDictionary*)data
{
	//-----------------------------------------------------------------------------------------------------------
	// 駅情報編集
	//-----------------------------------------------------------------------------------------------------------
	station.name 		= [data objectForKey:KEY_TITLE];					// 駅名
	station.code 		= [data objectForKey:KEY_STATION_CODE];				// 駅コード
	station.ucode 		= [data objectForKey:KEY_ID];						// 固有識別子(ucode)
	station.sameAs 		= [data objectForKey:KEY_SAME_AS];					// 固有識別子
	station.date 		= [self convIsoDate:[data objectForKey:KEY_DATE]];	// 生成時刻
	station.lon			= [data objectForKey:KEY_LON];						// 経度
	station.lat			= [data objectForKey:KEY_LAT];						// 緯度
	station.operator	= [data objectForKey:KEY_OPERATOR];					// 管理会社
	//-----------------------------------------------------------------------------------------------------------
	// 路線情報取得
	//-----------------------------------------------------------------------------------------------------------
	NSString 	*sameAs		= [data objectForKey:KEY_RAILWAY];
	NSString 	*conditions = [NSString stringWithFormat:@"%@ = \'%@\'", ATRBT_STASION_SAMEAS, sameAs];
	NSArray 	*lines 		= [self  getData:ENTITY_LINE Conditions:conditions Sorts:nil];
	if ([lines count] != 1) {
		NSLog(@"updateStationData 更新エラー：路線データが異常です");
		return NO;
	}
	station.line = lines[0];												// 路線情報
	//-----------------------------------------------------------------------------------------------------------
	// 出入口情報取得
	//-----------------------------------------------------------------------------------------------------------
	NSSet 		*ucodes		= [data objectForKey:KEY_GATE];
	for (NSString *ucode in ucodes) {
		NSString 	*conditions = [NSString stringWithFormat:@"%@ = \'%@\'", ATRBT_GATE_UCODE, ucode];
		NSArray  	*gates 		= [self getData:ENTITY_GATE Conditions:conditions Sorts:nil];
		[station addGates:[NSSet setWithArray:gates]];						//  出入口情報
	}
	//-----------------------------------------------------------------------------------------------------------
	// 施設情報取得
	//-----------------------------------------------------------------------------------------------------------
	NSString 	*facilitysameAs		= [data objectForKey:KEY_FACILITY];
	NSString 	*facilityconditions = [NSString stringWithFormat:@"%@ = \'%@\'", ATRBT_FACILITY_SAMEAS, facilitysameAs];
	NSArray  	*facilitys 			= [self getData:ENTITY_FACILITY Conditions:facilityconditions Sorts:nil];
	[station addFacilitys:[NSSet setWithArray:facilitys]];				//  施設情報

	//-----------------------------------------------------------------------------------------------------------
	// 駅情報更新
	//-----------------------------------------------------------------------------------------------------------
	NSError *error = Nil;
	if(![self.managedObjectContext save:&error]){
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		return NO;
	}
	return YES;
}

//---------------------------------------------------------------------------------------------------------------
// createGateData
//
// 出入口情報を更新する
// CoreDataに存在しない場合は新規作成，存在する場合はスルー（何もしない）
//
// param		なし
//
// return		void
//---------------------------------------------------------------------------------------------------------------
- (BOOL)createGateData
{
	//-----------------------------------------------------------------------------------------------------------
	// メトロオープンデータ出入口情報取得
	//-----------------------------------------------------------------------------------------------------------
	NSArray *datas = [self getMetoroData:QUERY_DATA_POI];
	for(NSDictionary *data in datas) {
		//-------------------------------------------------------------------------------------------------------
		// CoreDataより出入口情報取得
		//-------------------------------------------------------------------------------------------------------
		NSString *ucode 		= [data objectForKey:KEY_ID];		// 固有識別子(ucode)
		NSString *conditions	= [NSString stringWithFormat:@" %@ = '%@'", ATRBT_UCODE, ucode];
		NSArray  *gates 		= [self getData:ENTITY_GATE Conditions:conditions Sorts:nil];
		//-------------------------------------------------------------------------------------------------------
		// 取得件数がない場合は新規作成
		//-------------------------------------------------------------------------------------------------------
		if ([gates count] == 0) {
			// 路線情報の空レコード生成
			Gate *gate 	= [NSEntityDescription insertNewObjectForEntityForName:ENTITY_GATE
														   inManagedObjectContext:self.managedObjectContext];
			// 路線情報を編集しCoreDataに登録する
			if (![self editGateData:gate dicLine:data]){
				return NO;
			}
		}
		//-------------------------------------------------------------------------------------------------------
		// １件取得の場合
		//-------------------------------------------------------------------------------------------------------
		else if ([gates count] == 1) {
			NSLog(@"updateGateData 更新ワーニング：同一固有識別子(ucode)があります");
			continue;
		}
		//-------------------------------------------------------------------------------------------------------
		// 取得データが複数件の場合はエラーとする
		//-------------------------------------------------------------------------------------------------------
		else {
			NSLog(@"updateGateData 更新エラー：データが複数件あります");
			continue;
		}
	}
	NSLog(@"<<<<<<<<<<<<<<<<<<<< 出入口情報処理終了 >>>>>>>>>>>>>>>>>>>>");
	return YES;
}

//---------------------------------------------------------------------------------------------------------------
// editGateData
//
// 出入口情報を編集しCoreDataに登録する
//
// param		(Gate *)gate							出入口レコード
//				(NSDictionary*)data						メトロオープンデータ出入口情報
//
// return		(NSArray *)								取得データ
//---------------------------------------------------------------------------------------------------------------
- (BOOL)editGateData:(Gate *)gate dicLine:(NSDictionary*)data
{
	// 出入口情報編集
	gate.name			= [data objectForKey:KEY_TITLE];					// 出入口名
	gate.floor			= [data objectForKey:KEY_FLOOR];					// 地物の階数（高さ情報）
	gate.ucode 			= [data objectForKey:KEY_ID];						// 固有識別子(ucode)
	gate.lon			= [data objectForKey:KEY_LON];						// 経度
	gate.lat			= [data objectForKey:KEY_LAT];						// 緯度
	// 出入口情報更新
	NSError *error = Nil;
	if(![self.managedObjectContext save:&error]){
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		return NO;
	}
	return YES;
}

//---------------------------------------------------------------------------------------------------------------
// createFacilityData
//
// 施設情報を更新する
// CoreDataに存在しない場合は新規作成，存在する場合は生成時刻を確認して更新
//
// param		なし
//
// return		void
//---------------------------------------------------------------------------------------------------------------
- (BOOL)createFacilityData
{
	//-----------------------------------------------------------------------------------------------------------
	// メトロオープンデータ施設情報報取得
	//-----------------------------------------------------------------------------------------------------------
	NSArray *datas = [self getMetoroData:QUERY_DATA_STA_FACIL];
//	NSLog(@"施設情報データ件数（%d）",[datas count]);
	for(NSDictionary *data in datas) {
		//-------------------------------------------------------------------------------------------------------
		// CoreDataより施設情報取得
		//-------------------------------------------------------------------------------------------------------
		NSString *ucode 		= [data objectForKey:KEY_ID];		// 固有識別子(ucode)
		NSString *conditions	= [NSString stringWithFormat:@"%@ = '%@'", ATRBT_FACILITY_UCODE, ucode];
		NSArray  *facilitys 	= [self getData:ENTITY_FACILITY Conditions:conditions Sorts:nil];
		//-------------------------------------------------------------------------------------------------------
		// 取得件数がない場合は新規作成
		//-------------------------------------------------------------------------------------------------------
		if ([facilitys count] == 0) {
			// 施設情報の空レコード生成
			Facility *facility = [NSEntityDescription insertNewObjectForEntityForName:ENTITY_FACILITY
															 inManagedObjectContext:self.managedObjectContext];
			// 施設情報を編集しCoreDataに登録する
			if (![self editFacilityData:facility dic:data]) {
				return NO;
			}
			// バリアフリー情報を編集しCoreDataに登録する
			if (![self createBarrierFreeData:[data objectForKey:KEY_BARRIER] Facility:facility]) {
				return NO;
			}
			// プラットホーム情報を編集しCoreDataに登録する
			if (![self createPlatformData:[data objectForKey:KEY_PLATFORM] Facility:facility]) {
				return NO;
			}
		}
		//-------------------------------------------------------------------------------------------------------
		// １件取得の場合
		//-------------------------------------------------------------------------------------------------------
		else if ([facilitys count] == 1) {
			Facility *facility = facilitys[0];
			// 更新日付が異なる場合はUPDATEする
			if (![facility.date isEqual:[self convIsoDate:[data objectForKey:KEY_DATE]]]) {
				// 施設情報を編集しCoreDataに登録する
				if (![self editFacilityData:facility dic:data]){
					return NO;
				}
				// バリアフリー情報を編集しCoreDataに登録する
				if (![self createBarrierFreeData:[data objectForKey:KEY_BARRIER] Facility:facility]) {
					return NO;
				}
				// プラットホーム情報を編集しCoreDataに登録する
				if (![self createPlatformData:[data objectForKey:KEY_PLATFORM] Facility:facility]) {
					return NO;
				}
			}
		}
		//-------------------------------------------------------------------------------------------------------
		// 取得データが複数件の場合はエラーとする
		//-------------------------------------------------------------------------------------------------------
		else {
			NSLog(@"createFacilityData 更新エラー：データが複数件あります");
			continue;
		}
	}
	NSLog(@"<<<<<<<<<<<<<<<<<<<< 施設情報処理終了 >>>>>>>>>>>>>>>>>>>>");
	return YES;
}

//---------------------------------------------------------------------------------------------------------------
// editFacilityData
//
// 施設情報を編集しCoreDataに登録する
//
// param		(BarrierFree *)rec						バリアフリーレコード
//				(NSDictionary*)data						メトロオープンデータバリアフリー情報
//
// return		(BOOL)
//---------------------------------------------------------------------------------------------------------------
- (BOOL)editFacilityData:(Facility *)rec dic:(NSDictionary*)data
{
	//-----------------------------------------------------------------------------------------------------------
	// 施設情報編集
	//-----------------------------------------------------------------------------------------------------------
	rec.ucode 		= [data objectForKey:KEY_ID];						// 固有識別子(ucode)
	rec.sameAs 		= [data objectForKey:KEY_SAME_AS];					// 固有識別子
	rec.date 		= [self convIsoDate:[data objectForKey:KEY_DATE]];	// 生成時刻
	//-----------------------------------------------------------------------------------------------------------
	// 施設情報更新
	//-----------------------------------------------------------------------------------------------------------
	NSError *error = Nil;
	if(![self.managedObjectContext save:&error]){
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		return NO;
	}
	return YES;
}

//---------------------------------------------------------------------------------------------------------------
// createBarrierFreeData
//
// バリアフリー情報を更新する
// CoreDataに存在しない場合は新規作成，存在する場合は更新する
//
// param		(NSArray *)datas					バリアフリー情報
//				(Facility *)facility				施設情報
//
// return		void
//---------------------------------------------------------------------------------------------------------------
- (BOOL)createBarrierFreeData:(NSArray *)datas Facility:(Facility *)facility
{
//	static int cnt = 0;
//	cnt = cnt + [datas count];
//	NSLog(@"バリアフリー情報件数（%d）",cnt);
	for(NSDictionary *data in datas) {
		//-------------------------------------------------------------------------------------------------------
		// CoreDataより施設情報取得
		//-------------------------------------------------------------------------------------------------------
		NSString *ucode 		= [data objectForKey:KEY_ID];		// 固有識別子(ucode)
		NSString *conditions	= [NSString stringWithFormat:@"%@ = '%@'", ATRBT_BARRIER_UCODE, ucode];
		NSArray  *barriers 		= [self getData:ENTITY_BARRIER Conditions:conditions Sorts:nil];
		//-------------------------------------------------------------------------------------------------------
		// 取得件数がない場合は新規作成
		//-------------------------------------------------------------------------------------------------------
		if ([barriers count] == 0) {
			//---------------------------------------------------------------------------------------------------
			// バリアフリー情報新規作成
			//---------------------------------------------------------------------------------------------------
			// バリアフリー情報の空レコード生成
			BarrierFree *barrier 	= [NSEntityDescription insertNewObjectForEntityForName:ENTITY_BARRIER
																  inManagedObjectContext:self.managedObjectContext];
			// バリアフリー関係(BarrierFreeとServiceDitail)情報を更新する
			if (![self updateBarrierFreeData:data BarrierFree:barrier Facility:facility]){
				return NO;
			}
		}
		//-------------------------------------------------------------------------------------------------------
		// １件取得の場合
		//-------------------------------------------------------------------------------------------------------
		else if ([barriers count] == 1) {
			BarrierFree *barrier 	= barriers[0];
			// バリアフリー関係(BarrierFreeとServiceDitail)情報を更新する
			if (![self updateBarrierFreeData:data BarrierFree:barrier Facility:facility]){
				return NO;
			}
		}
		//-------------------------------------------------------------------------------------------------------
		// 取得データが複数件の場合はエラーとする
		//-------------------------------------------------------------------------------------------------------
		else {
			NSLog(@"updateGateData 更新エラー：データが複数件あります");
			return NO;
		}
	}
	return YES;
}

//---------------------------------------------------------------------------------------------------------------
// updateBarrierFreeData
//
// バリアフリー関係(BarrierFreeとServiceDitail)情報を更新する
//
// param		(NSDictionary *)data				バリアフリー情報
//				(BarrierFree *)barrier				バリアフリー情報レコード
//				(Facility *)facility				施設情報レコード
//
// return		BOOL
//---------------------------------------------------------------------------------------------------------------
- (BOOL)updateBarrierFreeData:(NSDictionary *)data  BarrierFree:(BarrierFree *)barrier Facility:(Facility *)facility
{
	//-----------------------------------------------------------------------------------------------------------
	// 施設情報を追加
	//-----------------------------------------------------------------------------------------------------------
	barrier.facility = facility;
	//-----------------------------------------------------------------------------------------------------------
	// バリアフリー情報を編集しCoreDataに登録する
	//-----------------------------------------------------------------------------------------------------------
	if (![self editBarrierFreeData:barrier dic:data]){
		return NO;
	}
	//-----------------------------------------------------------------------------------------------------------
	// バリアフリー利用詳細情報削除
	//-----------------------------------------------------------------------------------------------------------
	NSString *conditions =[NSString stringWithFormat:@"%@.%@ = '%@'",
						   						ATRBT_SERVICE_BARRIER, ATRBT_BARRIER_UCODE, barrier.ucode];
	if (![self deleteData:ENTITY_SERVICE Conditions:conditions]) {
		return NO;
	}
	//-----------------------------------------------------------------------------------------------------------
	// バリアフリー利用詳細情報作成
	//-----------------------------------------------------------------------------------------------------------
	NSArray *serviceDetails	= [data objectForKey:KEY_SERVICE];				// 施設情報の詳細
	if (serviceDetails == nil) {											// Nilの場合は作成しない
		return YES;
	}
	for (NSDictionary *serviceDetail in serviceDetails) {
		// バリアフリー利用詳細情報の空レコード生成
		 ServiceDetail *service = [NSEntityDescription insertNewObjectForEntityForName:ENTITY_SERVICE
															  inManagedObjectContext:self.managedObjectContext];
		// バリアフリー情報を追加
		service.barrierFree = barrier;
		// バリアフリー利用詳細情報を編集しCoreDataに登録する
		if (![self editServiceDitailData:service dic:serviceDetail]){
			return NO;
		}
	}
	return YES;
}

//---------------------------------------------------------------------------------------------------------------
// editBarrierFreeData
//
// バリアフリー情報を編集しCoreDataに登録する
//
// param		(BarrierFree *)rec						バリアフリーレコード
//				(NSDictionary*)data						メトロオープンデータバリアフリー情報
//
// return		(BOOL)									
//---------------------------------------------------------------------------------------------------------------
- (BOOL)editBarrierFreeData:(BarrierFree *)rec dic:(NSDictionary*)data
{
	//-----------------------------------------------------------------------------------------------------------
	// バリアフリー情報編集
	//-----------------------------------------------------------------------------------------------------------
	rec.name 		= [data objectForKey:KEY_CATEGORY_NAME];			// バリアフリー施設名
	rec.ucode 		= [data objectForKey:KEY_ID];						// 固有識別子(ucode)
	rec.sameAs 		= [data objectForKey:KEY_SAME_AS];					// 固有識別子
	rec.placeName	= [data objectForKey:KEY_PLACE];					// 施設の設置されている場所の名前
	rec.locatedArea	= [data objectForKey:KEY_AREA];						// 施設の設置場所（改札内／改札外）
	rec.remark		= [data objectForKey:KEY_REMARK];					// 補足事項
	//-----------------------------------------------------------------------------------------------------------
	// 多機能トイレ情報
	//-----------------------------------------------------------------------------------------------------------
	NSSet 		*assistants	= [data objectForKey:KEY_ASSIST];
	for (NSString *assistant in assistants) {
		NSString 	*conditions = [NSString stringWithFormat:@"%@ = \'%@\'", ATRBT_TOILET_ASST_CODE, assistant];
		NSArray  	*toilets 	= [self getData:ENTITY_TOILET_ASST Conditions:conditions Sorts:nil];
		if ([toilets count] == 0) {
			NSLog(@"多機能トイレ情報異常（%@）", assistant);
		}
		else {
			[rec addToiletAssistances:[NSSet setWithArray:toilets]];	// 多機能トイレ情報
		}
	}
	//-----------------------------------------------------------------------------------------------------------
	// 車いす利用可能情報
	//-----------------------------------------------------------------------------------------------------------
	NSString 	*available	= [data objectForKey:KEY_AVAILABLE];
	if (available != nil) {												// Nil以外の場合は登録
		NSString 	*conditions = [NSString stringWithFormat:@"%@ = \'%@\'", ATRBT_AVAILABLE_CODE, available];
		NSArray  	*availables = [self getData:ENTITY_AVAILABLE Conditions:conditions Sorts:nil];
		if ([availables count] != 1) {
			NSLog(@"車いす利用可能情報異常（%@）", available);
		}
		else {
			rec.available		= ((Available *)availables[0]).name;	// 車いす利用可能情報
		}
	}
	//-----------------------------------------------------------------------------------------------------------
	// バリアフリー情報更新
	//-----------------------------------------------------------------------------------------------------------
	NSError *error = Nil;
	if(![self.managedObjectContext save:&error]){
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		return NO;
	}
	return YES;
}

//---------------------------------------------------------------------------------------------------------------
// editServiceDitailData
//
// バリアフリー利用詳細情報を編集しCoreDataに登録する
//
// param		(ServiceDetail *)rec					バリアフリー利用詳細レコード
//				(NSDictionary*)data						メトロオープンデータバリアフリー情報
//
// return		(BOOL)
//---------------------------------------------------------------------------------------------------------------
- (BOOL)editServiceDitailData:(ServiceDetail *)rec dic:(NSDictionary*)data
{
//	static int cnt = 0;
//	cnt++;
//	NSLog(@"バリアフリー利用詳細情報件数（%d）",cnt);
	//-----------------------------------------------------------------------------------------------------------
	// バリアフリー利用詳細情報編集
	//-----------------------------------------------------------------------------------------------------------
	rec.operationDay	= [data objectForKey:KEY_OPERATION_DAY];			// 施設の利用可能曜日
	rec.startTime 		= [data objectForKey:KEY_START_TIME];				// 施設の利用可能開始時間
	rec.endTime 		= [data objectForKey:KEY_END_TIME];					// 施設の利用可能終了時間
	rec.direction 		= [data objectForKey:KEY_DIRECTION];				// エスカレータの方向
	//-----------------------------------------------------------------------------------------------------------
	// バリアフリー利用詳細更新
	//-----------------------------------------------------------------------------------------------------------
	NSError *error = Nil;
	if(![self.managedObjectContext save:&error]){
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		return NO;
	}
	return YES;
}

//---------------------------------------------------------------------------------------------------------------
// createPlatformData
//
// プラットホーム情報を更新する
// CoreDataに存在しない場合は新規作成，存在する場合は更新する
//
// param		(NSArray *)datas					バリアフリー情報
//				(Facility *)facility				施設情報
//
// return		void
//---------------------------------------------------------------------------------------------------------------
- (BOOL)createPlatformData:(NSArray *)datas Facility:(Facility *)facility
{
//	static int cnt = 0;
//	cnt = cnt + [datas count];
//	NSLog(@"プラットホーム情報件数（%d）",cnt);
	//-----------------------------------------------------------------------------------------------------------
	// 改札外の最寄り施設情報を削除する
	//-----------------------------------------------------------------------------------------------------------
	if (![self deleteSurroundingData:facility]){
		return NO;
	}
	//-----------------------------------------------------------------------------------------------------------
	// 乗換情報削除
	//-----------------------------------------------------------------------------------------------------------
	if (![self deleteTransferData:facility]){
		return NO;
	}
	//-------------------------------------------------------------------------------------------------------
	// プラットホーム情報削除
	//-------------------------------------------------------------------------------------------------------
	if (![self deletePlatformData:facility]) {
		return NO;
	}
	for(NSDictionary *data in datas) {
		//-------------------------------------------------------------------------------------------------------
		// プラットホーム情報新規作成
		//-------------------------------------------------------------------------------------------------------
		// プラットホーム情報の空レコード生成
		Platform *platform 	= [NSEntityDescription insertNewObjectForEntityForName:ENTITY_PLATFORM
															inManagedObjectContext:self.managedObjectContext];
		// プラットホーム情報を更新する
		if (![self editPlatformData:data Platform:platform Facility:facility]){
			return NO;
		}
		//-------------------------------------------------------------------------------------------------------
		// 乗換情報新規作成
		//-------------------------------------------------------------------------------------------------------
		NSArray *transfers	= [data objectForKey:KEY_TRANSFER];				// 乗換情報
		for(NSDictionary *transfer in transfers) {
			if (![self editTransferData:(NSDictionary*)transfer Platform:platform]) {
				return NO;
			}
		}
		//-------------------------------------------------------------------------------------------------------
		// 改札外の最寄り施設情報作成
		//-------------------------------------------------------------------------------------------------------
		NSArray *surrounds	= [data objectForKey:KEY_SURROUNDING];				// 改札外の最寄り施設
		for(NSString *surround in surrounds) {
			if (![self editSurroundingData:surround Platform:platform]){
				return NO;
			}
		}
	}
	return YES;
}

//---------------------------------------------------------------------------------------------------------------
// deletePlatformData
//
// プラットホーム情報を削除する
//
// param		(Facility *)facility					施設情報
//
// return		(BOOL)
//---------------------------------------------------------------------------------------------------------------
- (BOOL)deletePlatformData:(Facility *)facility
{
	NSString *conditions	= [NSString stringWithFormat:@"%@.%@ = '%@'",
							   ATRBT_PLATFORM_FACILITY, ATRBT_UCODE, facility.ucode];
	if (![self deleteData:ENTITY_PLATFORM Conditions:conditions]) {
		return NO;
	}
	return YES;
}

//---------------------------------------------------------------------------------------------------------------
// editPlatformData
//
// プラットホーム情報を編集しCoreDataに登録する
//
// param		(NSDictionary*)data						メトロオープンデータプラットホーム情報
// 				(Platform *)rec							プラットホームレコード
//				(Facility *)facility					施設情報
//
// return		(BOOL)
//---------------------------------------------------------------------------------------------------------------
- (BOOL)editPlatformData:(NSDictionary*)data Platform:(Platform *)rec Facility:(Facility *)facility
{
	//-----------------------------------------------------------------------------------------------------------
	// プラットホーム情報編集
	//-----------------------------------------------------------------------------------------------------------
	rec.carComposition	= [data objectForKey:KEY_CAR_COMPOS];			// 車両編成数
	rec.carNumber 		= [data objectForKey:KEY_CAR_NUM];				// 車両の号車番号
	rec.facility 		= facility;										// 施設情報
	// 列車方面マスタ取得
	NSString 	*direction	= [data objectForKey:KEY_RAIL_DIRECT];
	if (direction == nil) {												// Nil以外の場合は登録
		NSLog(@"プラットホーム情報の列車方面異常");
		return NO;
	}
	else {
		rec.railDirection	= [self getRailDirectionName:direction];	// プラットフォームに停車する列車の方面
	}
	// 最寄りのバリアフリー施設情報
	NSArray *sameAses	= [data objectForKey:KEY_BARRIER];				// 最寄りのバリアフリー施設
	for (NSString *sameAs in sameAses) {
		NSString *conditions 	= [NSString stringWithFormat:@"%@ = '%@'", ATRBT_BARRIER_SAMEAS, sameAs];
		NSArray  *barrierfrees	= [self getData:ENTITY_BARRIER Conditions:conditions Sorts:nil];
		if ([barrierfrees count] == 1) {
			[rec addBarrierFreesObject:barrierfrees[0]];				// 最寄りのバリアフリー施設登録
		}
		else {
			NSLog(@"<========== 最寄りのバリアフリー施設情報異常（%@）==========>", sameAs);
		}
	}
	//-----------------------------------------------------------------------------------------------------------
	// プラットホーム情報更新
	//-----------------------------------------------------------------------------------------------------------
	NSError *error = Nil;
	if(![self.managedObjectContext save:&error]){
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		return NO;
	}
	return YES;
}

//---------------------------------------------------------------------------------------------------------------
// deleteTransferData
//
// 乗換情報を削除する
//
// param		(Facility *)facility					施設情報
//
// return		(BOOL)
//---------------------------------------------------------------------------------------------------------------
- (BOOL)deleteTransferData:(Facility *)facility
{
	NSString *conditions =[NSString stringWithFormat:@"%@.%@.%@ = '%@'",
						   ATRBT_TRANSFER_PLATFORM, ATRBT_PLATFORM_FACILITY, ATRBT_UCODE, facility.ucode];
	if (![self deleteData:ENTITY_TRANSFER Conditions:conditions]) {
		return NO;
	}
	return YES;
}

//---------------------------------------------------------------------------------------------------------------
// editTransferData
//
// 乗換情報を更新する
//
// param		(NSDictionary*)data						メトロオープンデータプラットホーム情報
// 				(Platform *)platform					プラットホームレコード
//				(Facility *)facility					施設情報
//
// return		(BOOL)
//---------------------------------------------------------------------------------------------------------------
- (BOOL)editTransferData:(NSDictionary*)data Platform:(Platform *)platform
{
//	static int cnt = 0;
//	cnt++;
//	NSLog(@"乗換情報件数(%d)", cnt);
	// 乗換情報の空レコード生成
	Transfer *transfer 	= [NSEntityDescription insertNewObjectForEntityForName:ENTITY_TRANSFER
														inManagedObjectContext:self.managedObjectContext];
	transfer.railway		= [data objectForKey:KEY_RAILWAY];				// 乗換路線
	//  路線情報取得
	NSString 	*conditions = [NSString stringWithFormat:@"%@ = '%@'", ATRBT_LINE_SAMEAS, transfer.railway];
	NSArray  	*lines 		= [self getData:ENTITY_LINE Conditions:conditions Sorts:nil];
	if ([lines count] == 1) {
		transfer.line			= lines[0];									//   路線情報
	}
	else {
		NSLog(@"路線情報取得異常 (%@)", transfer.railway);
	}
	transfer.necessaryTime	= [data objectForKey:KEY_NECESSARY_TIME];		// 所要時間（分）
	transfer.platform		= platform;										// プラットホーム情報
	// 列車方面
	if ([data objectForKey:KEY_RAIL_DIRECT] == nil) {
		transfer.railDirection	= nil;
	} else {
		transfer.railDirection	= [self getRailDirectionName:[data objectForKey:KEY_RAIL_DIRECT]];
	}
	// 乗換情報更新
	NSError *error = Nil;
	if(![self.managedObjectContext save:&error]){
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		return NO;
	}
	return YES;
}

//---------------------------------------------------------------------------------------------------------------
// deleteSurroundingData
//
// 改札外の最寄り施設情報を削除する
//
// param		(Facility *)facility					施設情報
//
// return		(BOOL)
//---------------------------------------------------------------------------------------------------------------
- (BOOL)deleteSurroundingData:(Facility *)facility
{
	NSString *conditions =[NSString stringWithFormat:@"%@.%@.%@ = '%@'",
						   ATRBT_SURROUND_PLATFORM, ATRBT_PLATFORM_FACILITY, ATRBT_UCODE, facility.ucode];
	if (![self deleteData:ENTITY_SURROUND Conditions:conditions]) {
		return NO;
	}
	return YES;
}

//---------------------------------------------------------------------------------------------------------------
// editSurroundingData
//
// 改札外の最寄り施設情報を更新する
//
// param		(NSDictionary*)data						メトロオープンデータプラットホーム情報
// 				(Platform *)platform					プラットホームレコード
//				(Facility *)facility					施設情報
//
// return		(BOOL)
//---------------------------------------------------------------------------------------------------------------
- (BOOL)editSurroundingData:(NSString*)data Platform:(Platform *)platform
{
//	static int cnt = 0;
//	cnt++;
//	NSLog(@"改札外の最寄り施設件数(%d)", cnt);
	// 乗換情報の空レコード生成
	Surrounding *surround 	= [NSEntityDescription insertNewObjectForEntityForName:ENTITY_SURROUND
														inManagedObjectContext:self.managedObjectContext];
	surround.name			= data;											// 施設名
	surround.platform		= platform;										// プラットホーム情報
	// 改札外の最寄り施設情報更新
	NSError *error = Nil;
	if(![self.managedObjectContext save:&error]){
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		return NO;
	}
	return YES;
}

//---------------------------------------------------------------------------------------------------------------
// createMasterToiletAssistance
//
// 多機能トイレマスタを更新する
//
// param		なし
//
// return		void
//---------------------------------------------------------------------------------------------------------------
- (BOOL)createMasterToiletAssistance
{
	//-----------------------------------------------------------------------------------------------------------
	// 多機能トイレマスタを更新する
	//-----------------------------------------------------------------------------------------------------------
	if (![self createDatas:ENTITY_TOILET_ASST Plists:ENTITY_TOILET_ASST]){
		NSLog(@"createMasterToiletAssistance 更新エラー：多機能トイレマスタが異常です");
		return NO;
	}
	NSLog(@"<<<<<<<<<<<<<<<<<<<< 多機能トイレマスタ処理終了 >>>>>>>>>>>>>>>>>>>>");
	return YES;
}

//---------------------------------------------------------------------------------------------------------------
// createMasterAvailable
//
// 車イス利用可能マスタを更新する
//
// param		なし
//
// return		void
//---------------------------------------------------------------------------------------------------------------
- (BOOL)createMasterAvailable
{
	//-----------------------------------------------------------------------------------------------------------
	// 車イス利用可能マスタを更新する
	//-----------------------------------------------------------------------------------------------------------
	if (![self createDatas:ENTITY_AVAILABLE Plists:ENTITY_AVAILABLE]){
		NSLog(@"createMasterToiletAssistance 更新エラー：車イス利用可能マスタが異常です");
		return NO;
	}
	NSLog(@"<<<<<<<<<<<<<<<<<<<< 車イス利用可能マスタ処理終了 >>>>>>>>>>>>>>>>>>>>");
	return YES;
}

//---------------------------------------------------------------------------------------------------------------
// createMasterDirection
//
// 列車方面マスタを更新する
//
// param		なし
//
// return		void
//---------------------------------------------------------------------------------------------------------------
- (BOOL)createMasterDirection
{
	//-----------------------------------------------------------------------------------------------------------
	// 列車方面マスタを更新する
	//-----------------------------------------------------------------------------------------------------------
	if (![self createDatas:ENTITY_DIRECTION Plists:ENTITY_DIRECTION]){
		NSLog(@"createMasterToiletAssistance 更新エラー：列車方面マスタが異常です");
		return NO;
	}
	NSLog(@"<<<<<<<<<<<<<<<<<<<< 列車方面マスタ処理終了 >>>>>>>>>>>>>>>>>>>>");
	return YES;
}

//---------------------------------------------------------------------------------------------------------------
// createMasterOperator
//
// 運行会社マスタを更新する
//
// param		なし
//
// return		void
//---------------------------------------------------------------------------------------------------------------
- (BOOL)createMasterOperator
{
	//-----------------------------------------------------------------------------------------------------------
	// 運行会社マスタを更新する
	//-----------------------------------------------------------------------------------------------------------
	if (![self createDatas:ENTITY_OPERATOR Plists:ENTITY_OPERATOR]){
		NSLog(@"createMasterToiletAssistance 更新エラー：運行会社マスタが異常です");
		return NO;
	}
	NSLog(@"<<<<<<<<<<<<<<<<<<<< 運行会社マスタ処理終了 >>>>>>>>>>>>>>>>>>>>");
	return YES;
}

//---------------------------------------------------------------------------------------------------------------
// createMasterTrainType
//
// 列車種別マスタを更新する
//
// param		なし
//
// return		void
//---------------------------------------------------------------------------------------------------------------
- (BOOL)createMasterTrainType
{
	//-----------------------------------------------------------------------------------------------------------
	// 列車種別マスタを更新する
	//-----------------------------------------------------------------------------------------------------------
	if (![self createDatas:ENTITY_TRAIN_TYPE Plists:ENTITY_TRAIN_TYPE]){
		NSLog(@"createMasterToiletAssistance 更新エラー：列車種別マスタが異常です");
		return NO;
	}
	NSLog(@"<<<<<<<<<<<<<<<<<<<< 列車種別マスタ処理終了 >>>>>>>>>>>>>>>>>>>>");
	return YES;
}




//---------------------------------------------------------------------------------------------------------------
// getRailDirectionName
//
// 列車方面の日本語名を取得する
//
// param		(NSString*)code							列車方面コード
//
// return		(NSString*)								列車方面の日本語名
//---------------------------------------------------------------------------------------------------------------
- (NSString*)getRailDirectionName:(NSString*)code
{
	NSString 	*conditions = [NSString stringWithFormat:@"%@ = '%@'", ATRBT_DIRECTION_CODE, code];
	NSArray  	*directions = [self getData:ENTITY_DIRECTION Conditions:conditions Sorts:nil];
	if ([directions count] != 1) {
		NSLog(@"<========== 列車方面マスタ異常（%@）==========>", code);
		return nil;
	}
	return ((Direction *)directions[0]).name;
}

//---------------------------------------------------------------------------------------------------------------
// getTrainTypeName
//
// 列車種別の日本語名を取得する
//
// param		(NSString*)code							列車種別コード
//
// return		(NSString*)								列車種別の日本語名
//---------------------------------------------------------------------------------------------------------------
- (NSString*)getTrainTypeName:(NSString*)code
{
	NSString 	*conditions = [NSString stringWithFormat:@"%@ = '%@'", ATRBT_TYPE_CODE, code];
	NSArray  	*trainTypes = [self getData:ENTITY_TRAIN_TYPE Conditions:conditions Sorts:nil];
	if ([trainTypes count] != 1) {
		NSLog(@"<========== 列車種別マスタ異常（%@）==========>", code);
		return nil;
	}
	return ((TrainType *)trainTypes[0]).name;
}

//---------------------------------------------------------------------------------------------------------------
// getMetoroData
//
// メトロオープンデータ取得
//
// param		(NSString *)query						取得条件
//
// return		(NSArray *)								取得データ
//---------------------------------------------------------------------------------------------------------------
- (NSArray *)getMetoroData:(NSString *)query{
	// メトロオープンデータ接続クラスを生成
	MetoroCommunication *metoroComm = [[MetoroCommunication alloc] init];
	// メトロオープンデータ路線情報取得
	NSURL 	*url 	= [metoroComm createConnectDatasURL:query];
	NSArray *datas	= [metoroComm syncCommunication:url];
	return datas;
}

//---------------------------------------------------------------------------------------------------------------
// convIsoDate
//
// ISO8601日付時刻形式（2013-01-13T15:10:00+09:00）をNSDate型にする
//
// param		(NSString *)date						ISO8601日付時刻形式（文字列）
//
// return		void
//---------------------------------------------------------------------------------------------------------------
- (NSDate *)convIsoDate:(NSString *)stDate{
	NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ssZZZZ"];
	NSDate *date = [formatter dateFromString:stDate];
	return date;
}

@end
