//
//  RulerCollectionViewCell.m
//  TestDemo
//
//  Created by xunmei on 2017/7/24.
//  Copyright © 2017年 xunmei. All rights reserved.
//

#import "RulerCollectionViewCell.h"



@interface RulerCollectionViewCell ()

@property (nonatomic) NSUInteger rulerHeight;

@property (nonatomic) NSUInteger rulerWidth;

@property (nonatomic,assign) CGFloat distanceLeftAndRight;

@property (nonatomic,assign) CGFloat distanceValue;

@property (assign,nonatomic) RulerCollectionViewCellLineStyle lineStyle;

@end

@implementation RulerCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.rulerHeight = frame.size.height;
        self.rulerWidth = frame.size.width;
        self.distanceValue = frame.size.width / RULERCOUNTNUM;
        self.distanceLeftAndRight = self.distanceValue;
        self.lineStyle = RulerCollectionViewCellLineStyleNone;
//        self.clipsToBounds = YES;
    }
    return self;

}


- (void)setCellLabelText:(NSIndexPath *)indexPath timeStyle:(RulerCollectionViewCellTimeStyle)tiemStyle lastCell:(BOOL)isLastCell
{
    NSInteger hour,min;
    if (tiemStyle == RulerCollectionViewCellTimeStyleHour) {
        hour = indexPath.row;
        min = 0;
    }else
    {
        hour = indexPath.row / 60;
        min = indexPath.row % 60;
    }
    UILabel *label = [self viewWithTag:1000];
    if (label) {
        label.hidden = NO;
        label.text = [NSString stringWithFormat:@"%02ld:%02ld:00",hour,min];
        [label sizeToFit];
    }
    
//    UILabel *label2 = [self viewWithTag:1001];
//    if (label2 == nil) {
//        
//        label2 = [[UILabel alloc] init];
//        label2.textColor = [UIColor colorWithRed:82/255.0 green:82/255.0 blue:82/255.0 alpha:1.0];
//        label2.tag = 1001;
//        [self addSubview:label2];
//    }
//    if (isLastCell) {
//        label2.hidden = NO;
//        label2.text = [NSString stringWithFormat:@"%02ld:00:00",hour + 1];
//        CGSize textSize = [label.text sizeWithAttributes:@{ NSFontAttributeName : label2.font }];
//        
//        label2.frame = CGRectMake(self.frame.size.width + self.distanceValue - textSize.width / 2, (self.rulerHeight - textSize.height) * 0.5, 0, 0);
//        [label2 sizeToFit];
//    }else
//    {
//        label2.hidden = YES;
//        label2.text = @"";
//    }


}

