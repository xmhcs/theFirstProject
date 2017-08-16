//
//  RulerAutoView.m
//  test
//
//  Created by xunmei on 2017/7/25.
//  Copyright © 2017年 xunmei. All rights reserved.
//

#import "RulerAutoView.h"
#import "RulerCollectionViewCell.h"

#define SHEIGHT 8 // 中间指示器顶部闭合三角形高度
#define INDICATORCOLOR [UIColor yellowColor].CGColor // 中间指示器颜色

static NSString * const RulerCollectionViewCellId = @"RulerCollectionViewCellIdentifier";

@interface RulerAutoView  ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    double timeNum;
}

@property (strong,nonatomic) UICollectionView *rulerCollectionView;

@property (assign,nonatomic) RulerCollectionViewCellTimeStyle timeStyle;

//@property (strong,nonatomic) NSMutableArray *timeStyleMinDataSourchArray;
//
//@property (strong,nonatomic) NSMutableArray *timeStyleHourDataSourchArray;

@property (strong,nonatomic) NSMutableDictionary *timeStyleMinModelArrayDictionary;
@property (strong,nonatomic) NSMutableDictionary *timeStyleHourModelArrayDictionary;
@end

@implementation RulerAutoView

+ (instancetype)showRulerScrollViewWithCount:(NSUInteger)count average:(NSNumber *)average currentValue:(CGFloat)currentValue smallMode:(BOOL)mode
{
    return nil;
}

+ (instancetype)showRulerScrollViewWithFrame:(CGRect)frame smallMode:(BOOL)mode
{
    RulerAutoView *rulerView = [[RulerAutoView alloc] initWithFrame:frame];
    return rulerView;

}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.timeStyle = RulerCollectionViewCellTimeStyleHour;
        
        [self addSubview:self.rulerCollectionView];
        
        [self drawRacAndLine];
        
        UIButton *autoScorll = [UIButton buttonWithType:UIButtonTypeCustom];
        autoScorll.frame = CGRectMake(0, 0, 150, 30);
        [autoScorll setTitle:@"Auto Scroll 11s" forState:UIControlStateNormal];
        
        [autoScorll addTarget:self action:@selector(autoScrollButtonClick:) forControlEvents:UIControlEventTouchUpInside];

        [autoScorll setBackgroundColor:[UIColor cyanColor]];
   
        [self addSubview:autoScorll];
        
        UIButton *min = [UIButton buttonWithType:UIButtonTypeCustom];
        min.frame = CGRectMake(160, 0, 100, 30);
        min.tag = 20001;
        [min setTitle:@"分钟" forState:UIControlStateNormal];
        [min setBackgroundColor:[UIColor greenColor]];
        [min addTarget:self action:@selector(changeScrollTimeStyle:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:min];
        
        UIButton *hour = [UIButton buttonWithType:UIButtonTypeCustom];
        hour.frame = CGRectMake(270, 0, 100, 30);
        hour.tag = 20002;
        [hour setTitle:@"小时" forState:UIControlStateNormal];
        [hour setBackgroundColor:[UIColor purpleColor]];
        [hour addTarget:self action:@selector(changeScrollTimeStyle:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:hour];
        
    }
    return self;
    

}

#pragma mark - collectionView
- (NSUInteger)getCurrentCellNum
{
    if (self.timeStyle == RulerCollectionViewCellTimeStyleHour) {
        return 24 + 1;
    }else
    {
        return 24 * 60 + 1;
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self getCurrentCellNum];
}



- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RulerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:RulerCollectionViewCellId forIndexPath:indexPath];
    
//        cell.backgroundColor = [UIColor colorWithRed:(arc4random() % 256)/255.0 green:(arc4random() % 256)/255.0 blue:(arc4random() % 256)/255.0 alpha:1.0];
    
//    [cell drawRuler];
    
    
    
    BOOL isEnd = indexPath.row == ([self getCurrentCellNum] - 1) ? YES : NO;
    BOOL isHead = indexPath.row == 0 ? YES : NO;
    if (isHead) {
        [cell drawRulerWithCellStyle:RulerCollectionViewCellLineStyleHead];
    }else if (isEnd){
        [cell drawRulerWithCellStyle:RulerCollectionViewCellLineStyleEnd];
    }else
    {
        [cell drawRulerWithCellStyle:RulerCollectionViewCellLineStyleNormal];
    }
    
    [cell setCellLabelText:indexPath timeStyle:self.timeStyle lastCell:isEnd];
    
    NSArray *timeListArray;
    NSString *keyValue = [NSString stringWithFormat:@"%ld",indexPath.row];
    if (self.timeStyle == RulerCollectionViewCellTimeStyleHour) {
        timeListArray = [self.timeStyleHourModelArrayDictionary objectForKey:keyValue];
    }else
    {
        timeListArray = [self.timeStyleMinModelArrayDictionary objectForKey:keyValue];
    }
    [cell setPlayVideoTime:indexPath list:timeListArray timeStyle:self.timeStyle];
    
    return cell;
    
}

