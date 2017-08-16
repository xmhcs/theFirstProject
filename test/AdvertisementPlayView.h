//
//  AdvertisementPlayView.h
//  Pet
//
//  Created by zhuoshang on 2017/3/6.
//  Copyright © 2017年 zs. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    /* 滚动点居中 */
    PageContolAlimentCenter,
    /* 滚动点居右 */
    PageContolAlimentRight,
    /* 滚动点隐藏 */
    PageContolAlimentNone
} PageControlAliment;

typedef void(^tapActionBlock)(NSInteger);

@interface AdvertisementPlayView : UIView<UIScrollViewDelegate>

@property (nonatomic, assign)NSTimeInterval duration;  //播放间隔时间

@property (nonatomic, assign)PageControlAliment pageControlAliment;

@property (nonatomic, strong)UIImage * placeHoldImage;

@property (nonatomic, strong)NSArray * images;

+(instancetype)BannerViewWithFrame:(CGRect)frame images:(NSArray *)images;

-(void)startWithTapActionNeedAutoScro:(BOOL)need Block:(tapActionBlock)block;

- (void)stop;

- (void)start;

- (void)pause;

@end
