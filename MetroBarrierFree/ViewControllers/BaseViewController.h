//
//  BaseViewController.h
//  MetroBarrierFree
//
//  Created by Masako Yamada on 2014/10/24.
//  Copyright (c) 2014年 501Software. All rights reserved.
//

#import "ViewController.h"

@interface BaseViewController : ViewController
#pragma mark -
#pragma mark enum
// ---------------------------------------------------------------------------------------------------------
//	列挙型
// ---------------------------------------------------------------------------------------------------------
// フォントサイズ種別
typedef enum FontSizeType : int {
	
	FONT_SIZE_TYPE_SMALL	= 1,	// フォントサイズ小
	FONT_SIZE_TYPE_MEDIUM	= 2,	// フォントサイズ中
	FONT_SIZE_TYPE_LARGE	= 3		// フォントサイズ大
	
} FontSizeType;

#pragma mark -
#pragma mark property
//---------------------------------------------------------------------------------------------------------------
// プロパティ
//---------------------------------------------------------------------------------------------------------------

#pragma mark -
#pragma mark common outlet
//---------------------------------------------------------------------------------------------------------------
// 共通アウトレット
//---------------------------------------------------------------------------------------------------------------
@property IBOutlet UIScrollView *baseScrollView;

#pragma mark -
#pragma mark common event
//---------------------------------------------------------------------------------------------------------------
// 共通イベント
//---------------------------------------------------------------------------------------------------------------
- (IBAction)onFontSizeSmallTouchUpInside:(id)sender;
- (IBAction)onFontSizeMediumTouchUpInside:(id)sender;
- (IBAction)onFontSizeLargeTouchUpInside:(id)sender;

#pragma mark -
#pragma mark public methods
//---------------------------------------------------------------------------------------------------------------
// 公開メソッド
//---------------------------------------------------------------------------------------------------------------
// フォント関連
- (void)saveFontSizeType:(FontSizeType)fontSizeType;
- (FontSizeType)getSavedFontSizeType;
- (void)changeFontSize:(FontSizeType)fontSizeType;
- (float)getFontSize:(FontSizeType)fontSizeType;

// アーカイブ関連
- (BOOL)archiveObjectToUserDefault:(id)obj forKey:(NSString*)key;
- (id)unarchiveObjectFromUserDefault:(NSString*)key;
- (BOOL)archiveObjectToDocuments:(id)obj toFile:(NSString*)fileName;
- (id)unarchiveObjectFromDocuments:(NSString*)fileName;
- (BOOL)deleteObjectFromDocuments:(NSString*)fileName;
- (BOOL)archiveObjectToCache:(id)obj toFile:(NSString*)fileName;
- (id)unarchiveObjectFromCache:(NSString*)fileName;
- (BOOL)deleteObjectFromCache:(NSString*)fileName;


#pragma mark -
#pragma mark define
//---------------------------------------------------------------------------------------------------------------
// ファイル定義
//---------------------------------------------------------------------------------------------------------------
#define PLIST_FILE_NAME				@"settings"			// plistファイル名

//---------------------------------------------------------------------------------------------------------------
// アーカイブキー名
//---------------------------------------------------------------------------------------------------------------
#define ARCHIVE_KEY_FONT_SIZE_TYPE	@"FONT_SIZE_TYPE"	// フォントサイズ種別
@end