// 时间间隔
- (NSTimeInterval)dateTimeDifferenceWithStartTime:(NSString *)curTime referenceTime:(NSString *)referenceTime timeLength:(NSString *)timeLength before:(BOOL)isBefore{
    NSString *startTimeStr = [NSString stringWithFormat:@"2000-01-01 %@",curTime];
    NSDateFormatter *date = [[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-MM-dd HHmmss"];
    NSDate *curD =[date dateFromString:startTimeStr];
    NSDate *referenceD = [date dateFromString:referenceTime];
    NSTimeInterval cur = [curD timeIntervalSince1970]*1;
    NSTimeInterval reference = [referenceD timeIntervalSince1970]*1;
    NSTimeInterval effect;
    if (isBefore) {
         effect = reference - timeLength.intValue;
    }else
    {
        effect = reference + timeLength.intValue;
    }
    NSTimeInterval result = cur - effect;
    
    return result;
}

- (void)setCellLabelTextString:(NSString *)textString lastCell:(BOOL)isLastCell
{
  

}

- (void)setPlayVideoTime:(NSIndexPath *)indexPath list:(NSArray <RulerTimeQuantumModel *>*)timeQuantumModelArray timeStyle:(RulerCollectionViewCellTimeStyle)tiemStyle
{
  
    NSArray *layerArray = [NSArray arrayWithArray:self.layer.sublayers];
    for (CALayer *layer in layerArray) {
        if ([layer isKindOfClass:[CAShapeLayer class]]) {
            // 移除之前的shapeLayerbg
            if ([layer.name isEqualToString:@"shapeLayerbg"]) {
                [layer removeFromSuperlayer];
            }
        }
    }
    if (timeQuantumModelArray && [timeQuantumModelArray isKindOfClass:[NSArray class]]) {
        
        
        CGMutablePathRef pathRefbg = CGPathCreateMutable();
        CAShapeLayer *shapeLayerbg = [CAShapeLayer layer];
        shapeLayerbg.name = @"shapeLayerbg";
//        shapeLayerbg.strokeColor = [UIColor colorWithRed:79/255.0 green:229/255.0 blue:68/255.0 alpha:1.0].CGColor;
//        shapeLayerbg.fillColor = [UIColor colorWithRed:79/255.0 green:229/255.0 blue:68/255.0 alpha:1.0].CGColor;
        
        shapeLayerbg.strokeColor = [UIColor purpleColor].CGColor;
        shapeLayerbg.fillColor = [UIColor purpleColor].CGColor;
        shapeLayerbg.lineWidth = 1.f;
        shapeLayerbg.lineCap = kCALineCapButt;

        for (RulerTimeQuantumModel *model in timeQuantumModelArray) {
            if (model && [model isKindOfClass:[RulerTimeQuantumModel class]]) {
                
                
                NSString *timeLength;
                NSInteger hour,min;
                NSTimeInterval singleTime;
                if (tiemStyle == RulerCollectionViewCellTimeStyleMin) {
                    hour = indexPath.row / 60;
                    min = indexPath.row % 60;
                    // 31 = 60 - 29 cell开始时间为 00:00:29
                    timeLength = [NSString stringWithFormat:@"%d",31];
                    singleTime = 60.0;
                }else
                {
                   
                    hour = indexPath.row;
                    min = 0;
                    timeLength = [NSString stringWithFormat:@"%d",(3600 - 31 * 60)];
                    singleTime = 3600.0;
                }
                
                NSString *referenceTime = [NSString stringWithFormat:@"2000-01-01 %02ld%02ld00",hour,min];
                NSTimeInterval interval = [self dateTimeDifferenceWithStartTime:model.startTime referenceTime:referenceTime timeLength:timeLength before:YES];
                
                CGFloat startX = interval * self.frame.size.width / singleTime;
                CGFloat length = 1.0 * model.timeLength.intValue * self.frame.size.width / singleTime;
                if (length < 1) {
                    length = 1.0;
                }
                
                CGPathAddRect(pathRefbg, NULL, CGRectMake(startX, DISTANCETOPANDBOTTOM - 5, length , self.rulerHeight - (DISTANCETOPANDBOTTOM - 5) * 2));

            }else
            {
                NSLog(@"timeQuantumModelArray_RulerTimeQuantumModel_parameter_error--model:%@",model);
            }
        }
        shapeLayerbg.path = pathRefbg;
        CGPathRelease(pathRefbg);
//        [self.layer addSublayer:shapeLayerbg];
        [self.layer insertSublayer:shapeLayerbg atIndex:0];
        
    }else
    {
        NSLog(@"timeQuantumModelArray_parameter_nil");
    }

}

- (UILabel *)getCurrentLabel;
{
    UILabel *label = [self viewWithTag:1000];
    if (label == nil) {
        label = [[UILabel alloc] init];
        label.textColor = [UIColor colorWithRed:82/255.0 green:82/255.0 blue:82/255.0 alpha:1.0];
        label.tag = 1000;
        [self addSubview:label];
    }
    return label;

}

- (void)drawRuler{

}

- (void)drawRulerWithCellStyle:(RulerCollectionViewCellLineStyle)cellLineStyle {
    
    NSInteger lineNum,k;
    CGFloat topAndBottomLineStartPoint = 0;
    CGFloat topAndBottomLineEndPoint = self.frame.size.width;
    
    if (self.lineStyle == cellLineStyle) {
        return;
    }else{
        
        if (self.lineStyle == RulerCollectionViewCellLineStyleNone) {
            
        }else{
            NSArray *layerArray = [NSArray arrayWithArray:self.layer.sublayers];
            for (CALayer *layer in layerArray) {
                if ([layer isKindOfClass:[CAShapeLayer class]]) {
                    [layer removeFromSuperlayer];
                }
            }
        }
        
    
        if (cellLineStyle == RulerCollectionViewCellLineStyleNormal){
            
            lineNum = RULERCOUNTNUM;
            k = 1;
            
        }else if (cellLineStyle == RulerCollectionViewCellLineStyleHead){
            
            lineNum = RULERCOUNTNUM;
            k = RULERCOUNTNUM * 0.5 + 1;
            topAndBottomLineStartPoint = (RULERCOUNTNUM * 0.5 + 1) * self.distanceValue - self.distanceLeftAndRight * 0.5;
        
        }else {
            lineNum = RULERCOUNTNUM * 0.5;
            k = 1;
            topAndBottomLineEndPoint = RULERCOUNTNUM * 0.5 * self.distanceValue + self.distanceLeftAndRight * 0.5;
        }
    
    }
    
    CGMutablePathRef pathRefTop = CGPathCreateMutable();
    CAShapeLayer *shapeLayerTop = [CAShapeLayer layer];
    shapeLayerTop.strokeColor = [UIColor colorWithRed:77/255.0 green:77/255.0 blue:77/255.0 alpha:1.0].CGColor;
    shapeLayerTop.fillColor = [UIColor clearColor].CGColor;
    shapeLayerTop.lineWidth = 1.f;
    shapeLayerTop.lineCap = kCALineCapButt;
    CGPathMoveToPoint(pathRefTop, NULL, topAndBottomLineStartPoint , DISTANCETOPANDBOTTOM);
    CGPathAddLineToPoint(pathRefTop, NULL, topAndBottomLineEndPoint , DISTANCETOPANDBOTTOM);
    shapeLayerTop.path = pathRefTop;
    CGPathRelease(pathRefTop);
    [self.layer addSublayer:shapeLayerTop];
    
    CGMutablePathRef pathRefBottom = CGPathCreateMutable();
    CAShapeLayer *shapeLayerBottom = [CAShapeLayer layer];
    shapeLayerBottom.strokeColor = [UIColor colorWithRed:77/255.0 green:77/255.0 blue:77/255.0 alpha:1.0].CGColor;
    shapeLayerBottom.fillColor = [UIColor clearColor].CGColor;
    shapeLayerBottom.lineWidth = 1.f;
    shapeLayerBottom.lineCap = kCALineCapButt;
    CGPathMoveToPoint(pathRefBottom, NULL, topAndBottomLineStartPoint, self.frame.size.height -  DISTANCETOPANDBOTTOM);
    CGPathAddLineToPoint(pathRefBottom, NULL, topAndBottomLineEndPoint, self.frame.size.height -  DISTANCETOPANDBOTTOM);
    shapeLayerBottom.path = pathRefBottom;
    CGPathRelease(pathRefBottom);
    [self.layer addSublayer:shapeLayerBottom];
    
    CGMutablePathRef pathRef1 = CGPathCreateMutable();
    CGMutablePathRef pathRef2 = CGPathCreateMutable();
    
    CAShapeLayer *shapeLayer1 = [CAShapeLayer layer];
    shapeLayer1.strokeColor = [UIColor colorWithRed:77/255.0 green:77/255.0 blue:77/255.0 alpha:1.0].CGColor;
    shapeLayer1.fillColor = [UIColor clearColor].CGColor;
    shapeLayer1.lineWidth = 1.f;
    shapeLayer1.lineCap = kCALineCapButt;
    
    CAShapeLayer *shapeLayer2 = [CAShapeLayer layer];
    shapeLayer2.strokeColor = [UIColor colorWithRed:77/255.0 green:77/255.0 blue:77/255.0 alpha:1.0].CGColor;
    shapeLayer2.fillColor = [UIColor clearColor].CGColor;
    shapeLayer2.lineWidth = 1.f;
    shapeLayer2.lineCap = kCALineCapButt;
    
    for (NSInteger i = k; i < lineNum + 2; i++) {
        
        if (i % 16 == 0) {
            CGPathMoveToPoint(pathRef2, NULL,  self.distanceValue * i - self.distanceLeftAndRight * 0.5 , DISTANCETOPANDBOTTOM);
            CGPathAddLineToPoint(pathRef2, NULL,  self.distanceValue * i - self.distanceLeftAndRight * 0.5, DISTANCETOPANDBOTTOM + self.rulerHeight * 0.25);
            CGPathMoveToPoint(pathRef2, NULL,  self.distanceValue * i - self.distanceLeftAndRight * 0.5, self.rulerHeight - DISTANCETOPANDBOTTOM - self.rulerHeight * 0.25);
            CGPathAddLineToPoint(pathRef2, NULL,  self.distanceValue * i - self.distanceLeftAndRight * 0.5, self.rulerHeight - DISTANCETOPANDBOTTOM);
            
            UILabel *label = [self getCurrentLabel];
            label.text = @"00:00:00";
            CGSize textSize = [label.text sizeWithAttributes:@{ NSFontAttributeName : label.font }];
            label.frame = CGRectMake( self.distanceValue * i - textSize.width * 0.5, (self.rulerHeight - textSize.height) * 0.5, 0, 0);
            [label sizeToFit];
            
        }
        else if ((i - 1) % 5 == 0) {
            CGPathMoveToPoint(pathRef1, NULL,  self.distanceValue * i - self.distanceLeftAndRight * 0.5, DISTANCETOPANDBOTTOM);
            CGPathAddLineToPoint(pathRef1, NULL,   self.distanceValue * i - self.distanceLeftAndRight * 0.5, DISTANCETOPANDBOTTOM + self.rulerHeight * 0.2);
            
            CGPathMoveToPoint(pathRef1, NULL,   self.distanceValue * i - self.distanceLeftAndRight * 0.5, self.rulerHeight - DISTANCETOPANDBOTTOM - self.rulerHeight * 0.2);
            CGPathAddLineToPoint(pathRef1, NULL,   self.distanceValue * i - self.distanceLeftAndRight * 0.5, self.rulerHeight - DISTANCETOPANDBOTTOM);
        }
        else
        {
            CGPathMoveToPoint(pathRef1, NULL,   self.distanceValue * i - self.distanceLeftAndRight * 0.5 , DISTANCETOPANDBOTTOM);
            CGPathAddLineToPoint(pathRef1, NULL,   self.distanceValue * i - self.distanceLeftAndRight * 0.5, DISTANCETOPANDBOTTOM + self.rulerHeight * 0.16);
            
            CGPathMoveToPoint(pathRef1, NULL,   self.distanceValue * i - self.distanceLeftAndRight * 0.5, self.rulerHeight - DISTANCETOPANDBOTTOM - self.rulerHeight * 0.16);
            CGPathAddLineToPoint(pathRef1, NULL,   self.distanceValue * i - self.distanceLeftAndRight * 0.5, self.rulerHeight - DISTANCETOPANDBOTTOM);
        }
    }
    
    shapeLayer1.path = pathRef1;
    shapeLayer2.path = pathRef2;
    
    CGPathRelease(pathRef1);
    CGPathRelease(pathRef2);
    
    [self.layer addSublayer:shapeLayer1];
    [self.layer addSublayer:shapeLayer2];

    self.lineStyle = cellLineStyle;
    
}

/*
- (void)drawRuler {
    
    if (self.isRraw) {
        
        NSLog(@"return la");
        return;
    }

    
    CGMutablePathRef pathRefTop = CGPathCreateMutable();
    CAShapeLayer *shapeLayerTop = [CAShapeLayer layer];
    shapeLayerTop.strokeColor = [UIColor colorWithRed:77/255.0 green:77/255.0 blue:77/255.0 alpha:1.0].CGColor;
    shapeLayerTop.fillColor = [UIColor clearColor].CGColor;
    shapeLayerTop.lineWidth = 1.f;
    shapeLayerTop.lineCap = kCALineCapButt;
    CGPathMoveToPoint(pathRefTop, NULL, self.distanceLeftAndRight , DISTANCETOPANDBOTTOM);
    CGPathAddLineToPoint(pathRefTop, NULL, self.frame.size.width + self.distanceLeftAndRight, DISTANCETOPANDBOTTOM);
    shapeLayerTop.path = pathRefTop;
    CGPathRelease(pathRefTop);
    [self.layer addSublayer:shapeLayerTop];
    
    CGMutablePathRef pathRefBottom = CGPathCreateMutable();
    CAShapeLayer *shapeLayerBottom = [CAShapeLayer layer];
    shapeLayerBottom.strokeColor = [UIColor colorWithRed:77/255.0 green:77/255.0 blue:77/255.0 alpha:1.0].CGColor;
    shapeLayerBottom.fillColor = [UIColor clearColor].CGColor;
    shapeLayerBottom.lineWidth = 1.f;
    shapeLayerBottom.lineCap = kCALineCapButt;
    CGPathMoveToPoint(pathRefBottom, NULL, self.distanceLeftAndRight, self.frame.size.height -  DISTANCETOPANDBOTTOM);
    CGPathAddLineToPoint(pathRefBottom, NULL, self.frame.size.width + self.distanceLeftAndRight, self.frame.size.height -  DISTANCETOPANDBOTTOM);
    shapeLayerBottom.path = pathRefBottom;
    CGPathRelease(pathRefBottom);

    [self.layer addSublayer:shapeLayerBottom];
    

    CGMutablePathRef pathRef1 = CGPathCreateMutable();
    CGMutablePathRef pathRef2 = CGPathCreateMutable();

    CAShapeLayer *shapeLayer1 = [CAShapeLayer layer];
    shapeLayer1.strokeColor = [UIColor colorWithRed:77/255.0 green:77/255.0 blue:77/255.0 alpha:1.0].CGColor;
    shapeLayer1.fillColor = [UIColor clearColor].CGColor;
    shapeLayer1.lineWidth = 1.f;
    shapeLayer1.lineCap = kCALineCapButt;
    
    CAShapeLayer *shapeLayer2 = [CAShapeLayer layer];
    shapeLayer2.strokeColor = [UIColor colorWithRed:77/255.0 green:77/255.0 blue:77/255.0 alpha:1.0].CGColor;
    shapeLayer2.fillColor = [UIColor clearColor].CGColor;
    shapeLayer2.lineWidth = 1.f;
    shapeLayer2.lineCap = kCALineCapButt;
    
    for (int i = 0; i <= rulerCountNum; i++) {
        
        UILabel *rule = [[UILabel alloc] init];
        rule.textColor = [UIColor colorWithRed:82/255.0 green:82/255.0 blue:82/255.0 alpha:1.0];
        rule.tag = 1000+i;
//        rule.text = [NSString stringWithFormat:@"%.0f",i * self.distanceValue];
        CGSize textSize = [rule.text sizeWithAttributes:@{ NSFontAttributeName : rule.font }];
        
        if (i % 30 == 0) {
            CGPathMoveToPoint(pathRef2, NULL, self.distanceLeftAndRight + self.distanceValue * i , DISTANCETOPANDBOTTOM);
            CGPathAddLineToPoint(pathRef2, NULL, self.distanceLeftAndRight + self.distanceValue * i, DISTANCETOPANDBOTTOM + self.rulerHeight * 0.25);
            CGPathMoveToPoint(pathRef2, NULL, self.distanceLeftAndRight + self.distanceValue * i , self.rulerHeight - DISTANCETOPANDBOTTOM - self.rulerHeight * 0.25);
            CGPathAddLineToPoint(pathRef2, NULL, self.distanceLeftAndRight + self.distanceValue * i, self.rulerHeight - DISTANCETOPANDBOTTOM);
        
            rule.frame = CGRectMake(self.distanceLeftAndRight + self.distanceValue * i - textSize.width / 2, (self.rulerHeight - textSize.height) * 0.5, 0, 0);
//            [rule sizeToFit];
            [self addSubview:rule];
            
        }
        else if (i % 5 == 0) {
            CGPathMoveToPoint(pathRef1, NULL, self.distanceLeftAndRight + self.distanceValue * i , DISTANCETOPANDBOTTOM);
            CGPathAddLineToPoint(pathRef1, NULL, self.distanceLeftAndRight + self.distanceValue * i, DISTANCETOPANDBOTTOM + self.rulerHeight * 0.2);
            
            CGPathMoveToPoint(pathRef1, NULL, self.distanceLeftAndRight + self.distanceValue * i , self.rulerHeight - DISTANCETOPANDBOTTOM - self.rulerHeight * 0.2);
            CGPathAddLineToPoint(pathRef1, NULL, self.distanceLeftAndRight + self.distanceValue * i, self.rulerHeight - DISTANCETOPANDBOTTOM);
        }
        else
        {
            CGPathMoveToPoint(pathRef1, NULL, self.distanceLeftAndRight + self.distanceValue * i , DISTANCETOPANDBOTTOM);
            CGPathAddLineToPoint(pathRef1, NULL, self.distanceLeftAndRight + self.distanceValue * i, DISTANCETOPANDBOTTOM + self.rulerHeight * 0.16);
            
            CGPathMoveToPoint(pathRef1, NULL, self.distanceLeftAndRight + self.distanceValue * i , self.rulerHeight - DISTANCETOPANDBOTTOM - self.rulerHeight * 0.16);
            CGPathAddLineToPoint(pathRef1, NULL, self.distanceLeftAndRight + self.distanceValue * i, self.rulerHeight - DISTANCETOPANDBOTTOM);
        }
    }

    shapeLayer1.path = pathRef1;
    shapeLayer2.path = pathRef2;
    
    CGPathRelease(pathRef1);
    CGPathRelease(pathRef2);

    [self.layer addSublayer:shapeLayer1];
    [self.layer addSublayer:shapeLayer2];
    self.isRraw = YES;
    
    CGMutablePathRef pathRefbg = CGPathCreateMutable();
    CAShapeLayer *shapeLayerbg = [CAShapeLayer layer];
    shapeLayerbg.strokeColor = [UIColor greenColor].CGColor;
    shapeLayerbg.fillColor = [UIColor colorWithRed:79/255.0 green:229/255.0 blue:68/255.0 alpha:0.7].CGColor;
    shapeLayerbg.lineWidth = 1.f;
    shapeLayerbg.lineCap = kCALineCapButt;
    CGPathMoveToPoint(pathRefbg, NULL, 0 , DISTANCETOPANDBOTTOM - 5);
    CGPathAddLineToPoint(pathRefbg, NULL, 4 * 200 / 30.0  + self.distanceLeftAndRight, DISTANCETOPANDBOTTOM - 5);
    CGPathAddLineToPoint(pathRefbg, NULL, 4 * 200 / 30.0 + self.distanceLeftAndRight, self.rulerHeight - DISTANCETOPANDBOTTOM + 5);
    CGPathAddLineToPoint(pathRefbg, NULL, 0, self.rulerHeight - DISTANCETOPANDBOTTOM + 5);
    CGPathAddLineToPoint(pathRefbg, NULL, 0, DISTANCETOPANDBOTTOM - 5);
    
    CGPathMoveToPoint(pathRefbg, NULL, self.frame.size.width -  4 * 200 / 30.0, DISTANCETOPANDBOTTOM - 5);
    CGPathAddLineToPoint(pathRefbg, NULL, self.frame.size.width, DISTANCETOPANDBOTTOM - 5);
    CGPathAddLineToPoint(pathRefbg, NULL, self.frame.size.width, self.rulerHeight - DISTANCETOPANDBOTTOM + 5);
    CGPathAddLineToPoint(pathRefbg, NULL, self.frame.size.width -  4 * 200 / 30.0, self.rulerHeight - DISTANCETOPANDBOTTOM + 5);
    CGPathAddLineToPoint(pathRefbg, NULL, self.frame.size.width -  4 * 200 / 30.0, DISTANCETOPANDBOTTOM - 5);

    shapeLayerbg.path = pathRefbg;
    CGPathRelease(pathRefbg);
    [self.layer insertSublayer:shapeLayerbg atIndex:0];
    
//    NSLog(@"====%@====",self.layer.sublayers);
    
//    NSArray *layerArray = [NSArray arrayWithArray:self.layer.sublayers];
//    for (CALayer *layer in layerArray) {
//        if ([layer isKindOfClass:[CAShapeLayer class]]) {
//            [layer removeFromSuperlayer];
//        }
//    }

}
*/
@end