/*
 时间段管理说明：
 一、 RulerCollectionViewCellTimeStyleHour 小时制时
 1、RulerCollectionViewCellLineStyleNormal类型的cell管理的时间段为上一小时的29分00秒起到本小时29分00秒止00:29:00~01:29:00  当前label为01:00:00
 2、RulerCollectionViewCellLineStyleHead类型的cell管理的时间段为00时00分00秒起到00时29分00秒止00:00:00~00:29:00  当前label为00:00:00
 3、RulerCollectionViewCellLineStyleEnd类型的cell管理的时间段为23时29分00秒起到24时00分00秒止23:29:00~24:00:00  当前label为24:00:00
 
 二、 RulerCollectionViewCellTimeStyleMin 分钟制时，
 1、RulerCollectionViewCellLineStyleNormal类型的cell管理的时间段为上一分钟的29秒起到本分钟29秒止  00:01:29~00:02:29  当前label为00:02:00
 2、RulerCollectionViewCellLineStyleHead类型的cell管理的时间段为00时00分00秒起到00时00分29秒止00:00:00~00:00:29  当前label为00:00:00
 3、RulerCollectionViewCellLineStyleEnd类型的cell管理的时间段为23时29分00秒起到24时00分00秒止23:59:29~24:00:00  当前label为24:00:00
 
 三、另外有跨天的情况下，直接在24:00:00后画
 */

