//
//  AdvertisementPlayView.m
//  Pet
//
//  Created by zhuoshang on 2017/3/6.
//  Copyright © 2017年 zs. All rights reserved.
//

#import "AdvertisementPlayView.h"

@interface AdvertisementPlayView(){
    BOOL _need;
}

//容器
@property(nonatomic,strong)UIScrollView     *scrollView;
/* 滚动圆点 **/
@property(nonatomic,strong)UIPageControl    *pageControl;
/* 定时器 **/
@property(nonatomic,strong)NSTimer          *animationTimer;
/* 当前index **/
@property(nonatomic,assign)NSInteger        currentPageIndex;
/* 所有的图片数组 **/
@property(nonatomic,strong)NSMutableArray   *imageArray;
/* 当前图片数组，永远只存储三张图 **/
@property(nonatomic,strong)NSMutableArray   *currentArray;
/* block方式接收回调 */
@property(nonatomic,copy)tapActionBlock block;

@end

@implementation AdvertisementPlayView

+ (instancetype)BannerViewWithFrame:(CGRect)frame images:(NSArray *)images {
    AdvertisementPlayView * view = [[AdvertisementPlayView alloc] initWithFrame:frame];
    view.images = images;
    return view;
}

- (instancetype) init {
    return [self initWithFrame:[UIScreen mainScreen].bounds];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self render];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.scrollView.frame = self.bounds;
}

- (void)render {
    self.autoresizesSubviews = YES;
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    self.scrollView.contentMode = UIViewContentModeCenter;
    self.scrollView.contentSize = CGSizeMake(3 * self.bounds.size.width, self.bounds.size.height);
    self.scrollView.delegate = self;
    self.scrollView.contentOffset = CGPointMake(self.bounds.size.width, 0);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self addSubview:self.scrollView];
    
    //设置分页显示的圆点
    _pageControl = [[UIPageControl alloc] init];
    _pageControl.alpha = 0.8;
    _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    _pageControl.pageIndicatorTintColor = [UIColor grayColor];
    [self addSubview:_pageControl];
    
    //点击事件
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self addGestureRecognizer:tapGesture];
    
    //默认五秒钟循环播放
    self.duration = 5.;
    //默认居中
    self.pageControlAliment = PageContolAlimentCenter;
    //默认第一张
    self.currentPageIndex = 0;
}

- (void)setPageControlAliment:(PageControlAliment)pageControlAliment {
    _pageControlAliment = pageControlAliment;
    _pageControl.hidden = NO;
    switch (pageControlAliment) {
        case PageContolAlimentCenter:
        {
            _pageControl.frame = CGRectMake(0, CGRectGetHeight(self.scrollView.frame) - 20, CGRectGetWidth(self.scrollView.frame), 10);
        }
            break;
        case PageContolAlimentRight:
        {
            CGSize size = CGSizeMake(self.images.count * 10 * 1.2, 10);
            CGFloat x = self.scrollView.frame.size.width - size.width - 10;
            CGFloat y = self.scrollView.frame.size.height - 20;
            _pageControl.frame = CGRectMake(x, y, size.width, size.height);
        }
            break;
        case PageContolAlimentNone:
            _pageControl.hidden = YES;
            break;
            
        default:
            break;
    }
}

- (void)setDuration:(NSTimeInterval)duration {
    _duration = duration;
    
    [self.animationTimer invalidate];
    self.animationTimer = nil;
    
    if (duration <= 0) {
        return;
    }
    
    self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:_duration
                                                           target:self
                                                         selector:@selector(animationTimerDidFired:)
                                                         userInfo:nil
                                                          repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.animationTimer forMode:NSRunLoopCommonModes];
    [self.animationTimer setFireDate:[NSDate distantFuture]];
}

-(void)downLoadImage{
    if (self.images && self.images.count > 0) {
        self.imageArray = [NSMutableArray array];
        __weak typeof(self) weak = self;
        [self.images enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIImageView *imageView = [[UIImageView alloc]init];
            imageView.backgroundColor = [UIColor yellowColor];
            
//            [imageView sd_setImageWithURL:[NSURL URLWithString:obj] placeholderImage:self.placeHoldImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
//            {
//                NSLog(@"%@",error.description);
//            }];
//            [imageView sd_setImageWithURL:[NSURL URLWithString:obj] completed:^(UIImage *image, NSError *error, EMSDImageCacheType cacheType, NSURL *imageURL)
//            {
//                
//            }];
            
            
            
            [weak.imageArray addObject:imageView];
        }];
        _pageControl.numberOfPages = self.images.count;
        [self configContentViews];
    }
}

