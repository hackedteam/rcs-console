package it.ht.rcs.console.entities.view.components.advanced.timeline
{

	public class TimelineUtils
	{

		public static var months:Array=["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
    public static var monthNames:Array=["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];

		public static function doubleDigits(n:Number):String
		{
			if (n <= 9)
				return "0" + n;
			return String(n);
		}
    
    public static const DAY:Number=1000 * 60 * 60 * 24;
    public static const HOUR:Number=1000 * 60 * 60;
    public static const MINUTE:Number=1000 * 60;

	}
}
