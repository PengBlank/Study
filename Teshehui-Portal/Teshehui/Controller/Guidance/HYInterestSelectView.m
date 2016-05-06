//
//  HYInterestSelectView.m
//  Teshehui
//
//  Created by 成才 向 on 16/3/23.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYInterestSelectView.h"
#import "Masonry.h"
#import "UIView+GetImage.h"
#import "HYMallHomeItem.h"

@interface HYInterestSelectView ()
{
    UIImage *_btnFrameImg;
}
@property (nonatomic, strong) UIScrollView *allScopeView;
@property (nonatomic, strong) NSMutableArray *allScopeBtns;
@property (nonatomic, strong) NSMutableArray *selectedScopeBtns;
@property (nonatomic, strong) NSMutableArray *selectedItemCodes;
@property (nonatomic, strong) NSArray *totalItems;
@property (nonatomic, strong) UIButton *confirmBtn;
@property (nonatomic, strong) UILabel *countLab;

@end

@implementation HYInterestSelectView

- (instancetype)initWithFrame:(CGRect)frame supportSkip:(BOOL)supportSkip
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        UIView *barView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                   0,
                                                                   frame.size.width,
                                                                   64)];
        UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width/2-60, 32, 120, 20)];
        titleLab.tintColor = [UIColor colorWithWhite:0.1
                                            alpha:1.0];
        titleLab.font = [UIFont systemFontOfSize:19];
        titleLab.textAlignment = NSTextAlignmentCenter;
        titleLab.text = @"我感兴趣";
        [barView addSubview:titleLab];
        
        UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 63, frame.size.width, 1)];
        lineView.image = [[UIImage imageNamed:@"line_cell_bottom"] stretchableImageWithLeftCapWidth:2 topCapHeight:0];
        [barView addSubview:lineView];
        
        [self addSubview:barView];
    
        UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, frame.size.width, 220)];
        [self addSubview:scroll];
        self.allScopeView = scroll;
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 220, frame.size.width, 1)];
        line.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
        [self addSubview:line];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(line.frame), 200, 20)];
        label.font = [UIFont systemFontOfSize:15.0];
        label.textColor = [UIColor colorWithWhite:.5 alpha:1];
        label.text = [NSString stringWithFormat:@"最多还可选择%d个", (int)self.maxSelectCount];
        [self addSubview:label];
        self.countLab = label;
        
        if (supportSkip)
        {
            UIButton *go = [[UIButton alloc] initWithFrame:CGRectMake(0, frame.size.height-45, frame.size.width/2, 45)];
            go.backgroundColor = [UIColor redColor];
            go.titleLabel.font = [UIFont systemFontOfSize:18.0];
            [go setTitleColor:[UIColor whiteColor]
                     forState:UIControlStateNormal];
            [go setTitle:@"确定"
                forState:UIControlStateNormal];
            [go addTarget:self
                   action:@selector(confirmAction)
         forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:go];
            
            self.confirmBtn = go;
            
            UIButton *skip = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width/2, frame.size.height-45, frame.size.width/2, 45)];
            skip.backgroundColor = [UIColor grayColor];
            skip.titleLabel.font = [UIFont systemFontOfSize:18.0];
            [skip setTitleColor:[UIColor whiteColor]
                     forState:UIControlStateNormal];
            [skip setTitle:@"取消"
                forState:UIControlStateNormal];
            [skip addTarget:self
                   action:@selector(skipSelect)
         forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:skip];
        }
        else
        {
            UIButton *go = [[UIButton alloc] initWithFrame:CGRectMake(0, frame.size.height-45, frame.size.width, 45)];
            go.backgroundColor = [UIColor redColor];
            go.titleLabel.font = [UIFont systemFontOfSize:18.0];
            [go setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [go setTitle:@"确定" forState:UIControlStateNormal];
            [go addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:go];
            
            self.confirmBtn = go;
        }
    }
    return self;
}

#pragma mark - getter/setter
- (NSMutableArray *)allScopeBtns
{
    if (!_allScopeBtns) {
        _allScopeBtns = [NSMutableArray array];
    }
    return _allScopeBtns;
}

- (NSMutableArray *)selectedScopeBtns
{
    if (!_selectedScopeBtns) {
        _selectedScopeBtns = [NSMutableArray array];
    }
    return _selectedScopeBtns;
}

- (NSMutableArray *)selectedItemCodes
{
    if (!_selectedItemCodes) {
        _selectedItemCodes = [NSMutableArray new];
    }
    return _selectedItemCodes;
}

