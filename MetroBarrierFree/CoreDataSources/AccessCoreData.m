//---------------------------------------------------------------------------------------------------------------
//  AccessCoreData.m
//  
//
//  データを作成する
//
//  Created by yuta on 2013/07/20.
//  Copyright (c) 2013年 SunMeadow. All rights reserved.
//---------------------------------------------------------------------------------------------------------------
#import "AccessCoreData.h"

@implementation AccessCoreData

//---------------------------------------------------------------------------------------------------------------
// init
//
// 初期処理
//
// param		なし
//
// return		id
//---------------------------------------------------------------------------------------------------------------
- (id)init {

	self = [super init];
	if (self != nil) {
		// コアデータを初期化
		self.connectCoreData = [[ConnectCoreData alloc] initBundleSqliteCoreData];
		self.managedObjectContext = [self.connectCoreData managedObjectContext];
    }

    return self;
}

//---------------------------------------------------------------------------------------------------------------
// initEmptyCoreData
//
// 初期処理
// 新規の場合に空のCoreDataを作成する
//
// param		なし
//
// return		id
//---------------------------------------------------------------------------------------------------------------
- (id)initEmptyCoreData {
	self = [super init];
	if (self != nil) {
		// コアデータを初期化
		self.connectCoreData = [[ConnectCoreData alloc] initEmptyCoreData];
		self.managedObjectContext = [self.connectCoreData managedObjectContext];
    }
    return self;
}

//---------------------------------------------------------------------------------------------------------------
// initBundleSqliteCoreData
//
// 初期処理
// 新規の場合にバンドルしたSQLiteFileからCoreDataを作成する
//
// param		なし
//
// return		id
//---------------------------------------------------------------------------------------------------------------
- (id)initBundleSqliteCoreData {
	self = [super init];
	if (self != nil) {
		// コアデータを初期化
		self.connectCoreData = [[ConnectCoreData alloc] initBundleSqliteCoreData];
		self.managedObjectContext = [self.connectCoreData managedObjectContext];
	}
    return self;
}

//---------------------------------------------------------------------------------------------------------------
// createData
//
// データをエンティティに登録する
//
// param		(NSString *)entity					エンティティ名
// 				(NSArray *)data						データ
//
// return		void
//---------------------------------------------------------------------------------------------------------------
- (BOOL)createData:(NSString *)entity ManagedObject:(NSManagedObject *)data
{
	// データ登録
	[self.managedObjectContext insertObject:data];
	return YES;
}

//---------------------------------------------------------------------------------------------------------------
// createData
//
// データをエンティティに登録する
//
// param		(NSString *)entity					エンティティ名
// 				(NSArray *)data						データ
//
// return		void
//---------------------------------------------------------------------------------------------------------------
- (BOOL)createData:(NSString *)entity Data:(NSDictionary *)data
{
	// エンティティオブジェクト生成
	NSManagedObject *managedObject = [NSEntityDescription
										 insertNewObjectForEntityForName:entity
										 inManagedObjectContext:self.managedObjectContext];
	// データ登録
	NSError *error = nil;
	[managedObject setValuesForKeysWithDictionary:data];
	if(![self.managedObjectContext save:&error]){
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		return NO;
	}
	return YES;
}

//---------------------------------------------------------------------------------------------------------------
// createDatas
//
// データをエンティティに登録する
//
// param		(NSString *)entity					エンティティ名
// 				(NSArray *)data						データ
//
// return		void
//---------------------------------------------------------------------------------------------------------------
- (BOOL)createDatas:(NSString *)entity Datas:(NSArray *)datas
{
	for(NSDictionary *data in datas) {
		// エンティティオブジェクト生成
		NSManagedObject *managedObject = [NSEntityDescription
											 insertNewObjectForEntityForName:entity
											 inManagedObjectContext:self.managedObjectContext];
		// データ登録
		NSError *error = nil;
		[managedObject setValuesForKeysWithDictionary:data];
		if(![self.managedObjectContext save:&error]){
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			return NO;
		}
	}
	return YES;
}

//---------------------------------------------------------------------------------------------------------------
// createDatas
//
// PListをエンティティに登録する
//
// param		(NSString *)entity					エンティティ名
// 				(NSString *)plistName				Plist名
//
// return		void
//---------------------------------------------------------------------------------------------------------------
- (BOOL)createDatas:(NSString *)entity Plists:(NSString *)plistName
{
	// Plistデータ取得
	NSArray *datas = [self getPlistData:plistName];
	// Plistデータ取得失敗
	if (datas == nil){
		NSLog(@"Plistデータ取得失敗");
		return NO;
	}
	// データをエンティティに登録する
	return [self createDatas:entity Datas:datas];
}

//---------------------------------------------------------------------------------------------------------------
// getPlistData
//
// PlistからデータをNSArray型で取得する
//
// param		(NSString *)plistName				Plist名
//
// return		(NSArray *)data						取得データ
//---------------------------------------------------------------------------------------------------------------
- (NSArray *)getPlistData: (NSString *)plistName
{
	// plistファイル情報を取得
	NSBundle	*bundle	= [NSBundle mainBundle];
	NSString	*path 	= [bundle pathForResource:plistName ofType:@"plist"];
	NSArray 	*data 	= [NSArray arrayWithContentsOfFile:path];
	return data;
}

