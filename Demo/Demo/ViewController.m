//
//  ViewController.m
//  Demo
//
//  Created by donggua on 2020/3/23.
//  Copyright © 2020 wky. All rights reserved.
//

#import "ViewController.h"
#import "HttpClient.h"
#import "MJExtension.h"
#import "ListModel.h"
#import "ListCell.h"
#import "UICollectionViewCell+Register.h"
#import "UIImageView+WebCache.h"
#import "MJRefreshAutoNormalFooter.h"
#import "DemoConst.h"

@interface ViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, assign) NSInteger pageNumber;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *datas;
@property (nonatomic, assign) NSInteger total;
@property (nonatomic, strong) NSMutableArray *visibleIndexPaths;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.pageNumber = 1;
    [self initCollectionView];
    [self loadDataWithPageNum:self.pageNumber];
}

-(void)initCollectionView {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    CGFloat width = (kWidth - 2*outerMargin - innerMargin)/2;
    flowLayout.itemSize = CGSizeMake(width, width * 4/3);
    flowLayout.minimumLineSpacing = innerMargin;
    flowLayout.minimumInteritemSpacing = innerMargin;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight) collectionViewLayout:flowLayout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [ListCell registeredByCollectionView:self.collectionView];
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        // 加载更多
        if (self.total > self.pageNumber * pageCount) {
            self.pageNumber += 1;
            [self loadDataWithPageNum:self.pageNumber];
        }else {
            [self.collectionView.mj_footer endRefreshingWithNoMoreData];
        }
    }];
    [self.view addSubview:self.collectionView];
}

#pragma mark -- loadData
-(void)loadDataWithPageNum:(NSInteger)pageNum {
    NSLog(@"pageNum==%ld",pageNum);
    NSString *url = @"http://devmobile.zhuawawa.site/neckpets/getBlindBoxSeriesLitByTabType.json";
    NSDictionary *param = @{
        @"requestData": @{
               @"pageNumber": @(pageNum).stringValue,
               @"userToken": @"8ed7ddfde5ca37849b7c43591957d7fb73adc2a1"
           }.mj_JSONString
    };
    [[HttpClient defaultClient] post:url parameters:param headers:@{} success:^(id  _Nonnull responseObject) {
        if (responseObject) {
            NSDictionary *resDic = (NSDictionary *)responseObject;
            self.total = [[resDic objectForKey:@"total"] integerValue];
            NSArray *arr = [resDic objectForKey:@"data"];
            NSMutableArray *tempArr = [NSMutableArray arrayWithCapacity:0];
            for (int i = 0; i < arr.count; i ++) {
                ListModel *model = [ListModel mj_objectWithKeyValues:arr[i]];
                [tempArr addObject:model];
            }
            NSArray *combineArr = [self.datas arrayByAddingObjectsFromArray:[tempArr copy]];
            self.datas = combineArr;
            if (pageNum > 1) {
                [self.collectionView.mj_footer endRefreshing];
            }
            [self.collectionView reloadData];
        }
    } failure:^(NSString * _Nonnull error, NSString * _Nonnull errorMessage) {
        NSLog(@"%@",errorMessage);
    }];
}

#pragma mark -- UICollectionViewDelegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ListModel *model = nil;
    if (self.datas.count > indexPath.item) {
        model = self.datas[indexPath.row];
    }
    ListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([ListCell class]) forIndexPath:indexPath];
    cell.nameLabel.text = model.name;
    cell.desLabel.text = model.desc;
    cell.priceLabel.text = [NSString stringWithFormat:@"¥%.0f",model.price];
    // 默认为占位图
    cell.img.image = [UIImage imageNamed:@""];
    // item不在当前屏幕内直接返回cell
    if (self.visibleIndexPaths.count != 0 && ![self.visibleIndexPaths containsObject:indexPath]) {
        return cell;
    }
    // collectionView在没有滚动时下载当前屏幕内的图片
    if (self.collectionView.dragging == NO && self.collectionView.decelerating == NO) {
        [cell.img sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:[UIImage imageNamed:@""] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        }];
    }
    return cell;
}

#pragma mark -- UICollectionViewDelegateFlowLayout
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, outerMargin, 0, outerMargin);
}

#pragma mark -- UIScrollViewDelegate
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        [self loadImagesForOnscreen];
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self loadImagesForOnscreen];
}

-(void)loadImagesForOnscreen {
    if (self.datas.count > 0) {
        // 当前屏幕内的item
        NSArray *visiblePaths = [self.collectionView indexPathsForVisibleItems];
        NSMutableArray *tempVisibleIndexPaths = [NSMutableArray arrayWithCapacity:0];
        for (NSIndexPath *indexPath in visiblePaths) {
            if (![self.visibleIndexPaths containsObject:indexPath]) {
                [tempVisibleIndexPaths addObject:indexPath];
            }
        }
        [self.collectionView reloadItemsAtIndexPaths:[tempVisibleIndexPaths copy]];
    }
}

#pragma mark -- lazyInit
-(NSArray *)datas {
    if (!_datas) {
        _datas = [NSArray array];
    }
    return _datas;
}

-(NSMutableArray *)visibleIndexPaths {
    if (!_visibleIndexPaths) {
        _visibleIndexPaths = [NSMutableArray arrayWithCapacity:0];
    }
    return _visibleIndexPaths;
}

@end
