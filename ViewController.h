//
//  ViewController.h
//  MenuDemo
//
//  Created by luwu on 16/4/21.
//  Copyright © 2016年 iflyota. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLWRightDrawreController.h"
@interface ViewController : UIViewController<LLWRightDrawerControllerChild>

@property(nonatomic,weak)LLWRightDrawreController *drawer;
@end

