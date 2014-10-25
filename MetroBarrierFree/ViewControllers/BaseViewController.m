//
//  BaseViewController.m
//  MetroBarrierFree
//
//  Created by Masako Yamada on 2014/10/24.
//  Copyright (c) 2014年 501Software. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

#pragma mark -
#pragma mark local method headers
// ---------------------------------------------------------------------------------------------------------
//	ローカルメソッド
// ---------------------------------------------------------------------------------------------------------
@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	// UI初期化処理を実行
	[self initUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -
#pragma mark local method
// ---------------------------------------------------------------------------------------------------------
//	ローカルメソッド
// ---------------------------------------------------------------------------------------------------------
// ---------------------------------------------------------------------------------------------------------
// initUI
//
// UI初期処理
//
// param		なし
//
// return		なし
// ---------------------------------------------------------------------------------------------------------
- (void)initUI {
	
	// フォントサイズを前回選択したサイズに設定
	[self changeFontSize:[self getFontSize:[self getSavedFontSizeType]]];
	
	// 残りは各画面で実装する
}

// ---------------------------------------------------------------------------------------------------------
// saveFontSizeType
//
// フォントサイズ種別を保存する
//
// param		(FontSizeType)fontSizeType	フォントサイズ種別
//
// return		なし
// ---------------------------------------------------------------------------------------------------------
- (void)saveFontSizeType:(FontSizeType)fontSizeType {
	
	[self archiveObjectToUserDefault:[NSNumber numberWithInt:fontSizeType] forKey:ARCHIVE_KEY_FONT_SIZE_TYPE];
}

// ---------------------------------------------------------------------------------------------------------
// getSavedFontSizeType
//
// 保存されたフォントサイズ種別を取得する
// 取得できなければフォントサイズ：中をデフォルトとして返す
//
// param		なし
//
// return		FontSizeType	フォントサイズ種別
// ---------------------------------------------------------------------------------------------------------
- (FontSizeType)getSavedFontSizeType {

	NSNumber *fontSizeType = (NSNumber*)[self unarchiveObjectFromUserDefault:ARCHIVE_KEY_FONT_SIZE_TYPE];
	
	if (!fontSizeType) {
		// 取得できなければ中を返す
		return FONT_SIZE_TYPE_MEDIUM;
	} else {
		// 取得できれば取得したフォントサイズ種別を返す
		return [fontSizeType intValue];
	}
}

// ---------------------------------------------------------------------------------------------------------
// changeFontSize
//
// フォントサイズを変更する
// ベースのスクロールビュー内にあるラベルとボタンラベルサイズを一括変更する
// 他にも変更が必要なコントロールがある場合は各画面でオーバーライドすること
//
// param		(FontSizeType)fontSizeType	フォントサイズ種別
//
// return		なし
// ---------------------------------------------------------------------------------------------------------
- (void)changeFontSize:(FontSizeType)fontSizeType {
	
	// -----------------------------------------------------------------------------------------------------
	// フォントサイズを取得
	// -----------------------------------------------------------------------------------------------------
	float fontSize = [self getFontSize:fontSizeType];
	
	// -----------------------------------------------------------------------------------------------------
	// ベーススクロールビュー内のビューのフォントサイズを変更
	// -----------------------------------------------------------------------------------------------------
	[_baseScrollView.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		
		// ラベル
		if ([obj isKindOfClass:[UILabel class]]) {
			UIFont *font = [((UILabel*)obj).font fontWithSize:fontSize];
			[(UILabel*)obj setFont:font];
			[(UILabel*)obj sizeToFit];
		}
		
		// ボタン
		if ([obj isKindOfClass:[UIButton class]]) {
			UIFont *font = [((UIButton*)obj).titleLabel.font fontWithSize:fontSize];
			[((UIButton*)obj).titleLabel setFont:font];
			[(UIButton*)obj sizeToFit];
		}
	}];
	
	// -----------------------------------------------------------------------------------------------------
	// 選択されたフォントサイズを保存する
	// -----------------------------------------------------------------------------------------------------
	[self saveFontSizeType:fontSizeType];
}

