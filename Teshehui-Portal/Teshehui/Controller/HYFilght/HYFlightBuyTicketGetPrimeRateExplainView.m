//
//  HYFlightBuyTicketGetPrimeRateExplainView.m
//  Teshehui
//
//  Created by HYZB on 15/11/6.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYFlightBuyTicketGetPrimeRateExplainView.h"
#import <UIKit/UIKit.h>

#define titleLabelFont [UIFont boldSystemFontOfSize:15.0]
#define contentLabelFont [UIFont systemFontOfSize:13.0]

@interface HYFlightBuyTicketGetPrimeRateExplainView ()
{
    UIView *_contentView;
    UIScrollView *_scrollView;
    UIWebView *_webV;
}

@end

@implementation HYFlightBuyTicketGetPrimeRateExplainView

- (id)initWithHTMLstring:(NSString *)htmlString
{
    CGRect bounds = [[UIScreen mainScreen] bounds];
    self = [super initWithFrame:bounds];
    self.backgroundColor = [UIColor clearColor];
    if (self) {
        
        // self.cabin = cabin;
     //   CGFloat scrollHeight = [self calculateContentHeight];
        CGFloat contentHeight = [UIScreen mainScreen].bounds.size.height;
        
        //创建contentView
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TFScalePoint(320), contentHeight)];
        _contentView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.8];
        [self addSubview:_contentView];
        
        _webV = [[UIWebView alloc] initWithFrame:CGRectMake(0, 80, TFScalePoint(320), contentHeight-80)];
        _webV.backgroundColor = [UIColor clearColor];
        [_webV setOpaque:NO];
        [_contentView addSubview:_webV];
        [_webV loadHTMLString:htmlString baseURL:nil];
        
//        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 10, TFScalePoint(300), contentHeight-10)];
//        _scrollView.backgroundColor = [UIColor clearColor];
//        _scrollView.contentSize = CGSizeMake(TFScalePoint(300), scrollHeight);
//        _scrollView.bounces = NO;
//        [_contentView addSubview:_scrollView];
        
        // 描述标题及内容
       // [self addLabels];
        
        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        closeBtn.frame = TFRectMake(295, 30, 20, 20);
        [closeBtn setBackgroundImage:[UIImage imageNamed:@"btn_closeicon"] forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(closeBtnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:closeBtn];
        
    }
    return self;
}

- (void)closeBtnDidClicked:(UIButton *)btn
{
    [self removeFromSuperview];
}

- (CGFloat)calculateContentHeight
{
//    if (_cabin)
//    {
//        CGFloat scrollHeight = 0;
//        NSString *returnMoneyTitle = @"返现";
//        NSString *pointTitle = @"现金券";
//        if (_cabin.expandedResponse.alertedRule.length > 0)
//        {
//            CGSize size = [returnMoneyTitle sizeWithFont:titleLabelFont
//                                  constrainedToSize:CGSizeMake(TFScalePoint(280), 300)];
//            scrollHeight += size.height;
//            scrollHeight += 10;
//            
//            size = [_cabin.expandedResponse.alertedRule sizeWithFont:contentLabelFont
//                                                   constrainedToSize:CGSizeMake(TFScalePoint(280), 1000)];
//            scrollHeight += size.height;
//            
//            scrollHeight += 10;
//        }
//        if (_cabin.expandedResponse.refundRule.length > 0)
//        {
//            //第二行起与前一部分的距离
//            scrollHeight += 10;
//            
//            CGSize size = [pointTitle sizeWithFont:titleLabelFont
//                                 constrainedToSize:CGSizeMake(TFScalePoint(280), 300)];
//            scrollHeight += size.height;
//            scrollHeight += 10;
//            
//            size = [_cabin.expandedResponse.refundRule sizeWithFont:contentLabelFont
//                                                  constrainedToSize:CGSizeMake(TFScalePoint(280), 1000)];
//            scrollHeight += size.height;
//            
//            scrollHeight += 10;
//        }
//        return scrollHeight;
//    }
    return 0;
}

- (void)addLabels
{
    if (!_scrollView) {
        return;
    }
    
    //购票说明
    NSString *topTitle = @"买机票得优惠";
    
    UILabel *topTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, 100, 20)];
    topTitleLabel.text = topTitle;
    topTitleLabel.backgroundColor = [UIColor clearColor];
    topTitleLabel.textColor = [UIColor whiteColor];
    topTitleLabel.font = titleLabelFont;
    [_scrollView addSubview:topTitleLabel];
    
    UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(10, 48, TFScalePoint(280), 1)];
    line.image = [UIImage imageNamed:@"hotel_line_grgy_buttom.png"];
    [_scrollView addSubview:line];
    
    
    NSArray *titles = [self titleAndContents];
    
    CGFloat y = 60;
    for (NSUInteger i = 0; i < titles.count; i++)
    {
        //如果不是第一块，起始位置应该是分隔线向下偏移10
        if (i != 0) {
            y += 10;
        }
        
        NSString *title = [titles objectAtIndex:i][@"title"];
        NSString *content = [titles objectAtIndex:i][@"content"];
        
        CGSize size = [title sizeWithFont:titleLabelFont
                        constrainedToSize:CGSizeMake(TFScalePoint(280), 300)];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, y, size.width, size.height)];
        titleLabel.text = title;
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.font = titleLabelFont;
        [_scrollView addSubview:titleLabel];
        
        y += size.height + 20;  //10是标题到内容的距离
        
        size = [content sizeWithFont:contentLabelFont
                   constrainedToSize:CGSizeMake(TFScalePoint(280), 1000)];
        UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, y, size.width, size.height)];
        contentLabel.numberOfLines = 0;
        contentLabel.backgroundColor = [UIColor clearColor];
        contentLabel.font = contentLabelFont;
        contentLabel.textColor = [UIColor whiteColor];
        contentLabel.text = content;
        [_scrollView addSubview:contentLabel];
        
        y += size.height + 10;
        
        //横线
        if (i < titles.count - 1) {
            UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(10, y, TFScalePoint(280), 1)];
            line.image = [UIImage imageNamed:@"hotel_line_grgy_buttom.png"];
            [_scrollView addSubview:line];
        }
    }
}

- (NSArray *)titleAndContents
{
    NSMutableArray *titles = [NSMutableArray array];
    
//    if (_cabin.expandedResponse.refundRule.length > 0)
//    {
//        [titles addObject:@{@"title": @"返现",
//                            @"content": _cabin.expandedResponse.refundRule}];
//    }
//    
//    if (_cabin.expandedResponse.alertedRule.length > 0)
//    {
//        [titles addObject:@{@"title": @"现金券",
//                            @"content": _cabin.expandedResponse.alertedRule}];
//    }
    
    return titles;
}


@end
