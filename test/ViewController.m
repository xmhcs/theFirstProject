//
//  ViewController.m
//  test
//
//  Created by xunmei on 2017/7/14.
//  Copyright © 2017年 xunmei. All rights reserved.
//

#import "ViewController.h"
#import "RulerAutoView/RulerAutoView.h"
#import "AdvertisementPlayView.h"
#import "PagePointAnmiatedView.h"

@interface ViewController ()
{
    dispatch_group_t _group;
}


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self animate];
}

- (void)animate
{
    PagePointAnmiatedView *pageview = [[PagePointAnmiatedView alloc] initWithFrame:CGRectMake(100, 100, 100, 20)];
    [self.view addSubview:pageview];
    
    [pageview animatePagePointAnmiatedView:0.5];

}

- (void)yyyy
{
//    NSMutableArray * imgs = [NSMutableArray array];
//    for (AdverListModel * model in weakSelf.bannerModels) {
//        [imgs addObject:[NSString stringWithFormat:@"%@%@",AddressUrl, model.Img]];
//    }
//    weakSelf.banner = [AdvertisementPlayView BannerViewWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth / 16 * 9) images:imgs];
//    [self.bannerView addSubview:weakSelf.banner];
//    [weakSelf.banner startWithTapActionNeedAutoScro:YES Block:^(NSInteger index) {
//        NSLog(@"%ld", (long)index);
//    }];
    
    RulerAutoView *rulerView = [RulerAutoView showRulerScrollViewWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 240) smallMode:YES];
    
    [self.view addSubview:rulerView];
    
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0; i < 5; i ++ ) {
        RulerTimeQuantumModel *model = [[RulerTimeQuantumModel alloc] init];
        
        int startHour = arc4random() % 24;
        int startMin = arc4random() % 60;
        int startSecond = arc4random() % 60;
        
        int length = arc4random() % 16 + 6;
        
        model.startTime = [NSString stringWithFormat:@"%02d%02d%02d",startHour,startMin,startSecond];
        model.timeLength = [NSString stringWithFormat:@"%d",length];
        [arr addObject:model];
    }
    
    rulerView.rulerTimeQuantumModelArray = [arr mutableCopy];
    

}

- (void)testtttt{
    //    _group = dispatch_group_create();
    
    //    [self test1];
    
    
    //    NSArray *sdjh = @[@"hsjd",@"sdh",@"sdbvk"];
    
    NSMutableArray *array = [NSMutableArray arrayWithObjects:@"hsjd",@"sdh",@"sdbvk",@"sd234", nil];
    NSLog(@"change_before_%@",array);
    
    NSArray *ggg = @[@"1",@"2",@"3",@"4"];
    
    NSRange range = NSMakeRange(2, [ggg count]);
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
    
    [array insertObjects:ggg atIndexes:indexSet];
    
    NSLog(@"change_later_%@",array);


}

- (void)test1
{
    
    dispatch_group_async(_group, dispatch_queue_create("com.dispatch.test", DISPATCH_QUEUE_CONCURRENT), ^{
        
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://www.baidu.com"]];
        NSURLSessionDownloadTask *task = [[NSURLSession sharedSession] downloadTaskWithRequest:request completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            // 请求完成，可以通知界面刷新界面等操作
            NSLog(@"第一步网络请求完成");
            dispatch_semaphore_signal(sema);
        }];
        [task resume];
        // 以下还要进行一些其他的耗时操作
        NSLog(@"耗时操作继续进行");
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    });

    
    dispatch_group_async(_group, dispatch_queue_create("com.dispatch.test", DISPATCH_QUEUE_CONCURRENT), ^{
        
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://www.github.com"]];
        NSURLSessionDownloadTask *task = [[NSURLSession sharedSession] downloadTaskWithRequest:request completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            // 请求完成，可以通知界面刷新界面等操作
            NSLog(@"第二步网络请求完成");
            dispatch_semaphore_signal(sema);
        }];
        [task resume];
        // 以下还要进行一些其他的耗时操作
        NSLog(@"耗时操作继续进行");
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    });
    
    dispatch_group_notify(_group, dispatch_get_main_queue(), ^{
        NSLog(@"刷新界面等在主线程的操作");
    });
    

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
