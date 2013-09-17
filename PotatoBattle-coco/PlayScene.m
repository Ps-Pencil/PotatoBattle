//
//  PlayScene.m
//  PotatoBattle-coco
//
//  Created by pspencil on 6/9/13.
//  Copyright 2013 pspencil. All rights reserved.
//

#import "PlayScene.h"
#import "HelloWorldLayer.h"
#import "CombatScene.h"

@implementation PlayScene
+ (CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	PlayScene *layer = [PlayScene node];
	
	// add layer as a child to scene
	[scene addChild: layer];
    
	// return the scene
	return scene;
}

- (id) init{
    if((self = [super init])){
        CGSize size = [[CCDirector sharedDirector] winSize];
        
        CCMenuItemFont* backBtn = [CCMenuItemFont itemWithString:@"Back" block:^(id sender){
            [[CCDirector sharedDirector] replaceScene:[HelloWorldLayer scene]];
        }];
        CCMenuItemFont* proceedBtn = [CCMenuItemFont itemWithString:@"Proceed" target:self selector:@selector(proceedBtnPressed)];
        CCMenu* back = [CCMenu menuWithItems:proceedBtn,backBtn, nil];
        back.position = ccp(size.width / 2.0f, 20);
        [self addChild:back];
        [back alignItemsVerticallyWithPadding:5];
        
        dragged = FALSE;
        
        CCSprite* map = [CCSprite spriteWithFile:@"map.png"];
        map.position = ccp(size.width / 2.0f , size.height / 2.0f);
        [self addChild:map z:0 tag:0];
        
        for(int i = 1; i <= 5 ; i++)
        {
            CCSprite* potato = [CCSprite spriteWithFile:[NSString stringWithFormat:@"potato%d.png",i]];
            potato.position = ccp(map.position.x - [map boundingBox].size.width / 2.0f + (i-1) * [potato boundingBox].size.width +[potato boundingBox].size.width / 2.0f,map.position.y - [map boundingBox].size.height / 2.0f+[potato boundingBox].size.height/2);
            potato.tag = i;
            [self addChild:potato z:2];
            
            CCSprite* potato_shade = [CCSprite spriteWithFile:[NSString stringWithFormat:@"potato%d_shade.png",i]];
            potato_shade.position = ccp(map.position.x - [map boundingBox].size.width / 2.0f + (i-1) * [potato_shade boundingBox].size.width +[potato_shade boundingBox].size.width / 2.0f,map.position.y - [map boundingBox].size.height / 2.0f+[potato_shade boundingBox].size.height/2);
            potato_shade.tag = i+5;
            [self addChild:potato_shade z:1];
        }
        
        
        
        [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
    }
    return self;
}
-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    [self selectSpriteForTouch:touchLocation];
    return TRUE;
}
-(void) selectSpriteForTouch:(CGPoint) touchLocation{
    CCSprite* newSprite = nil;
    for(int i = 1; i <= 5; i++){
        CCSprite* temp = (CCSprite *)[self getChildByTag:i];
        if(CGRectContainsPoint(temp.boundingBox, touchLocation))
        {
            newSprite = temp;
            break;
        }
        
    }
    selSprite = newSprite;
}
-(CGPoint) boundPos:(CGPoint)newPos{
    CCSprite* map = (CCSprite *)[self getChildByTag:0];
    CGPoint retval = newPos;
    retval.x = MAX(retval.x, map.position.x - [map boundingBox].size.width / 2.0f + [selSprite boundingBox].size.width / 2.0f);
    retval.x = MIN(retval.x, map.position.x + [map boundingBox].size.width / 2.0f - [selSprite boundingBox].size.width / 2.0f);
    retval.y = MAX(retval.y, map.position.y - [map boundingBox].size.height / 2.0f + [selSprite boundingBox].size.height / 2.0f);
    retval.y = MIN(retval.y, map.position.y + [map boundingBox].size.height / 2.0f - [selSprite boundingBox].size.height / 2.0f);
    return retval;
    
}
-(void) panForTranslation: (CGPoint)translation{
    if(selSprite)
    {
        CGPoint newPos = ccpAdd(selSprite.position, translation);
        selSprite.position = [self boundPos:newPos];
        
        CCSprite* shade = (CCSprite*)[self getChildByTag:5+selSprite.tag];
        float x,y;
        CCSprite *map = (CCSprite *)[self getChildByTag:0];
        for(int i = 0; i <10 ; i++){
            x = map.position.x - map.boundingBox.size.width / 2.0f + shade.boundingBox.size.width / 2.0f + i * map.boundingBox.size.width / 10.0f;
            if(fabs(selSprite.position.x - x) <= map.boundingBox.size.width / 20.0f)
            {
                break;
            }
        }
        for(int i = 0; i < 10 ; i++){
            y = map.position.y - map.boundingBox.size.height / 2.0f + shade.boundingBox.size.height / 2.0f + i * map.boundingBox.size.height / 10.0f;
            if(fabs(selSprite.position.y - y) <= map.boundingBox.size.height / 20.0f)
            {
                break;
            }
        }
        CGPoint pos = ccp(x,y);
        shade.position = pos;
    }
}
-(BOOL) isBox1: (CGRect)rect1 collidingWithBox2: (CGRect )rect2{
    if (CGRectIntersectsRect(rect1, rect2)) {
        return true;
    }
    return false;
}
-(void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    dragged = TRUE;
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    CGPoint oldTouchLocation = [touch previousLocationInView:touch.view];
    oldTouchLocation = [[CCDirector sharedDirector] convertToGL:oldTouchLocation];
    oldTouchLocation = [self convertToNodeSpace:oldTouchLocation];
    
    CGPoint translation = ccpSub(touchLocation, oldTouchLocation);
    [self panForTranslation:translation];
    
    
}
-(CGRect) getRandomRect: (int) size{
    CCSprite* map = (CCSprite*)[self getChildByTag:0];
    int height = 1;
    int width = size;
    if(arc4random()%2==0)
    {
        float t = height;
        height = width;
        width = t;
    }
    int x = arc4random()% (10 - width + 1);
    int y = arc4random()% (10 - height + 1);
    return CGRectMake((float)x * map.boundingBox.size.width / 10.0f + map.boundingBox.origin.x, (float)y * map.boundingBox.size.height /10.0f + map.boundingBox.origin.y, width * map.boundingBox.size.width / 10.0f, height * map.boundingBox.size.width / 10.0f);
}
-(void) proceedBtnPressed{
    bool overlap = false;
    for(int i = 1; i < 5 && !overlap; i++){
        for(int j = i + 1 ; j <= 5 ; j++){
            if([self isBox1:((CCSprite *)[self getChildByTag:i]).boundingBox collidingWithBox2:((CCSprite *)[self getChildByTag:j]).boundingBox])
            {
                overlap = true;
                break;
            }
        }
    }
    if (overlap) {
        //Prompt for de-overlapping
    }
    else{
        
        NSMutableArray* array = [[NSMutableArray alloc] initWithCapacity:5];
        for(int i = 1; i <= 5 ; i++ )
        {
            [array addObject:[NSValue valueWithCGRect:((CCSprite*)[self getChildByTag:i]).boundingBox]];
        }
        NSMutableArray* hits = [[NSMutableArray alloc] init];
        NSMutableArray* AIarray = [[NSMutableArray alloc] init];
        int width[5] = {2,3,3,4,5};
        for(int i = 0 ; i<= 5 ; i ++)
        {
        
            CGRect rect = [self getRandomRect:width[i]];
            for(int j = 0 ; j < AIarray.count ; j++)
            {
                if(CGRectIntersectsRect(rect, [AIarray[j] CGRectValue]))
                {
                    rect = [self getRandomRect:width[i]];
                    j = -1;
                }
            }
            [AIarray addObject:[NSValue valueWithCGRect:rect]];
            
        }
        NSMutableArray* otherhits = [[NSMutableArray alloc] init];
        [[CCDirector sharedDirector] replaceScene:[CombatScene sceneWithParameters:AIarray andHits:hits andOtherPositions:array andOtherHits:otherhits]];
    }
}
-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
    if(selSprite){
        CCSprite* shade = (CCSprite*)[self getChildByTag:5 + selSprite.tag];
        if (!dragged) {
            selSprite.rotation = 90 - selSprite.rotation;
            shade.rotation = selSprite.rotation;
            selSprite.position = [self boundPos:selSprite.position];
            shade.position = [self boundPos:shade.position];
            [self panForTranslation:ccp(0,0)];
            selSprite.position = shade.position;
        }
        else{
            selSprite.position = shade.position;
        }
    }
    dragged = false;
    
    CCLOG(@"%f %f %f %f\n" , selSprite.boundingBox.origin.x, selSprite.boundingBox.origin.y, selSprite.position.x,selSprite.position.y);
    
    // check for collision
    
    
}
@end