// ---------------------------------------------------------------------------------------------------------
// getFontSize
//
// 指定のフォントサイズ種別に対応するフォントサイズを返す
//
// param		(FontSizeType)fontSizeType	フォントサイズ種別
//
// return		float						フォントサイズ
// ---------------------------------------------------------------------------------------------------------
- (float)getFontSize:(FontSizeType)fontSizeType {
	
	// -----------------------------------------------------------------------------------------------------
	// plistを取得
	// -----------------------------------------------------------------------------------------------------
	NSDictionary *plistItems = [NSDictionary dictionaryWithContentsOfFile:
								[[NSBundle mainBundle] pathForResource:PLIST_FILE_NAME ofType:@"plist"]];

	// -----------------------------------------------------------------------------------------------------
	// フォント種別毎に異なるフォントサイズを返す
	// -----------------------------------------------------------------------------------------------------
	float fontSize = 0.0f;
	
	switch (fontSizeType) {
		case FONT_SIZE_TYPE_SMALL:
			fontSize = [(NSNumber*)plistItems[@"fontSizeSmall"] floatValue];
			break;
				
		case FONT_SIZE_TYPE_MEDIUM:
			fontSize = [(NSNumber*)plistItems[@"fontSizeMedium"] floatValue];
			break;
			
		case FONT_SIZE_TYPE_LARGE:
			fontSize = [(NSNumber*)plistItems[@"fontSizeLarge"] floatValue];
			break;
			
		default:
			break;
	}
	
	return fontSize;
}

#pragma mark -
#pragma mark archive/property methods
/*----------------------------------------------------------------------------------------------------------
 archiveObjectToUserDefault:forKey
 オブジェクトやオブジェクトを含むArray/DictionaryなどをNSUserDefaultに保存する
 自作クラスの場合は<NSCoding>が実装済みであることが必要
 ※ユーザのアプリケーション設定値（プレファレンス）のみを保存すること
 
 @param		id			obj	保存するオブジェクト
 @param		NSString	key	ユーザデフォルト保存用キー
 @return	BOOL		YES:保存成功/NO:失敗
 ---------------------------------------------------------------------------------------------------------*/
- (BOOL)archiveObjectToUserDefault:(id)obj forKey:(NSString*)key
{
	NSData *archive = [NSKeyedArchiver archivedDataWithRootObject:obj];
	[[NSUserDefaults standardUserDefaults] setObject:archive forKey:key];
	
	return [[NSUserDefaults standardUserDefaults] synchronize];
}

/*----------------------------------------------------------------------------------------------------------
 unarchiveObjectFromUserDefault
 オブジェクトやオブジェクトを含むArray/DictionaryなどをNSUserDefaultから取得する
 自作クラスの場合は<NSCoding>が実装済みであることが必要
 
 @param		NSString	key	ユーザデフォルト保存用キー
 @return	id			保存したオブジェクト
 ---------------------------------------------------------------------------------------------------------*/
- (id)unarchiveObjectFromUserDefault:(NSString*)key
{
	NSData *archive = (NSData*)[[NSUserDefaults standardUserDefaults] objectForKey:key];
	
	return [NSKeyedUnarchiver unarchiveObjectWithData:archive];
}

/*----------------------------------------------------------------------------------------------------------
 archiveObjectToDocuments:toFile
 オブジェクトやオブジェクトを含むArray/DictionaryなどをDocumentsフォルダに保存する
 自作クラスの場合は<NSCoding>が実装済みであることが必要
 ※ユーザが自身で作成したデータ（入力テキストや写真）のみを保存すること（iCloud対応）
 
 @param		id			obj			保存するオブジェクト
 @param		NSString	fileName	保存用ファイル名
 @return	BOOL		YES:保存成功/NO:失敗
 ---------------------------------------------------------------------------------------------------------*/
- (BOOL)archiveObjectToDocuments:(id)obj toFile:(NSString*)fileName
{
	NSString *dir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
	NSString *path = [dir stringByAppendingPathComponent:fileName];
	
	return [NSKeyedArchiver archiveRootObject:obj toFile:path];
}

/*----------------------------------------------------------------------------------------------------------
 unarchiveObjectFromDocuments
 オブジェクトやオブジェクトを含むArray/DictionaryなどをDocumentsフォルダから取得する
 自作クラスの場合は<NSCoding>が実装済みであることが必要
 
 @param		NSString	fileName	保存用ファイル名
 @return	id			保存したオブジェクト
 ---------------------------------------------------------------------------------------------------------*/
