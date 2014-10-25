//---------------------------------------------------------------------------------------------------------------
//  AccessMetroData.h
//  MetroBarrierFree
//  メトロオープンデータから必要なデータを取得する
//
//
//  Created by yuta on 2014/10/23.
//  Copyright (c) 2014年 501Software. All rights reserved.
//---------------------------------------------------------------------------------------------------------------
#import "AccessCoreData.h"

@interface AccessMetroData : AccessCoreData
// SELECT句(property)
@property (nonatomic) NSExpressionDescription 		*lineName;					// 路線名
@end

@interface AccessMetroData (GetLine)
// Method
- (NSArray *)getLine;
@end
