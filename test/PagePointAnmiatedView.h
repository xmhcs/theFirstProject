//
//  PagePointAnmiatedView.h
//  test
//
//  Created by xunmei on 2017/8/9.
//  Copyright © 2017年 xunmei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PagePointAnmiatedView : UIView

- (instancetype)initWithFrame:(CGRect)frame;

- (void)animatePagePointAnmiatedView:(NSTimeInterval)spaceTime;

- (void)stopPagePointAnmiatedView;

@end
