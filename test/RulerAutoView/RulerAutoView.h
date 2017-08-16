//
//  RulerAutoView.h
//  test
//
//  Created by xunmei on 2017/7/25.
//  Copyright © 2017年 xunmei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RulerTimeQuantumModel.h"

@interface RulerAutoView : UIView

@property (nonatomic,strong) NSArray <RulerTimeQuantumModel *>* rulerTimeQuantumModelArray;

+ (instancetype)showRulerScrollViewWithFrame:(CGRect)frame smallMode:(BOOL)mode;

@end