#pragma mark - 私有函数

- (void)configContentViews
{
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    NSInteger previousPageIndex = [self getValidNextPageIndexWithPageIndex:_currentPageIndex - 1];
    NSInteger rearPageIndex = [self getValidNextPageIndexWithPageIndex:_currentPageIndex + 1];
    
    self.currentArray = (_currentArray?:[NSMutableArray new]);
    
    _currentArray.count == 0 ?:[_currentArray removeAllObjects];
    
    if (_imageArray) {
        if (_imageArray.count >= 3) {
            [_currentArray addObject:_imageArray[previousPageIndex]];
            [_currentArray addObject:_imageArray[_currentPageIndex]];
            [_currentArray addObject:_imageArray[rearPageIndex]];
        }
        else{
            [self getImageFromArray:_imageArray[previousPageIndex]];
            [self getImageFromArray:_imageArray[_currentPageIndex]];
            [self getImageFromArray:_imageArray[rearPageIndex]];
        }
    }
    
    [_currentArray enumerateObjectsUsingBlock:^(UIImageView *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.userInteractionEnabled = YES;
        CGRect rightRect = self.scrollView.frame;
        rightRect.origin = CGPointMake(CGRectGetWidth(self.scrollView.frame) * idx, 0);
        obj.frame = rightRect;
        [self.scrollView addSubview:obj];
    }];
    
    [self.scrollView setContentOffset:CGPointMake(CGRectGetWidth(self.scrollView.frame), 0)];
}

- (NSInteger)getValidNextPageIndexWithPageIndex:(NSInteger)currentPageIndex;
{
    if(currentPageIndex == -1){
        return self.images.count - 1;
    }
    else if (currentPageIndex == self.images.count){
        return 0;
    }
    else
        return currentPageIndex;
}

/**
 *  解决小于三个图片显示的bug
 *
 *  @param imageView 原始图
 */
-(void)getImageFromArray:(UIImageView *)imageView{
    //开辟自动释放池
    @autoreleasepool {
        UIImageView *tempImage = [[UIImageView alloc]initWithFrame:imageView.frame];
        tempImage.image = imageView.image;
        [_currentArray addObject:tempImage];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (_need) {
        [self.animationTimer setFireDate:[NSDate distantFuture]];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (_need) {
        [self.animationTimer setFireDate:[NSDate dateWithTimeIntervalSinceNow:self.duration]];
    }
}

- (void)pause {
    [self.animationTimer setFireDate:[NSDate distantFuture]];
}

- (void)start {
    [self.animationTimer setFireDate:[NSDate distantPast]];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int contentOffsetX = scrollView.contentOffset.x;
    if(contentOffsetX >= (2 * CGRectGetWidth(scrollView.frame))) {
        self.currentPageIndex = [self getValidNextPageIndexWithPageIndex:self.currentPageIndex + 1];
        _pageControl.currentPage = _currentPageIndex;
        [self configContentViews];
    }
    if(contentOffsetX <= 0) {
        self.currentPageIndex = [self getValidNextPageIndexWithPageIndex:self.currentPageIndex - 1];
        _pageControl.currentPage = _currentPageIndex;
        [self configContentViews];
    }
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [scrollView setContentOffset:CGPointMake(CGRectGetWidth(scrollView.frame), 0) animated:YES];
}


#pragma mark - 循环事件
- (void)animationTimerDidFired:(NSTimer *)timer
{
    CGPoint newOffset = CGPointMake(self.scrollView.contentOffset.x + CGRectGetWidth(self.scrollView.frame), self.scrollView.contentOffset.y);
    [self.scrollView setContentOffset:newOffset animated:YES];
}

#pragma mark - 响应事件
- (void)tapAction
{
    if (self.block) {
        self.block(self.currentPageIndex);
    }
}


#pragma mark - 外部API

-(void)startWithTapActionNeedAutoScro:(BOOL)need Block:(tapActionBlock)block{
    _need = need;
    [self downLoadImage];
    if (_need) {
        [self.animationTimer setFireDate:[NSDate date]];
    }
    self.block = block;
}

-(void)stop{
    [self.animationTimer invalidate];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
