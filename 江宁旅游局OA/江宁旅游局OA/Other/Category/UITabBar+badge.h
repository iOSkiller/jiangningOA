//
//  UITabBar+badge.h
//  物联网商机管理
//
//  Created by 欣华pro on 16/6/30.
//  Copyright © 2016年 欣华pro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBar (badge)
- (void)showBadgeOnItemIndex:(int)index;   //显示小红点

- (void)hideBadgeOnItemIndex:(int)index; //隐藏小红点

@end
