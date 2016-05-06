//
//  TravelOrderCodeCell.m
//  Teshehui
//
//  Created by macmini5 on 15/12/17.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "TravelOrderCodeCell.h"
#import "UIColor+hexColor.h"
#import "DefineConfig.h"
#import "Masonry.h"
// 景点名标签头文件：
#import "SFTag.h"
#import "SFTagView.h"

@interface TravelOrderCodeCell ()

@property (nonatomic, strong) SFTagView *tagView;

@end

@implementation TravelOrderCodeCell

-(id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return self;
}
// 创建UI
- (void) createUI
{
    self.contentView.backgroundColor = [UIColor clearColor];
    
    _bgView = [[UIView alloc] init];                    // 背景
    [_bgView setBackgroundColor:[UIColor whiteColor]];
    [_bgView.layer setBorderWidth:.5f];
    [_bgView.layer setBorderColor:[UIColor colorWithHexColor:@"a7a7a7" alpha:1].CGColor];
    [self.contentView addSubview:_bgView];
    [_bgView setClipsToBounds:YES];
    
    _lineView = [[UIView alloc] init];                  // 线
    [_lineView setBackgroundColor:[UIColor colorWithHexColor:@"a7a7a7" alpha:1]];
    [_bgView addSubview:_lineView];
    
    _ticketName = [[UILabel alloc] init];               // 票名
    [_ticketName setFont:[UIFont systemFontOfSize:15]];
    [_ticketName setTextColor:[UIColor blackColor]];
//    [_ticketName setText:@"圣诞节狂欢夜超值套票"];
    [_bgView addSubview:_ticketName];
    
    _humanCount = [[UILabel alloc] init];              // 人数量
    [_humanCount setFont:[UIFont systemFontOfSize:14]];
    [_humanCount setTextColor:[UIColor colorWithHexColor:@"343434" alpha:1]];
//    [_humanCount setText:@"成人 2   儿童 1"]; // 0的话不显示
    [_bgView addSubview:_humanCount];
    
    _remainDays = [[UILabel alloc] init];               // 剩余天数
    [_remainDays setFont:[UIFont systemFontOfSize:13]];
    [_remainDays setTextColor:[UIColor colorWithHexColor:@"343434" alpha:1]];
//    [_remainDays setText:@"剩余天数：2天"];
    [_bgView addSubview:_remainDays];
    
    _touristTitleLabel = [[UILabel alloc] init];        // 包含景点
    [_touristTitleLabel setFont:[UIFont systemFontOfSize:13]];
    [_touristTitleLabel setTextColor:[UIColor colorWithHexColor:@"343434" alpha:1]];
    [_touristTitleLabel setText:@"包含景点："];
    [_bgView addSubview:_touristTitleLabel];
//    [_touristTitleLabel setBackgroundColor:[UIColor yellowColor]];
    
    _touristName = [[UILabel alloc] init];
    [_touristName setFont:[UIFont systemFontOfSize:13]];
    [_touristName setNumberOfLines:0];
    [_touristName setTextColor:[UIColor colorWithHexColor:@"343434" alpha:1]];
    [_bgView addSubview:_touristName];
//    [_touristName.layer setBorderWidth:1];
//    [_touristName.layer setBorderColor:[UIColor blackColor].CGColor];
    
    // 这是包含景点的景点名标签方法
//    _tagView = [[SFTagView alloc] init];
//    [_tagView setBackgroundColor:[UIColor clearColor]];
//    _tagView.margin    = UIEdgeInsetsMake(0, -10, 0, 0); // 标签与背景 上 左 下 右 距离
//    _tagView.insets    = 10;    // 标签间列距离
//    _tagView.lineSpace = 5;     // 标签间行距离
//    [_bgView addSubview: _tagView];
//    [_tagView.layer setBorderWidth:1];
//    [_tagView.layer setBorderColor:[UIColor blackColor].CGColor];
    
    
// 添加约束
    WS(weakSelf);
    //背景
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.contentView.mas_top).offset(10);
        make.bottom.mas_equalTo(weakSelf.contentView.mas_bottom);
        make.left.mas_equalTo(weakSelf.contentView.mas_left).offset(12.5);
        make.right.mas_equalTo(weakSelf.contentView.mas_right).offset(-12.5);
    }];
    // 票名
    [_ticketName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_ticketName.superview.mas_top).offset(15);
        make.centerX.mas_equalTo(_ticketName.superview.mas_centerX);
    }];
    // 人数量
    [_humanCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_lineView.mas_top).offset(-15);
        make.centerX.mas_equalTo(_humanCount.superview.mas_centerX);
    }];
    // 线
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_lineView.superview.mas_top).offset(76);
        make.left.mas_equalTo(_lineView.superview.mas_left).offset(10);
        make.right.mas_equalTo(_lineView.superview.mas_right).offset(-10);
        make.height.mas_equalTo(0.5);
    }];
    // 剩余天数
    [_remainDays mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_remainDays.superview.mas_left).offset(13);
        make.top.mas_equalTo(_lineView.mas_bottom).offset(9);
    }];
    // 包含景点title
    CGSize tSize = [@"包含景点：" sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]}];
    [_touristTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_remainDays.mas_left);
        make.top.mas_equalTo(_remainDays.mas_bottom).offset(5);
        make.width.mas_equalTo(tSize.width);
    }];
    // 景点名
    CGFloat width = [TravelOrderCodeCell tagViewWidth]; // 主要是为了计算cell高度时,宽度准确
    [_touristName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_touristTitleLabel.mas_top);
        make.left.mas_equalTo(_touristTitleLabel.mas_right);
        make.width.mas_equalTo(width);
    }];
    
    // SFTagView标签
