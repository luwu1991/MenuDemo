//
//  LLWRightDrawreController.h
//  MenuDemo
//
//  Created by luwu on 16/5/18.
//  Copyright © 2016年 iflyota. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LLWRightDrawreController;

@protocol LLWRightDrawerControllerChild <NSObject>

@property(nonatomic,weak)LLWRightDrawreController *drawer;

@end

@interface LLWRightDrawreController : UIViewController
-(id)initWithCenterViewController:(UIViewController<LLWRightDrawerControllerChild>*)centerController RightViewController:(UIViewController*)rightViewController;
@property(nonatomic,strong,readonly)UIViewController<LLWRightDrawerControllerChild> *centerViewController;
@property(nonatomic,strong,readonly)UIViewController<LLWRightDrawerControllerChild> *rightViewController;
-(void)didClickOpenBtn:(UIButton*)btn;

@end
