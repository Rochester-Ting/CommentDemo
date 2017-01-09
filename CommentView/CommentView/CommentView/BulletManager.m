//
//  BulletManager.m
//  CommentView
//
//  Created by Rochester on 9/1/17.
//  Copyright © 2017年 Rochester. All rights reserved.
//

#import "BulletManager.h"
#import "BulletView.h"
@interface BulletManager ()
//       弹幕的数据来源
@property (nonatomic,strong) NSMutableArray *dataSource;
//       弹幕当前的数组
@property (nonatomic,strong) NSMutableArray *bulletComments;
//       存储弹幕view的数组
@property (nonatomic,strong) NSMutableArray *bulletViews;
//       是否停止动画
@property (nonatomic,assign) BOOL isStopAnimation;
@end
@implementation BulletManager
- (NSMutableArray *)dataSource{

    if (!_dataSource) {
//        _dataSource = [NSMutableArray array];
        _dataSource = [NSMutableArray arrayWithArray:_bulletSources];
    }
    return _dataSource;
}
- (NSMutableArray *)bulletComments{
    if (!_bulletComments) {
        _bulletComments = [NSMutableArray array];
    }
    return _bulletComments;
}
- (NSMutableArray *)bulletViews{
    if (!_bulletViews) {
        _bulletViews = [NSMutableArray array];
    }
    return _bulletViews;
}
- (instancetype)init{
    if (self = [super init]) {
        self.isStopAnimation = YES;
    }
    return self;
}
// 弹幕开始
- (void)start{
    if (!_isStopAnimation) {
        return;
    }
    _isStopAnimation = NO;
    [self.bulletComments removeAllObjects];
    [self.bulletComments addObjectsFromArray:self.dataSource];
    // 初始化弹幕
    [self initWithComments];
}
- (void)initWithComments{
    
    // 设置弹幕的弹道
    NSMutableArray *trajectorys = [NSMutableArray array];
    self.trag = self.trag > 0 ? self.trag : 4;
    for (int i = 0; i < self.trag; i++) {
        NSString *trajectory = [NSString stringWithFormat:@"%zd",i];
        [trajectorys addObject:trajectory];
    }
    
    for (int i = 0; i < self.trag; i++) {
        if (self.bulletComments.count == 0) {
            return;
        }
        // 获取当前的弹道,随机获取
        int index = arc4random() % trajectorys.count;
        int trajectory = [[trajectorys objectAtIndex:index] intValue];
        [trajectorys removeObjectAtIndex:index];
        // 从弹幕中获取弹幕
        NSString *comments = [self.bulletComments firstObject];
        [self.bulletComments removeObjectAtIndex:0];
        // 创建弹幕
        [self creatBulletView:comments withTrajectory:trajectory];
    }
}
- (void)creatBulletView:(NSString *)comments withTrajectory:(int)trajectory{
    if (_isStopAnimation) {
        return;
    }
    BulletView *bulletView = [[BulletView alloc] initWithComment:comments];
    bulletView.trajectory = trajectory;
    [self.bulletViews addObject:bulletView];
    // 弹幕移除屏幕后的回调
    __weak typeof(bulletView) weakBulletView = bulletView;
    __weak typeof(self) weakSelf = self;
    bulletView.statusBlock = ^(moveStatus moveSatus){
        if (_isStopAnimation) {
            return;
        }
        switch (moveSatus) {
            case Start:{
                // 将弹幕加入弹幕管理中
                [self.bulletViews addObject:weakBulletView];
                break;
            }
            case Enter:{
                // 查看是否还有弹幕,如果有继续创建弹幕
                NSString *comments = [self nextBullet];
                if (comments) {
                    [weakSelf creatBulletView:comments withTrajectory:trajectory];
                }
                break;
            }

            case End:{
                // 当弹幕飞出屏幕
                if ([weakSelf.bulletViews containsObject:weakBulletView]) {
                    [weakSelf.bulletViews removeObject:weakBulletView];
                    [weakBulletView stopAnimation];
                }
                break;
            }
            default:
                break;
        }

    };
    if (_generateViewBlock) {
        _generateViewBlock(bulletView);
    }
}
- (NSString *)nextBullet{
    if (self.bulletComments.count == 0) {
        return nil;
    }
    NSString *comments = self.bulletComments.firstObject;
    if (comments) {
        [self.bulletComments removeObjectAtIndex:0];
    }
    return comments;
}
// 弹幕关闭
- (void)stop{
    if (_isStopAnimation) {
        return;
    }
    _isStopAnimation = YES;
    
    [self.bulletViews enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        BulletView *view = obj;
        [view stopAnimation];
        view = nil;
    }];
    [self.bulletViews removeAllObjects];
}




@end
