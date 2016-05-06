//
//  CQHomeTileView.m
//  Teshehui
//
//  Created by ChengQian on 13-10-25.
//  Copyright (c) 2013年 Charse. All rights reserved.
//

#import "CQHomeTileView.h"

@interface CQHomeTileView()

@property (nonatomic, strong) UIImageView *iconeView;
@property (nonatomic, strong) UIImageView *touchView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, assign) kHomeTileType type;

@end

@implementation CQHomeTileView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame type:(kHomeTileType)type;
{
    self = [self initWithFrame:frame];
    
    if (self) {
        _type = type;

        CGRect rect = frame;
        rect.size.height *= 0.6;
        rect.size.width *= 0.6;
        _touchView = [[UIImageView alloc] initWithFrame:rect];
        _touchView.image = [UIImage imageNamed:@"touch_down"];
        _touchView.contentMode = UIViewContentModeScaleAspectFit;
        _touchView.center = CGPointMake(frame.size.width/2, frame.size.height/2);
        [_touchView setHidden:YES];
        [self addSubview:_touchView];
        
        switch (type) {
            case Flight:
            {
                self.backgroundColor = [UIColor colorWithRed:30.0/255.0
                                                       green:210.0/255.0
                                                        blue:254.0f/255.0
                                                       alpha:1.0f];
                UIImage *image = [UIImage imageNamed:@"MainPlane"];
                _iconeView = [[UIImageView alloc] initWithImage:image];
                CGRect frame1 = CGRectMake((frame.size.width-image.size.width)/2, (frame.size.height-image.size.height)/2+6, image.size.width, image.size.height);
                _iconeView.frame = frame1;
                [self addSubview:_iconeView];
                
                CGRect frame2 = CGRectMake(20, 22, 100, 20);
                _titleLabel = [[UILabel alloc] initWithFrame:frame2];
                _titleLabel.backgroundColor = [UIColor clearColor];
                _titleLabel.textColor = [UIColor whiteColor];
                _titleLabel.text = @"特奢头等舱";
                _titleLabel.font = [UIFont systemFontOfSize:18];
                [self addSubview:_titleLabel];
            }
                break;
            case CheapFlight:
            {
                self.backgroundColor = [UIColor colorWithRed:141.0/255.0
                                                       green:208.0/255.0
                                                        blue:8.0f/255.0
                                                       alpha:1.0f];
                UIImage *image = [UIImage imageNamed:@"air_icon"];
                _iconeView = [[UIImageView alloc] initWithImage:image];
                _iconeView.contentMode = UIViewContentModeScaleAspectFit;
                CGRect frame1 = CGRectMake(10, 16, 49, 35);
                _iconeView.frame = frame1;
                [self addSubview:_iconeView];
                
                CGRect frame2 = CGRectMake(65, 24, 80, 20);
                _titleLabel = [[UILabel alloc] initWithFrame:frame2];
                _titleLabel.backgroundColor = [UIColor clearColor];
                _titleLabel.textColor = [UIColor whiteColor];
                _titleLabel.text = @"经济舱";
                _titleLabel.font = [UIFont boldSystemFontOfSize:18];
                [self addSubview:_titleLabel];
            }
                break;
            case ShoppingMall:
            {
                self.backgroundColor = [UIColor colorWithRed:251.0/255.0
                                                       green:151.0/255.0
                                                        blue:25.0f/255.0
                                                       alpha:1.0f];
                UIImage *image = [UIImage imageNamed:@"vip_mall_icon"];
                _iconeView = [[UIImageView alloc] initWithImage:image];
                CGRect frame1 = CGRectMake((frame.size.width-image.size.width)/2, (frame.size.height-image.size.height)/2+6, image.size.width, image.size.height);
                _iconeView.frame = frame1;
                [self addSubview:_iconeView];
                
                CGRect frame2 = CGRectMake(20, 34, 80, 20);
                _titleLabel = [[UILabel alloc] initWithFrame:frame2];
                _titleLabel.backgroundColor = [UIColor clearColor];
                _titleLabel.textColor = [UIColor whiteColor];
                _titleLabel.text = @"特奢商城";
                _titleLabel.font = [UIFont systemFontOfSize:18];
                [self addSubview:_titleLabel];
            }
                break;
            case Hotels:
            {
                self.backgroundColor = [UIColor colorWithRed:251.0/255.0
                                                       green:49.0/255.0
                                                        blue:110.0f/255.0
                                                       alpha:1.0f];
                UIImage *image = [UIImage imageNamed:@"hotels_icon"];
                _iconeView = [[UIImageView alloc] initWithImage:image];
                CGRect frame1 = CGRectMake((frame.size.width-image.size.width)/2, (frame.size.height-image.size.height)/2, image.size.width, image.size.height);
                _iconeView.frame = frame1;
                [self addSubview:_iconeView];
                
                UILabel *tLab = [[UILabel alloc] initWithFrame:CGRectMake(56, 45, 60, 20)];
                tLab.backgroundColor = [UIColor clearColor];
                tLab.textColor = [UIColor whiteColor];
                tLab.text = @"HOTEL";
                tLab.font = [UIFont systemFontOfSize:10];
                [self addSubview:tLab];
                
                CGRect frame2 = CGRectMake(20, 20, 80, 20);
                _titleLabel = [[UILabel alloc] initWithFrame:frame2];
                _titleLabel.backgroundColor = [UIColor clearColor];
                _titleLabel.textColor = [UIColor whiteColor];
                _titleLabel.text = @"酒店";
                _titleLabel.font = [UIFont systemFontOfSize:18];
                [self addSubview:_titleLabel];
            }
                break;
            case Flowers:
            {
                self.backgroundColor = [UIColor colorWithRed:20.0/255.0
                                                       green:166.0/255.0
                                                        blue:250.0f/255.0
                                                       alpha:1.0f];
                UIImage *image = [UIImage imageNamed:@"home_icon_main7"];
                _iconeView = [[UIImageView alloc] initWithImage:image];
                CGRect frame1 = CGRectMake(50-image.size.width, (frame.size.height-image.size.height)/2, image.size.width, image.size.height);
                _iconeView.frame = frame1;
                [self addSubview:_iconeView];
                
                UILabel *tLab = [[UILabel alloc] initWithFrame:CGRectMake(60, 30, 60, 16)];
                tLab.backgroundColor = [UIColor clearColor];
                tLab.textColor = [UIColor whiteColor];
                tLab.text = @"春舞枝";
                tLab.font = [UIFont systemFontOfSize:16];
                [self addSubview:tLab];
                
                CGRect frame2 = CGRectMake(60, 48, 90, 20);
                _titleLabel = [[UILabel alloc] initWithFrame:frame2];
                _titleLabel.backgroundColor = [UIColor clearColor];
                _titleLabel.textColor = [UIColor whiteColor];
                _titleLabel.text = @"鲜花全球购";
                _titleLabel.font = [UIFont systemFontOfSize:18];
                [self addSubview:_titleLabel];
            }
                break;
            default:
                break;
        }
        
        /*
        UIImage *touch = [UIImage imageNamed:@"touch_down"];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        [btn setImage:touch forState:UIControlStateHighlighted];
        [btn setImage:nil forState:UIControlStateNormal];
        [btn addTarget:self
                action:@selector(didClck:)
      forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
         */
    }
    
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)didClck:(id)sender
{
    __weak typeof(self) b_self = self;
    [UIView animateWithDuration:0.2
                     animations:^{
                         b_self.transform = CGAffineTransformMakeScale(1.1, 1.2);
                     }completion:^(BOOL finish){
                         [UIView animateWithDuration:0.2
                                          animations:^{
                                              b_self.transform = CGAffineTransformMakeScale(0.9, 0.9);
                                          }completion:^(BOOL finish){
                                          }];
                     }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    __weak typeof(self) b_self = self;
    [UIView animateWithDuration:0.1
                     animations:^{
                         b_self.transform = CGAffineTransformMakeScale(0.95, 0.95);
                     }completion:^(BOOL finish){
                     }];
    
    [_touchView setHidden:NO];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    
    [self performSelector:@selector(touchEventEnd:)
               withObject:[NSNumber numberWithBool:NO]
               afterDelay:0.2];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
    [self performSelector:@selector(touchEventEnd:)
               withObject:[NSNumber numberWithBool:YES]
               afterDelay:0.2];
}

- (void)touchEventEnd:(id)sender
{
    self.transform = CGAffineTransformMakeScale(1.0, 1.0);
    [_touchView setHidden:YES];
    
    NSNumber *number = (NSNumber *)sender;
    if (number.boolValue)
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(didClckTileView:)])
        {
            [self.delegate didClckTileView:self];
        }
    }
}

@end
