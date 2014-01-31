//
//  HISCollectionViewController.m
//  Github To Go
//
//  Created by Tim Hise on 1/29/14.
//  Copyright (c) 2014 CleverKnot. All rights reserved.
//

#import "HISCollectionViewController.h"
#import "HISCollectionViewCell.h"
#import "HISNetworkController.h"
#import "HISGitUser.h"

@interface HISCollectionViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) NSOperationQueue *operationQueue;
@property (strong, nonatomic) NSMutableArray *searchResults;
@property (strong, nonatomic) NSMutableArray *userArray;

@end

@implementation HISCollectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.searchBar setDelegate:self];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    self.searchResults = [NSMutableArray new];
    self.operationQueue = [NSOperationQueue new];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadFinishedNotification:) name:DOWNLOAD_NOTIFICATION object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createUsersFromArray
{
    self.userArray = [NSMutableArray new];

    for (NSDictionary *dict in self.searchResults) {
        HISGitUser *user = [[HISGitUser alloc] init];
        user.name = [dict objectForKey:@"login"];
        user.URLForImage = [NSURL URLWithString:[dict objectForKey:@"avatar_url"]];
        user.URLForProfile = [NSURL URLWithString:[dict objectForKey:@"repos_url"]];
        user.operationQueue = self.operationQueue;
        [self.userArray addObject:user];
    }
    [self.collectionView reloadData];
}

#pragma mark - SearchBar

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    self.searchResults = [[HISNetworkController sharedController]usersForSearchString:searchBar.text];
    
    [self createUsersFromArray];
    
    [self.searchBar resignFirstResponder];
    
    NSLog(@"Search Results %@", self.searchResults);
}

#pragma mark - Collection View Delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.userArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HISCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    HISGitUser *user = self.userArray[indexPath.row];
    cell.nameLabel.text = user.name;
    
    if (user.image) {
        cell.userImage.image = user.image;
    } else {
        if (!user.isDownloading) {
            [user downloadAvatar];
            user.isDownloading = YES;
        }
    }
    
    return cell;
}

//- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//}

- (void)downloadFinishedNotification:(NSNotification *)note
{
    id sender = [[note userInfo] objectForKey:USER_KEY];
    
    if ([sender isKindOfClass:[HISGitUser class]]) {
        NSIndexPath *userPath = [NSIndexPath indexPathForItem:[self.userArray indexOfObject:sender] inSection:0];
        HISCollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:userPath];
        cell.isDownloading = NO;
        [self.collectionView reloadItemsAtIndexPaths:@[userPath]];
    } else {
        NSLog(@"Sender was not a Git User");
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        NSIndexPath *indexPath = [[self.collectionView indexPathsForSelectedItems] firstObject];
        
        NSDictionary *userDictionary = [self.searchResults objectAtIndex:indexPath.row];
        NSString *userString = [userDictionary objectForKey:@"html_url"];
        NSURL *url = [NSURL URLWithString:userString];
        
        self.detailViewController.detailItem = url;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([segue.destinationViewController isKindOfClass:[HISDetailViewController class]]) {
        NSIndexPath *indexPath = [[self.collectionView indexPathsForSelectedItems] firstObject];
        
        NSDictionary *repoDictionary = [self.searchResults objectAtIndex:indexPath.row];
        NSString *userString = [repoDictionary objectForKey:@"html_url"];
        NSURL *url = [NSURL URLWithString:userString];
        
        HISDetailViewController *destVC = (HISDetailViewController *)segue.destinationViewController;
        destVC.detailItem = url;
    }
}

@end