//    CGFloat width = [TravelOrderCodeCell tagViewWidth];
//    [_tagView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(_touristTitleLabel.mas_top);
//        make.left.mas_equalTo(_touristTitleLabel.mas_right);
//        make.width.mas_equalTo(width);
//    }];
}

// UI数据
- (void)bindData:(TravelTicketInfo *)ticketInfo
{
// 票名
    [_ticketName setText:ticketInfo.ticketName];
// 人数
    NSString *adultStr = [NSString stringWithFormat:@"成人  %@",ticketInfo.adultTickets];
    NSString *childStr = [NSString stringWithFormat:@"儿童  %@",ticketInfo.childTickets];
    NSMutableAttributedString *adultAttri = [[NSMutableAttributedString alloc] initWithString:adultStr];
    NSMutableAttributedString *childAttri = [[NSMutableAttributedString alloc] initWithString:childStr];
    // 富文本 字体变大红颜色
    NSDictionary *attributeDict = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:20],NSFontAttributeName, [UIColor colorWithHexColor:@"b80000" alpha:1],NSForegroundColorAttributeName, nil];
    
    CGFloat adultCount = ticketInfo.adultTickets.floatValue; // 成人数
    CGFloat childCount = ticketInfo.childTickets.floatValue; // 儿童数
    if(adultCount == 0 && childCount != 0)
    { // 只有儿童
        [childAttri setAttributes:attributeDict range:NSMakeRange(2, childStr.length-2)];
        [_humanCount setAttributedText:childAttri];
        
    }else if(adultCount != 0 && childCount == 0)
    { // 只有成人
        [adultAttri setAttributes:attributeDict range:NSMakeRange(2, adultStr.length-2)];
        [_humanCount setAttributedText:adultAttri];
        
    }else if(adultCount == 0 && childCount == 0)
    { }
    else
    { // 都有
        [adultAttri setAttributes:attributeDict range:NSMakeRange(2, adultStr.length-2)];
        [childAttri setAttributes:attributeDict range:NSMakeRange(2, childStr.length-2)];
        NSAttributedString *space = [[NSAttributedString alloc]initWithString:@"      "];
        [adultAttri appendAttributedString:space];
        [adultAttri appendAttributedString:childAttri];
        [_humanCount setAttributedText:adultAttri];
    }