- (void)handleTimeQuantumListArray
{
    NSArray *resultArray = [NSArray arrayWithArray:_rulerTimeQuantumModelArray];
    NSMutableArray *timeStyleMinDataSourchArray = [NSMutableArray array];
    NSMutableArray *timeStyleHourDataSourchArray = [NSMutableArray array];
    
    resultArray = [resultArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        
        RulerTimeQuantumModel *model1 = obj1;
        RulerTimeQuantumModel *model2 = obj2;
        
        NSComparisonResult result = [[NSNumber numberWithInt:model1.startTime.intValue] compare:[NSNumber numberWithInt:model2.startTime.intValue]];
        // 升序
        return result == NSOrderedDescending;
    }];
    
    _rulerTimeQuantumModelArray = [NSMutableArray arrayWithArray:resultArray];
    for (int i = 0; i < _rulerTimeQuantumModelArray.count; i ++) {
        RulerTimeQuantumModel *model = [_rulerTimeQuantumModelArray objectAtIndex:i];
        if (model.startTime && model.startTime.length >= 6) {
            
            NSString *startTime = [model.startTime substringToIndex:6];
            NSString *endTime;
            
            if (model.endTime && model.endTime.length >= 6) {
                endTime = [model.endTime substringToIndex:6];
    
                if(model.timeLength == nil){
                
                    model.timeLength = [self dateTimeDifferenceWithStartTime:startTime endTime:endTime];
                }else
                {
                    if (model.timeLength.intValue == [self dateTimeDifferenceWithStartTime:startTime endTime:endTime].intValue) {
                        
                    }else
                    {
//                        NSLog(@"%@---",model);
                        break;
                    }
                }
                
            }else
            {
                if(model.timeLength){
                    
                    model.endTime = [self dateTimeDifferenceWithStartTime:startTime timeLength:model.timeLength];
                    
                    endTime = model.endTime;
                    
                }else
                {
//                    NSLog(@"%@---",model);
                    break;
                
                }
            
            }
            
            NSString *startHour = [startTime substringToIndex:2];
            NSString *startMin = [startTime substringWithRange:NSMakeRange(2, 2)];
            NSString *startSecond = [startTime substringFromIndex:4];
            
            NSString *endHour = [endTime substringToIndex:2];
            NSString *endMin = [endTime substringWithRange:NSMakeRange(2, 2)];
            NSString *endSecond = [endTime substringFromIndex:4];
            
            if (startHour.intValue > 24) {
                NSLog(@"************>24*******%@---%@---%@",model.startTime,model.endTime,model.timeLength);
            }
            
            // 分钟制下的处理
            if (model.timeLength.intValue < 60) {
                
                if (model.timeLength.intValue < 30) {
                    
                    if (startMin.intValue < endMin.intValue) {
                        
                        int keyValue = endHour.intValue * 60 + endMin.intValue;
                        NSString *key = [NSString stringWithFormat:@"%d",keyValue];
                        
                        model.key = key;
                        NSLog(@"//结束时间本cell 跨00 \nstartTime:%@---\nendTime:%@----\nleng:%@--\nkey:%@",model.startTime,model.endTime,model.timeLength,model.key);
                        [timeStyleMinDataSourchArray addObject:model];
                    }else if (startMin.intValue == endMin.intValue){
                    
                        if (startSecond.intValue < 29) {
                            
                            if (endSecond.intValue < 29) {
                                
                                int keyValue = endHour.intValue * 60 + endMin.intValue;
                                NSString *key = [NSString stringWithFormat:@"%d",keyValue];
                                
                                model.key = key;
                                NSLog(@"//结束时间本cell 00右 \nstartTime:%@---\nendTime:%@----\nleng:%@--\nkey:%@",model.startTime,model.endTime,model.timeLength,model.key);
                                [timeStyleMinDataSourchArray addObject:model];
                            }else
                            {
                                RulerTimeQuantumModel *modelHead = [[RulerTimeQuantumModel alloc] init];
                                modelHead.startTime = startTime;
                                modelHead.endTime = [NSString stringWithFormat:@"%@%@%d",startHour,startMin,29];
                                modelHead.timeLength = [self dateTimeDifferenceWithStartTime:modelHead.startTime endTime:modelHead.endTime];
                                int startKeyValue = startHour.intValue * 60 + startMin.intValue;
                                NSString *startkey = [NSString stringWithFormat:@"%d",startKeyValue];
                                modelHead.key = startkey;
                                [timeStyleMinDataSourchArray addObject:modelHead];
                                
                                NSLog(@"开始时间本cell 00右 跨cell \nstartTime:%@---\nendTime:%@----\nleng:%@--\nkey:%@",modelHead.startTime,modelHead.endTime,modelHead.timeLength,modelHead.key);
                                
                                RulerTimeQuantumModel *modelEnd = [[RulerTimeQuantumModel alloc] init];
                                modelEnd.startTime = [NSString stringWithFormat:@"%@%@%d",startHour,startMin,29];
                                modelEnd.endTime = endTime;
                                modelEnd.timeLength = [self dateTimeDifferenceWithStartTime:modelEnd.startTime endTime:modelEnd.endTime];
                                int endKeyValue = modelHead.key.intValue + 1;
                                NSString *endkey = [NSString stringWithFormat:@"%d",endKeyValue];
                                modelEnd.key = endkey;
                                [timeStyleMinDataSourchArray addObject:modelEnd];
                                
                            }
                            
                        }else
                        {
                            int keyValue = endHour.intValue * 60 + endMin.intValue + 1;
                            NSString *key = [NSString stringWithFormat:@"%d",keyValue];
                            
                            model.key = key;
                            NSLog(@"//结束时间下一个cell 左00 \nstartTime:%@---\nendTime:%@----\nleng:%@--\nkey:%@",model.startTime,model.endTime,model.timeLength,model.key);
                            [timeStyleMinDataSourchArray addObject:model];
                            
                        }

                    }
                }
                
//                if (endMin.intValue <= 29) {//结束时间本cell 不跨区
//        
//                    int keyValue = endHour.intValue * 60 + endMin.intValue;
//                    NSString *key = [NSString stringWithFormat:@"%d",keyValue];
//                    model.key = key;
////                    NSLog(@"endSecond.intValue <= 29\nstartTime:%@---\nendTime:%@----\nleng:%@--\nkey:%@",model.startTime,model.endTime,model.timeLength,model.key);
//                    [timeStyleMinDataSourchArray addObject:model];
//                    
//                }else
//                {
//                    if (startSecond.intValue >= 29) { //开始时间本cell 不跨区
//                        int keyValue = startHour.intValue * 60 + startMin.intValue;
//                        NSString *key = [NSString stringWithFormat:@"%d",keyValue];
//                        model.key = key;
////                        NSLog(@"startTime.intValue >= 29\nstartTime:%@---\nendTime:%@----\nleng:%@--\nkey:%@",model.startTime,model.endTime,model.timeLength,model.key);
//                        [timeStyleMinDataSourchArray addObject:model];
//                    }else
//                    {
//                        RulerTimeQuantumModel *modelHead = [[RulerTimeQuantumModel alloc] init];
//                        modelHead.startTime = startTime;
//                        modelHead.endTime = [NSString stringWithFormat:@"%@%@%d",startHour,startMin,29];
//                        modelHead.timeLength = [self dateTimeDifferenceWithStartTime:modelHead.startTime endTime:modelHead.endTime];
//                        int startKeyValue = startHour.intValue * 60 + startMin.intValue;
//                        NSString *startkey = [NSString stringWithFormat:@"%d",startKeyValue];
//                        modelHead.key = startkey;
//                        [timeStyleMinDataSourchArray addObject:modelHead];
//                        
////                        NSLog(@"startSecond.intValue < 29\nstartTime:%@---\nendTime:%@----\nleng:%@--\nkey:%@",modelHead.startTime,modelHead.endTime,modelHead.timeLength,modelHead.key);
//                        
//                        RulerTimeQuantumModel *modelEnd = [[RulerTimeQuantumModel alloc] init];
//                        modelEnd.startTime = [NSString stringWithFormat:@"%@%@%d",startHour,startMin,29];
//                        modelEnd.endTime = endTime;
//                        modelEnd.timeLength = [self dateTimeDifferenceWithStartTime:modelEnd.startTime endTime:modelEnd.endTime];
//                        int endKeyValue = modelHead.key.intValue + 1;
//                        NSString *endkey = [NSString stringWithFormat:@"%d",endKeyValue];
//                        modelEnd.key = endkey;
//                        [timeStyleMinDataSourchArray addObject:modelEnd];
//                    
////                        NSLog(@"startSecond.intValue < 29\nstartTime:%@---\nendTime:%@----\nleng:%@--\nkey:%@",modelEnd.startTime,modelEnd.endTime,modelEnd.timeLength,modelEnd.key);
//                    }
//                
//                }
                
            }else
            {
//                NSLog(@"dayu60000000---%@",model.timeLength);
            
            }
            
            RulerTimeQuantumModel *hourModel = [[RulerTimeQuantumModel alloc] init];
            hourModel.startTime = model.startTime;
            hourModel.endTime = model.endTime;
            hourModel.timeLength = model.timeLength;
            hourModel.key = @"";
            // 小时制下的处理
            if (hourModel.timeLength.intValue < 3600) {
                
                if (hourModel.timeLength.intValue < 1800) {
                    
                    if (startHour.intValue < endHour.intValue) {
                        
                        int hkeyValue = endHour.intValue;
                        NSString *hkey = [NSString stringWithFormat:@"%d",hkeyValue];
                        
                        hourModel.key = hkey;
                        NSLog(@"//结束时间本cell 跨00 \nstartTime:%@---\nendTime:%@----\nleng:%@--\nkey:%@",hourModel.startTime,hourModel.endTime,hourModel.timeLength,hourModel.key);
                        [timeStyleHourDataSourchArray addObject:hourModel];
                        
                        
                    }else if (startHour.intValue == endHour.intValue){
                        
                        if (startMin.intValue < 29) {
                            int hkeyValue = endHour.intValue;
                            NSString *hkey = [NSString stringWithFormat:@"%d",hkeyValue];
                            
                            hourModel.key = hkey;
                            NSLog(@"//结束时间本cell 00右 \nstartTime:%@---\nendTime:%@----\nleng:%@--\nkey:%@",hourModel.startTime,hourModel.endTime,hourModel.timeLength,hourModel.key);
                            [timeStyleHourDataSourchArray addObject:hourModel];
                        }else
                        {
                            int hkeyValue = endHour.intValue + 1;
                            NSString *hkey = [NSString stringWithFormat:@"%d",hkeyValue];
                            
                            hourModel.key = hkey;
                            NSLog(@"//结束时间下一个cell 左00 \nstartTime:%@---\nendTime:%@----\nleng:%@--\nkey:%@",hourModel.startTime,hourModel.endTime,hourModel.timeLength,hourModel.key);
                            [timeStyleHourDataSourchArray addObject:hourModel];
                        
                        }
                    }
                }
                
                
//                if (endHour.intValue ) {
//                    
//                    
//                    
//                }else
//                {
//                    if (startMin.intValue >= 29) { //开始时间本cell 不跨区
//                        int hkeyValue = startHour.intValue;
//                        NSString *hkey = [NSString stringWithFormat:@"%d",hkeyValue];
//                        hourModel.key = hkey;
//                        NSLog(@"startTime.intValue >= 29\nstartTime:%@---\nendTime:%@----\nleng:%@--\nkey:%@",hourModel.startTime,hourModel.endTime,hourModel.timeLength,hourModel.key);
//                        [timeStyleHourDataSourchArray addObject:hourModel];
//                    }else
//                    {
//                        RulerTimeQuantumModel *modelHead = [[RulerTimeQuantumModel alloc] init];
//                        modelHead.startTime = startTime;
//                        modelHead.endTime = [NSString stringWithFormat:@"%@%@%d",startHour,startMin,29];
//                        modelHead.timeLength = [self dateTimeDifferenceWithStartTime:modelHead.startTime endTime:modelHead.endTime];
//                        int hstartKeyValue = startHour.intValue;
//                        NSString *hstartkey = [NSString stringWithFormat:@"%d",hstartKeyValue];
//                        modelHead.key = hstartkey;
//                        [timeStyleHourDataSourchArray addObject:modelHead];
//                        
//                        NSLog(@"startSecond.intValue < 29\nstartTime:%@---\nendTime:%@----\nleng:%@--\nkey:%@",modelHead.startTime,modelHead.endTime,modelHead.timeLength,modelHead.key);
//                        
//                        RulerTimeQuantumModel *modelEnd = [[RulerTimeQuantumModel alloc] init];
//                        modelEnd.startTime = [NSString stringWithFormat:@"%@%@%d",startHour,startMin,29];
//                        modelEnd.endTime = endTime;
//                        modelEnd.timeLength = [self dateTimeDifferenceWithStartTime:modelEnd.startTime endTime:modelEnd.endTime];
//                        int hendKeyValue = modelHead.key.intValue + 1;
//                        NSString *hendkey = [NSString stringWithFormat:@"%d",hendKeyValue];
//                        modelEnd.key = hendkey;
//                        [timeStyleHourDataSourchArray addObject:modelEnd];
//                        
//                        NSLog(@"startSecond.intValue < 29\nstartTime:%@---\nendTime:%@----\nleng:%@--\nkey:%@",modelEnd.startTime,modelEnd.endTime,modelEnd.timeLength,modelEnd.key);
//                    }
//                    
//                }
                
            }else
            {
                NSLog(@"dayu60000000---%@",model.timeLength);
                
            }
        }else
        {
            NSLog(@"handleTimeQuantumListArray_RulerTimeQuantumModel_model_error");
        }
    }
    
