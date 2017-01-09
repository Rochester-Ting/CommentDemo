//
//  ViewController.m
//  CommentView
//
//  Created by Rochester on 9/1/17.
//  Copyright © 2017年 Rochester. All rights reserved.
//

#import "ViewController.h"
#import "BulletManager.h"
#import "BulletView.h"
@interface ViewController ()
//       <#what#>
@property (nonatomic,strong) BulletManager *manager;
@end

@implementation ViewController
- (IBAction)btn:(UIButton *)sender {
    
    if (sender.selected) {
        [self.manager stop];
    }else{
        
        [self.manager start];
    }
    sender.selected = !sender.selected;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    BulletManager *manager = [[BulletManager alloc] init];
    // 设置弹幕内容
    manager.bulletSources = @[@"哈哈哈哈哈哈哈哈哈哈哈",@"嘿嘿嘿嘿嘿嘿嘿嘿嘿",@"啪啪啪啪啪啪啪啪",@"嘎嘎嘎嘎嘎嘎嘎嘎",@"2dygsyfgsyufgsydgfy",@"shfjncjnjc",@"发货的纠纷或点击返回的",@"时间和飞机上大号福",@"建省的恢复健康是多久发货",@"时间看到njccbhcbhcbchcbhc",@"发生的回复格式规范合适的股份合",@"计的帅哥和方式规定和",@"甲方公司电话机构发生的结",@"果返回时间的股份合计上多个环节"];
    self.manager = manager;
    // 设置弹幕有几行
    self.manager.trag = 5;
    __weak typeof(self) weakSelf = self;
    manager.generateViewBlock = ^(BulletView *view){
        [weakSelf addBulletView:view];
    };
}

- (void)addBulletView:(BulletView *)view{
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    view.frame = CGRectMake(screenW, 300 + view.trajectory * 40, CGRectGetWidth(view.bounds), CGRectGetHeight(view.bounds));
    [self.view addSubview:view];
    [view startAnimation];
}

@end
