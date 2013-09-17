//
//  Result.m
//  PotatoBattle-coco
//
//  Created by pspencil on 16/9/13.
//  Copyright 2013 pspencil. All rights reserved.
//

#import "Result.h"


@implementation Result

+(CCScene*) sceneWithWords:(NSString *)words{
        // 'scene' is an autorelease object.
        CCScene *scene = [CCScene node];
        
        // 'layer' is an autorelease object.
        Result *layer = [[[Result alloc] initWithWords:words] autorelease];
        
        // add layer as a child to scene
        [scene addChild: layer];
        
        // return the scene
        return scene;
}
- (id) initWithWords: (NSString *) words{
    if((self = [super init])){
        
        CGSize size = [[CCDirector sharedDirector] winSize];
        CCLabelTTF* banner = [CCLabelTTF labelWithString:words fontName:@"Marker Felt" fontSize:60];
        banner.position = ccp(size.width / 2.0f, size.height / 2.0f + 20);
        [self addChild:banner];
        
        CCMenuItemFont* backBtn = [CCMenuItemFont itemWithString:@"Main Menu" block:^(id sender){
            [[CCDirector sharedDirector] replaceScene:[HelloWorldLayer scene]];
        }];
        CCMenuItemFont* proceedBtn = [CCMenuItemFont itemWithString:@"Play Again" block:^(id sender){
            [[CCDirector sharedDirector] replaceScene:[PlayScene scene]] ;
        }];
        CCMenu* back = [CCMenu menuWithItems:proceedBtn,backBtn, nil];
        back.position = ccp(size.width / 2.0f, 60);
        [self addChild:back];
        [back alignItemsVerticallyWithPadding:10];

    }
    return self;
}
@end
