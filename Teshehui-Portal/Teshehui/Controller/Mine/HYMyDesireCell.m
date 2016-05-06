//
//  HYMyDesireCell.m
//  Teshehui
//
//  Created by Kris on 15/11/10.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYMyDesireCell.h"

@interface HYMyDesireCell ()<UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *statusLab;
@property (weak, nonatomic) IBOutlet UIView *topLineView;
@property (weak, nonatomic) IBOutlet UILabel *descLab;
@property (weak, nonatomic) IBOutlet UIView *bottomLineView;
@property (weak, nonatomic) IBOutlet UILabel *dateLab;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (nonatomic, assign) NSInteger delete_id;

@end

@implementation HYMyDesireCell

- (void)awakeFromNib
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    self.titleLab.frame = CGRectMake(self.titleLab.frame.origin.x, self.titleLab.frame.origin.y, TFScalePoint(180), 30);
    self.statusLab.frame = CGRectMake(width - 70, 10, 50, 30);
    self.topLineView.frame = CGRectMake(10, CGRectGetMaxY(self.titleLab.frame) + 10, TFScalePoint(300), 1);
    self.descLab.frame = CGRectMake(10, CGRectGetMaxY(self.topLineView.frame) + 10, TFScalePoint(280), 40);
    self.bottomLineView.frame = CGRectMake(10, CGRectGetMaxY(self.descLab.frame) + 10, TFScalePoint(300), 1);
    
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    [deleteBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    deleteBtn.frame = CGRectMake(width - 100, CGRectGetMaxY(self.bottomLineView.frame) + 10, 80, 30);
    deleteBtn.layer.borderWidth = 1;
    deleteBtn.layer.borderColor = [UIColor colorWithRed:221/255.0f green:222/255.0f blue:224/255.0f alpha:1.0].CGColor;
    [self addSubview:deleteBtn];
    [deleteBtn addTarget:self action:@selector(deleteBtnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    self.bottomView.backgroundColor = [UIColor colorWithRed:220/255.0f green:220/255.0f blue:220/255.0f alpha:1.0];
    self.bottomView.frame = CGRectMake(0, 175, TFScalePoint(320), 10);
}

- (void)setCellInfoWithModel:(HYMyDesirePoolModel *)model
{
    self.titleLab.text = model.wishTitle;
    self.statusLab.text = model.statusStr;
    self.descLab.text = model.wishContent;
    
    NSArray *strArr = [model.createTime componentsSeparatedByString:@" "];
    self.dateLab.text = strArr[0];
    
    self.delete_id = model.d_id;
}

- (void)deleteBtnDidClicked:(UIButton *)btn {
    
    UIAlertView *deleteAlert = [[UIAlertView alloc] initWithTitle:nil message:@"确定要删除本条记录吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [deleteAlert show];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        
        if ([self.delegate respondsToSelector:@selector(sendDeleteInfo:)])
        {
             [self.delegate sendDeleteInfo:self.delete_id];
        }
    } else {
        
    }
}

@end