- (NSArray *)totalItems
{
    if (!_totalItems) {
        _totalItems = [NSArray new];
    }
    return _totalItems;
}

#pragma mark - events
- (void)updateLabelCount
{
    NSInteger count = self.maxSelectCount-self.selectedItemCodes.count;
    if (count)
    {
        self.countLab.text = [NSString stringWithFormat:@"最多还可选择%d个", (int)count];
    }
    else
    {
        self.countLab.text = [NSString stringWithFormat:@"最多还可选择%d个", (int)self.maxSelectCount];
    }
}

- (void)skipSelect
{
    self.skip();
}

- (void)confirmAction
{
    //产品需求，只有当选择的标签达到7个的时候才能完成
    if ((self.selectedItemCodes.count>=self.maxSelectCount) &&
        self.completeSelect)
    {
        NSArray *selectItem = [self.selectedItemCodes copy];
        self.completeSelect(selectItem);
    }
}

- (void)sourceBtnAction:(UIButton *)btn
{
    if ([_allScopeBtns containsObject:btn])
    {
        if (self.selectedItemCodes.count < self.maxSelectCount)
        {
            [btn removeFromSuperview];
            
            //update img
            HYMallHomeItem *item = [self.totalItems objectAtIndex:btn.tag];
            if (![self.selectedItemCodes containsObject:item.bannerCode])
            {
                [self.selectedItemCodes addObject:item.bannerCode];
            }
            
            [self.allScopeBtns removeObject:btn];
            [self addBtnMark:btn];
            [self addSubview:btn];
            [self.selectedScopeBtns insertObject:btn atIndex:0];
            [self layoutSourceBtns:YES];
            [self layoutTargetBtns:YES];
        }
    }
    else
    {
        [btn removeFromSuperview];
        
        HYMallHomeItem *item = [self.totalItems objectAtIndex:btn.tag];
        [self.selectedItemCodes removeObject:item.bannerCode];
        
        [self.selectedScopeBtns removeObject:btn];
        [self.allScopeBtns addObject:btn];
        [self removeBtnMark:btn];
        [self.allScopeView addSubview:btn];
        [self layoutSourceBtns:YES];
        [self layoutTargetBtns:YES];
    }
    
    [self updateLabelCount];
}

- (void)handleLongPress:(UILongPressGestureRecognizer *)press
{
    if ([self.selectedScopeBtns containsObject:press.view])
    {
        if (press.state == UIGestureRecognizerStateBegan) {
            press.view.transform = CGAffineTransformMakeScale(1.2, 1.2);
        }
        else if (press.state == UIGestureRecognizerStateChanged) {
            CGPoint translation = [press locationInView:self];
            press.view.center = translation;
//            [pan setTranslation:CGPointZero inView:self];
        }
        else if (press.state == UIGestureRecognizerStateEnded) {
            press.view.transform = CGAffineTransformIdentity;
            [self insertBtn:(UIButton *)press.view];
            [self layoutTargetBtns:YES];
        }
    }
}


- (void)insertBtn:(UIButton *)movedBtn
{
    NSMutableArray *copy = [self.selectedScopeBtns mutableCopy];
    [copy removeObject:movedBtn];
    for (UIButton *btn in copy)
    {
        if (CGRectGetMinX(movedBtn.frame) < CGRectGetMinX(btn.frame)+20 &&
            CGRectGetMinY(movedBtn.frame) >= CGRectGetMinY(btn.frame)-20 &&
            CGRectGetMaxY(movedBtn.frame) <= CGRectGetMaxY(btn.frame)+20)
        {
            [self.selectedScopeBtns removeObject:movedBtn];
            NSInteger idx = [self.selectedScopeBtns indexOfObject:btn];
            [self.selectedScopeBtns insertObject:movedBtn atIndex:idx];
            break;
        }
        /// 如果是最后一个，插到最后去
        if ([copy lastObject] == btn) {
            if (CGRectGetMinY(movedBtn.frame) >= CGRectGetMinY(btn.frame)-20 &&
                CGRectGetMaxY(movedBtn.frame) <= CGRectGetMaxY(btn.frame)+20 &&
                CGRectGetMinX(movedBtn.frame) > CGRectGetMaxX(btn.frame) - 50 &&
                CGRectGetMinX(movedBtn.frame) < CGRectGetMaxX(btn.frame) + 50)
            {
                [self.selectedScopeBtns removeObject:movedBtn];
                [self.selectedScopeBtns addObject:movedBtn];
                break;
            }
        }
    }
}

