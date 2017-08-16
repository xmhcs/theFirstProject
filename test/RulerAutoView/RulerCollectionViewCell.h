//
//  RulerCollectionViewCell.h
//  TestDemo
//
//  Created by xunmei on 2017/7/24.
//  Copyright © 2017年 xunmei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RulerTimeQuantumModel.h"


#define DISTANCETOPANDBOTTOM 20.f // 标尺上下距离
#define RULERCOUNTNUM 30
#define RULERCELLWTDTH 200.f
#define RULERCELLHEIGHT 200.f

typedef NS_ENUM(NSInteger, RulerCollectionViewCellTimeStyle) {
    RulerCollectionViewCellTimeStyleMin,
    RulerCollectionViewCellTimeStyleHour
};
typedef NS_ENUM(NSInteger, RulerCollectionViewCellLineStyle) {
    RulerCollectionViewCellLineStyleNone = 0,
    RulerCollectionViewCellLineStyleNormal,
    RulerCollectionViewCellLineStyleHead,
    RulerCollectionViewCellLineStyleEnd
};

@interface RulerCollectionViewCell : UICollectionViewCell

- (void)drawRuler;

- (void)drawRulerWithCellStyle:(RulerCollectionViewCellLineStyle)cellLineStyle;

- (void)setCellLabelText:(NSIndexPath *)indexPath timeStyle:(RulerCollectionViewCellTimeStyle)tiemStyle lastCell:(BOOL)isLastCell;

- (void)setCellLabelTextString:(NSString *)textString lastCell:(BOOL)isLastCell;

- (void)setPlayVideoTime:(NSIndexPath *)indexPath list:(NSArray <RulerTimeQuantumModel *>*)timeQuantumModelArray timeStyle:(RulerCollectionViewCellTimeStyle)tiemStyle;

@end
