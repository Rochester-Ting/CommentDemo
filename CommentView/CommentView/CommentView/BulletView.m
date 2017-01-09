//
//  BulletView.m
//  CommentView
//
//  Created by Rochester on 9/1/17.
//  Copyright © 2017年 Rochester. All rights reserved.
//

#import "BulletView.h"
#define screenW [UIScreen mainScreen].bounds.size.width
static CGFloat margin = 10.0f;
@interface BulletView ()
//       弹幕label
@property (nonatomic,strong) UILabel  *labelCommet;
@end
@implementation BulletView
- (UILabel *)labelCommet{
    if (!_labelCommet) {
        _labelCommet = [[UILabel alloc] initWithFrame:CGRectZero];
        _labelCommet.font = [UIFont systemFontOfSize:14.0f];
        _labelCommet.textColor = [UIColor whiteColor];
        _labelCommet.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_labelCommet];
    }
    return _labelCommet;
}
- (instancetype)initWithComment:(NSString *)comment{
    if (self = [super init]) {
        self.backgroundColor = [UIColor redColor];
        self.labelCommet.text = comment;
        // 获取弹幕的长度
        NSDictionary *dict = @{NSFontAttributeName : [UIFont systemFontOfSize:14.0f]};
        CGFloat width = [comment sizeWithAttributes:dict].width;
        // 设置view的frame
        self.bounds = CGRectMake(0, 0, width + 2 * margin, 30);
        self.labelCommet.frame = CGRectMake(margin, 0, width, 30);
        
    }
    return self;
}
// 开启动画
- (void)startAnimation{
    // 弹幕的速度 v = s / t,(s是弹幕的长度,t是时间),在弹幕时间相同的情况下,弹幕越长速度越快
    // 弹幕的时间
    CGFloat duration = 3.0f;
    // 弹幕的宽度
    CGFloat wholeW = screenW + CGRectGetWidth(self.bounds);
    
    
    // 弹幕开始进入屏幕
    if (_statusBlock) {
        _statusBlock(Start);
    }
    
    // 弹幕完全进入屏幕
    // 计算弹幕的速度
    CGFloat speed = wholeW / duration;
    // 计算弹幕需要多久完全进入屏幕
    CGFloat enterDuration = CGRectGetWidth(self.bounds) / speed;
    [self performSelector:@selector(enterScreen) withObject:nil afterDelay:enterDuration];
    
    __block CGRect frame = self.frame;
    [UIView animateWithDuration:duration animations:^{
        frame.origin.x -= wholeW;
        self.frame = frame;
    } completion:^(BOOL finished) {
        // 动画结束的时候,移除弹幕的view
        [self removeFromSuperview];
        // 回调
        if (_statusBlock) {
            _statusBlock(End);
        }
    }];
}
- (void)enterScreen{
    if (_statusBlock) {
        _statusBlock(Enter);
    }
}
- (void)stopAnimation{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self removeFromSuperview];
    [self.layer removeAllAnimations];
    
}
@end
