//
//  ZBFormListView.h
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

@interface ZBFormListView : UIView
@property (nonatomic, strong) NSArray <NSString *>* topMenus;
@property (nonatomic, strong) NSArray <NSString *>* sideMenus;
@property (nonatomic, strong) NSArray * dataSource;
@property (nonatomic, assign) CGSize maxSize;

- (instancetype)initWithFrame:(CGRect)frame topMenus:(NSArray <NSString *>*)topMenus sideMenus:(NSArray <NSString *>*)sideMenus;
@end
