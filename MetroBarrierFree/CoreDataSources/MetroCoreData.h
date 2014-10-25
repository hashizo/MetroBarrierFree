//---------------------------------------------------------------------------------------------------------------
//  MetroCoreData.h
//	コアデータ基本情報
//
//  Created by Yuta on 2014/10/03.
//  Copyright (c) 2014年 501SoftWare. All rights reserved.
//---------------------------------------------------------------------------------------------------------------
#ifndef MetroCoreData_h
#define MetroCoreData_h

//---------------------------------------------------------------------------------------------------------------
// エンティティ名（マスタ）
//---------------------------------------------------------------------------------------------------------------
#define ENTITY_TOILET_ASST		@"ToiletAssistance"		// 多機能トイレマスタ
#define ENTITY_AVAILABLE		@"Available"			// 車いす利用可能マスタ
#define ENTITY_DIRECTION		@"Direction"			// 列車方面マスタ
#define ENTITY_OPERATOR			@"Operator"				// 運行会社マスタ
#define ENTITY_TRAIN_TYPE		@"TrainType"			// 列車種別


//---------------------------------------------------------------------------------------------------------------
// エンティティ名（トランザクション）
//---------------------------------------------------------------------------------------------------------------
#define ENTITY_LINE				@"Line"					// 路線情報
#define ENTITY_STATION			@"Station"				// 駅情報
#define ENTITY_GATE				@"Gate"					// 出入口情報
#define ENTITY_FACILITY			@"Facility"				// 施設情報
#define ENTITY_BARRIER			@"BarrierFree"			// バリアフリー情報
#define ENTITY_SERVICE			@"ServiceDetail"		// バリアフリー施設利用詳細情報
#define ENTITY_PLATFORM			@"Platform"				// プラットホーム情報
#define ENTITY_SURROUND			@"Surrounding"			// 改札外の最寄り施設情報
#define ENTITY_TRANSFER			@"Transfer"				// 乗換情報
#define ENTITY_STATION_ORDER	@"StationOrder"			// 駅順序情報
#define ENTITY_TRAVEL_TIME		@"TravelTime"			// 駅間の標準所要時間情報
#define ENTITY_WOMEN_CAR		@"WomenCar"				// 女性専用車両情報

//---------------------------------------------------------------------------------------------------------------
// 一般属性（Attribute)
//---------------------------------------------------------------------------------------------------------------
#define ATRBT_NAME				@"name"					// 名
#define ATRBT_CODE				@"code"					// コード
#define ATRBT_UCODE				@"ucode"				// 固有識別子(ucode)
#define ATRBT_SAMEAS			@"sameAs"				// 固有識別子各命名ルールあり
#define ATRBT_DATE				@"date"					// 生成時刻(ISO8601 日付時刻形式)
#define ATRBT_OPERATOR			@"operator"				// 管理会社
#define ATRBT_LON				@"long"					// 駅度
#define ATRBT_LAT				@"lat"					// 緯度
#define ATRBT_LINE				@"line"					// 路線情報
#define ATRBT_PLATFORM			@"platform"				// プラットホーム情報
#define ATRBT_STATION			@"station"				// 駅情報
#define ATRBT_TIME				@"necessaryTime"		// 所要時間（分）
#define ATRBT_FROM_STATION		@"fromStation";			// 起点の駅
#define ATRBT_TO_STATION		@"toStation";			// 終点の駅
#define ATRBT_OPERATION_DAY		@"operationDay"			// 実施曜日
#define ATRBT_CAR_COMPOSITION	@"carComposition"		// 車両編成数
#define ATRBT_CAR_NUMBER		@"carNumber"			// 車両の号車番号


//---------------------------------------------------------------------------------------------------------------
// 多機能トイレマスタ属性（Attribute)
//---------------------------------------------------------------------------------------------------------------
#define ATRBT_TOILET_ASST_NAME	ATRBT_NAME				// 多機能トイレ名
#define ATRBT_TOILET_ASST_CODE	ATRBT_CODE				// 多機能トイレキー名

//---------------------------------------------------------------------------------------------------------------
// 車いす利用可能マスタ属性（Attribute)
//---------------------------------------------------------------------------------------------------------------
#define ATRBT_AVAILABLE_NAME	ATRBT_NAME				// 車いす利用可能情報
#define ATRBT_AVAILABLE_CODE	ATRBT_CODE				// 車いす利用可能キー

