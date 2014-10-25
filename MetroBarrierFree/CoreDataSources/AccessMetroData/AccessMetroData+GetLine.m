//---------------------------------------------------------------------------------------------------------------
//  AccessMetroData+GetLine.m
//  MetroBarrierFree
//  路線名取得
//
//  Created by yuta on 2014/10/23.
//  Copyright (c) 2014年 501Software. All rights reserved.
//---------------------------------------------------------------------------------------------------------------
#import "AccessMetroData.h"

@implementation AccessMetroData (GetLine)
//---------------------------------------------------------------------------------------------------------------
// 路線名取得
//
// param		なし
//
// return		NSArray							路線
//---------------------------------------------------------------------------------------------------------------
- (NSArray *)getLine
{
	//-----------------------------------------------------------------------------------------------------------
	// 検索リクエストオブジェクトを作成する
	//-----------------------------------------------------------------------------------------------------------
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entityDescription = [NSEntityDescription entityForName:ENTITY_LINE
														 inManagedObjectContext:self.managedObjectContext];
	[fetchRequest setEntity:entityDescription];
	//-----------------------------------------------------------------------------------------------------------
	// SELECT句
	//-----------------------------------------------------------------------------------------------------------
	// 路線名
	self.lineName = [self getExpressionDescription:@"name"
										   KeyPath:@"name"
										ResultType:NSStringAttributeType];
	// セレクト句を作成
	[fetchRequest setPropertiesToFetch:[NSArray arrayWithObjects:self.lineName, nil]];
	[fetchRequest setReturnsDistinctResults:YES];				// DISTINCT設定
	//-----------------------------------------------------------------------------------------------------------
	// ソート順を設定
	//-----------------------------------------------------------------------------------------------------------
	NSArray *sortDescriptors = [self createSortDescriptors:@"ucode" SortOrdering:YES];
	[fetchRequest setSortDescriptors:sortDescriptors];

	//-----------------------------------------------------------------------------------------------------------
	// 結果出力型の設定
	//-----------------------------------------------------------------------------------------------------------
	[fetchRequest setResultType:NSDictionaryResultType];

	//-----------------------------------------------------------------------------------------------------------
	// 結果
	//-----------------------------------------------------------------------------------------------------------
	return [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
/*
	// 路線情報ソート条件作成
	NSArray *sorts = [self createSortDescriptors:@"ucode" SortOrdering:YES];
	// 路線情報取得
	return [self getData:ENTITY_LINE Conditions:nil Sorts:sorts];
*/
}

@end
