//
//  SceneDeatilInfo.h
//  Teshehui
//
//  Created by LiuLeiMacmini on 16/4/11.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SceneDeatilInfo : NSObject

@property (nonatomic,strong) NSString   *packId;//(套餐id)，
@property (nonatomic,strong) NSString   *packageName;//(套餐名),
@property (nonatomic,strong) NSString   *merId;//(商家Id)，
@property (nonatomic,strong) NSString   *merchantName;//(商家名称)，
@property (nonatomic,strong) NSString   *merchantAddress;//(商家地址),
@property (nonatomic,strong) NSString   *merchantMobile;//(商家电话),
@property (nonatomic,strong) NSString   *originalPrice;//(原价)，
@property (nonatomic,strong) NSString   *thsPrice;//(特奢汇价格),
@property (nonatomic,strong) NSString   *coupon;//(现金券),
@property (nonatomic,strong) NSString   *favorites;//(点赞数),
@property (nonatomic,strong) NSArray   *merUrlList;//(套餐图片地址)，
@property (nonatomic,strong) NSString   *recommendReason;//(推荐理由),
@property (nonatomic,strong) NSString   *details;//(套餐详情)，
@property (nonatomic,strong) NSString   *urlShare;//(分享地址）,
@property (nonatomic, assign) CGFloat longitude;//(经度),
@property (nonatomic, assign) CGFloat latitude;//;//(纬度)

@property (nonatomic, assign) NSInteger status; // (套餐状态0草稿1已上架2已下架),
@property (nonatomic,strong) NSString   *person; // (人数)
@end

@interface imageUrl : NSObject
@property (nonatomic, strong) NSString              *merUrl;
@end
