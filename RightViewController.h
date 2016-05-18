//
//  RightViewController.h
//  MenuDemo
//
//  Created by luwu on 16/5/18.
//  Copyright © 2016年 iflyota. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLWRightDrawreController.h"
@interface RightViewController : UIViewController<LLWRightDrawerControllerChild>
@property(nonatomic,weak)LLWRightDrawreController *drawer;
@end
