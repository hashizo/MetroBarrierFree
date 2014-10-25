//-------------------------------------------------------------------------------------------------------------------
//  ConnectCoreData.m
//  
//
//  CoreData接続クラス
//
//  Created by yuta on 2013/09/07.
//  Copyright (c) 2013年 SunMeadow. All rights reserved.
//---------------------------------------------------------------------------------------------------------------
#import "ConnectCoreData.h"

@implementation ConnectCoreData


#pragma mark - Init
//---------------------------------------------------------------------------------------------------------------
// init
//
// 初期処理（新規の場合に空のCoreDataを作成する）
//
// param		なし
//
// return		id
//---------------------------------------------------------------------------------------------------------------
- (id)init {
	self = [super init];
	if (self != nil) {
		// CoreData作成タイプを初期化
		self.coredataCreateType = EMPTY_DATA;
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
		// CoreData作成タイプを初期化
		self.coredataCreateType = EMPTY_DATA;
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
		// CoreData作成タイプを初期化
		self.coredataCreateType = BUNDLE_SQLITE_FILE;
   
		// データベースのバージョンを確認して古い場合は、最新のバンドルデータベースをコピーする
		[self checkDataBaseVersion];
	}
    return self;
}

#pragma mark - Core Data stack
//---------------------------------------------------------------------------------------------------------------
// managedObjectContext
//
// アプリケーションの管理対象オブジェクトコンテキストを返却
//
// param		なし
//
// return		NSManagedObjectContext*			管理対象オブジェクトコンテキスト
//---------------------------------------------------------------------------------------------------------------
- (NSManagedObjectContext *)managedObjectContext {

	static NSManagedObjectContext *managedObjectContext = nil;
	static dispatch_once_t onceToken;
	
	dispatch_once(&onceToken, ^
	{
		NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
		if (coordinator != nil) {
			managedObjectContext = [[NSManagedObjectContext alloc] init];
			[managedObjectContext setPersistentStoreCoordinator: coordinator];
		}
	});
	
	return managedObjectContext;
}

//---------------------------------------------------------------------------------------------------------------
// managedObjectModel
//
// アプリケーションの管理対象オブジェクトモデルを返却
//
// param		なし
//
// return		NSManagedObjectModel *			管理対象オブジェクトモデル
//---------------------------------------------------------------------------------------------------------------
- (NSManagedObjectModel *)managedObjectModel {

	static NSManagedObjectModel *managedObjectModel = nil;
	static dispatch_once_t onceToken;
	
	dispatch_once(&onceToken, ^
	{
		NSURL *modelURL = [[NSBundle mainBundle] URLForResource:RESOURCE_FILE_NAME
															withExtension:COREDATA_FILE_TYPE];
		managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
	});
	
	return managedObjectModel;
}

//---------------------------------------------------------------------------------------------------------------
// persistentStoreCoordinator
//
// アプリケーションの永続ストアコーディネータを返却
//
// param		なし
//
// return		NSPersistentStoreCoordinator *		永続ストアコーディネータ
//---------------------------------------------------------------------------------------------------------------
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {

	static NSPersistentStoreCoordinator *persistentStoreCoordinator = nil;
	static dispatch_once_t onceToken;

	dispatch_once(&onceToken, ^
	{
		NSError *error;
		//-------------------------------------------------------------------------------------------------------
		// CoreData用Sqliteデータのパスを作成する
		//-------------------------------------------------------------------------------------------------------
		NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:
						   [NSString stringWithFormat:@"%@.%@", RESOURCE_FILE_NAME, SQLITE_FILE_TYPE]];
	
		//-------------------------------------------------------------------------------------------------------
		// CoreData用Sqliteデータの存在を確認する
		//-------------------------------------------------------------------------------------------------------
		if ([storeURL checkResourceIsReachableAndReturnError:&error] == NO) {
			// CoreData用Sqliteデータがない場合
			[self setIsSQliteFile:NO];

			//-----------------------------------------------------------------------------------------------
			// バンドルしてるCoreData用Sqliteデータを利用する場合
			//-----------------------------------------------------------------------------------------------
			if (self.coredataCreateType == BUNDLE_SQLITE_FILE){
				// バンドルしているSQLiteファイルを使えるようにコピーする
				[self copyNewStore];
			}
		}
		else {
			// CoreData用Sqliteデータがある場合
			[self setIsSQliteFile:YES];
		}

		//-------------------------------------------------------------------------------------------------------
		// 永続ストアコーディネータを生成する
		//-------------------------------------------------------------------------------------------------------
		persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc]
									  initWithManagedObjectModel:[self managedObjectModel]];

		if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil
																URL:storeURL options:nil error:&error]) {

			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			NSLog(@"CoreDataアクセスクラス：アプリケーションの永続ストアコーディネータを返却に失敗[%s:%d]"
																						,__FILE__,__LINE__);
			abort();
		}
	});
	
	return persistentStoreCoordinator;
}