- (id)unarchiveObjectFromDocuments:(NSString*)fileName
{
	NSString *dir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
	NSString *path = [dir stringByAppendingPathComponent:fileName];
	
	return [NSKeyedUnarchiver unarchiveObjectWithFile:path];
}

/*----------------------------------------------------------------------------------------------------------
 deleteObjectFromDocuments
 Documentsフォルダから指定のシリアライズ用ファイルを削除する
 
 @param		NSString	fileName	削除ファイル名
 @return	BOOL		YES:削除成功/NO:失敗
 ---------------------------------------------------------------------------------------------------------*/
- (BOOL)deleteObjectFromDocuments:(NSString*)fileName
{
	NSString *dir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
	NSString *path = [dir stringByAppendingPathComponent:fileName];
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	return [fileManager removeItemAtPath:path error:nil];
}

/*----------------------------------------------------------------------------------------------------------
 archiveObjectToDocuments:toFile
 オブジェクトやオブジェクトを含むArray/DictionaryなどをCacheフォルダに保存する
 自作クラスの場合は<NSCoding>が実装済みであることが必要
 ※アプリが使用する外部データ（再取得可能なもの）のみを保存すること
 
 @param		id			obj			保存するオブジェクト
 @param		NSString	fileName	保存用ファイル名
 @return	BOOL		YES:保存成功/NO:失敗
 ---------------------------------------------------------------------------------------------------------*/
- (BOOL)archiveObjectToCache:(id)obj toFile:(NSString *)fileName
{
	NSString *dir = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
	NSString *path = [dir stringByAppendingPathComponent:fileName];
	
	return [NSKeyedArchiver archiveRootObject:obj toFile:path];
}

/*----------------------------------------------------------------------------------------------------------
 unarchiveObjectFromDocuments
 オブジェクトやオブジェクトを含むArray/DictionaryなどをCacheフォルダから取得する
 自作クラスの場合は<NSCoding>が実装済みであることが必要
 
 @param		NSString	fileName	保存用ファイル名
 @return	id			保存したオブジェクト
 ---------------------------------------------------------------------------------------------------------*/
- (id)unarchiveObjectFromCache:(NSString*)fileName
{
	NSString *dir = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
	NSString *path = [dir stringByAppendingPathComponent:fileName];
	
	return [NSKeyedUnarchiver unarchiveObjectWithFile:path];
}

/*----------------------------------------------------------------------------------------------------------
 deleteObjectFromCache
 Cacheフォルダから指定のシリアライズ用ファイルを削除する
 
 @param		NSString	fileName	削除ファイル名
 @return	BOOL		YES:削除成功/NO:失敗
 ---------------------------------------------------------------------------------------------------------*/
- (BOOL)deleteObjectFromCache:(NSString*)fileName
{
	NSString *dir = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
	NSString *path = [dir stringByAppendingPathComponent:fileName];
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	return [fileManager removeItemAtPath:path error:nil];
}

#pragma mark -
#pragma mark common event
// ---------------------------------------------------------------------------------------------------------
//	共通イベント
// ---------------------------------------------------------------------------------------------------------
// ---------------------------------------------------------------------------------------------------------
// onFontSizeSmallTouchUpInside
//
// フォントサイズ小押下処理
//
// param		(id)sender	フォントサイズ小ボタン
//
// return		IBAction
// ---------------------------------------------------------------------------------------------------------
- (IBAction)onFontSizeSmallTouchUpInside:(id)sender {
	[self changeFontSize:FONT_SIZE_TYPE_SMALL];
}

// ---------------------------------------------------------------------------------------------------------
// onFontSizeMediumTouchUpInside
//
// フォントサイズ中押下処理
//
// param		(id)sender	フォントサイズ小ボタン
//
// return		IBAction
// ---------------------------------------------------------------------------------------------------------
- (IBAction)onFontSizeMediumTouchUpInside:(id)sender {
	[self changeFontSize:FONT_SIZE_TYPE_MEDIUM];
}

// ---------------------------------------------------------------------------------------------------------
// onFontSizeLargeTouchUpInside
//
// フォントサイズ大押下処理
//
// param		(id)sender	フォントサイズ大ボタン
//
// return		IBAction
// ---------------------------------------------------------------------------------------------------------
- (IBAction)onFontSizeLargeTouchUpInside:(id)sender {
	[self changeFontSize:FONT_SIZE_TYPE_LARGE];
}

@end
