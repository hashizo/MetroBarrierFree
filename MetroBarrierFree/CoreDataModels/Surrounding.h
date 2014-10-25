//
//  Surrounding.h
//  MetroBarrierFree
//
//  Created by yuta on 2014/10/17.
//  Copyright (c) 2014年 501Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Platform;

@interface Surrounding : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) Platform *platform;

@end
