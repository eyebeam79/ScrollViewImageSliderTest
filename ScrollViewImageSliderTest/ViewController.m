//
//  ViewController.m
//  ScrollViewImageSliderTest
//
//  Created by Jinho Son on 2014. 1. 7..
//  Copyright (c) 2014년 STD1. All rights reserved.
//

#import "ViewController.h"

#define IMAGE_NUM 4

@interface ViewController ()
{
    UIScrollView *_scrollView;
    UIPageControl *pageControl;
    int loadedPageCount;
}

@end

@implementation ViewController

// 인자로 넘어온 페이지를 로딩
- (void)loadContentsPage:(int)pageNo
{
    // 이미 로딩한 페이지인지, 페이지한계를 넘었는지를 체크
    if (pageNo<0 || pageNo<loadedPageCount || pageNo>=IMAGE_NUM)
    {
        return;
    }
    
    float width = _scrollView.frame.size.width;
    float height = _scrollView.frame.size.height;
    
    NSString *fileName = [NSString stringWithFormat:@"image%d", pageNo];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"jpg"];
    UIImage *image = [UIImage imageWithContentsOfFile:filePath];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    
    imageView.frame = CGRectMake(width*pageNo, 0, width, height);
    [_scrollView addSubview:imageView];
    loadedPageCount++;
}

// 스크롤이 끝나면서 새로운 페이지 로딩
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // 페이지인덱스 계산
    float width = _scrollView.frame.size.width;
    float offsetX = _scrollView.contentOffset.x;
    int pageNo = floor(offsetX/width);
    
    pageControl.currentPage = pageNo;
    
    // 전,후 페이지까지 함께 로딩
    [self loadContentsPage:pageNo-1];
    [self loadContentsPage:pageNo];
    [self loadContentsPage:pageNo+1];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_scrollView];
    
    // 스크롤뷰의 크기를 구함
    float width = _scrollView.bounds.size.width;
    float height = _scrollView.bounds.size.height;
    
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.contentSize = CGSizeMake(width*IMAGE_NUM, height);
    
    pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(130, 400, 60, 40)];
    [self.view addSubview:pageControl];
    pageControl.numberOfPages = IMAGE_NUM;
    
    // 초기값설정
    loadedPageCount = 0;
    [self loadContentsPage:0];
    [self loadContentsPage:1];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
