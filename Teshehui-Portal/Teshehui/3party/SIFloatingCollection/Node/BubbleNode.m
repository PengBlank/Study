//
//  BubbleNode.m
//  SIFloatingCollectionByOC
//
//  Created by yurongde on 16/3/17.
//  Copyright © 2016年 yurongde. All rights reserved.
//

#import "BubbleNode.h"
#import "SDWebImageManager.h"
#import "UIImage+Addition.h"

@interface BubbleNode()

@property (nonatomic, strong) dispatch_queue_t imgQueue;


@end

@implementation BubbleNode

+ (instancetype)initWithRadius:(CGFloat)radius{
    BubbleNode *node = [BubbleNode shapeNodeWithCircleOfRadius:radius];
    if (!node) {
        return nil;
    }
    [node configureNode];
    
    return node;
}



- (void)addIconWithPath:(NSString *)path
{
    if (path != self.imgPath)
    {
        self.imgPath = path;
        
        [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:path]
                                                        options:0
                                                       progress:nil
                                                      completed:^(UIImage *image,
                                                                  NSError *error,
                                                                  SDImageCacheType cacheType,
                                                                  BOOL finished,
                                                                  NSURL *imageURL) {
                                                          
//                                                          UIImage *scale = [image imageWithScaleSize:CGSizeMake(30, 30)
//                                                                                              radius:15];
                                                          [self.tagIcon setTexture:[SKTexture textureWithImage:image]];
                                                          self.tagIcon.position = CGPointMake(0, 10);
                                                          
                                                          if (self.labelNode.position.y > -20)
                                                          {
                                                              SKAction *moveLabel = [SKAction moveByX:0.0
                                                                                                    y:-14
                                                                                             duration:0.2];
                                                              
                                                              [self.labelNode runAction:moveLabel];
                                                          }
                                                          
                                                          [self.tagIcon setHidden:NO];
                                                      }];
    }
}

- (void)removeIcon
{
    if (self.imgPath)
    {
        self.imgPath = nil;
        if (self.labelNode.position.y >= -20)
        {
            SKAction *moveLabel = [SKAction moveByX:0.0
                                                  y:14
                                           duration:0.2];
            
            [self.labelNode runAction:moveLabel];
        }
    }
    
    [self.tagIcon setHidden:YES];
}

#pragma mark - private methods
- (void)configureNode {
    
    CGRect boundingBox = CGPathGetBoundingBox(self.path);
    CGFloat radius = boundingBox.size.width / 2.0;
    self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:radius + 1.0];

    self.fillColor = [SKColor colorWithRed:246/255.0
                                     green:48.0/255.0
                                      blue:88.0/255.0
                                     alpha:1];
    self.strokeColor = [SKColor colorWithRed:246/255.0
                                       green:48.0/255.0
                                        blue:88.0/255.0
                                       alpha:1];
    self.lineWidth = 1;
    
    self.labelNode.position = CGPointZero;

    self.labelNode.fontColor = [SKColor whiteColor];
    self.labelNode.fontSize = 10;
    self.labelNode.userInteractionEnabled = NO;
    self.labelNode.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    self.labelNode.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    [self addChild:self.labelNode];
    
    self.tagIcon.position = CGPointZero;
    self.tagIcon.size = CGSizeMake(30, 30);
    [self addChild:self.tagIcon];
    [self removeIcon];
}

#pragma mark - public methods
- (SKAction *)selectingAnimation {
    [self removeActionForKey:removingKey];
    return [SKAction scaleTo:1.6 duration:0.2];
}
- (SKAction *)normalizeAnimation {
    [self removeActionForKey:removingKey];
    return [SKAction scaleTo:1.0 duration:0.2];
}

- (SKAction *)removeAnimation {
    [self removeActionForKey:removingKey];
    return [SKAction fadeOutWithDuration:0.2];
}
- (SKAction *)removingAnimation {
    
    SKAction *pulseUp = [SKAction scaleTo:self.xScale + 0.13 duration:0];
    SKAction *pulseDown = [SKAction scaleTo:self.xScale duration:0.3];
    SKAction *pulse = [SKAction sequence:@[pulseUp,pulseDown]];
    SKAction *repeatPulse = [SKAction repeatActionForever:pulse];
    
    return repeatPulse;
}

#pragma mark - getters and setters
- (SKSpriteNode *)tagIcon
{
    if (!_tagIcon)
    {
        _tagIcon = [SKSpriteNode spriteNodeWithImageNamed:@""];
    }
    
    return _tagIcon;
}

- (SKLabelNode *)labelNode {
    if (!_labelNode) {
        _labelNode = [SKLabelNode labelNodeWithFontNamed:@""];
    }
    return _labelNode;
}

- (dispatch_queue_t)imgQueue
{
    if (!_imgQueue)
    {
        _imgQueue = dispatch_queue_create("com.tsh.img", DISPATCH_QUEUE_SERIAL);
    }
    
    return _imgQueue;
}

@end
