package it.ht.rcs.console.monitor
{
  public class StatusEntry
  {
    [Bindable]
    public var title:String;
    [Bindable]
    public var status:String;
    [Bindable]
    public var address:String;
    [Bindable]
    public var desc:String;
    [Bindable]
    public var time:Number;
    [Bindable]
    public var cpu:Number;
    [Bindable]
    public var cput:Number;
    [Bindable]
    public var df:Number;
    
    public function StatusEntry(data:Object)
    {
      this.title = data.title;
      this.status = data.status;
      this.address = data.address;
      this.desc = data.desc;
      this.time = data.time;
      this.cpu = data.cpu;
      this.cput = data.cput;
      this.df = data.df;
    }
    
    public function remove():void
    {
      StatusManager.instance.removeEntry(this);
    }
  }
}