//    NSString *string = [self dateTimeDifferenceWithStartTime:@"035623" endTime:@"035610"];

//    NSLog(@"%@-----00000000",string);
    
//    for (RulerTimeQuantumModel *model00 in self.timeStyleMinDataSourchArray) {
//        NSLog(@"\nstartTime:%@---\nendTime:%@----\nleng:%@--\nkey:%@",model00.startTime,model00.endTime,model00.timeLength,model00.key);
//    }
//    
//    for (RulerTimeQuantumModel *modelh in self.timeStyleHourDataSourchArray) {
//        NSLog(@"hour\nstartTime:%@---\nendTime:%@----\nleng:%@--\nkey:%@",modelh.startTime,modelh.endTime,modelh.timeLength,modelh.key);
//    }
    self.timeStyleMinModelArrayDictionary = [self groupArrayDictionary:timeStyleMinDataSourchArray];

    self.timeStyleHourModelArrayDictionary = [NSMutableDictionary dictionaryWithDictionary:[self groupArrayDictionary:timeStyleHourDataSourchArray]];
    
    [self.rulerCollectionView reloadData];
    
    NSLog(@"--timeStyleMinModelArrayDictionary--%@\n---timeStyleHourModelArrayDictionary--%@",self.timeStyleMinModelArrayDictionary,self.timeStyleHourModelArrayDictionary);
    
    NSLog(@"-----------------------------handleTimeQuantumListArray---------------------");

}

