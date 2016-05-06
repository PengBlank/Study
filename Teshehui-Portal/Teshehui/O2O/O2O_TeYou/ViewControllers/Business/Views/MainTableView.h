//
//  MainTableView.h
//  Teshehui
//
//  Created by apple_administrator on 16/4/1.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

/**
 *  实体店首页列表view
 */




typedef void (^selectRowBlock)(id obj);
#import <UIKit/UIKit.h>
#import "SceneCategoryInfo.h"

@protocol MainTableViewDelegate <NSObject>

- (void)QRcodeClickWithMainTableView;

@end


@interface MainTableView : UIView

- (instancetype)initWithFrame:(CGRect)frame type:(NSInteger)type models:(NSMutableArray *)models city:(NSString *)city;
@property (nonatomic, strong) UIImageView       *myQRCode;
@property (nonatomic, strong) UITableView       *tableView;
@property (nonatomic, assign) id <MainTableViewDelegate> delegate;
@property (nonatomic, copy) selectRowBlock      selectBlock;
@end