//---------------------------------------------------------------------------------------------------------------
// 列車方面マスタ属性（Attribute)
//---------------------------------------------------------------------------------------------------------------
#define ATRBT_DIRECTION_NAME	ATRBT_NAME				// 列車方面名
#define ATRBT_DIRECTION_CODE	ATRBT_CODE				// 列車方面キー

//---------------------------------------------------------------------------------------------------------------
// 運行会社マスタ属性（Attribute)
//---------------------------------------------------------------------------------------------------------------
#define ATRBT_OPERATOR_NAME		ATRBT_NAME				// 運行会社
#define ATRBT_OPERATOR_CODE		ATRBT_CODE				// 運行会社キー

//---------------------------------------------------------------------------------------------------------------
// 列車種別マスタ属性（Attribute)
//---------------------------------------------------------------------------------------------------------------
#define ATRBT_TYPE_NAME			ATRBT_NAME				// 列車種別
#define ATRBT_TYPE_CODE			ATRBT_CODE				// 列車種別キー


//---------------------------------------------------------------------------------------------------------------
// 施設情報属性（Attribute)
//---------------------------------------------------------------------------------------------------------------
#define ATRBT_FACILITY_UCODE	ATRBT_UCODE				// 固有識別子(ucode)
#define ATRBT_FACILITY_SAMEAS	ATRBT_SAMEAS			// 固有識別子
#define ATRBT_FACILITY_DATE		ATRBT_DATE				// 駅情報の生成時刻(ISO8601 日付時刻形式)

//---------------------------------------------------------------------------------------------------------------
// バリアフリー情報属性（Attribute)
//---------------------------------------------------------------------------------------------------------------
#define ATRBT_BARRIER_NAME		ATRBT_NAME				// 設備名
#define ATRBT_BARRIER_PLACE		@"placeName"			// 施設の設置されている場所の名前
#define ATRBT_BARRIER_AREA		@"locatedArea"			// 施設の設置場所（改札内／改札外）
#define ATRBT_BARRIER_AVAILABLE	@"available"			// 車いす利用情報
#define ATRBT_BARRIER_REMARK	@"remark"				// 補足事項
#define ATRBT_BARRIER_UCODE		ATRBT_UCODE				// 固有識別子(ucode)
#define ATRBT_BARRIER_SAMEAS	ATRBT_SAMEAS			// 固有識別子

//---------------------------------------------------------------------------------------------------------------
// バリアフリー施設利用詳細情報属性（Attribute)
//---------------------------------------------------------------------------------------------------------------
#define ATRBT_SERVICE_START		@"startTime"			// 利用開始時間
#define ATRBT_SERVICE_END		@"endTime"				// 利用終了時間
#define ATRBT_SERVICE_DAY		ATRBT_OPERATION_DAY		// 利用曜日
#define ATRBT_SERVICE_DIRECTION	@"direction"			// エスカレーターの方向
#define ATRBT_SERVICE_BARRIER	@"barrierFree"			// バリアフリー情報

//---------------------------------------------------------------------------------------------------------------
// プラットホーム情報属性（Attribute)
//---------------------------------------------------------------------------------------------------------------
#define ATRBT_PLATFORM_COMPOS	ATRBT_CAR_COMPOSITION	// 車両編成数
#define ATRBT_PLATFORM_NUMBER	ATRBT_CAR_NUMBER		// 車両の号車番号
#define ATRBT_PLATFORM_DIRECT	@"railDirection"		// プラットフォームに停車する列車の方面
#define ATRBT_PLATFORM_FACILITY	@"facility"				// 施設情報

//---------------------------------------------------------------------------------------------------------------
// 改札外の最寄り施設情報属性（Attribute)
//---------------------------------------------------------------------------------------------------------------
#define ATRBT_SURROUND_NAME		ATRBT_NAME				// 施設名
#define ATRBT_SURROUND_PLATFORM	ATRBT_PLATFORM			// プラットホーム情報

//---------------------------------------------------------------------------------------------------------------
// 乗換情報属性（Attribute)
//---------------------------------------------------------------------------------------------------------------
#define ATRBT_TRANSFER_TIME		ATRBT_TIME				// 所要時間（分）
#define ATRBT_TRANSFER_DIRECT	@"railDirection"		// 乗り換え可能路線の方面
#define ATRBT_TRANSFER_RAILWAY	@"railway"				// 乗り換え可能路線
#define ATRBT_TRANSFER_PLATFORM	ATRBT_PLATFORM			// プラットホーム情報

