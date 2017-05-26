//
//  ZBCollectionView.h
//  ZBFormList
//
//  Created by 清科 on 2017/5/26.
//  Copyright © 2017年 清科. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kItemHeight    30.0f
#define kTitleFont     [UIFont systemFontOfSize:15]
#define kLineColor     [UIColor blackColor]
#define kLineWidth     1.0f
@interface ZBCollectionView : UICollectionView
@property (nonatomic, strong) NSArray <NSString *>* menus;
@end
