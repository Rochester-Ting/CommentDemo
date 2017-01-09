//
//  BulletView.h
//  CommentView
//
//  Created by Rochester on 9/1/17.
//  Copyright © 2017年 Rochester. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,moveStatus){
    Start, // 弹幕开始
    Enter, // 弹幕完全进入屏幕
    End    // 弹幕完全离开屏幕
};
typedef void(^statusBlock)(moveStatus move);
@interface BulletView : UIView

//       弹幕的弹道
@property (nonatomic,assign) int trajectory;
//       弹幕移除屏幕后的状态回调
@property (nonatomic,copy) statusBlock statusBlock;
//       初始化弹幕
- (instancetype)initWithComment:(NSString *)comment;
//       开始动画
- (void)startAnimation;
//       停止动画
- (void)stopAnimation;
@end
