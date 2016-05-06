//
//  HYEarnTicketFooterView.m
//  Teshehui
//
//  Created by HYZB on 15/10/26.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYEarnTicketFooterView.h"
#import "UIImage+Addition.h"

@interface HYEarnTicketFooterView ()

@property (weak, nonatomic) IBOutlet UIImageView *taxiImageView;
@property (weak, nonatomic) IBOutlet UIImageView *trainImageView;
@property (weak, nonatomic) IBOutlet UIImageView *travelImageView;
@property (weak, nonatomic) IBOutlet UIView *leftLineView;
@property (weak, nonatomic) IBOutlet UILabel *expectLabel;
@property (weak, nonatomic) IBOutlet UIView *rightLineView;

@end

@implementation HYEarnTicketFooterView

- (void)awakeFromNib
{
//    [self.taxiImageView setImage:[UIImage imageWithNamedAutoLayout:@"didiTaxi"]];
//    [self.trainImageView setImage:[UIImage imageWithNamedAutoLayout:@"train"]];
//    [self.travelImageView setImage:[UIImage imageWithNamedAutoLayout:@"donkeyTravel"]];
//    CGFloat spec = 5;
//    CGFloat width = (ScreenRect.size.width-spec*2)/3;
//    CGRect taxiFrame = self.taxiImageView.frame;
//    taxiFrame.size.width = width;
//    taxiFrame.size.height = width/1.8;
//    taxiFrame.origin.x = 0;
//    self.taxiImageView.frame = taxiFrame;
//    
//    CGRect trainFrame = self.trainImageView.frame;
//    trainFrame.size.width = width;
//    trainFrame.size.height = width/1.8;
//    trainFrame.origin.x = CGRectGetMaxX(taxiFrame)+spec;
//    self.trainImageView.frame = trainFrame;
//    
//    CGRect travelFrame = self.travelImageView.frame;
//    travelFrame.size.width = width;
//    travelFrame.origin.x = CGRectGetMaxX(trainFrame)+spec;
//    travelFrame.size.height = width/1.8;
//    self.travelImageView.frame = travelFrame;
//    
//    CGRect leftLineFrame = self.leftLineView.frame;
//    leftLineFrame.size.width = TFScalePoint(40);
//    leftLineFrame.origin.x = TFScalePoint(20);
//    self.leftLineView.frame = leftLineFrame;
//    
//    CGRect expectLabelFrame = self.expectLabel.frame;
//    expectLabelFrame.origin.x = CGRectGetMaxX(leftLineFrame);
//    expectLabelFrame.size.width = TFScalePoint(200);
//    self.expectLabel.frame = expectLabelFrame;
//    
//    CGRect rightLineViewFrame = self.rightLineView.frame;
//    rightLineViewFrame.origin.x = CGRectGetMaxX(expectLabelFrame);
//    rightLineViewFrame.size.width = TFScalePoint(40);
//    self.rightLineView.frame = rightLineViewFrame;
    
}

@end
