package 
{
	import flash.events.Event;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	//for dat drag
	import flash.geom.Rectangle;
	//android stuffs
	import flash.events.TouchEvent;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;

	public class PageMVC extends MovieClip
	{
		private var _model:Object;
		private var _controller:Object;
		//movieclips
		private var _graphic;
		//values
		private var _currentPage:uint;
		private var _beginPoint:Number;
		private var _shift:int;
		private var _sliding:Boolean = false;

		public function PageMVC(model:Object, controller:Object):void
		{
			_model = model;
			_controller = controller;
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		private function onAddedToStage(event:Event):void
		{
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			_model.addEventListener(Event.CHANGE, onChange);
			_currentPage = 0;
			initialize();
		}
		private function initialize():void
		{
			//add the first page of whatever
			//change what the "graphics" are by looking at what the stage is
			switch (_model.currentStage)
			{
				case "AboutScreen" :
					_graphic = new AboutScreen;
					_graphic.officialSiteButton.addEventListener(TouchEvent.TOUCH_TAP, onOfficialSiteClick);
					_graphic.myWebLink.addEventListener(TouchEvent.TOUCH_TAP, onMyWebLinkClick);
					break;
				case "SettingsScreen":
					_graphic = new SettingsScreen;
					//SCOOCH BAR
					_graphic.scoochBar.nob.addEventListener(TouchEvent.TOUCH_BEGIN, onNobDrag);
					//find out the percent of the model's scooch and reflect that (the -200 is because the axis is in the middle)
					_graphic.scoochBar.nob.x = _model.scooch / _model.ORIGINAL_SCOOCH * 200 - 200;
					_graphic.scoochBar.numDisplay.text = _model.scooch;
					
					//MIN SCOOCH BAR
					_graphic.minScoochBar.nob.addEventListener(TouchEvent.TOUCH_BEGIN, onNobDrag);
					_graphic.minScoochBar.nob.x = _model.minScooch / _model.ORIGINAL_MIN_SCOOCH * 200 - 200;
					_graphic.minScoochBar.numDisplay.text = _model.minScooch;
					break;
				default :
					trace("something is wrong with addFirstPage");
					trace(_model.currentStage);
					break;
			}
			addChild(_graphic);
			_graphic.x = 240;
			_graphic.y = 400;
			_graphic.gotoAndStop(1);
			_currentPage = 1;
			//adding scrolling stuff
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			stage.addEventListener(TouchEvent.TOUCH_BEGIN, onTouchBegin);
		}
		private function onChange(event:Event):void
		{
			//check to see if touch has ended, and it's time to start sliding the movieclip
			if (_sliding)
			{
				//slow the speed a bit
				_shift *= 0.9;
				//if the shift is still big enough, slide by the shift (aka gradually slowing)
				if (Math.abs(_shift) >= 1) {
					_graphic.y -= _shift;
					checkFlip();
				}
				else
				{
					_sliding = false;
					_shift = 0;
				}
			}
		}
		/*
		* BUTTON EVENT LISTENERS
		*/
		private function onTouchBegin(event:TouchEvent):void
		{
			_beginPoint = event.stageY;
			stage.addEventListener(TouchEvent.TOUCH_MOVE, onTouchMove);
			stage.addEventListener(TouchEvent.TOUCH_END, onTouchEnd);
		}
		private function onTouchMove(event:TouchEvent):void
		{
			//shift should > 0 if moving down, < 0 if moving up, divided for natural moving speed
			_shift = (_beginPoint - event.stageY) / 8;
			_graphic.y -= _shift;
			checkFlip();
		}
		private function onTouchEnd(event:TouchEvent):void
		{
			_sliding = true;
			stage.removeEventListener(TouchEvent.TOUCH_MOVE, onTouchMove);
			stage.removeEventListener(TouchEvent.TOUCH_END, onTouchEnd);
		}
		//from aboutScreen
		private function onOfficialSiteClick(event:TouchEvent):void
		{
			_controller.processOfficialSiteClick();
		}
		private function onMyWebLinkClick(event:TouchEvent):void
		{
			_controller.processMyWebLinkClick();
		}
		//from settingsScreen
		private function onNobDrag(event:TouchEvent):void
		{
			var boundary:Rectangle = new Rectangle(-200, 0, 400, 0);
			event.target.startTouchDrag(event.touchPointID, false, boundary);
			event.target.addEventListener(TouchEvent.TOUCH_END, onNobDragStop);
		}
		private function onNobDragStop(event:TouchEvent):void
		{
			event.target.stopTouchDrag(event.touchPointID);
			//send the new value to the controller. The nob's x is +200 because it is in the center of a bar that's 400px wide
			_controller.processNewBar(event.target.x + 200, event.target.parent.name);
			//now reset the number based on what bar this is
			switch (event.target.parent.name)
			{
				case "scoochBar":
					event.target.parent.numDisplay.text = _model.scooch;
					break;
				case "minScoochBar":
					event.target.parent.numDisplay.text = _model.minScooch;
					break;
				default:
					trace("something wrong with onNobDragStop in PageMVC");
					break;
			}
			event.target.removeEventListener(TouchEvent.TOUCH_END, onNobDragStop);
		}
		/*
		* OTHER IMPORTANT FUNCTIONS
		*/
		private function checkFlip():void
		{
			//flipping pages
			if (_shift > 0)
			{
				//see if it's time to flip
				if (_graphic.y < -400)
				{
					//see if there is a page to flip to
					if (_currentPage < _graphic.totalFrames - 1)
					{
						gotoNextPage(true);
					}
					else
					{
						_graphic.y = -400;
					}
				}
			}
			else if (_shift < 0)
			{
				//see if it's time to flip
				if (_graphic.y > 400)
				{
					//see if there is a page to flip to, if not stay at 400
					if (_currentPage > 1)
					{
						gotoNextPage(false);
					}
					else
					{
						_graphic.y = 400;
					}
				}
			}
		}
		private function gotoNextPage(yeaOrNay:Boolean):void
		{
			//go to the next page
			if (yeaOrNay)
			{
				_currentPage++;
				_graphic.gotoAndStop(_currentPage);
				_graphic.y += 800;
			}
			//go to the previous page
			else
			{
				_currentPage--;
				_graphic.gotoAndStop(_currentPage);
				_graphic.y -= 800;
			}
		}
		private function onRemovedFromStage(event:Event):void
		{
			//go back to the first page to get rid of weird TypeError bug
			_graphic.gotoAndStop(1);
			//remove most eventlisteners
			stage.removeEventListener(TouchEvent.TOUCH_BEGIN, onTouchBegin);
			stage.removeEventListener(TouchEvent.TOUCH_MOVE, onTouchMove);
			stage.removeEventListener(TouchEvent.TOUCH_END, onTouchEnd);
			_model.removeEventListener(Event.CHANGE, onChange);
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			//remove specific eventlisteners
			switch (_model.currentStage)
			{
				case "AboutScreen":
					_graphic.officialSiteButton.removeEventListener(TouchEvent.TOUCH_TAP, onOfficialSiteClick);
					_graphic.myWebLink.removeEventListener(TouchEvent.TOUCH_TAP, onMyWebLinkClick);
					break;
				case "SettingsScreen":
					_graphic.scoochBar.nob.removeEventListener(TouchEvent.TOUCH_BEGIN, onNobDrag);
					_graphic.minScoochBar.nob.removeEventListener(TouchEvent.TOUCH_BEGIN, onNobDrag);
					break;
				default:
					trace("something went wrong in 'onRemovedFromStage");
					break;
			}
			removeChild(_graphic);
		}
	}
}