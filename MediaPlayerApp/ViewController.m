//
//  ViewController.m
//  MediaPlayerApp
//
//  Created by dev-fsp-4 on 09/05/17.
//  Copyright © 2017 ViewExtend. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    allSongs = [MPMediaQuery songsQuery];
    NSArray *itemsFromGenericQuery = [allSongs items];
    self.songsList = [NSMutableArray arrayWithArray:itemsFromGenericQuery];
    NSLog(@"self.songsList =:=== %@",self.songsList);
    _songTable.delegate = self;
    _songTable.dataSource = self;
    _searchField.delegate = self;
    playPause = YES;
    if ([self.songsList count]>0) {
        selectedItem = [[self.songsList objectAtIndex:0] representativeItem];
        musicPlayer = [MPMusicPlayerController systemMusicPlayer];
        [musicPlayer setQueueWithItemCollection:[MPMediaItemCollection collectionWithItems:[allSongs items]]];
        [musicPlayer setNowPlayingItem:selectedItem];
        [musicPlayer prepareToPlay];
        [musicPlayer setCurrentPlaybackTime: 0];
    }
}


- (IBAction)playBtnAction:(id)sender {
    if (!playPause) {
        playPause = YES;
        [musicPlayer pause];
        UIImage *pauseImage = [UIImage imageNamed:@"play"];
        [_playPauseBtn setImage:pauseImage forState:UIControlStateNormal];
    }else{
        playPause = NO;
        UIImage *pauseImage = [UIImage imageNamed:@"pause"];
        [_playPauseBtn setImage:pauseImage forState:UIControlStateNormal];
        [musicPlayer  play];
    }
}

- (IBAction)backwardBtnAction:(id)sender {
    [musicPlayer skipToPreviousItem];
}

- (IBAction)forwardBtnAction:(id)sender {
    [musicPlayer skipToNextItem];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.songsList count]>0)
        return self.songsList.count;
    else
        return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"songCell";
    
    SongTableViewCell *tablecell;
    if (tablecell == nil) {
        tablecell = (SongTableViewCell *)[_songTable dequeueReusableCellWithIdentifier:CellIdentifier];
    }
    
    MPMediaItem *song;
    if (searchBoolVal) {
        if([self.searchResults count]>0)
        {
            song = [self.searchResults objectAtIndex:indexPath.row];
            NSString *songTitle = [song valueForKey: MPMediaItemPropertyTitle];
            tablecell.songTitle.text = songTitle;
            _songTitleLabel.text = songTitle;
        }
    }else{
            song = [self.songsList objectAtIndex:indexPath.row];
            NSString *songTitle = [song valueForKey: MPMediaItemPropertyTitle];
            tablecell.songTitle.text = songTitle;
            _songTitleLabel.text = songTitle;
    }
    return tablecell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    playPause = NO;
    UIImage *pauseImage = [UIImage imageNamed:@"pause"];
    [_playPauseBtn setImage:pauseImage forState:UIControlStateNormal];
    NSUInteger selectedIndex = [[_songTable indexPathForSelectedRow] row];
    MPMediaItem *selectedItems = [[self.songsList objectAtIndex:selectedIndex] representativeItem];
    NSString *songTitle = [[self.songsList objectAtIndex:selectedIndex] valueForKey: MPMediaItemPropertyTitle];
    _songTitleLabel.text = [NSString stringWithFormat:@"%@",songTitle];
    [musicPlayer setNowPlayingItem:selectedItems];
    [musicPlayer play];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
     searchBoolVal = YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    searchBoolVal = NO;
    [_songTable reloadData];
    [textField resignFirstResponder];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:
    (NSString *)string{
    NSString *searchString = @"";
    if([string length]==1 && [textField.text length]==0)
    {
        searchString = string;
    }
    else if([string length]==1 && [textField.text length]!=0)
    {
        searchString = [NSString stringWithFormat:@"%@%@",textField.text,string];
    }
    else if ([string length]==0 && [textField.text length]>1)
    {
        searchString = [NSString stringWithFormat:@"%@",[textField.text substringToIndex:([textField.text length]-1)]];
    }
    MPMediaQuery *albumQuery = [MPMediaQuery songsQuery];
    MPMediaPropertyPredicate *albumPredicate = [MPMediaPropertyPredicate predicateWithValue: searchString forProperty: MPMediaItemPropertyTitle];
    [albumQuery addFilterPredicate:albumPredicate];
    NSArray *albumTracks = [albumQuery items];
    self.searchResults = [NSMutableArray arrayWithArray:albumTracks];
    [_songTable reloadData];
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
