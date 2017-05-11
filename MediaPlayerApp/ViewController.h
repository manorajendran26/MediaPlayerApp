//
//  ViewController.h
//  MediaPlayerApp
//
//  Created by dev-fsp-4 on 09/05/17.
//  Copyright © 2017 ViewExtend. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "SongTableViewCell.h"

@interface ViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    MPMusicPlayerController *musicPlayer;
    MPMediaItem *selectedItem;
    BOOL playPause;
    BOOL searchBoolVal;
    MPMediaQuery *allSongs;
}
@property (strong,nonatomic) NSMutableArray *searchResults;
@property (strong, nonatomic) NSMutableArray *songsList;
@property (strong, nonatomic) IBOutlet UITableView *songTable;
@property (strong, nonatomic) IBOutlet UIButton *playPauseBtn;
@property (strong, nonatomic) IBOutlet UILabel *songTitleLabel;

@property (strong, nonatomic) IBOutlet UITextField *searchField;

@end