- (NSMutableDictionary *)groupArrayDictionary:(NSArray <RulerTimeQuantumModel *>*)dataArray{

    if (dataArray && [dataArray isKindOfClass:[NSArray class]]) {
        NSMutableArray *keyArr = [NSMutableArray array];
        
        [dataArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            if (obj && [obj isKindOfClass:[RulerTimeQuantumModel class]]) {
                
                RulerTimeQuantumModel *model = (RulerTimeQuantumModel *)obj;
                NSString *key = model.key;
                [keyArr addObject:key];
            }
        }];
        //去重
        NSSet *set = [NSSet setWithArray:keyArr];
        NSArray *userArray = [set allObjects];
        //yes升序排列，no,降序排列
        NSSortDescriptor *sd1 = [NSSortDescriptor sortDescriptorWithKey:nil ascending:YES];
        NSArray *myary = [userArray sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sd1, nil]];

        NSMutableDictionary *dataDictionary = [NSMutableDictionary dictionary];
        [myary enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSString *keyValue = (NSString *)obj;
            
            if (keyValue) {
                NSMutableArray *modelArray = [NSMutableArray array];
                for (RulerTimeQuantumModel *model in dataArray)
                {
                    NSString *key = model.key;
                    if([keyValue isEqualToString:key])
                    {
                        [modelArray addObject:model];
                    }
                }
                [dataDictionary setObject:modelArray forKey:keyValue];
            }
   
            
        }];
        
        NSLog(@"----%@",dataDictionary);
        return dataDictionary;
        
    }else
    {
        return [NSMutableDictionary dictionary];
    }


}

/**
 * 开始到结束的时间差
 */
