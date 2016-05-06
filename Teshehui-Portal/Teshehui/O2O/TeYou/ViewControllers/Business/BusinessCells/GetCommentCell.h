//
//  GetCommentCell.h
//  Teshehui
//
//  Created by macmini5 on 15/11/20.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

/**
 查看评论页面－评论cell
 **/

#import "BaseCell.h"

@interface GetCommentCell : BaseCell

@property (nonatomic,strong) UILabel    *commentLabel;     // 评论
@property (nonatomic,strong) UIView     *bgView;           // 背景
@property (nonatomic,strong) UIButton   *allButton;        // 查看全部
@property (nonatomic,strong) void(^buttonBlock)(CGFloat labelHeight);

// 加载UI数据内容
- (void) loadCommentLabelText:(NSString *)textStr;
// 根据文字计算cell的高度
+ (CGFloat)cellHeightWithString:(NSString *)textStr;
@end
