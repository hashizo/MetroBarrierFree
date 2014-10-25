//
//  Available.h
//  MetroBarrierFree
//
//  Created by yuta on 2014/10/17.
//  Copyright (c) 2014年 501Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Available : NSManagedObject

@property (nonatomic, retain) NSString * code;
@property (nonatomic, retain) NSString * name;

@end
