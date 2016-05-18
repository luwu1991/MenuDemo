//
//  LLWRightDrawreController.m
//  MenuDemo
//
//  Created by luwu on 16/5/18.
//  Copyright © 2016年 iflyota. All rights reserved.
//

#import "LLWRightDrawreController.h"

static CGFloat const WidthScale = 0.8;

@interface LLWRightDrawreController()<UIGestureRecognizerDelegate>
@property(nonatomic,strong)UIView *centerView;
@property(nonatomic,assign)BOOL open;
@property(nonatomic,strong)UITapGestureRecognizer *tapGR;//点击手势
@property(nonatomic,strong)UIPanGestureRecognizer *panGR;//滑动手势
@property(nonatomic, assign) CGPoint panGestureStartLocation;//开始滑动的位置
@property(nonatomic,assign) CGPoint *panGestureLastLocation;//上一个滑动的位置
@end

@implementation LLWRightDrawreController

-(id)initWithCenterViewController:(UIViewController<LLWRightDrawerControllerChild> *)centerController RightViewController:(UIViewController<LLWRightDrawerControllerChild> *)rightViewController{
    NSParameterAssert(centerController);
    NSParameterAssert(rightViewController);
    self = [super init];
    if (self) {
        _rightViewController = rightViewController;
        _centerViewController = centerController;
        if ([_rightViewController respondsToSelector:@selector(setDrawer:)]) {
            _rightViewController.drawer = self;
        }
        
        if ([_centerViewController respondsToSelector:@selector(setDrawer:)]) {
            _centerViewController.drawer = self;
        }
    }
    return self;
}
/**
 *  添加中间主视图控制器
 */
-(void)addCenterViwController{
    NSParameterAssert(self.centerViewController);
    NSParameterAssert(self.centerView);
    
    [self addChildViewController:self.centerViewController];
    self.centerViewController.view.frame = self.view.bounds;
    [self.centerView addSubview:self.centerViewController.view];
    [self.centerViewController didMoveToParentViewController:self];
}
/**
 *  初始化手势
 */
-(void)setupGestureRecognizers{
    self.tapGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureRecognized:)];
    self.panGR = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(papGestureRecognized:)];
    self.panGR.maximumNumberOfTouches = 1;
    self.panGR.delegate = self;
    
    [self.centerView addGestureRecognizer:self.panGR];
}
/**
 *  移除手势
 */
-(void)removeGestureRecognizers{
    NSParameterAssert(self.centerView);
    NSParameterAssert(self.panGR);
    [self.centerView removeGestureRecognizer:self.panGR];
}

-(void)setupRightViewController{
    self.rightViewController.view.frame =CGRectMake( self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height);
}
-(void)viewDidLoad{
    [super viewDidLoad];
    self.centerView = [[UIView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:self.centerView];
    
    [self addCenterViwController];
    [self setupRightViewController];
    [self setupGestureRecognizers];
}

-(void)toOpen{
    
    [self addChildViewController:self.rightViewController];
    self.rightViewController.view.frame = CGRectMake( self.rightViewController.view.frame.origin.x, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:self.rightViewController.view];
    
    [UIView animateWithDuration:0.4 animations:^{
        self.rightViewController.view.frame = CGRectMake(self.view.frame.size.width*(1-WidthScale), self.rightViewController.view.frame.origin.y, self.rightViewController.view.frame.size.width, self.rightViewController.view.frame.size.height);
        self.centerView.frame = CGRectMake(-self.view.frame.size.width * WidthScale, 0, self.view.frame.size.width, self.view.frame.size.height);
    } completion:^(BOOL finished) {
        self.open = YES;
        [self.centerView addGestureRecognizer:self.tapGR];
    }];
}

-(void)toClose{
    [UIView animateWithDuration:0.4 animations:^{
        self.rightViewController.view.frame = CGRectMake(self.centerView.frame.size.width, self.rightViewController.view.frame.origin.y, self.rightViewController.view.frame.size.width, self.rightViewController.view.frame.size.height);
        self.centerView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    } completion:^(BOOL finished) {
        self.open = NO;
        [self.centerView removeGestureRecognizer:self.tapGR];
    }];
}

-(void)tapGestureRecognized:(UITapGestureRecognizer*)tapGR{
    if (tapGR.state == UIGestureRecognizerStateEnded) {
        if (self.open) {
            [self toClose];
        }
        else{
            [self toOpen];
        }
    }
}

-(void)papGestureRecognized:(UIPanGestureRecognizer*)panGR{
    UIGestureRecognizerState state = panGR.state;
    CGPoint location = [panGR locationInView:self.view];
    switch (state) {
        case UIGestureRecognizerStateBegan:
            self.panGestureStartLocation = location;
            break;
            
        case UIGestureRecognizerStateChanged:
        {
            CGFloat delta = 0.0f;
            if (self.open) {//菜单打开状态
                delta = location.x - self.panGestureStartLocation.x;
                CGRect l = self.rightViewController.view.frame;
                CGRect c = self.centerView.frame;
                if (delta > self.view.frame.size.width * WidthScale) {
                    l.origin.x = self.view.frame.size.width;
                    c.origin.x = 0;
                }
                else if(delta < 0.0f){
                    l.origin.x = self.view.frame.size.width * (1-WidthScale);
                    c.origin.x = self.centerView.frame.origin.x;
                }
                else{
                    l.origin.x = self.view.frame.size.width *(1- WidthScale) + delta;
                    c.origin.x = -self.view.frame.size.width *WidthScale + delta;
                }
                self.rightViewController.view.frame = l;
                self.centerView.frame = c;
                
            }
            else{//菜单关闭状态
                if (self.panGestureStartLocation.x < self.view.frame.size.width/2) {
                    return;
                }
                CGRect l = self.rightViewController.view.frame;
                CGRect c = self.centerView.frame;
                delta = self.panGestureStartLocation.x - location.x;
                if (delta > self.view.frame.size.width * WidthScale) {
                    l.origin.x = self.view.frame.size.width *(1-WidthScale);
                    c.origin.x = -self.view.frame.size.width * WidthScale;
                }
                else if (delta < 0.0f){
                    l.origin.x = self.view.frame.size.width;
                    c.origin.x = 0;
                }
                else{
                    l.origin.x = self.view.frame.size.width - delta;
                    c.origin.x = - delta;
                }
                self.rightViewController.view.frame = l;
                self.centerView.frame = c;
            }
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            CGFloat tableViewLocation = self.rightViewController.view.frame.origin.x;
            if (self.open) {
                if (tableViewLocation >= self.view.frame.size.width *2/3) {
                    [self toClose];
                }
                else{
                    [self toOpen];
                }
            }
            else{
                if (self.view.frame.size.width - tableViewLocation >= self.view.frame.size.width/3 ) {
                    [self toOpen];
                }
                else{
                    [self toClose];
                }
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark --对外提供的方法
-(void)didClickOpenBtn:(UIButton*)btn{
    if (self.open) {
        [self toClose];
    }
    else{
        [self toOpen];
    }
}
@end