- (NSString *)dateTimeDifferenceWithStartTime:(NSString *)startTime endTime:(NSString *)endTime{
    NSDateFormatter *date = [[NSDateFormatter alloc]init];
    [date setDateFormat:@"HHmmss"];
    NSDate *startD =[date dateFromString:startTime];
    NSDate *endD = [date dateFromString:endTime];
    NSTimeInterval start = [startD timeIntervalSince1970]*1;
    NSTimeInterval end = [endD timeIntervalSince1970]*1;
    NSTimeInterval value = end - start;
//    int second = (int)value %60;//秒
//    int minute = (int)value /60%60;
//    int house = (int)value / (24 * 3600)%3600;
//    int day = (int)value / (24 * 3600);
//    NSString *str;
//    if (day != 0) {
//        str = [NSString stringWithFormat:@"耗时%d天%d小时%d分%d秒",day,house,minute,second];
//    }else if (day==0 && house != 0) {
//        str = [NSString stringWithFormat:@"耗时%d小时%d分%d秒",house,minute,second];
//    }else if (day== 0 && house== 0 && minute!=0) {
//        str = [NSString stringWithFormat:@"耗时%d分%d秒",minute,second];
//    }else{
//        str = [NSString stringWithFormat:@"耗时%d秒",second];
//    }
    
    NSString *str = [NSString stringWithFormat:@"%d",(int)value];
    return str;
}

/**
 * 开始
 */
- (NSString *)dateTimeDifferenceWithStartTime:(NSString *)startTime timeLength:(NSString *)timeLength{
    NSDateFormatter *date = [[NSDateFormatter alloc]init];
    [date setDateFormat:@"HHmmss"];
    NSDate *startD =[date dateFromString:startTime];
    NSTimeInterval start = [startD timeIntervalSince1970]*1;
    NSTimeInterval value = start + timeLength.intValue;
    NSDate *endD = [NSDate dateWithTimeIntervalSince1970:value];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HHmmss"];
    NSString *destDateString = [dateFormatter stringFromDate:endD];
    
    return destDateString;
}

#pragma mark - buttonClick
- (void)changeScrollTimeStyle:(UIButton *)button
{

    if (button.tag == 20001) {
        self.timeStyle = RulerCollectionViewCellTimeStyleMin;
    }else
    {
        self.timeStyle = RulerCollectionViewCellTimeStyleHour;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.rulerCollectionView reloadData];
    });

    double rulerValue;
//    NSLog(@"timeNum------%f",timeNum);
    if (self.timeStyle == RulerCollectionViewCellTimeStyleHour) {
        rulerValue = timeNum / 120.0;
    }else
    {
        rulerValue = timeNum / 2.0;
    }
    
    NSString *numStr = [NSString stringWithFormat:@"%d",RULERCOUNTNUM];
    double num = [numStr doubleValue];
    CGFloat rulerValueRule = rulerValue * RULERCELLWTDTH / RULERCOUNTNUM;

    CGFloat offset = rulerValueRule - RULERCELLWTDTH  * (RULERCOUNTNUM * 0.5 - 2.5) / num - 0.68;
    
//    NSLog(@"rulerValueRule===%f-----offset===%f",rulerValueRule,offset);
    self.rulerCollectionView.contentOffset = CGPointMake(offset , 0);
    
}

- (void)autoScrollButtonClick:(UIButton *)button
{
    
    __block NSInteger time = 11; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(timer,DISPATCH_TIME_NOW,1.0*NSEC_PER_SEC, 0); //每秒执行
    
    dispatch_source_set_event_handler(timer, ^{
        if(time <= 0){ //倒计时结束，关闭
            dispatch_source_cancel(timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                button.enabled = YES;
                [button setBackgroundColor:[UIColor cyanColor]];
            });
            
        }else{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.rulerCollectionView.contentOffset.x >= (RULERCELLWTDTH * [self getCurrentCellNum] + self.frame.size.width)) {}else
                {
                    if (self.timeStyle == RulerCollectionViewCellTimeStyleHour) {
                        
                        // 1.0 1秒  120 = 1小时3600秒 RULERCOUNTNUM格 == 3600/30
                        // 2 = 1分钟60秒 RULERCOUNTNUM格 == 60/30
                        self.rulerCollectionView.contentOffset = CGPointMake(self.rulerCollectionView.contentOffset.x + (1.0/120.0) * RULERCELLWTDTH / 30.0 , 0);
                    }else
                    {
                        self.rulerCollectionView.contentOffset = CGPointMake(self.rulerCollectionView.contentOffset.x + ((1.0/2.0) * RULERCELLWTDTH / 30.0) - 0.05, 0);
                    }
                }
            });
            time--;
        }
    });
    dispatch_resume(timer);
    
    button.enabled = NO;
    [button setBackgroundColor:[UIColor grayColor]];
    
}

