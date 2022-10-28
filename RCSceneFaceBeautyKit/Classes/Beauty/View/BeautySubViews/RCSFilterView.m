//
//  RCSFilterView.m
//  RCSceneFaceBeautyKit
//
//  Created by 彭蕾 on 2022/9/16.
//

#import "RCSFilterView.h"
#import <RCSceneBaseKit/RCSBaseKit.h>

@interface RCSFilterView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

@end

@class RCSFilterCell;
@implementation RCSFilterView

- (instancetype)initWithFrame:(CGRect)frame {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing = 15;
    flowLayout.minimumLineSpacing = 15;
    flowLayout.itemSize = CGSizeMake(54, 70);
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 16, 0, 16);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.flowLayout = flowLayout;
    
    if (self = [self initWithFrame:frame collectionViewLayout:flowLayout]) {
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        self.backgroundColor = [UIColor clearColor];
        self.delegate = self;
        self.dataSource = self;
        [self registerClass:[RCSFilterCell class] forCellWithReuseIdentifier:@"RCSFilterCell"];
        _selectedIndex = 2;
    }
    return self;
}

- (void)setFilters:(NSArray<RCSBeautyModel *> *)filters {
    _filters = filters;
    [self reloadData];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    if (selectedIndex >= self.filters.count && selectedIndex >= 0) return;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:selectedIndex inSection:0];
    /// 滑动到之前设置的index
    dispatch_main_async_safe(^{
          [self scrollToItemAtIndexPath:indexPath
                                      atScrollPosition:UICollectionViewScrollPositionNone
                                              animated:NO];
    });

    _selectedIndex = selectedIndex;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.filters.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                           cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    RCSFilterCell *cell = (RCSFilterCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"RCSFilterCell"
                                                                                     forIndexPath:indexPath];

    RCSBeautyModel *model = _filters[indexPath.row];
    cell.titleLabel.text = model.title;
    cell.titleLabel.textColor = [UIColor whiteColor];
    cell.imageView.image = RCSBeautyImageNamed(model.key);
    cell.imageView.layer.borderWidth = 0.0;
    cell.imageView.layer.borderColor = [UIColor clearColor].CGColor;

    if (_selectedIndex == indexPath.row) {
        cell.imageView.layer.borderWidth = 2.0;
        cell.imageView.layer.borderColor = RCSBeautyMainColor.CGColor;
        cell.titleLabel.textColor = RCSBeautyMainColor;
    }

    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedIndex = indexPath.row;
    [self reloadData];
    if (self.customDelegate && [self.customDelegate respondsToSelector:@selector(filterViewDidSelectedIndex:)]) {
        [self.customDelegate filterViewDidSelectedIndex:indexPath.row];
    }
}

@end


@implementation RCSFilterCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 54, 54)];
        self.imageView.layer.masksToBounds = YES;
        self.imageView.layer.cornerRadius = 3.0;
        self.imageView.layer.borderWidth = 0.0;
        self.imageView.layer.borderColor = [UIColor clearColor].CGColor;
        [self addSubview:self.imageView];

        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(-8, 54, 70, frame.size.height - 54)];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:10];
        [self addSubview:self.titleLabel];
    }
    return self;
}
@end
