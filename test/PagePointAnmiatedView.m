//
//  PagePointAnmiatedView.m
//  test
//
//  Created by xunmei on 2017/8/9.
//  Copyright © 2017年 xunmei. All rights reserved.
//

#import "PagePointAnmiatedView.h"

static NSUInteger const pointNum = 5;

@interface PagePointAnmiatedView ()
{
    NSTimer *timer;
}

@property (assign,nonatomic) NSInteger currentImage;

@property (strong,nonatomic) UIImageView *currentImageView;

@end

@implementation PagePointAnmiatedView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        _currentImage = 0;
        UIImage *image_1 = [UIImage imageNamed:@"pairing_for_ball_gray"];
        UIImage *image_2 = [UIImage imageNamed:@"pairing_for_ball_blue"];
        for (int i = 0; i < pointNum; i ++) {

            CGFloat width = frame.size.width / (pointNum * 2);
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * width * 2, (frame.size.height - width) * 0.5, width, width)];
            imageView.tag = 40000 + i;
            imageView.image = image_1;
            if (i == 0) {
                imageView.image = image_2;
                self.currentImageView = imageView;
            }
            [self addSubview:imageView];
        }
    }

    return self;
}

- (void)animatePagePointAnmiatedView:(NSTimeInterval)spaceTime
{
    if (timer == nil) {
        _currentImage = 0;
        timer = [NSTimer scheduledTimerWithTimeInterval:spaceTime target:self selector:@selector(BkcheckwifiTimer:) userInfo:nil repeats:YES];
    }

}

- (void)stopPagePointAnmiatedView
{
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
}

- (void)BkcheckwifiTimer:(NSTimer *)timer
{

    _currentImage ++;
    if (_currentImage > (pointNum - 1)) {
        _currentImage = 0;
    }
    
    UIImage *image_1 = [UIImage imageNamed:@"pairing_for_ball_gray"];
    UIImage *image_2 = [UIImage imageNamed:@"pairing_for_ball_blue"];
    UIImageView *imageview = [self viewWithTag:40000 + _currentImage];
    self.currentImageView.image = image_1;
    imageview.image = image_2;
    self.currentImageView = imageview;
    
}

@end