//---------------------------------------------------------------------------------------------------------------
// 路線情報属性（Attribute)
//---------------------------------------------------------------------------------------------------------------
#define ATRBT_LINE_NAME			ATRBT_NAME				// 運行系統名
#define ATRBT_LINE_CODE			ATRBT_CODE				// 路線コード
#define ATRBT_LINE_OPERATOR		@"operate"				// 運行会社
#define ATRBT_LINE_UCODE		ATRBT_UCODE				// 固有識別子(ucode)。支線には別IDを割り当てる
#define ATRBT_LINE_SAMEAS		ATRBT_SAMEAS			// 固有識別子 命名ルール:odpt.Railway:TokyoMetro.路線名
#define ATRBT_LINE_DATE			ATRBT_DATE				// 駅情報の生成時刻(ISO8601 日付時刻形式)

//---------------------------------------------------------------------------------------------------------------
// 駅順序情報属性（Attribute)
//---------------------------------------------------------------------------------------------------------------
#define ATRBT_ORDER				@"order"				// 駅順序
#define ATRBT_ORDER_CODE		ATRBT_CODE				// 駅コード
#define ATRBT_ORDER_LINE		ATRBT_LINE				// 路線情報

//---------------------------------------------------------------------------------------------------------------
// 駅間の標準所要時間情報属性（Attribute)
//---------------------------------------------------------------------------------------------------------------
#define ATRBT_TRAVEL_FROM		ATRBT_FROM_STATION		// 駅間の起点
#define ATRBT_TRAVEL_TO			ATRBT_TO_STATION		// 駅間の終点
#define ATRBT_TRAVEL_TIME		ATRBT_TIME				// 所要時間（分）
#define ATRBT_TRAVEL_TYPE 		@"trainType"			// 列車種別
#define ATRBT_TRAVEL_LINE		ATRBT_LINE				// 路線情報

//---------------------------------------------------------------------------------------------------------------
// 女性専用車両情報属性（Attribute)
//---------------------------------------------------------------------------------------------------------------
#define ATRBT_WOMEN_FROM		ATRBT_FROM_STATION		// 女性専用車両開始駅
#define ATRBT_WOMEN_TO			ATRBT_TO_STATION		// 女性専用車両終了駅
#define ATRBT_WOMEN_DAY 		ATRBT_OPERATION_DAY		// 女性専用車両実施曜日
#define ATRBT_WOMEN_START		@"startTime"			// 女性専用車両開始時間
#define ATRBT_WOMEN_UNTIL		@"untilTime"			// 女性専用車両終了時間
#define ATRBT_WOMEN_COMPOS		ATRBT_CAR_COMPOSITION	// 車両編成数
#define ATRBT_WOMEN_NUMBER		ATRBT_CAR_NUMBER		// 女性専用車両実施車両号車番号
#define ATRBT_WOMEN_LINE		ATRBT_LINE				// 路線情報

//---------------------------------------------------------------------------------------------------------------
// 出入口情報属性（Attribute)
//---------------------------------------------------------------------------------------------------------------
#define ATRBT_GATE_NAME			ATRBT_NAME				// 出入口名
#define ATRBT_GATE_FLOOR		@"floor"				// 地物の階数
#define ATRBT_GATE_UCODE		ATRBT_UCODE				// 固有識別子(ucode)
#define ATRBT_GATE_LON			ATRBT_LON				// 経度
#define ATRBT_GATE_LAT			ATRBT_LAT				// 緯度
#define ATRBT_GATE_STATION		ATRBT_STATION			// 駅情報

//---------------------------------------------------------------------------------------------------------------
// 駅情報属性（Attribute)
//---------------------------------------------------------------------------------------------------------------
#define ATRBT_STASION_NAME		ATRBT_NAME				// 駅名
#define ATRBT_STASION_CODE		ATRBT_CODE				// 駅コード
#define ATRBT_STASION_UCODE		ATRBT_UCODE				// 固有識別子(ucode)
#define ATRBT_STASION_SAMEAS	ATRBT_SAMEAS			// 固有識別子 
#define ATRBT_STASION_DATE		ATRBT_DATE				// 駅情報の生成時刻(ISO8601 日付時刻形式)
#define ATRBT_STASION_OPERATOR	ATRBT_OPERATOR			// 管理会社
#define ATRBT_STASION_LON		ATRBT_LON				// 代表点の経度
#define ATRBT_STASION_LAT		ATRBT_LAT				// 代表点の緯度
#define	ATRBT_STASION_LINE		ATRBT_LINE				// 路線情報

#endif
