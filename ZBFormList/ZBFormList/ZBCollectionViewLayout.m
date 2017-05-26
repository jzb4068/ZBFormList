//
//  ZBCollectionViewLayout.m
//  ZBFormList
//
//  Created by 清科 on 2017/5/26.
//  Copyright © 2017年 清科. All rights reserved.
//

#import "ZBCollectionViewLayout.h"

@interface ZBCollectionViewLayout ()

@property (nonatomic,assign) CGFloat contentHeight;
@property (nonatomic,assign) CGFloat contentWidth;
@property (nonatomic,strong) NSMutableArray * itemAttributes; //保存每个item的数据(frame)

@end

@implementation ZBCollectionViewLayout

#pragma mark - Life cycle
- (void)dealloc {
    [_itemAttributes removeAllObjects];
    _itemAttributes = nil;
}

-(NSMutableArray*)itemAttributes {
    if (!_itemAttributes) {
        _itemAttributes = [NSMutableArray array];
    }
    return _itemAttributes;
}

- (void)setSectionInset:(UIEdgeInsets)sectionInset {
    if (!UIEdgeInsetsEqualToEdgeInsets(_sectionInset, sectionInset)) {
        _sectionInset = sectionInset;
        [self invalidateLayout];
    }
}

- (void)setMinimumLineSpacing:(CGFloat)minimumLineSpacing {
    if (_minimumLineSpacing != minimumLineSpacing) {
        _minimumLineSpacing = minimumLineSpacing;
        [self invalidateLayout];
    }
}

- (void)setMinimumInteritemSpacing:(CGFloat)minimumInteritemSpacing {
    if (_minimumInteritemSpacing != minimumInteritemSpacing) {
        _minimumInteritemSpacing = minimumInteritemSpacing;
        [self invalidateLayout];
    }
}

- (void)setItemSize:(CGSize)itemSize {
    if (!CGSizeEqualToSize(_itemSize, itemSize)) {
        _itemSize = itemSize;
        [self invalidateLayout];
    }
}

#pragma mark----计算item的位置
-(void)prepareLayout {
    [super prepareLayout];
    
    if (_itemAttributes) {
        [self.itemAttributes removeAllObjects];
    }
    
    CGFloat itemWidth  = _itemSize.width;
    CGFloat itemHeight = _itemSize.height;
    for (int i = 0; i < self.collectionView.numberOfSections; i ++) {
        NSInteger numberOfItems = [self.collectionView numberOfItemsInSection:i];
        for (int j = 0; j < numberOfItems; j ++) {
            //计算item的坐标
            CGFloat delta_x = self.sectionInset.left + (self.minimumInteritemSpacing + itemWidth) * j;
            CGFloat delta_y = self.sectionInset.top + (self.minimumLineSpacing + itemHeight) * i;
            
            NSIndexPath * indexPath = [NSIndexPath indexPathForItem:j inSection:i];
            
            UICollectionViewLayoutAttributes * layoutAttritubutes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            
            layoutAttritubutes.frame = CGRectMake(delta_x , delta_y, itemWidth, itemHeight);
            [self.itemAttributes addObject:layoutAttritubutes];
            
            _contentWidth  = CGRectGetMaxX(layoutAttritubutes.frame);
            _contentHeight = CGRectGetMaxY(layoutAttritubutes.frame);
        }
    }
}

// 重写设置collectionView最终的contentSize
- (CGSize)collectionViewContentSize {
    CGSize contentSize = CGSizeZero;
    
    contentSize.width  = _contentWidth + self.sectionInset.right;
    contentSize.height = _contentHeight + self.sectionInset.bottom;
    
    return contentSize;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    return (self.itemAttributes)[indexPath.item];
}

-(NSArray*)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray * attributes = [self.itemAttributes filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(UICollectionViewLayoutAttributes *evaluatedObject, NSDictionary *bindings) {
        return CGRectIntersectsRect(rect, [evaluatedObject frame]);
    }]];
    
    return attributes;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    CGRect oldBounds = self.collectionView.bounds;
    if (CGRectGetWidth(newBounds) != CGRectGetWidth(oldBounds)) {
        return YES;
    }
    return NO;
}

@end
