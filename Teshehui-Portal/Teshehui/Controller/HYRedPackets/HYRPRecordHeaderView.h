//
//  HYRPRecordHeaderView.h
//  Teshehui
//
//  Created by HYZB on 15/3/10.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HYRPRecordHeaderViewDelegate <NSObject>

@optional
- (void)didSwitchRedpacketRecordType:(BOOL)isRecv;

@end

@interface HYRPRecordHeaderView : UIView

@property (nonatomic, weak) id<HYRPRecordHeaderViewDelegate> delegate;
@property (nonatomic, strong, readonly) UILabel *countLab;
@property (nonatomic, strong, readonly) UILabel *countDescLab;
@property (nonatomic, strong, readonly) UILabel *totalLab;
@property (nonatomic, strong, readonly) UILabel *totalDescLab;

@end