// 剩余天数
    if (_isHistory)
    {
        // 历史订单页面不显示天数
        [_remainDays setHidden:YES];
        
        [_touristTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_remainDays.superview.mas_left).offset(13);
            make.top.mas_equalTo(_lineView.mas_bottom).offset(8);
        }];
    }else
    {
        [_remainDays setText:[NSString stringWithFormat:@"剩余天数：%@天",ticketInfo.days]];
    }
    
//    if ([ticketInfo.days integerValue] == 0) {
//        NSMutableAttributedString *daysAtt1 = [[NSMutableAttributedString alloc] initWithString:@"剩余天数："];
//        NSMutableAttributedString *daysAtt2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@天",ticketInfo.days] attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexColor:@"a7a7a7" alpha:1]}];
//        
//        [daysAtt1 appendAttributedString:daysAtt2];
//        [_remainDays setAttributedText:daysAtt1];
//    }else
//    {
//        [_remainDays setText:[NSString stringWithFormat:@"剩余天数：%@天",ticketInfo.days]];
//    }
    
// 包含景点
    NSArray *touristArr = ticketInfo.tourists; // 景点数组 touristName景点名 isCheck是否划线(0不划线，1划线)
    NSMutableArray *touristNameArr = [NSMutableArray array]; // 保存景点名用
    NSMutableArray *isCheckArr     = [NSMutableArray array]; // 保存是否划线用
    for (NSDictionary *dic in touristArr) {
        [touristNameArr addObject:dic[@"touristName"]];
        [isCheckArr addObject:dic[@"isCheck"]];
    }
    [_touristName setAttributedText:[self appendTouristNames:touristNameArr isChecks:isCheckArr]];
    
    // 标签的方法
//    [self setupDataWithTouristNames:touristNameArr isChecks:isCheckArr];
}

#pragma mark - 添加景点名

- (NSAttributedString *)appendTouristNames:(NSArray *)tNArr isChecks:(NSArray *)iCArr
{
    NSMutableAttributedString *tNAttri = [[NSMutableAttributedString alloc] init]; // 用来保存景点名
    
    [tNArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
     {
         NSString *str = obj;   // 景点文字
         NSUInteger length = [str length]; // 文字长度
         NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:str];
         
         if ([iCArr[idx] integerValue]) // 是否划线(0不划线，1划线)
         {
             // 加划线
             [attri addAttribute:NSStrikethroughStyleAttributeName
                           value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle)
                           range:NSMakeRange(0, length)];
             // 划线颜色
             [attri addAttribute:NSStrikethroughColorAttributeName
                           value:[UIColor colorWithHexColor:@"a7a7a7" alpha:1]
                           range:NSMakeRange(0, length)];
             // 文字颜色
             [attri addAttribute:NSForegroundColorAttributeName
                           value:[UIColor colorWithHexColor:@"a7a7a7" alpha:1]
                           range:NSMakeRange(0, length)];
             
             [tNAttri appendAttributedString:attri];
         }else
         {
             [tNAttri appendAttributedString:attri];
         }
         // 加空格
         NSAttributedString *space = [[NSAttributedString alloc] initWithString:@"   "];
         [tNAttri appendAttributedString:space];
     }];
    // 设置一下行距离 正值增加行距，负值减小行距
//    NSMutableParagraphStyle *parastyle = [[NSMutableParagraphStyle alloc] init];
//    parastyle.lineSpacing = 8;
//    NSUInteger strLength = [tNAttri length];
//    [tNAttri addAttribute:NSParagraphStyleAttributeName value:parastyle range:NSMakeRange(0, strLength)];
    
    return tNAttri;
}