#pragma mark - ScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    // 0.68 误差调零
    CGFloat offSetX = scrollView.contentOffset.x + RULERCELLWTDTH  * (RULERCOUNTNUM * 0.5 - 2.5) / RULERCOUNTNUM + 0.68;
    
//    NSLog(@"offSetX-====%f---contentOffset===%f",offSetX,scrollView.contentOffset.x);
    CGFloat ruleValue = offSetX * RULERCOUNTNUM / RULERCELLWTDTH;
    if (ruleValue < 0.f) {
        return;
    } else if (ruleValue > RULERCOUNTNUM * [self getCurrentCellNum]) {
        return;
    }
    
    NSString *curOffset = [NSString stringWithFormat:@"%f",offSetX];
//    NSLog(@"000000****%@",curOffset);
    NSString *curText = [NSString stringWithFormat:@"当前刻度值: %.4f",ruleValue];
    
    if (self.timeStyle == RulerCollectionViewCellTimeStyleHour) {
        timeNum = ruleValue * 120.0;
    }else
    {
        timeNum = ruleValue * 2.0;
    }
    
//    NSLog(@"%f+++++",timeNum);
    
//    NSInteger hour = timeNum % 60;
    int totalSeconds = round(timeNum);
    
    int hour = totalSeconds / 3600;
    int min = (totalSeconds%3600)/60;
    int second = totalSeconds%60;
    
    NSString *curTime = [NSString stringWithFormat:@"当前时间: %02d:%02d:%02d",hour,min,second];
    
//    NSLog(@"--%@",curText);
//    
//    NSLog(@"当前时间--%@",curTime);
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    //    [self animationRebound:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    //    [self animationRebound:scrollView];
}

#pragma mark - rulerHandle
- (void)animationRebound:(UIScrollView *)scrollView {
    CGFloat offSetX = scrollView.contentOffset.x + self.rulerCollectionView.frame.size.width / 2 - 200/30;
    CGFloat oX = (offSetX / 200/30) * 1;
#ifdef DEBUG
    NSLog(@"ago*****************ago:oX:%f",oX);
#endif
    if ([self valueIsInteger:[NSNumber numberWithInteger:1]]) {
        oX = [self notRounding:oX afterPoint:0];
    }
    else {
        oX = [self notRounding:oX afterPoint:1];
    }
#ifdef DEBUG
    NSLog(@"after*****************after:oX:%.1f",oX);
#endif
    CGFloat offX = (oX / (1)) * 200/30 + 200/30 - self.rulerCollectionView.frame.size.width / 2;
    [UIView animateWithDuration:.2f animations:^{
        scrollView.contentOffset = CGPointMake(offX, 0);
    }];
}

- (CGFloat)notRounding:(CGFloat)price afterPoint:(NSInteger)position {
    NSDecimalNumberHandler*roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain scale:position raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber*ouncesDecimal;
    NSDecimalNumber*roundedOunces;
    ouncesDecimal = [[NSDecimalNumber alloc]initWithFloat:price];
    roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    return [roundedOunces floatValue];
}

- (BOOL)valueIsInteger:(NSNumber *)number {
    NSString *value = [NSString stringWithFormat:@"%f",[number floatValue]];
    if (value != nil) {
        NSString *valueEnd = [[value componentsSeparatedByString:@"."] objectAtIndex:1];
        NSString *temp = nil;
        for(int i =0; i < [valueEnd length]; i++)
        {
            temp = [valueEnd substringWithRange:NSMakeRange(i, 1)];
            if (![temp isEqualToString:@"0"]) {
                return NO;
            }
        }
    }
    return YES;
}