#pragma mark - Application's documents directory
//---------------------------------------------------------------------------------------------------------------
// applicationDocumentsDirectory
//
// アプリケーションのドキュメントディレクトリを返却
//
// param		なし
//
// @return		NSURL *						ドキュメントディレクトリ
//---------------------------------------------------------------------------------------------------------------
- (NSURL *)applicationDocumentsDirectory {
	return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
												   inDomains:NSUserDomainMask] lastObject];
}

#pragma mark - New Store Copy
//---------------------------------------------------------------------------------------------------------------
// copyNewStore
//
// バンドルしているSQLiteファイルを使えるようにコピーする
//
// param		なし
//
// @return		なし
//---------------------------------------------------------------------------------------------------------------
- (void)copyNewStore {

	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^
	{
		//-------------------------------------------------------------------------------------------------------
		// アプリが利用するSQLiteのURLを取得
		//-------------------------------------------------------------------------------------------------------
		NSURL *storeURL    = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:
						   [NSString stringWithFormat:@"%@.%@", RESOURCE_FILE_NAME, SQLITE_FILE_TYPE]];

		NSURL *storeURLshm = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:
						   [NSString stringWithFormat:@"%@.%@", RESOURCE_FILE_NAME, SQLITE_SHM_FILE_TYPE]];

		NSURL *storeURLwal = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:
						   [NSString stringWithFormat:@"%@.%@", RESOURCE_FILE_NAME, SQLITE_WAL_FILE_TYPE]];
	
		
		NSLog(@"storeURL    (%@)",storeURL);
		NSLog(@"storeURLshm (%@)",storeURLshm);
		NSLog(@"storeURLwal (%@)",storeURLwal);

		//-------------------------------------------------------------------------------------------------------
		// バンドルしているSQLiteのURLを取得
		//-------------------------------------------------------------------------------------------------------
		NSURL *defaultStoreURL = [[NSBundle mainBundle]
								  URLForResource:RESOURCE_FILE_NAME withExtension:SQLITE_FILE_TYPE];

		NSURL *defaultStoreURLshm = [[NSBundle mainBundle]
								  URLForResource:RESOURCE_FILE_NAME withExtension:SQLITE_SHM_FILE_TYPE];

		NSURL *defaultStoreURLwal = [[NSBundle mainBundle]
									 URLForResource:RESOURCE_FILE_NAME withExtension:SQLITE_WAL_FILE_TYPE];

		NSLog(@"defaultStoreURL    (%@)",defaultStoreURL);
		NSLog(@"defaultStoreURLshm (%@)",defaultStoreURLshm);
		NSLog(@"defaultStoreURLwal (%@)",defaultStoreURLwal);

		//-------------------------------------------------------------------------------------------------------
		// バンドルしているSQLiteをURLをアプリが利用するSQLiteのURLにコピー
		//-------------------------------------------------------------------------------------------------------
		if (defaultStoreURL) {
			NSFileManager *fileManager = [NSFileManager defaultManager];
			
			// 古いバージョンのSQLiteファイルを削除
			[fileManager removeItemAtURL:storeURL		error:nil];
			[fileManager removeItemAtURL:storeURLshm	error:nil];
			[fileManager removeItemAtURL:storeURLwal	error:nil];

			// SQLiteファイルコピー
			if ([fileManager fileExistsAtPath:[defaultStoreURL path]]){
				[fileManager copyItemAtURL:defaultStoreURL toURL:storeURL error:nil];
			}
			if ([fileManager fileExistsAtPath:[defaultStoreURLshm path]]){
				[fileManager copyItemAtURL:defaultStoreURLshm toURL:storeURLshm error:nil];
			}
			if ([fileManager fileExistsAtPath:[defaultStoreURLwal path]]){
				[fileManager copyItemAtURL:defaultStoreURLwal toURL:storeURLwal error:nil];
			}
		}
	});
}

