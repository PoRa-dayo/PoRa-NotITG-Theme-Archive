local t = Def.ActorFrame {
	InitCommand=cmd(fov,90),
	LoadActor("1.txt")..{
		OnCommand=cmd(x,SCREEN_CENTER_X+(-50-320);y,SCREEN_CENTER_Y+(-30-240);zoomx,400;zoomy,400;zoomz,400;z,WideScale(100,200);rotationx,3;spin;effectmagnitude,0,20,0);
	};
	LoadActor("2.txt")..{
		OnCommand=cmd(x,SCREEN_CENTER_X+(-50-320);y,SCREEN_CENTER_Y+(-30-240);zoomx,400;zoomy,400;zoomz,400;z,WideScale(100,200);rotationx,3;spin;effectmagnitude,0,20,0);
	};
	LoadActor("bg2")..{
		OnCommand=cmd(x,SCREEN_CENTER_X-320;y,SCREEN_CENTER_Y-240;zoomtowidth,SCREEN_WIDTH;zoomtoheight,SCREEN_HEIGHT;blend,'BlendMode_Add');
	};
	LoadActor("smoke")..{
		OnCommand=cmd(x,SCREEN_CENTER_X-320;y,SCREEN_CENTER_Y-240;blend,'BlendMode_Add';texcoordvelocity,0.1,0;zoomtowidth,SCREEN_WIDTH;zoomtoheight,SCREEN_HEIGHT;diffusealpha,.5);
	};
};
return t;