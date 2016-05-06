//
//  HYMallHomeModalAdsViewModel.h
//  Teshehui
//
//  Created by Kris on 16/1/6.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "JSONModel.h"
#import "HYMallHomeBoard.h"
#import "HYMallHomeItem.h"

@interface HYMallHomeModalAdsViewModel : JSONModel

@property (nonatomic, copy) NSArray *picUrls;
@property (nonatomic, copy) NSArray *tapUrls;
@property (nonatomic, copy) NSArray *items;
@property (nonatomic, strong) HYMallHomeBoard *board;

@property (nonatomic, assign) NSUInteger showNum;

//+ (instancetype)viewModelWithSubjects:(NSArray <HYMallHomeBoard *>*)subjects;
+ (instancetype)viewModelWithSubject:(HYMallHomeBoard *)subject;

@end
