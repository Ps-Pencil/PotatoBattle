//
//  HelloWorldLayer.m
//  PotatoBattle-coco
//
//  Created by pspencil on 4/9/13.
//  Copyright pspencil 2013. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"
#import "PlayScene.h"
#pragma mark - HelloWorldLayer

// HelloWorldLayer implementation
@implementation HelloWorldLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super initWithColor:ccc4(236, 240, 241, 255)]) ) {
		
        CGSize size = [[CCDirector sharedDirector] winSize];
        
        __block id copy_self = self;
        
        CCSprite* btnOrange = [CCSprite spriteWithFile:@"button.png"];
        btnOrange.color = ccc3(241, 196, 15);
       // btnOrange.scaleX = size.width * 0.5f / btnOrange.boundingBox.size.width;
       // btnOrange.scaleY = size.height * 0.05 / btnOrange.boundingBox.size.height;
        btnOrange.anchorPoint = ccp(0.5,0.5);
        
        CCSprite* btnOrangeSelected = [CCSprite spriteWithFile:@"button.png"];
       // btnOrangeSelected.scaleX = btnOrange.scaleX;
        //btnOrangeSelected.scaleY = btnOrange.scaleY;
        btnOrangeSelected.color = ccc3(243, 156, 18);
        
        CCSprite* btnGreen = [CCSprite spriteWithFile:@"button.png"];
        btnGreen.color = ccc3(46,204,113);
       // btnGreen.scaleX = btnOrange.scaleX;
       // btnGreen.scaleY =  btnOrange.scaleY;
        
        CCSprite* btnGreenSelected = [CCSprite spriteWithFile:@"button.png"];
        btnGreenSelected.color = ccc3(39,174,96);
        
        CCSprite* btnBlue = [CCSprite spriteWithFile:@"button.png"];
        btnBlue.color = ccc3(52,152,219);
        CCSprite* btnBlueSelected = [CCSprite spriteWithFile:@"button.png"];
        btnBlueSelected.color = ccc3(41,128,185);
        
        CCSprite* btnPurple = [CCSprite spriteWithFile:@"button.png"];
        btnPurple.color = ccc3(155,89,182);
        CCSprite* btnPurpleSelected = [CCSprite spriteWithFile:@"button.png"];
        btnPurpleSelected.color = ccc3(142,68,173);
       // btnBlue.scaleX = btnOrange.scaleX;
       // btnBlue.scaleY =  btnOrange.scaleY;
        
        
        CCMenuItemSprite* play = [CCMenuItemSprite itemWithNormalSprite:btnOrange selectedSprite:btnOrangeSelected target:self selector:@selector(playButtonTouched)         ];
        play.anchorPoint = ccp(0.5,0.5);
        play.position = ccp(size.width / 2.0, size.height / 2.0f);
        play.scaleX =size.width * 0.5f / btnOrange.boundingBox.size.width;
        play.scaleY =size.height * 0.05 / btnOrange.boundingBox.size.height;
        CCLabelTTF* playText = [CCLabelTTF labelWithString:@"Play" fontName:@"Lato-Light" fontSize:19];
        playText.position = play.position;
        [self addChild:playText z:1];
        
        CCMenuItemSprite* multiplayer = [CCMenuItemSprite itemWithNormalSprite:btnGreen selectedSprite:btnGreenSelected target:self selector:@selector(multiplayerButtonTouched)];
        multiplayer.anchorPoint = ccp(0.5,0.5);
        multiplayer.position = ccp(size.width / 2.0, play.position.y - size.height / 8.0);
        multiplayer.scaleX = play.scaleX;
        multiplayer.scaleY =play.scaleY;
        CCLabelTTF* multiplayerText = [CCLabelTTF labelWithString:@"Multiplayer" fontName:@"Lato-Light" fontSize:19];
        multiplayerText.position = multiplayer.position;
        [self addChild:multiplayerText z:1];
        
        
        CCMenuItemSprite* settings = [CCMenuItemSprite itemWithNormalSprite:btnBlue selectedSprite:btnBlueSelected target:self selector:@selector(settingsButtonTouched)];
        settings.anchorPoint = ccp(0.5,0.5);
        settings.position = ccp(size.width / 2.0, multiplayer.position.y - size.height / 8.0);
        settings.scaleX = play.scaleX;
        settings.scaleY =play.scaleY;
        CCLabelTTF* settingsText = [CCLabelTTF labelWithString:@"Settings" fontName:@"Lato-Light" fontSize:19];
        settingsText.position = settings.position;
        [self addChild:settingsText z:1];
        
        CCMenuItemSprite* about = [CCMenuItemSprite itemWithNormalSprite:btnPurple selectedSprite:btnPurpleSelected target:self selector:@selector(settingsButtonTouched)];
        about.anchorPoint = ccp(0.5,0.5);
        about.position = ccp(size.width / 2.0, settings.position.y - size.height / 8.0);
        about.scaleX = play.scaleX;
        about.scaleY =play.scaleY;
        CCLabelTTF* aboutText = [CCLabelTTF labelWithString:@"About" fontName:@"Lato-Light" fontSize:19];
        aboutText.position = about.position;
        [self addChild:aboutText z:1];

        CCMenu* menu = [CCMenu menuWithItems:play,multiplayer,settings, about,nil];
        menu.anchorPoint = ccp(0,0);
        menu.position = ccp(0,0);
        [self addChild:menu];
        
		
		//
		// Leaderboards and Achievements
		//
		
		// Default font size will be 28 points.
		/*[CCMenuItemFont setFontSize:28];
		
		// to avoid a retain-cycle with the menuitem and blocks
		__block id copy_self = self;
		
		// Achievement Menu Item using blocks
		CCMenuItem *itemAchievement = [CCMenuItemFont itemWithString:@"Achievements" block:^(id sender) {
			
			
			GKAchievementViewController *achivementViewController = [[GKAchievementViewController alloc] init];
			achivementViewController.achievementDelegate = copy_self;
			
			AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
			
			[[app navController] presentModalViewController:achivementViewController animated:YES];
			
			[achivementViewController release];
		}];
		
		// Leaderboard Menu Item using blocks
		CCMenuItem *itemLeaderboard = [CCMenuItemFont itemWithString:@"Leaderboard" block:^(id sender) {
			
			
			GKLeaderboardViewController *leaderboardViewController = [[GKLeaderboardViewController alloc] init];
			leaderboardViewController.leaderboardDelegate = copy_self;
			
			AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
			
			[[app navController] presentModalViewController:leaderboardViewController animated:YES];
			
			[leaderboardViewController release];
		}];

		
		CCMenu *menu = [CCMenu menuWithItems:itemAchievement, itemLeaderboard, nil];
		
		[menu alignItemsHorizontallyWithPadding:20];
		[menu setPosition:ccp( size.width/2, size.height/2 - 50)];
		
		// Add the menu to the layer
		[self addChild:menu];*/

	}
	return self;
}

-(void) playButtonTouched{
    CCLOG(@"Clicked");
    [[CCDirector sharedDirector] replaceScene:[PlayScene scene]];
}
-(void) multiplayerButtonTouched{
    
}
-(void) settingsButtonTouched{
    
}
-(void)aboutButtonTouched{
    
}
// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}

#pragma mark GameKit delegate
/*
-(void) achievementViewControllerDidFinish:(GKAchievementViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}

-(void) leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}
 */
@end
