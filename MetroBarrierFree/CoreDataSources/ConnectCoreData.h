//---------------------------------------------------------------------------------------------------------------
//  ConnectCoreData.h
//
//
//  CoreData接続クラス
//
//  Created by yuta on 2013/09/07.
//  Copyright (c) 2013年 SunMeadow. All rights reserved.
//---------------------------------------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface ConnectCoreData : NSObject

//---------------------------------------------------------------------------------------------------------------
// プロパティ
//---------------------------------------------------------------------------------------------------------------
// CoreData基本プロパティ
@property (nonatomic, readonly) NSManagedObjectModel			*managedObjectModel;
@property (nonatomic, readonly) NSManagedObjectContext			*managedObjectContext;
@property (nonatomic, readonly) NSPersistentStoreCoordinator	*persistentStoreCoordinator;
// CoreDataの元のSQLiteファイルの存在プロパティ
@property (nonatomic)BOOL 										isSQliteFile;
// 新規の場合のCoreDataの作成方法決定プロパティ
@property (nonatomic)int										coredataCreateType;

//---------------------------------------------------------------------------------------------------------------
// メソッド
//---------------------------------------------------------------------------------------------------------------
- (NSURL *)applicationDocumentsDirectory;
- (id)initBundleSqliteCoreData;
- (id)initEmptyCoreData;

//---------------------------------------------------------------------------------------------------------------
// ファイル定義
//---------------------------------------------------------------------------------------------------------------
#define RESOURCE_FILE_NAME			@"MetroData"			// リソースファイル名
#define SQLITE_FILE_TYPE			@"sqlite"				// Sqliteファイルタイプ
#define SQLITE_SHM_FILE_TYPE		@"sqlite-shm"			// Sqlite shmファイルタイプ
#define SQLITE_WAL_FILE_TYPE		@"sqlite-wal"			// Sqlite walファイルタイプ

#define COREDATA_FILE_TYPE			@"momd"					// Coredataファイルタイプ

#define COREDATA_PLIST_NAME			@"CoreDataInfo"			// CoreDataプロパティリストファイル名
#define KEY_DATABASE_VERSION		@"DataBaseVersion"		// データベースバージョンのキー

#define PLIST_FILE_TYPE				@"plist"				// プロパティリストファイルタイプ


//---------------------------------------------------------------------------------------------------------------
// CoreData作成タイプ定義(coredataCreateType)
//---------------------------------------------------------------------------------------------------------------
#define BUNDLE_SQLITE_FILE			0						// バンドルしたSQLiteファイルでCoreDataを作成
#define EMPTY_DATA					1						// 空のCoreDataを作成

@end

