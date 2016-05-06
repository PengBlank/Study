//
//  categoryInfo.h
//  Teshehui
//
//  Created by apple_administrator on 15/9/4.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface categoryInfo : NSObject

@property (nonatomic, strong) NSMutableArray        *SubCategorys;
@property (nonatomic, assign) NSInteger             CaId;
@property (nonatomic, assign) NSInteger             ParentId;
@property (nonatomic, assign) NSInteger             MerchantCount;
@property (nonatomic, assign) NSInteger             Sort;
@property (nonatomic, assign) NSInteger             Level;
@property (nonatomic, strong) NSString              *Name;
@property (nonatomic, strong) NSString              *CreatedOn;

@end

@interface cityInfo : NSObject

@property (nonatomic, strong) NSMutableArray        *SubAdress;
@property (nonatomic, assign) NSInteger             Sort;
@property (nonatomic, assign) NSInteger             ParentId;
@property (nonatomic, assign) NSInteger             OrzId;
@property (nonatomic, assign) NSInteger             Level;
@property (nonatomic, strong) NSString              *Name;


@end
