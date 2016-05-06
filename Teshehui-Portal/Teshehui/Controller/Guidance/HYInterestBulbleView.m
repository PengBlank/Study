//
//  HYInterestBulbleView.m
//  Teshehui
//
//  Created by 成才 向 on 16/3/29.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYInterestBulbleView.h"
#import "BubblesScene.h"
#import "BubbleNode.h"
#import "HYMallHomeItem.h"
#import "KNCirclePercentView.h"

@interface HYInterestBulbleView ()
<SIFloatingCollectionSceneDelegate>

@property (nonatomic) SKView *skView;/**< 游戏根视图*/
@property (nonatomic) BubblesScene *floatingCollectionScene;

@property (nonatomic, strong) KNCirclePercentView *circleView;

@property (nonatomic, strong) NSMutableArray *totalItems;
@property (nonatomic, strong) NSMutableArray *selectedItemCodes;


//- (void)addSpriteNodeWithPath:(NSString *)path;

@end

@implementation HYInterestBulbleView

- (instancetype)initWithFrame:(CGRect)frame supportSkip:(BOOL)supportSkip
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.maxSelectCount = 7;
        
        UILabel *label1= [[UILabel alloc] initWithFrame:CGRectMake(0, 50, 100, 0)];
        label1.font = [UIFont systemFontOfSize:22];
        label1.text = @"选择你的购物喜好";
        [label1 sizeToFit];
        label1.frame = CGRectMake(frame.size.width/2-label1.frame.size.width/2,
                                  50,
                                  label1.frame.size.width,
                                  label1.frame.size.height);
        [self addSubview:label1];
        
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        label2.font = [UIFont systemFontOfSize:14.0];
        label2.textColor = [UIColor colorWithWhite:0.3
                                             alpha:1.0];
        
        NSString *string = @"请点击下方小球，开启你的贴心专享服务，让剁手变的更有趣！";
        if (supportSkip)
        {
            string = @"请点击下方小球，开启你的贴心专享服务，让剁手变的更有趣!（再次点击可以取消选择）";
        }
        label2.text=  string;
        label2.numberOfLines = 0;
        CGSize size = [label2 sizeThatFits:CGSizeMake(frame.size.width - 40, label2.font.lineHeight)];
        label2.frame = CGRectMake(CGRectGetMidX(frame)-size.width/2, CGRectGetMaxY(label1.frame)+5, size.width, size.height);
        [self addSubview:label2];
        
        CGFloat maxY = CGRectGetMaxY(label2.frame);
        self.skView = [[SKView alloc]initWithFrame:CGRectMake(0,
                                                              maxY,
                                                              frame.size.width,
                                                              frame.size.height-maxY)];
        self.skView.backgroundColor = [SKColor whiteColor];
        self.skView.showsFPS = NO;
        self.skView.showsNodeCount = NO;
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        self.skView.ignoresSiblingOrder = YES;
        
        [self addSubview:self.skView];
        
        self.floatingCollectionScene = [[BubblesScene alloc]initWithSize:self.skView.bounds.size];
        self.floatingCollectionScene.topOffset = 0;
        self.floatingCollectionScene.bottomOffset = 100;
        self.floatingCollectionScene.floatingDelegate = self;
        [self.skView presentScene:self.floatingCollectionScene];
        
        self.circleView = [[KNCirclePercentView alloc] initWithFrame:CGRectMake(CGRectGetMidX(frame)-30, CGRectGetHeight(frame)-70, 60, 60)];
        [self.circleView drawCircleWithPercent:20
                                                   duration:2
                                                  lineWidth:5
                                                  clockwise:YES
                                                    lineCap:kCALineCapRound
                                                  fillColor:[UIColor clearColor]
                                                strokeColor:[SKColor colorWithRed:252/255.0 green:178/255.0 blue:186/255.0 alpha:1]
                                             animatedColors:@[[SKColor colorWithRed:250/255.0 green:49/255.0 blue:89/255.0 alpha:1]]];
        [self addSubview:_circleView];
        [self.circleView startAnimation];
        
        self.circleView.percentLabel.font = [UIFont systemFontOfSize:14.0];
        self.circleView.percentLabel.textColor = [SKColor colorWithRed:255/255.0 green:98/255.0 blue:118/255.0 alpha:1];
        
        
        WS(weakSelf);
        self.circleView.clickCallback = ^{
            
            //产品需求，只有当选择的标签达到7个的时候才能完成
            if ((self.selectedItemCodes.count>=self.maxSelectCount) &&
                weakSelf.completeSelect)
            {
                NSArray *selectItem = [weakSelf.selectedItemCodes copy];
                weakSelf.completeSelect(selectItem);
            }
        };
        
        self.circleView.percentLabel.text = @"您";
    }
    return self;
}