//---------------------------------------------------------------------------------------------------------------
// getDataCount
//
// データ件数確認
//
// param		なし
//
// return		id
//---------------------------------------------------------------------------------------------------------------
- (NSInteger)getDataCount:(NSString *)entity  {

	//-----------------------------------------------------------------------------------------------------------
	// 検索リクエストオブジェクトを作成する
	//-----------------------------------------------------------------------------------------------------------
	// 検索リクエストオブジェクト生成
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	// 対象エンティティの取得
	NSEntityDescription *entityDescription = [NSEntityDescription entityForName:entity
														 inManagedObjectContext:self.managedObjectContext];
	[fetchRequest setEntity:entityDescription];

	//-----------------------------------------------------------------------------------------------------------
	// SELECT句を作成する
	//-----------------------------------------------------------------------------------------------------------
	NSExpressionDescription			*dataCount;									// データ件数

	// 合計数
	dataCount	= [self getExpressionDescriptionForAggregate:@"dataCount"
									  	KeyPath:@"_pk"
									   Function:@"count:"
									    ResultType:NSInteger32AttributeType];
	// SELECT句を生成
	[fetchRequest setPropertiesToFetch:[NSArray arrayWithObjects:dataCount,Nil]];

	//-----------------------------------------------------------------------------------------------------------
	// 結果出力型の設定
	//-----------------------------------------------------------------------------------------------------------
	[fetchRequest setResultType:NSDictionaryResultType];

	//-----------------------------------------------------------------------------------------------------------
	// 結果
	//-----------------------------------------------------------------------------------------------------------
	NSError *error = nil;
	NSArray *data =[self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
	if(data == Nil){
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		return NO;
	}

	return [[[data objectAtIndex:0] valueForKey:dataCount.name] integerValue];


//	return [[[[self.managedObjectContext executeFetchRequest:fetchRequest error:nil]
//			  									objectAtIndex:0] valueForKey:dataCount.name] integerValue];

}

//---------------------------------------------------------------------------------------------------------------
// deleteAllData
//
// エンティティからデータを全件削除する
//
// param		(NSString *)entity					エンティティ名
//
// return		void
//---------------------------------------------------------------------------------------------------------------
- (BOOL)deleteAllData:(NSString *)entity {
	NSError 	*error;

	//-----------------------------------------------------------------------------------------------------------
	// 条件を作成する（全件）
	//-----------------------------------------------------------------------------------------------------------
	// 検索リクエストオブジェクト生成
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];

	// 対象エンティティの取得
	NSEntityDescription *entityDescription = [NSEntityDescription entityForName:entity
														 inManagedObjectContext:self.managedObjectContext];
	[fetchRequest setEntity:entityDescription];

    // バッチサイズ設定
	[fetchRequest setFetchBatchSize:20];

	//-----------------------------------------------------------------------------------------------------------
	// 全件削除する
	//-----------------------------------------------------------------------------------------------------------
	NSArray *arrayFatch = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
	for (NSManagedObject *object in arrayFatch) {
		[self.managedObjectContext deleteObject:object];
	}

	error = Nil;
	if(![self.managedObjectContext save:&error]){
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		return NO;
	}

	return YES;
}

//---------------------------------------------------------------------------------------------------------------
// getData
//
// エンティティからデータを取得する
//
// param		(NSString *)conditions					取得条件
//				(NSArray *)sortDescriptors				ソート順
//
// return		(NSArray *)								取得データ			
//---------------------------------------------------------------------------------------------------------------
- (NSArray *)getData:(NSString *)entity Conditions:(NSString *)conditions Sorts:(NSArray *)sortDescriptors
{
	NSError *error = nil;
	//-----------------------------------------------------------------------------------------------------------
	//  検索リクエストオブジェクトを作成する
	//-----------------------------------------------------------------------------------------------------------
	// 検索リクエストオブジェクト生成
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];

	// 対象エンティティの取得
	NSEntityDescription *entityDescription = [NSEntityDescription entityForName:entity
														 inManagedObjectContext:self.managedObjectContext];
	[fetchRequest setEntity:entityDescription];

    // バッチサイズ設定
	[fetchRequest setFetchBatchSize:20];

	// 検索条件設定
	NSPredicate *pred = [NSPredicate predicateWithFormat:conditions];
	[fetchRequest setPredicate:pred];

	// ソート順設定
	[fetchRequest setSortDescriptors:sortDescriptors];

	//-----------------------------------------------------------------------------------------------------------
	// データ取得
	//-----------------------------------------------------------------------------------------------------------
	[fetchRequest setEntity:[NSEntityDescription entityForName:entity
										inManagedObjectContext:self.managedObjectContext]];
	NSArray *lists = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
	if (error){
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		return nil;
	}

	return lists;
}

