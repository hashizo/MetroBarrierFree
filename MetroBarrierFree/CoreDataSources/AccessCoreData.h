//---------------------------------------------------------------------------------------------------------------
//  AccessCoreData.h
//  
//
//  データクラス
//
//  Created by yuta on 2013/07/20.
//  Copyright (c) 2013年 SunMeadow. All rights reserved.
//---------------------------------------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "ConnectCoreData.h"
#import "MetroCoreData.h"


@interface AccessCoreData : NSObject

//---------------------------------------------------------------------------------------------------------------
// プロパティ
//---------------------------------------------------------------------------------------------------------------
@property (strong, nonatomic) NSManagedObjectContext 		*managedObjectContext;
@property (strong, nonatomic) ConnectCoreData 				*connectCoreData;

//---------------------------------------------------------------------------------------------------------------
// メソッド
//---------------------------------------------------------------------------------------------------------------
- (id)initBundleSqliteCoreData;
- (id)initEmptyCoreData;

- (BOOL)		createData:			(NSString *)entity Data:(NSDictionary *)data;
- (BOOL)		createDatas:		(NSString *)entity Datas:(NSArray *)datas;
- (BOOL)		createDatas:		(NSString *)entity Plists:(NSString *)plistName;
- (NSArray *)	getPlistData: 		(NSString *)plistName;

- (NSInteger)	getDataCount:		(NSString *)entity;
- (BOOL)		deleteData:			(NSString *)entity Conditions:(NSString *)conditions;
- (BOOL)		deleteAllData:		(NSString *)entity;
- (BOOL)		isSQliteFile;
- (NSArray *)	getData:(NSString *)entity Conditions:(NSString *)conditions Sorts:(NSArray *)sortDescriptors;
- (NSArray *)	createSortDescriptors:(NSString *)sortkey SortOrdering:(BOOL)ascending;

- (NSExpressionDescription *)getExpressionDescription:(NSString *)name
								 KeyPath:(NSString *)key
								 ResultType:(NSAttributeType)Type;

- (NSExpressionDescription *)getExpressionDescriptionForAggregate:(NSString *)name
											 KeyPath:(NSString *)key
											Function:(NSString *)function
											 ResultType:(NSAttributeType)Type;


@end