//---------------------------------------------------------------------------------------------------------------
// checkDataBaseVersion
//
// データベースのバージョンを確認して古い場合は、最新のバンドルデータベースをコピーする
//
// param		なし
//
// @return		なし
//---------------------------------------------------------------------------------------------------------------
- (void) checkDataBaseVersion {
	
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^
	{
		//-------------------------------------------------------------------------------------------------------
		// データベースバージョン情報を取得
		//-------------------------------------------------------------------------------------------------------
		// VersionプロパティリストのURLを取得
		NSURL *versionURL = [[NSBundle mainBundle] URLForResource:COREDATA_PLIST_NAME withExtension:PLIST_FILE_TYPE];
		
		// Versionプロパティリストを取得する
		NSMutableDictionary *versionList = [NSMutableDictionary dictionaryWithContentsOfURL:versionURL];
		
		// データベースバージョンを取得
		NSString *dataBaseVersion = [versionList objectForKey:KEY_DATABASE_VERSION];
/*
		NSString *str = [NSString stringWithFormat:@"データベースNo1         = %@\n",dataBaseVersion];
		NSLog(@"%@" ,str);
		UIAlertView *alert	= [[UIAlertView alloc]init];
		alert.title			= @"データベースVersion①";
		alert.message		= dataBaseVersion;
		[alert addButtonWithTitle:@"OK"];
		[alert show];
*/
		//-------------------------------------------------------------------------------------------------------
		// バンドルバージョン情報を取得する
		//-------------------------------------------------------------------------------------------------------
		NSString *bundleVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
/*
		str = [NSString stringWithFormat:@"バンドルバージョンNo = %@\n",bundleVersion];
		NSLog(@"%@" ,str);
*/
		//-------------------------------------------------------------------------------------------------------
		// データベースバージョンとバンドルバージョンを比較する
		//-------------------------------------------------------------------------------------------------------
		if (![dataBaseVersion isEqualToString:bundleVersion]) {
			//-----------------------------------------------------------------------------------------------
			// 差異がある場合
			//-----------------------------------------------------------------------------------------------
			// 最新のデータベースにする
			[self copyNewStore];
/*
			str = @"最新のデータベースにする\n";
			NSLog(@"%@" ,str);
			alert	= [[UIAlertView alloc]init];
			alert.title			= @"データベース";
			alert.message		= str;
			[alert addButtonWithTitle:@"OK"];
			[alert show];
*/
			// データベースバージョンをバンドルバージョンに合わせる
			[versionList setObject:bundleVersion forKey:@"DataBaseVersion"];
			[versionList writeToURL:versionURL atomically:YES];
		}
/*
		// データベースバージョンを取得
		dataBaseVersion = Nil;
		versionList = Nil;
		versionList = [NSMutableDictionary dictionaryWithContentsOfURL:versionURL];
		dataBaseVersion = [versionList objectForKey:@"DataBaseVersion"];
		str = [NSString stringWithFormat:@"データベースNo2         = %@\n",dataBaseVersion];
		NSLog(@"%@" ,str);
		alert	= [[UIAlertView alloc]init];
		alert.title			= @"データベースVersion②";
		alert.message		= dataBaseVersion;
		[alert addButtonWithTitle:@"OK"];
		[alert show];
*/
	});
}

@end