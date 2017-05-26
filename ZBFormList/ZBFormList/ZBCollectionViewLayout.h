//
//  ZBCollectionViewLayout.h
//  ZBFormList
//
//  Created by 清科 on 2017/5/26.
//  Copyright © 2017年 清科. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZBCollectionViewLayout : UICollectionViewLayout
@property (nonatomic, assign) CGFloat minimumLineSpacing;
@property (nonatomic, assign) CGFloat minimumInteritemSpacing;
@property (nonatomic, assign) CGSize itemSize;
@property (nonatomic, assign) UIEdgeInsets sectionInset; //设置内边距
@end
