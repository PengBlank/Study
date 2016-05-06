//
//  HYSortHeadView.h
//  HYManagmentDept
//
//  Created by RayXiang on 14-5-14.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HYSortHeadView;
@protocol HYSortHeadViewDelegate <UITextFieldDelegate, NSObject>
@optional
- (void)headViewDidClickedQueryBtn:(HYSortHeadView *)headView;
- (void)headViewDidClickedAllBtn:(HYSortHeadView *)headView;

@end

//@protocol HYSortDateDelegate <NSObject>
//
//- (void)headView:(HYSortHeadView *)headView didGetFromDate:(NSDate *)date;
//- (void)headView:(HYSortHeadView *)headView didGetToDate:(NSDate *)date;
//
//@end


/**
 *  The common head view for order list, vip card list...
 */
@interface HYSortHeadView : UIView {
    
}
/**
 *  最前面的label, 如"下单时间从", "会员名"
 */
@property (nonatomic, readonly) UILabel *fromLabel;

/**
 *  中单的label
 */
@property (nonatomic, readonly) UILabel *toLabel;

@property (nonatomic, readonly) UITextField *fromField;
@property (nonatomic, readonly) UITextField *toField;

/**
 *  查询按钮
 */
@property (nonatomic, readonly) UIButton *queryBtn;
/**
 *  显示全部
 */
@property (nonatomic, readonly) UIButton *allBtn;

@property (nonatomic, weak) id<HYSortHeadViewDelegate> delegate;

@property (nonatomic, assign) CGFloat fromFieldWidth;
@property (nonatomic, assign) CGFloat toFieldWidth;


@end
