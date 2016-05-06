//
//  HYMovieTicketOrderListFrame.h
//  Teshehui
//
//  Created by HYZB on 16/3/10.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HYMovieTicketOrderListModel;

@interface HYMovieTicketOrderListFrame : NSObject

@property (nonatomic, assign) CGRect topViewFrame;
@property (nonatomic, assign) CGRect picImageViewFrame;
@property (nonatomic, assign) CGRect orderCodeLabelFrame;
@property (nonatomic, assign) CGRect cityLabelFrame;
@property (nonatomic, assign) CGRect addressLabelFrame;
@property (nonatomic, assign) CGRect addressFrame;
@property (nonatomic, assign) CGRect priceLabelFrame;
@property (nonatomic, assign) CGRect countsLabelFrame;
@property (nonatomic, assign) CGRect pointLabelFrame;
@property (nonatomic, assign) CGRect PayStatusLabelFrame;
@property (nonatomic, strong) HYMovieTicketOrderListModel *model;

@property (nonatomic, assign) CGFloat cellHeight;

@end
