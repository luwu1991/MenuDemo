//
//  ViewController.m
//  MenuDemo
//
//  Created by luwu on 16/4/21.
//  Copyright © 2016年 iflyota. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>
#import "LLWRightDrawreController.h"

@interface ViewController ()<UIGestureRecognizerDelegate>
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blueColor];
    UIButton *btn = [[UIButton alloc]init];
    btn.frame = CGRectMake(100, 100, 100, 100   );
    btn.backgroundColor = [UIColor redColor];
    [btn addTarget:self action:@selector(clickbtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
   
}

-(void)clickbtn:(UIButton*)btn{
    [self.drawer didClickOpenBtn:btn];
}


@end