- (void)bindWithData:(NSArray *)data selectedIndexs:(NSArray *)data2
{
    self.totalItems = [data mutableCopy];
    if ([data2 isKindOfClass:[NSArray class]]) {
        self.selectedItemCodes = [data2 mutableCopy];
    }
    
    [self updateDoneBtnTitle];
    
    for (int i=0; i < data.count; i++) {
        CGFloat bubbleRadius = 30;
        BubbleNode *node = [BubbleNode initWithRadius:bubbleRadius];
        
        HYMallHomeItem *item = [data objectAtIndex:i];
        
        NSString *string = item.name;
        if (string.length > 10)
        {
            string = [string stringByReplacingCharactersInRange:NSMakeRange(3, string.length-5)
                                                     withString:@"..."];
        }
        node.labelNode.text = string;
        
        [self.floatingCollectionScene addChild:node];
        
        for (NSString *itemCode in self.selectedItemCodes) {
            if ([item.bannerCode isEqualToString:itemCode]) {
                node.state = SIFloatingNode_Selected;
                [node addIconWithPath:item.tagSelectedImg];
                break;
            }
        }
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.circleView drawCircleWithPercent:(self.selectedItemCodes.count/(float)(self.maxSelectCount)*100)
                                      duration:2
                                     lineWidth:3
                                     clockwise:YES
                                       lineCap:kCALineCapRound
                                     fillColor:[UIColor clearColor]
                                   strokeColor:[SKColor colorWithRed:255/255.0 green:215/255.0 blue:218/255.0 alpha:1]
                                animatedColors:@[[SKColor colorWithRed:255/255.0 green:98/255.0 blue:118/255.0 alpha:1]]];
        [self.circleView startAnimation];
    });
    
}

- (BOOL)item:(HYMallHomeItem *)item isEqual:(HYMallHomeItem *)item2
{
    if ([item.name isEqualToString:item2.name] &&
        [item.url isEqualToString:item2.url]) {
        return YES;
    }
    return NO;
}

- (NSMutableArray *)totalItems
{
    if (!_totalItems) {
        _totalItems = [NSMutableArray new];
    }
    return _totalItems;
}

- (NSMutableArray *)selectedItemCodes
{
    if (!_selectedItemCodes) {
        _selectedItemCodes = [NSMutableArray new];
    }
    return _selectedItemCodes;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)updateDoneBtnTitle
{
    NSString *title = (self.selectedItemCodes.count>=self.maxSelectCount) ? @"完成" : @"您";
    self.circleView.percentLabel.text = title;
}

#pragma mark - delegate

- (BOOL)floatingScene:(SIFloatingCollectionScene *)scene
shouldSelectFloatingNodeAtIndex:(NSInteger)index
{
    return (self.selectedItemCodes.count < self.maxSelectCount);
}
- (BOOL)floatingScene:(SIFloatingCollectionScene *)scene
shouldDeselectFloatingNodeAtIndex:(NSInteger)index
{
    return YES;
}
- (BOOL)floatingScene:(SIFloatingCollectionScene *)scene
didSelectFloatingNodeAtIndex:(NSInteger)index
{
    if (self.selectedItemCodes.count >= self.maxSelectCount)
    {
        return NO;
    }
    
    //update img
    HYMallHomeItem *item = [self.totalItems objectAtIndex:index];
    BubbleNode *node = [scene.floatingNodes objectAtIndex:index];
    [node addIconWithPath:item.tagSelectedImg];
    
    [self.selectedItemCodes addObject:item.bannerCode];
    [self.circleView animatePersent:(self.selectedItemCodes.count/(float)(self.maxSelectCount)*100)];
    
    [self updateDoneBtnTitle];
    
    return YES;
}

- (BOOL)floatingScene:(SIFloatingCollectionScene *)scene didDeselectFloatingNodeAtIndex:(NSInteger)index {
    HYMallHomeItem *item = [self.totalItems objectAtIndex:index];
    [self.selectedItemCodes removeObject:item.bannerCode];
    [self.circleView animatePersent:(self.selectedItemCodes.count/(float)(self.maxSelectCount)*100)];
    
    [self updateDoneBtnTitle];
    
    BubbleNode *node = [scene.floatingNodes objectAtIndex:index];
    [node removeIcon];
    return YES;
}

- (BOOL)floatingScene:(SIFloatingCollectionScene *)scene shouldRemoveFloatingNodeAtIndex:(NSInteger)index {
    return YES;
}
- (BOOL)floatingScene:(SIFloatingCollectionScene *)scene didRemoveFloatingNodeAtIndex:(NSInteger)index {
    return YES;
}

@end