- (void)bindWithData:(NSArray *)data selectedIndexs:(NSArray *)data2;
{
    [self.allScopeBtns makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.selectedScopeBtns makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    self.totalItems = [data copy];
    
    if ([data2 isKindOfClass:[NSArray class]]) {
        self.selectedItemCodes = [data2 mutableCopy];
    }
    
    for (int i = 0; i < data.count; i ++)
    {
        HYMallHomeItem *item = data[i];
        UIButton *btn = [self createBtn];
        btn.tag = i;
        [btn setTitle:item.name forState:UIControlStateNormal];
        
        if ([self.selectedItemCodes containsObject:item.bannerCode])
        {
            [self.selectedScopeBtns addObject:btn];
            [self addSubview:btn];
        }
        else
        {
            [self.allScopeView addSubview:btn];
            [self.allScopeBtns addObject:btn];
        }
    }
    [self layoutSourceBtns:NO];
    [self layoutTargetBtns:NO];
    
    //update select status
    if ([self.selectedScopeBtns count])
    {
        for (UIButton *btn in self.selectedScopeBtns)
        {
            [self addBtnMark:btn];
        }
    }
    
    [self updateLabelCount];
}

- (void)layoutSourceBtns:(BOOL)animated
{
    float x = 20;
    float y = 20;
    float yspace = 10;
    float xspace = 10;
    float width = (self.frame.size.width - 2 * x - 3 * xspace) / 4;
    float height = 25;
    for (int i = 0; i < self.allScopeBtns.count; i++)
    {
        UIButton *btn = self.allScopeBtns[i];
        
        if (animated) {
            [UIView beginAnimations:@"animation" context:nil];
        }
        
        btn.frame = CGRectMake(x, y, width, height);
        
        if (animated) {
            [UIView commitAnimations];
        }
        
        
        x += width + xspace;
        if (i % 4 == 3) {
            y += height + yspace;
            x = 20;
        }
    }
    
    self.allScopeView.contentSize = CGSizeMake(self.frame.size.width, y + yspace + height);
}

- (void)layoutTargetBtns:(BOOL)animated
{
    float x = 20;
    float y = CGRectGetMaxY(_countLab.frame) + 10;
    float yspace = 10;
    float xspace = 10;
    float width = (self.frame.size.width - 2 * x - 3 * xspace) / 4;
    float height = 25;
    for (int i = 0; i < self.selectedScopeBtns.count; i++)
    {
        UIButton *btn = self.selectedScopeBtns[i];
        
        if (animated) {
            [UIView beginAnimations:@"animation" context:nil];
        }
        
        btn.frame = CGRectMake(x, y, width, height);
        
        if (animated) {
            [UIView commitAnimations];
        }
        
        x += width + xspace;
        if (i % 4 == 3) {
            y += height + yspace;
            x = 20;
        }
    }
}

- (UIButton *)createBtn
{
    if (!_btnFrameImg) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        view.layer.borderColor = [UIColor colorWithWhite:.8 alpha:1].CGColor;
        view.layer.borderWidth = 1.0;
        view.layer.cornerRadius = 2.0;
        view.layer.masksToBounds = YES;
        _btnFrameImg = [[view getImage] resizableImageWithCapInsets:UIEdgeInsetsMake(2, 2, 2, 2) resizingMode:UIImageResizingModeStretch];
    }
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundImage:_btnFrameImg
                   forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithWhite:.7 alpha:1]
              forState:UIControlStateNormal];
    [btn addTarget:self
            action:@selector(sourceBtnAction:)
  forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.font = [UIFont systemFontOfSize:12.0];
    UILongPressGestureRecognizer *press = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    [btn addGestureRecognizer:press];
    return btn;
}

- (void)addBtnMark:(UIButton *)btn
{
    UIImage *image = [UIImage imageNamed:@"mall_interest_x"];
    CALayer *layer = [[CALayer alloc] init];
    layer.contents = (id)image.CGImage;
    layer.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    layer.position = CGPointMake(CGRectGetMaxX(btn.bounds), CGRectGetMinY(btn.bounds));
    [btn.layer addSublayer:layer];
    [btn.layer setValue:layer forKey:@"xx"];
}

- (void)removeBtnMark:(UIButton *)btn
{
    CALayer *xxlayer = [btn.layer valueForKey:@"xx"];
    [xxlayer removeFromSuperlayer];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
