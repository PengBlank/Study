//
//  HYMovieTicketOrderDetailViewController.m
//  Teshehui
//
//  Created by HYZB on 16/2/25.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYMovieTicketOrderDetailViewController.h"

#define margin 15

@interface HYMovieTicketOrderDetailViewController ()

@end

@implementation HYMovieTicketOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"订单详情";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:scrollView];
    
    [self setupScrollView:scrollView];
}

#pragma mark - privateMethod
- (void)setupScrollView:(UIScrollView *)scrollView
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
    imageView.backgroundColor = [UIColor grayColor];
    [scrollView addSubview:imageView];
    
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(margin, margin+10, 70, 15)];
    dateLabel.textAlignment = NSTextAlignmentCenter;
    dateLabel.textColor = [UIColor whiteColor];
    dateLabel.font = [UIFont systemFontOfSize:11];
    [scrollView addSubview:dateLabel];
    dateLabel.text = @"2015-12-31";
    
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(margin, CGRectGetMaxY(dateLabel.frame), 70, 20)];
    timeLabel.textAlignment = NSTextAlignmentCenter;
    timeLabel.textColor = [UIColor whiteColor];
    timeLabel.font = [UIFont systemFontOfSize:15];
    [scrollView addSubview:timeLabel];
    timeLabel.text = @"21:30";
    
    CGFloat x = CGRectGetMaxX(dateLabel.frame)+margin+10;
    CGFloat y = margin;
    CGFloat width = 190;
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, width, 15)];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:13];
    [scrollView addSubview:titleLabel];
    titleLabel.text = @"鬼吹灯之寻龙诀  2张";
    
    UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, CGRectGetMaxY(titleLabel.frame), width, 30)];
    addressLabel.numberOfLines = 2;
    addressLabel.textColor = [UIColor whiteColor];
    addressLabel.font = [UIFont systemFontOfSize:10];
    [scrollView addSubview:addressLabel];
    addressLabel.text = @"保利国际影城深圳南山店 VIP厅 保利国际影城深圳南山店 VIP厅 保利国际影城深圳南山店 VIP厅 保利国际影城深圳南山店 VIP厅";
    
    UILabel *seatLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, CGRectGetMaxY(addressLabel.frame), width, 30)];
    seatLabel.numberOfLines = 2;
    seatLabel.textColor = [UIColor whiteColor];
    seatLabel.font = [UIFont systemFontOfSize:10];
    [scrollView addSubview:seatLabel];
    seatLabel.text = @"1排7座/1排6座 1排7座/1排6座 1排7座/1排6座 1排7座/1排6座";
    
    // 取票码
    CGFloat drawTicketCodeViewY = CGRectGetMaxY(imageView.frame)+20;
    UIView *drawTicketCodeView = [[UIView alloc] initWithFrame:CGRectMake(0, drawTicketCodeViewY, CGRectGetWidth(imageView.frame), 60)];
//    drawTicketCodeView.frame = CGRectMake(0, CGRectGetMaxY(imageView.frame), CGRectGetWidth(imageView.frame), 0);
    [scrollView addSubview:drawTicketCodeView];
    [self setupDrawTicketCodeView:drawTicketCodeView];
    
    // 取票提示
    CGFloat drawTicketExplainY = CGRectGetMaxY(drawTicketCodeView.frame)+20;
    UILabel *drawTicketExplain = [[UILabel alloc] initWithFrame:CGRectMake(margin, drawTicketExplainY, 60, 14)];
    drawTicketExplain.font = [UIFont systemFontOfSize:12];
    [scrollView addSubview:drawTicketExplain];
    drawTicketExplain.text = @"取票提示";
    
    NSString *text = @"请凭取票码715247154726至卖座网取票机取票，如果遇到机器故障凭影院订单号234862和取票码824870至柜台取票";
    CGFloat labelX = CGRectGetMaxX(drawTicketExplain.frame)+20;
    CGFloat labelWidth = TFScalePoint(self.view.frame.size.width - labelX -margin);
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(labelWidth, MAXFLOAT)];
    UILabel *explainLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelX, drawTicketExplainY, labelWidth, size.height)];
    explainLabel.numberOfLines = 0;
    explainLabel.font = [UIFont systemFontOfSize:12];
    [scrollView addSubview:explainLabel];
    explainLabel.text = text;
    
    // 订单详情
    CGFloat orderDetailY = CGRectGetMaxY(explainLabel.frame) + 20;
    CGFloat orderDetailH = 280;
    UIView *OrderDetailView = [[UIView alloc] initWithFrame:CGRectMake(0, orderDetailY, self.view.frame.size.width, orderDetailH)];
    [scrollView addSubview:OrderDetailView];
    [self setupBottomView:OrderDetailView];
    
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, CGRectGetMaxY(OrderDetailView.frame));
    
}

/**
 *  取票码
 */
- (void)setupDrawTicketCodeView:(UIView *)drawTicketCodeView
{
    CGFloat height = drawTicketCodeView.frame.size.height/2;
    UILabel *drawTicketLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, drawTicketCodeView.frame.size.width, height)];
    drawTicketLabel.font = [UIFont systemFontOfSize:20];
    drawTicketLabel.textColor = [UIColor redColor];
    [drawTicketCodeView addSubview:drawTicketLabel];
    drawTicketLabel.textAlignment = NSTextAlignmentCenter;
    drawTicketLabel.text = @"取票码";
    
    UILabel *codeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(drawTicketLabel.frame), drawTicketCodeView.frame.size.width, height)];
    codeLabel.font = [UIFont systemFontOfSize:20];
    codeLabel.textColor = [UIColor redColor];
    [drawTicketCodeView addSubview:codeLabel];
    codeLabel.textAlignment = NSTextAlignmentCenter;
    codeLabel.text = @"715247154726";
}

/**
 *  订单详情
 */
- (void)setupBottomView:(UIView *)bottomView
{
    UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(margin, 5, 60, 14)];
    detailLabel.font = [UIFont systemFontOfSize:13];
    [bottomView addSubview:detailLabel];
    detailLabel.text = @"订单详情";
    
    CGFloat x = CGRectGetMaxX(detailLabel.frame)+20;
    CGFloat H = 25;
    CGFloat W = TFScalePoint(self.view.frame.size.width - x -margin);

    NSArray *arr = @[@"订 单 号:201602016304104112",@"电   影:鬼吹灯之寻龙诀",@"影   院:保利国际影城深圳南山店",@"影   票:2 张 3D 订座票",@"语  言:国语",@"订单金额:88.00元",@"手 机 号:13800138000",@"下单时间:2015-12-31 21:30",];
    for (NSInteger i = 0; i < 8; i++)
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x, i*H, W, H)];
        label.font = [UIFont systemFontOfSize:12];
        label.text = arr[i];
        [bottomView addSubview:label];
    }
}

@end