//---------------------------------------------------------------------------------------------------------------
// createSortDescriptors
//
// ソート条件を作成する
//
// param		(NSString *)key							ソートキー
// 				(BOOL)ascending							ソート順
//
// return		(NSArray *)								取得条件
//---------------------------------------------------------------------------------------------------------------
- (NSArray *)createSortDescriptors:(NSString *)sortkey SortOrdering:(BOOL)ascending {

    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:sortkey ascending:ascending];
    NSArray *sortDescriptors = @[sortDescriptor];

	return sortDescriptors;

}

//---------------------------------------------------------------------------------------------------------------
// getExpressionDescription
//
// セレクト句の項目の作成
//
// param		(NSString *)name						項目名
//				(NSString *)key							項目のDB上のキーパス
//				(BOOL)ascending							項目の型
//
// return		(NSArray *)								取得条件
//---------------------------------------------------------------------------------------------------------------
- (NSExpressionDescription *)getExpressionDescription:(NSString *)name
											  KeyPath:(NSString *)key
										   ResultType:(NSAttributeType)Type
{
	//-----------------------------------------------------------------------------------------------------------
	// 項目の初期化
	//-----------------------------------------------------------------------------------------------------------
	NSExpressionDescription *item = [[NSExpressionDescription alloc] init];

	//-----------------------------------------------------------------------------------------------------------
	// 項目のキーパスを作成
	//-----------------------------------------------------------------------------------------------------------
	NSExpression *itemKeyPath = [NSExpression expressionForKeyPath:key];
	
	//-----------------------------------------------------------------------------------------------------------
	// 項目の作成
	//-----------------------------------------------------------------------------------------------------------
	// 項目名の設定
	[item setName:name];
	// 項目のキーパス設定
	[item setExpression:itemKeyPath];
	// 項目のキーパス設定
	[item setExpressionResultType:Type];

	return item;
}

//---------------------------------------------------------------------------------------------------------------
// getExpressionDescriptionForAggregate
//
// セレクト句の集計関数項目の作成
//
// param		(NSString *)name						項目名
//				(NSString *)key							項目のDB上のキーパス
//				(NSString *)function					集計関数
//				(BOOL)ascending							項目の型
//
// return		(NSArray *)								取得条件
//---------------------------------------------------------------------------------------------------------------
- (NSExpressionDescription *)getExpressionDescriptionForAggregate:(NSString *)name
														  KeyPath:(NSString *)key
														 Function:(NSString *)function
													   ResultType:(NSAttributeType)Type
{
	//-----------------------------------------------------------------------------------------------------------
	// 項目の初期化
	//-----------------------------------------------------------------------------------------------------------
	NSExpressionDescription *item = [[NSExpressionDescription alloc] init];
	
	//-----------------------------------------------------------------------------------------------------------
	// 項目のキーパスを作成
	//-----------------------------------------------------------------------------------------------------------
	NSExpression *itemKeyPath = [NSExpression expressionForKeyPath:key];
	
	//-----------------------------------------------------------------------------------------------------------
	//集計関数の作成
	//-----------------------------------------------------------------------------------------------------------
	NSExpression *expression = [NSExpression expressionForFunction:function
														 arguments:[NSArray arrayWithObject:itemKeyPath]];
	
	//-----------------------------------------------------------------------------------------------------------
	// 項目の作成
	//-----------------------------------------------------------------------------------------------------------
	// 項目名の設定
	[item setName:name];
	// 項目のキーパス設定
	[item setExpression:expression];
	// 項目のキーパス設定
	[item setExpressionResultType:Type];
	
	return item;
}

//---------------------------------------------------------------------------------------------------------------
// deleteData
//
// エンティティからデータを削除する
//
// param		(NSString *)conditions					取得条件
//
// return		(NSArray *)								取得データ
//---------------------------------------------------------------------------------------------------------------
- (BOOL)deleteData:(NSString *)entity Conditions:(NSString *)conditions
{
	//-----------------------------------------------------------------------------------------------------------
	// 削除するレコードを取得する
	//-----------------------------------------------------------------------------------------------------------
	NSArray *datas = [self getData:entity Conditions:conditions Sorts:nil];

	//-----------------------------------------------------------------------------------------------------------
	// レコードを削除する
	//-----------------------------------------------------------------------------------------------------------
	for (NSManagedObject *data in datas) {
		[self.managedObjectContext deleteObject:data];
	}

	//-----------------------------------------------------------------------------------------------------------
	// コミット
	//-----------------------------------------------------------------------------------------------------------
	NSError *error = nil;
	if(![self.managedObjectContext save:&error]){
		NSLog(@"deleteData error %@, %@", error, [error userInfo]);
		return NO;
	}
	return YES;
}

//---------------------------------------------------------------------------------------------------------------
// isData
//
// 最新の武器鍛冶データが存在するか確認する
//
// param		なし
//
// return		(BOOL)								存在する(YES) 存在しない(NO)
//---------------------------------------------------------------------------------------------------------------
- (BOOL)isSQliteFile {

	// 存在確認
	return [self.connectCoreData isSQliteFile];

}
@end