#pragma mark -－ 标签方法
- (void)setupDataWithTouristNames:(NSArray *)tNArr isChecks:(NSArray *)iCArr
{
//    NSArray *a = @[@"太长显示不完极限是这十五个字了",@"欢乐谷游玩"];
    [self.tagView removeAllTags]; // 先吧view里的标签清空再添加
    [tNArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
     {
         NSString *isCheck = iCArr[idx]; // 是否划线(0不划线，1划线)
         SFTag *tag = [SFTag tagWithText:obj];
         tag.font = [UIFont systemFontOfSize:13];
         tag.textColor = [UIColor colorWithHexColor:@"343434" alpha:1];
         if ([isCheck integerValue] == 1) {
             tag.textColor = [UIColor colorWithHexColor:@"a7a7a7" alpha:1];
         }
         tag.bgColor = [UIColor clearColor];
         [self.tagView addTag:tag isCheck:isCheck];
     }];
}

#pragma mark - 计算cell高度
+(CGFloat)cellHeightWithTouristNameArr:(NSArray *)arr IsHistory:(BOOL)isHistory
{
    NSMutableString *mtStr = [[NSMutableString alloc] init]; // 用来保存景点名
    
    for (NSString *str in arr)
    {
        [mtStr appendFormat:@"%@   ",str];
    }
    // 设置一下行距 正值增加行距，负值减小行距
    //    NSMutableParagraphStyle *parastyle = [[NSMutableParagraphStyle alloc] init];
    //    parastyle.lineSpacing = 8;
    //    NSUInteger strLength = [tNAttri length];
    //    [tNAttri addAttribute:NSParagraphStyleAttributeName value:parastyle range:NSMakeRange(0, strLength)];
    
    // 计算高度
    CGSize size = CGSizeMake([self tagViewWidth], MAXFLOAT);
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:13],NSFontAttributeName, nil];
    CGRect rect = [mtStr boundingRectWithSize:size
                                      options:NSStringDrawingUsesLineFragmentOrigin
                                   attributes:dic
                                      context:nil
                   ];
    CGFloat height = rect.size.height;
    CGSize size2 = [@"一个字的高度" sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]}];
    CGFloat height2 = 0;
    if (isHistory)
    {   // 如果是历史订单 减去“剩余天数的高度”
        height2 = size2.height+7; // 7是两个label之间的距离
    }
    if(height/size2.height > 1) // 是否超过一行
    {
        return height +143-16-height2;
    }
    return 143-height2;
    

//下面的方法是用标签的时候计算cell的高度的方法 暂不用，保留
    
////    NSArray *a = @[@"太长显示不完极限是共十五个字了",@"不会那么长"];
//    CGFloat width = [TravelOrderCodeCell tagViewWidth];
//    CGRect rect = CGRectMake(0, 0, width, 0);
//    SFTagView *tView = [[SFTagView alloc] initWithFrame:rect];
//    [tView setBackgroundColor:[UIColor clearColor]];
//    tView.margin    = UIEdgeInsetsMake(0, -10, 0, 0); // 标签与背景 上 左 下 右 距离
//    tView.insets    = 10;    // 标签间列距离
//    tView.lineSpace = 5;     // 标签间行距离
//    
//    __block CGFloat height = 0;
//    [tView removeAllTags]; // 先吧view里的标签清空再添加
//    [arr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
//     {
//         SFTag *tag = [SFTag tagWithText:obj];
//         tag.font = [UIFont systemFontOfSize:13];
//         
//         height = [tView calculateHeight:tag]; // 这里会计算出标签View的高度
//     }];
//    CGSize size = [@"一个字的高度" sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]}];
//    if(height/2 > size.height) // 是否超过一行
//    {
//        return height +143-16;
//    }
//    return 143;
}

// 标签背景框的宽度
+ (CGFloat)tagViewWidth
{
    CGSize size = [@"包含景点：" sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]}];
    CGFloat width = kScreen_Width-size.width-26-25;
    return width;
}


#pragma mark --------------
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