#pragma mark - shapeLayer_Line
- (void)drawRacAndLine {
    
    // 指示器
    CAShapeLayer *shapeLayerLine = [CAShapeLayer layer];
    shapeLayerLine.strokeColor = INDICATORCOLOR;
    shapeLayerLine.fillColor = INDICATORCOLOR;
    shapeLayerLine.lineWidth = 1.f;
    shapeLayerLine.lineCap = kCALineCapSquare;
    
    NSUInteger ruleHeight = 20;
    CGMutablePathRef pathLine = CGPathCreateMutable();
    CGPathMoveToPoint(pathLine, NULL, self.rulerCollectionView.frame.size.width / 2, self.rulerCollectionView.frame.origin.y + self.rulerCollectionView.frame.size.height - ruleHeight - SHEIGHT);//G1
    CGPathAddLineToPoint(pathLine, NULL, self.rulerCollectionView.frame.size.width / 2 - SHEIGHT / 2, self.rulerCollectionView.frame.origin.y + self.rulerCollectionView.frame.size.height - ruleHeight);//G2
    CGPathAddLineToPoint(pathLine, NULL, self.rulerCollectionView.frame.size.width / 2 + SHEIGHT / 2, self.rulerCollectionView.frame.origin.y + self.rulerCollectionView.frame.size.height - ruleHeight);//G3
    CGPathAddLineToPoint(pathLine, NULL, self.rulerCollectionView.frame.size.width / 2, self.rulerCollectionView.frame.origin.y + self.rulerCollectionView.frame.size.height - ruleHeight - SHEIGHT);//G1
    CGPathAddLineToPoint(pathLine, NULL, self.rulerCollectionView.frame.size.width / 2, self.rulerCollectionView.frame.origin.y + ruleHeight + SHEIGHT); //G4
    CGPathAddLineToPoint(pathLine, NULL, self.rulerCollectionView.frame.size.width / 2 - SHEIGHT / 2, self.rulerCollectionView.frame.origin.y + ruleHeight); //G5
    CGPathAddLineToPoint(pathLine, NULL, self.rulerCollectionView.frame.size.width / 2 + SHEIGHT / 2, self.rulerCollectionView.frame.origin.y + ruleHeight); //G6
    CGPathAddLineToPoint(pathLine, NULL, self.rulerCollectionView.frame.size.width / 2,self.rulerCollectionView.frame.origin.y +  ruleHeight + SHEIGHT); //G4
    shapeLayerLine.path = pathLine;
    CGPathRelease(pathLine);
    [self.layer addSublayer:shapeLayerLine];
}

#pragma mark - setter&&getter
- (UICollectionView *)rulerCollectionView
{
    if (!_rulerCollectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        layout.itemSize = CGSizeMake(RULERCELLWTDTH, RULERCELLHEIGHT);
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _rulerCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 40,self.frame.size.width, self.frame.size.height - 40)
                                                  collectionViewLayout:layout];
        [_rulerCollectionView registerClass:[RulerCollectionViewCell class] forCellWithReuseIdentifier:RulerCollectionViewCellId];
//        _rulerCollectionView.backgroundColor = [UIColor colorWithRed:61/255.0 green:61/255.0 blue:61/255.0 alpha:1.0];
        _rulerCollectionView.backgroundColor = [UIColor lightGrayColor];
        _rulerCollectionView.showsVerticalScrollIndicator = NO;
        _rulerCollectionView.showsHorizontalScrollIndicator = NO;
        
        NSString *numStr = [NSString stringWithFormat:@"%d",RULERCOUNTNUM];
        double num = [numStr doubleValue];
        // 0.5 0.9 误差补偿 2.5格 1.5格
        _rulerCollectionView.contentInset = UIEdgeInsetsMake(0, RULERCELLWTDTH  * (RULERCOUNTNUM * 0.5 - 2.5) / num  + 0.9, 0, RULERCELLWTDTH  * (RULERCOUNTNUM * 0.5 - 1.5) / num + 0.5);
        
        _rulerCollectionView.dataSource = self;
        _rulerCollectionView.delegate = self;
        
    }
    return _rulerCollectionView;
    
}

- (void)setRulerTimeQuantumModelArray:(NSArray<RulerTimeQuantumModel *> *)rulerTimeQuantumModelArray
{
    if (rulerTimeQuantumModelArray && [rulerTimeQuantumModelArray isKindOfClass:[NSArray class]]) {
        _rulerTimeQuantumModelArray = rulerTimeQuantumModelArray;
        NSLog(@"-----------------------------handleTimeQuantumListArray---------------------");
        [self handleTimeQuantumListArray];
    }

}

//- (NSMutableDictionary *)timeStyleMinModelArrayDictionary
//{
//    if (_timeStyleMinModelArrayDictionary) {
//        _timeStyleMinModelArrayDictionary = [NSMutableDictionary dictionary];
//    }
//    return _timeStyleMinModelArrayDictionary;
//}
//
//- (NSMutableDictionary *)timeStyleHourModelArrayDictionary
//{
//    if (_timeStyleHourModelArrayDictionary) {
//        _timeStyleHourModelArrayDictionary = [NSMutableDictionary dictionary];
//    }
//    return _timeStyleHourModelArrayDictionary;
//}

//- (NSMutableArray *)timeStyleMinDataSourchArray
//{
//    if (_timeStyleMinDataSourchArray == nil) {
//        _timeStyleMinDataSourchArray = [NSMutableArray array];
//    }
//    return _timeStyleMinDataSourchArray;
//}
//
//- (NSMutableArray *)timeStyleHourDataSourchArray
//{
//    if (_timeStyleHourDataSourchArray == nil) {
//        _timeStyleHourDataSourchArray = [NSMutableArray array];
//    }
//    return _timeStyleHourDataSourchArray;
//
//}


@end
