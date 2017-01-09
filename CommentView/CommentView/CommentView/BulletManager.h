//
//  BulletManager.h
//  CommentView
//
//  Created by Rochester on 9/1/17.
//  Copyright © 2017年 Rochester. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BulletView;
@interface BulletManager : NSObject
//       弹幕数组
@property (nonatomic,strong) NSArray *bulletSources;
//       弹道
@property (nonatomic,assign) int trag;
//      弹幕开始执行
- (void)start;
//      弹幕结束执行
- (void)stop;

//      添加到viewController上的回调
@property (nonatomic,copy) void(^generateViewBlock)(BulletView *view);
@end
